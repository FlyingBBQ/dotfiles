#!/bin/sh

userresources=$HOME/.xresources
usermodmap=$HOME/.xmodmap
userkeymap=$HOME/.xbindkeysrc
userstartup=$HOME/.startup_local

# merge in user defaults
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -f "$userkeymap" ]; then
    xbindkeys &
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

if [ -f "$userstartup" ]; then
    . "$userstartup"
fi

# relaunch dwm if the binary changes, otherwise bail
csum=$(sha1sum $(which dwm))
new_csum=""
while true
do
    if [ "$csum" != "$new_csum" ]
    then
        csum=$new_csum
        dwm
    else
        exit 0
    fi
    new_csum=$(sha1sum $(which dwm))
    sleep 1
done

