export VISUAL=vim
export EDITOR=$VISUAL
export GOPATH=$HOME/go
PATH="$PATH:$GOPATH/bin"

# Use local/scratch XDG Paths, if present
_scratch_home="/scratch${HOME}"
if [ -d ${_scratch_home} ]; then
  export XDG_CACHE_HOME="${_scratch_home}/.cache"
  export XDG_DATA_HOME="${_scratch_home}/.local/share"
fi

