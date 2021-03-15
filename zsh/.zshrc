#
# ~/.zprofile
#
# FlyingBBQ » zsh
#

# prompt
PROMPT='%F{red}%~ %F{yellow}▼%f '
RPROMPT='%F{237}%*%f'

# alias
alias ls='exa -g'
alias ll='ls -l'
alias la='ls -a'
alias lt='ls -TL 2'
alias gs='git status'
alias dl='cd ~/downloads'
alias pac='pikaur'
alias dots='cd ~/.dotfiles'
alias weather='curl -s wttr.in | head -7'
alias forecast='curl -s wttr.in'
alias ranger='. ranger'
alias stowc='stow -t ~/.config'
alias slep='~/bin/lock.sh && systemctl suspend'
alias nvimit='nvim ~/.config/nvim/init.vim'
alias x='exit'

# local alias
[[ -f ~/.zlocal ]]  && . ~/.zlocal

# history
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt incappendhistory
setopt histignorealldups
setopt sharehistory

# options
setopt autocd
#setopt correct
eval $(thefuck --alias)
setopt extendedglob
setopt nolistambiguous

# completion rules
zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:processes' command 'ps -A'
zstyle :compinstall filename '/home/derek/.zshrc'
zmodload zsh/complist

# load and init completion
autoload -Uz compinit && compinit

# git prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "%b"
setopt prompt_subst
precmd_vcs_info() {
    vcs_info
    # string not null
    if [[ -n ${vcs_info_msg_0_} ]]; then
        if [[ -n $(git status --porcelain) ]]; then
            RPROMPT='%F{237}[%F{magenta}${vcs_info_msg_0_}%F{237}] %F{237}%*%f'
        else
            RPROMPT='%F{237}[%F{green}${vcs_info_msg_0_}%F{237}] %F{237}%*%f'
        fi
    else
        RPROMPT='%F{237}%*%f'
    fi
}
precmd_functions+=( precmd_vcs_info )

# vi mode cursor
zle-keymap-select () {
    if [ $TERM = "st-256color" ]; then
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
    if [ $TERM = "st-256color" ]; then
        echo -ne "\e[4 q"
    fi
}
zle -N zle-line-init

# set vi mode
bindkey -v

# bindings
bindkey ' ' magic-space
bindkey '^o' history-beginning-search-backward
bindkey '^n' history-beginning-search-forward
#bindkey '^r' history-incremental-search-backward
#bindkey '^s' history-incremental-search-forward
bindkey '^k' expand-or-complete
bindkey -M menuselect '^j' reverse-menu-complete
bindkey -s '^g' "git add -u; git commit -v && git push"

# fix delete key
bindkey -a '\033[P' delete-char
bindkey -v '^?' backward-delete-char

# fix HOME, END
bindkey '\033[H' beginning-of-line
bindkey '\033[4~' end-of-line

# change output of time command
TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --min-height=8 --inline-info --layout=reverse'
export FZF_CTRL_T_OPTS="--preview '([[ -f {} ]] && (bat --style=numbers --color=always --line-range :500 {} || cat {})) || ([[ -d {} ]] && (tree -C -L 2 {} | less))' --select-1 --exit-0"

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

bindkey '^f' fzf-file-widget
bindkey '^p' fzf-cd-widget
