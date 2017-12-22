#
# ~/.zprofile
#
# FlyingBBQ » zsh
#

[[ -f ~/.profile ]] && . ~/.profile
[[ -f ~/.zshrc ]] && . ~/.zshrc

# autostart x on boot
[[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 ]] && startx
