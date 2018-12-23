#!/bin/sh
#
# FlyingBBQ - sysinfo
#

distro="$(cat /etc/*-release | grep PRETTY_NAME | cut -d '=' -f2 | tr -d '"')"
shell="$(echo $SHELL | cut -c 6-)"
wm="$(wmctrl -m | grep Name: | cut -d ' ' -f2)"
packages="$(pacman -Qq | wc -l)"
font="Tamsyn"
colors="Gruvbox"

#printf " \e[1;31m    ▄ \e[1;32m ▄ \e[1;33m ▄ \e[1;34m ▄ \e[1;35m ▄ \e[1;36m ▄ \e[1;37m ▄ \n"
printf " \e[0m\n"
printf " \e[1;34m       distro \e[0m$distro\n"
printf " \e[1;34m     packages \e[0m$packages\n"
printf " \e[1;34m        shell \e[0m$shell\n"
printf " \e[1;34m           wm \e[0m$wm\n"
printf " \e[1;34m         font \e[0m$font $fontsize\n"
printf " \e[1;34m       colors \e[0m$colors\n"
printf " \e[0m\n"
printf " \e[1;31m    ▀ \e[1;32m ▀ \e[1;33m ▀ \e[1;34m ▀ \e[1;35m ▀ \e[1;36m ▀ \e[1;37m ▀ \n"

curl -s wttr.in | awk 'NR>=2 && NR<=7'

#printf " \e[0m\n"
#printf " \e[1;31m    ▀ \e[1;32m ▀ \e[1;33m ▀ \e[1;34m ▀ \e[1;35m ▀ \e[1;36m ▀ \e[1;37m ▀ \n"
