#
## User configuration sourced by interactive shells
##
#
## Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Enable <C>-<S>-t open new termite in current directory
if [[ $TERM == xterm-termite && -f /etc/profile.d/vte.sh ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7
fi

# bindings
bindkey '^Z' push-input
bindkey '^N' up-history
bindkey '^P' down-history
bindkey '^R' history-incremental-search-backward
bindkey -M isearch '^N' vi-repeat-search
bindkey -M isearch '^P' vi-rev-repeat-search
