#
# ~/.zprofile
#
# FlyingBBQ » zsh
#

# prompt
PROMPT='%F{red}%~ %F{yellow}%(?.▼.▽)%f '
RPROMPT='${vcs_info_msg_0_} %F{237}%*%f'

# alias
alias ls='exa -g'
alias ll='ls -l'
alias la='ls -a'
alias lt='ls -TL 2'

alias pac='paru'
alias ranger='. ranger'
alias stowc='stow -t ~/.config'
alias fda='fd --no-ignore -L'
alias slep='~/bin/lock.sh && systemctl suspend'
alias gs='git status'
alias td='nvim ~/.todo'
alias dpc='$(echo $TERM | sed "s/-256color//") &!'

alias weather='curl -s wttr.in | head -7'
alias forecast='curl -s wttr.in'

alias dl='cd ~/downloads'
alias dots='cd ~/.dotfiles'
alias nvimit='cd ~/.config/nvim && nvim init.lua'

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
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{blue}"
zstyle ':vcs_info:*' unstagedstr "%F{magenta}"
zstyle ':vcs_info:git*' formats "%F{237}[%F{green}%c%u%b%F{237}]"
zstyle ':vcs_info:git*' actionformats "%F{237}(%F{cyan}%a%F{237})-[%F{green}%c%u%b%F{237}]"
precmd() {
    vcs_info
}

# vi mode cursor
zle-keymap-select() {
    if [ $TERM = "st-256color" ]; then
        if [ $KEYMAP = vicmd ]; then
            echo -ne "\e[2 q"
        else
            echo -ne "\e[4 q"
        fi
    fi
}
zle -N zle-keymap-select

zle-line-init() {
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
bindkey '^p' history-beginning-search-backward
bindkey '^n' history-beginning-search-forward
bindkey '^k' expand-or-complete
bindkey -M menuselect '^j' reverse-menu-complete

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
bindkey '^o' fzf-cd-widget

# fzf + git
is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
    fzf --height 80% --min-height 20 --preview-window right:70% --bind ctrl-l:toggle-preview "$@"
}

gd() {
    # Show diff for each modified file.
    is_in_git_repo || return
    preview_cmd="git diff $@ --color=always -- {-1} | sed 1,4d"
    git diff $@ --name-only | fzf-down -m --ansi --preview $preview_cmd | read file_name
    if [[ ! -z "$file_name" ]] ; then
        git diff $@ -- $file_name
    fi
}


gb() {
    # Display commits for each branch
    is_in_git_repo || return
    preview_cmd='git log --oneline --graph --color=always $(sed s/^..// <<< {} | cut -d" " -f1)'
    git branch -a --color=always | grep -v '/HEAD\s' | sort |
    fzf-down --ansi --multi --tac --preview $preview_cmd |
    sed 's/^..//' | cut -d' ' -f1 |
    sed 's#^remotes/##'
}

gsl() {
    # List stashes and browse files in the selected stash.
    is_in_git_repo || return
    git stash list | fzf | cut -d':' -f1 | read stash_name
    git log $stash_name --format="%H" | read stash_hash
    if [[ ! -z $stash_name ]] ; then
        gd $stash_hash~ $stash_hash
    fi
}

gh() {
    # Show commit history and browse files of diff.
    is_in_git_repo || return
    preview_cmd='grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always'
    git log --oneline --graph --color=always |
    fzf-down --ansi --no-sort --reverse --multi --preview $preview_cmd |
    grep -o "[a-f0-9]\{7,\}" | read commit_hash
    if [[ ! -z $commit_hash ]] ; then
        gd $commit_hash~ $commit_hash
    fi
}

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=239"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true
bindkey '^_' autosuggest-accept
