#
# ~/.bash_profile
#

[[ -f ~/.profile ]] && . ~/.profile
[[ -f ~/.bashrc ]] && . ~/.bashrc

# autostart x on boot
[[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 ]] && startx
