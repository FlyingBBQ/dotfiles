#
# ~/.zprofile
#
# FlyingBBQ » zsh
#

[[ -f ~/.profile ]] && . ~/.profile
[[ -f ~/.zshrc ]] && . ~/.zshrc

# autostart x on boot
## arch
#[[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 ]] && startx
## void
if [ -z "$DISPLAY" ] && [ "$(fgconsole)" -eq 1 ]; then
    startx
fi
