#
# ~/.profile
#
# FlyingBBQ » shell
#

export VISUAL="nvim"
export EDITOR=$VISUAL
export TERMCMD="/usr/local/bin/st"
export XDG_CONFIG_HOME=${HOME}/.config

export PATH=${PATH}:${HOME}/bin
export PATH=${PATH}:${HOME}/.local/bin

# Fix misbehaving Java applications in dwm
export _JAVA_AWT_WM_NONREPARENTING=1
