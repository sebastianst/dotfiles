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

# vi mode status
# Add hooks instead of overwriting zle-line-init etc.
function vim-mode-prompt {
  VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
  RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$EPS1"
  zle reset-prompt
}

autoload -Uz add-zle-hook-widget
add-zle-hook-widget line-init vim-mode-prompt
add-zle-hook-widget keymap-select vim-mode-prompt

# default WORDCHARS include too many chars for my taste
WORDCHARS='*?_-.~$%^'
# bindings
bindkey '^Z' push-input
bindkey '^N' up-history
bindkey '^P' down-history
bindkey '^R' history-incremental-search-backward
bindkey -M isearch '^N' vi-repeat-search
bindkey -M isearch '^P' vi-rev-repeat-search
# sane vi-insert mode behaviour - use emacs widgets
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' kill-line

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[[ -f /home/seb/src/ganache/node_modules/tabtab/.completions/electron-forge.zsh ]] && . /home/seb/src/ganache/node_modules/tabtab/.completions/electron-forge.zsh

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true
