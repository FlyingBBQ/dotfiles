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
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!{.git}/*"'
export FZF_DEFAULT_OPTS='--height 30% --min-height=8 --inline-info --layout=reverse'

if [[ $- == *i* ]]; then

# CTRL-F - Paste the selected file path(s) into the command line
__fsel() {
    local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
        -o -type f -print \
        -o -type d -print \
        -o -type l -print 2> /dev/null | cut -b3-"}"
            setopt localoptions pipefail 2> /dev/null
            eval "$cmd" | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read item; do
            echo -n "${(q)item} "
        done
        local ret=$?
        echo
        return $ret
    }

fzf-file-widget() {
LBUFFER="${LBUFFER}$(__fsel)"
local ret=$?
zle reset-prompt
return $ret
}
zle     -N   fzf-file-widget
bindkey '^f' fzf-file-widget

# Ensure precmds are run after cd
fzf-redraw-prompt() {
local precmd
for precmd in $precmd_functions; do
    $precmd
done
zle reset-prompt
}
zle -N fzf-redraw-prompt

# CTRL-p - cd into the selected directory
fzf-cd-widget() {
local cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | cut -b3-"}"
    setopt localoptions pipefail 2> /dev/null
    local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" fzf +m)"
    if [[ -z "$dir" ]]; then
        zle redisplay
        return 0
    fi
    cd "$dir"
    local ret=$?
    zle fzf-redraw-prompt
    return $ret
}
zle     -N   fzf-cd-widget
bindkey '^p' fzf-cd-widget

# CTRL-R - Paste the selected command from history into the command line
fzf-history-widget() {
local selected num
setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
selected=( $(fc -rl 1 |
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" fzf) )
    local ret=$?
    if [ -n "$selected" ]; then
        num=$selected[1]
        if [ -n "$num" ]; then
            zle vi-fetch-history -n $num
        fi
    fi
    zle reset-prompt
    return $ret
}
zle     -N   fzf-history-widget
bindkey '^r' fzf-history-widget

fi
# end fzf
