#!/bin/sh
# This shell script is PUBLIC DOMAIN. You may do whatever you want with it.

TOGGLE=/tmp/.toggle

if [ ! -e $TOGGLE ]; then
    touch $TOGGLE
    notify-send "xautolock disabled"
    pkill xautolock
else
    rm $TOGGLE
    xautolock -time 15 -locker '/usr/bin/i3lock-fancy' &
    notify-send "xautolock enabled"
fi
