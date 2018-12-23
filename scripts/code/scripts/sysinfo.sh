#!/bin/sh
#
# FlyingBBQ - sysinfo
#

distro="$(cat /etc/*-release | grep PRETTY_NAME | cut -d '=' -f2 | tr -d '"')"
shell="$(echo $SHELL | cut -c 6-)"
wm="$(wmctrl -m | grep Name: | cut -d ' ' -f2)"
packages="$(pacman -Qq | wc -l)"
font="tamsyn"
colors="gruvbox"

#printf " \033[1;31m    ▄ \033[1;32m ▄ \033[1;33m ▄ \033[1;34m ▄ \033[1;35m ▄ \033[1;36m ▄ \033[1;37m ▄ \n"
printf " \033[0m\n"
printf " \033[1;34m       distro \033[0m$distro\n"
printf " \033[1;34m     packages \033[0m$packages\n"
printf " \033[1;34m        shell \033[0m$shell\n"
printf " \033[1;34m           wm \033[0m$wm\n"
printf " \033[1;34m         font \033[0m$font $fontsize\n"
printf " \033[1;34m       colors \033[0m$colors\n"
printf " \033[0m\n"
printf " \033[1;31m    ▀ \033[1;32m ▀ \033[1;33m ▀ \033[1;34m ▀ \033[1;35m ▀ \033[1;36m ▀ \033[1;37m ▀ \n"

curl -s wttr.in | awk 'NR>=2 && NR<=7'

#printf " \033[0m\n"
#printf " \033[1;31m    ▀ \033[1;32m ▀ \033[1;33m ▀ \033[1;34m ▀ \033[1;35m ▀ \033[1;36m ▀ \033[1;37m ▀ \n"
