#
## User configuration sourced by interactive shells
##
#
## Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

[[ -f ~/.aliases ]] && source ~/.aliases

# Enable <C>-<S>-t open new termite in current directory
if [[ $TERM == xterm-termite  ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7
fi
