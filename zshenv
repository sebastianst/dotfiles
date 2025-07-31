# Start configuration added by Zim install {{{
#
# User configuration sourced by all invocations of the shell
#

# Define Zim location
export ZIM_HOME="${HOME}/.zim"
export ZIM_CONFIG_FILE="${HOME}/.zimrc"
# }}} End configuration added by Zim install

umask 027
export VISUAL=nvim
export EDITOR=$VISUAL
export PAGER="less -r"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XAUTHORITY="${HOME}/.Xauthority"
export GOPATH="${HOME}/go"
export GNUPGHOME="${HOME}/.gnupg"
export PNPM_HOME="${HOME}/.local/share/pnpm"

PATH="$PATH:$GOPATH/bin:$PNPM_HOME"

PATH="$PATH:${HOME}/bin"

# foundry
PATH="$PATH:${HOME}/.foundry/bin"

# from https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2#.tj0bz9a4o
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# pass
export PASSWORD_STORE_DIR="${XDG_DATA_HOME}/password-store"
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
