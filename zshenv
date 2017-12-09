umask 027
export VISUAL=vim
export EDITOR=$VISUAL

# Use local/scratch XDG Paths, if present and flagged with .useme file
_home_prefix="/scratch${HOME}"
[ -f ${_home_prefix}/.useme ] || _home_prefix=${HOME} # default to ~

export XDG_CACHE_HOME="${_home_prefix}/.cache"
export XDG_DATA_HOME="${_home_prefix}/.local/share"
export XAUTHORITY="${_home_prefix}/.Xauthority"
export GOPATH="${_home_prefix}/go"
export GNUPGHOME="${_home_prefix}/.gnupg"
export npm_config_prefix="${_home_prefix}/.node_modules"

PATH="$PATH:$GOPATH/bin:$npm_config_prefix/bin:$HOME/bin"

# from https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2#.tj0bz9a4o
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
