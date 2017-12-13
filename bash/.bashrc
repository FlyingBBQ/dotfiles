#
# ~/.bashrc
#
# FlyingBBQ » bash
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# alias
alias ls='ls --color=auto'
alias la='ls -A --color=auto'
#alias cd='>/dev/null cd'
#alias c='clear'
alias x='exit'
alias alsi='alsi -l -u'
alias weather='curl -s wttr.in | head -7'
alias forecast='curl -s wttr.in'
alias clk='tty-clock -s -b -c -C 3'
alias ranger='ranger --choosedir=/tmp/.rangerdir; LASTDIR=`cat /tmp/.rangerdir`; cd "$LASTDIR"'
alias dots='cd ~/.dotfiles'
alias stowc='stow -t ~/.config'

# shell prompt
PS1='\[\e[0;31m\]\w \[\e[0;33m\]∇\[\e[0m\] '

# functions
cs() { cd "$@" && ls; }

# cdpath ":" = delimeter
#CDPATH='.:..:../..:~:~/documents'

# spelling
shopt -s cdspell

# cd without "cd"
shopt -s autocd

# history
shopt -s histappend
export HISTCONTROL=ignoredups
export HISTFILESIZE=1000
export HISTSIZE=1000
export PROMPT_COMMAND='history -a'
