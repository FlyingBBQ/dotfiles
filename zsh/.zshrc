#
# ~/.zprofile
#
# FlyingBBQ » zsh
#

# prompt
PROMPT='%F{red}%~ %F{yellow}∇%f '
RPROMPT='%F{7}%*%f'

# alias
alias ls='ls --color=auto'
alias la='ls -A --color=auto'
alias x='exit'
alias alsi='alsi -l -u'
alias weather='curl -s wttr.in | head -7'
alias forecast='curl -s wttr.in'
alias clk='tty-clock -s -b -c -C 3'
alias ranger='ranger --choosedir=/tmp/.rangerdir; LASTDIR=`cat /tmp/.rangerdir`; cd "$LASTDIR"'
alias dots='cd ~/.dotfiles'
alias stowc='stow -t ~/.config'

# history
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt incappendhistory
setopt histignorealldups
setopt sharehistory

# options
setopt autocd
setopt extendedglob

zstyle :compinstall filename '/home/derek/.zshrc'
zstyle ':completion:*' menu yes select
zmodload zsh/complist

# completion
autoload -Uz compinit
compinit

# vi mode cursor
zle-keymap-select () {
    if [ $TERM = "rxvt-unicode-256color" ]; then
        if [ $KEYMAP = vicmd ]; then
            echo -ne "\e[2 q"
        else
            echo -ne "\e[4 q"
        fi
    fi
}
zle -N zle-keymap-select
zle-line-init () {
    zle -K viins
    if [ $TERM = "rxvt-unicode-256color" ]; then
        echo -ne "\e[4 q"
    fi
}
zle -N zle-line-init

# set vi mode
bindkey -v

# bindigs
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^k' expand-or-complete
bindkey '^j' reverse-menu-complete
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

