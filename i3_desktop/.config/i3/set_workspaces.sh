#!/bin/bash

sleep 0.5
lock.sh &

sleep 0.5
discord &

sleep 2
i3-msg 'workspace 2:|2| ; append_layout ~/.config/i3/workspaces/workspace-2-qt.json'
qutebrowser &

sleep 0.5
i3-msg 'workspace 3:|3| ; append_layout ~/.config/i3/workspaces/workspace-3_clock.json'

# terminals workspace 3
urxvt -name topleft -e 'ncmpcpp' &
urxvt -name bottomleft -e 'cava' &
urxvt -name topright -e bash -c "alsi -l -u && bash" &
urxvt -name centerright -e bash -c "tty-clock -s -b -c -C 3" &
urxvt -name bottomright -e bash -c "vtop -t brew" &
