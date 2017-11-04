#!/bin/bash

# check if mpd is playing
artist=$(mpc -h ~/.config/mpd/socket current -f %artist%)
if [ -n "$artist" ]; then

    # create temp file if $artist is not null
    temp=/tmp/.lastSong_info
    if [ ! -e $temp ]; then
        touch $temp
        echo "tit" > $temp
    fi

    current=`cat $temp`
    if [ "$current" == "tit" ]; then
        echo "- $artist -"
        echo "art" > $temp
    else 
        title=$(mpc -h ~/.config/mpd/socket current -f %title%)
        echo $title 
        echo "tit" > $temp
    fi
else
    echo ""
fi
