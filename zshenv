export VISUAL=vim
export EDITOR=$VISUAL
export GOPATH=$HOME/go

# Use local/scratch XDG Paths, if present
_scratch_home="/scratch${HOME}"
if [ -d ${_scratch_home} ]; then
  export XDG_CACHE_HOME="${_scratch_home}/.cache"
  export XDG_DATA_HOME="${_scratch_home}/.local/share"
  export XAUTHORITY="${_scratch_home}/.Xauthority"
  # Set local gopath if possible
  export GOPATH="${_scratch_home}/go"
fi

PATH="$PATH:$GOPATH/bin"

# from https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2#.tj0bz9a4o
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
