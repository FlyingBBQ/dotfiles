#
# ~/.zprofile
#
# FlyingBBQ » zsh
#

# prompt
PROMPT='%F{red}%~ %F{yellow}∇%f '
RPROMPT='%F{237}%*%f'

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
alias gs='git status'
alias slep='~/code/scripts/lock.sh && systemctl suspend'
alias nvimit='nvim ~/.config/nvim/init.vim'
alias tu='urxvt &'

# history
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt incappendhistory
setopt histignorealldups
setopt sharehistory

# options
setopt autocd
setopt correct
setopt extendedglob
setopt nolistambiguous

zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle :compinstall filename '/home/derek/.zshrc'
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

# bindings
bindkey '^p' history-beginning-search-backward
bindkey '^n' history-beginning-search-forward
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward
bindkey '^k' expand-or-complete
bindkey ' ' magic-space
bindkey -M menuselect '^j' reverse-menu-complete
bindkey -s '^g' "git add -u; git commit -v && git push"

# fix delete key
bindkey -a '^[[3~' delete-char
bindkey -v '^?' backward-delete-char

# fix HOME, END
bindkey '\e[7~' beginning-of-line
bindkey '\e[8~' end-of-line
