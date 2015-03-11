# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd
unsetopt beep notify
bindkey -e
# End of lines configured by zsh-newuser-install

# custom options
setopt auto_cd

# PATH=$PATH:/opt/android-sdk/platform-tools/ #seems to be included generally
# Set aliases
source ~/.aliases
[[ $PATH =~ $HOME/bin ]] || PATH="$HOME/bin:$PATH"
export GOPATH=$HOME/go
PATH="$PATH:$GOPATH/bin"
export LC_NUMERIC=en_US.utf8
export EDITOR=emacs
REPORTTIME=10
export LESS=' -R '

# Enabling colors
autoload -U colors && colors

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' format "%{$fg[magenta]%}  Completions - %B%d%b%{$reset_color%}"
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=** r:|=**'
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' menu select=long
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' prompt "%{$fg[magenta]%}Corrections (%B%e%b errors)%{$reset_color%}"
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/sebastians/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# custom completion
setopt completeinword
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

# Configuring the prompt
autoload -U promptinit
promptinit
PROMPT="%{$fg[white]%}%n%{$fg[magenta]%}@%{$fg[blue]%}%m %{$fg[magenta]%}%1~ %{$reset_color%}%B%#%b "
RPROMPT="[%{$fg[magenta]%}%?%{$reset_color%}]"

# set xterm titles
case $TERM in
    *xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
           precmd () {print -Pn "\e]0;%n@%M: %~\a"}
        ;;
esac

insert_sudo     () { zle beginning-of-line; zle -U "sudo " }
insert_man      () { zle beginning-of-line; zle -U "man "  }

zle -N insert-sudo      insert_sudo
zle -N insert-man       insert_man

bindkey "^S" insert-sudo
#bindkey "^S^M" insert-man

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
case $TERM in
    *xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
	function zle-line-init () {
	    echoti smkx
	}
	function zle-line-finish () {
	    echoti rmkx
	}
	zle -N zle-line-init
	zle -N zle-line-finish
esac

# jump backwards/forwards with Ctrl+left/right
bindkey ';5D' emacs-backward-word
bindkey ';5C' emacs-forward-word

# delete words b/f with ctrl-backspace/del
#bindkey '^?' backward-kill-word
bindkey '^[[3;5~' kill-word
