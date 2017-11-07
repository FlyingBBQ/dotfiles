#!/bin/bash

dir=~/music/dank/
song=$(ls $dir | sort -R | tail --lines=1)

mpv $dir$song --volume 70
