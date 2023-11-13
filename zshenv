# Start configuration added by Zim install {{{
#
# User configuration sourced by all invocations of the shell
#

# Define Zim location
: ${ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim}
# }}} End configuration added by Zim install

umask 027
export VISUAL=nvim
export EDITOR=$VISUAL

# Use local/scratch XDG Paths, if present and flagged with .useme file
_home_prefix="/scratch${HOME}"
[ -f ${_home_prefix}/.useme ] || _home_prefix=${HOME} # default to ~

export XDG_CACHE_HOME="${_home_prefix}/.cache"
export XDG_DATA_HOME="${_home_prefix}/.local/share"
export XAUTHORITY="${_home_prefix}/.Xauthority"
export GOPATH="${_home_prefix}/go"
export GNUPGHOME="${_home_prefix}/.gnupg"
export PNPM_HOME="${_home_prefix}/.local/share/pnpm"

PATH="$PATH:$GOPATH/bin:$PNPM_HOME"

PATH="$PATH:${_home_prefix}/bin"

# foundry
PATH="$PATH:${_home_prefix}/.foundry/bin"

# from https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2#.tj0bz9a4o
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# pass
export PASSWORD_STORE_DIR="${XDG_DATA_HOME}/password-store"
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
