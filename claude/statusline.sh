#!/usr/bin/env bash
# Claude Code status line. Receives the session JSON on stdin, prints one line.
#
# Payload reference (v2.1.233): session_id, session_name, prompt_id, transcript_path,
# cwd, model{id,display_name}, workspace{current_dir,project_dir,added_dirs,
# git_worktree,repo{host,owner,name}}, version, output_style{name},
# cost{total_cost_usd,total_duration_ms,total_api_duration_ms,total_lines_added,
# total_lines_removed}, context_window{total_input_tokens,total_output_tokens,
# context_window_size,current_usage,used_percentage,remaining_percentage},
# exceeds_200k_tokens, fast_mode, effort{level}, thinking{enabled},
# rate_limits{five_hour,seven_day}, vim{mode}, agent{name,type}, remote{session_id},
# pr{number,url,review_state,kind}, worktree{name,path,branch,original_cwd,original_branch}
set -uo pipefail

DIM=$'\033[2m'; RESET=$'\033[0m'
CYAN=$'\033[36m'; BLUE=$'\033[34m'; GREEN=$'\033[32m'
YELLOW=$'\033[33m'; RED=$'\033[31m'; MAGENTA=$'\033[35m'
SEP="${DIM} │ ${RESET}"

# One jq pass over the payload — a q()-per-field helper would fork jq a dozen times
# on every keystroke-triggered refresh. Sentinels (-1, "") stand in for absent fields
# so `set -u` stays on.
eval "$(jq -r '
  def s: . // "";
  @sh "model=\(.model.display_name|s)",
  @sh "effort=\(.effort.level|s)",
  @sh "fast=\(.fast_mode == true|tostring)",
  @sh "nothink=\(.thinking.enabled == false|tostring)",
  @sh "dir=\(.workspace.current_dir // .cwd|s)",
  @sh "worktree=\(.workspace.git_worktree|s)",
  @sh "pr=\(.pr.number // "" |tostring)",
  @sh "pr_state=\(.pr.review_state|s)",
  @sh "ctx=\(.context_window.used_percentage // -1|floor|tostring)",
  @sh "five=\(.rate_limits.five_hour.used_percentage // -1|floor|tostring)",
  @sh "cents=\(.cost.total_cost_usd // 0|.*100|round|tostring)",
  @sh "vim=\(.vim.mode|s)",
  @sh "agent=\(.agent.name|s)"
')"

parts=()
add() { parts+=("$1"); }

# The plan is absent from the payload, so read the logged-in account directly.
# A non-default CLAUDE_CONFIG_DIR keeps its own .claude.json and so its own account,
# which is why both the lookup and the cache are keyed per config dir — sharing one
# cache across dirs makes a Max session render the default dir's plan.
config_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
account="$config_dir/.claude.json"
[[ -f $account ]] || account="$HOME/.claude.json"

# Cached: the account file is ~100KB and only changes plan on re-login.
plan_cache="${XDG_CACHE_HOME:-$HOME/.cache}/claude-code-plan${config_dir//\//-}"
if [[ ! -f $plan_cache ]] || [[ -n $(find "$plan_cache" -mmin +60 2>/dev/null) ]]; then
  mkdir -p "$(dirname "$plan_cache")"
  jq -r '.oauthAccount // {}
    | (.organizationType // "" | sub("^claude_"; "")) as $t
    | {enterprise:"Ent", max:"Max", pro:"Pro", team:"Team"}[$t] // $t
  ' "$account" 2>/dev/null >"$plan_cache"
fi
plan=$(<"$plan_cache")
[[ -n $plan ]] && add "${MAGENTA}${plan}${RESET}"

[[ -n $agent ]] && add "${MAGENTA}@${agent}${RESET}"

# Model, plus the knobs that silently change how it behaves.
if [[ -n $model ]]; then
  m="${CYAN}${model}${RESET}"
  [[ -n $effort ]] && m+=" ${DIM}${effort}${RESET}"
  [[ $fast == true ]] && m+=" ${YELLOW}⚡${RESET}"
  [[ $nothink == true ]] && m+=" ${DIM}(no think)${RESET}"
  add "$m"
fi

# Location: the worktree name when in one, else the directory basename.
dir=${dir:-$PWD}
add "${BLUE}${worktree:-$(basename "$dir")}${RESET}"

# --no-optional-locks and -uno keep the dirty check cheap in large monorepos.
branch=$(git -C "$dir" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null) \
  || branch=$(git -C "$dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
if [[ -n $branch ]]; then
  if git -C "$dir" --no-optional-locks status --porcelain -uno 2>/dev/null | grep -q .; then
    add "${YELLOW}⎇ ${branch}*${RESET}"
  else
    add "${GREEN}⎇ ${branch}${RESET}"
  fi
fi

[[ -n $pr ]] && add "${DIM}PR #${pr}${pr_state:+ $pr_state}${RESET}"

if (( ctx >= 0 )); then
  if   (( ctx >= 85 )); then c=$RED
  elif (( ctx >= 60 )); then c=$YELLOW
  else                       c=$DIM
  fi
  add "${c}ctx ${ctx}%${RESET}"
fi

# Only populated for claude.ai subscription accounts (Pro/Max).
(( five >= 0 )) && add "${DIM}5h ${five}%${RESET}"

(( cents > 0 )) && add "$(printf '%s$%d.%02d%s' "$DIM" $((cents / 100)) $((cents % 100)) "$RESET")"

[[ -n $vim ]] && add "${DIM}${vim}${RESET}"

out=""
for p in ${parts[@]+"${parts[@]}"}; do
  [[ -n $out ]] && out+="$SEP"
  out+="$p"
done
printf '%s\n' "$out"
