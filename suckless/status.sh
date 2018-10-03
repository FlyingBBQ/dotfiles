#!/bin/sh
#
# FlyingBBQ @ dwm status
#

status_fifo=/tmp/status-fifo
sep="#1 #4"

# make fifo file
[ -e "$status_fifo" ] && rm "$status_fifo"
mkfifo "$status_fifo"

## Modules
# date
while :
do
    echo 'D'$(date "+%a %d %b");
    sleep 60;
done > $status_fifo &

# time
while :
do
    echo 'H'$(date "+%T");
    sleep 1;
done > $status_fifo &

# memory
while :
do
    perc=$(free -m | grep Mem | awk '{printf "%2.f", $3/$2 * 100.0}' | cut -d "%" -f1)
    if [ $perc -gt 85 ]; then
        mem="#8 RAM #9$perc%"
    else
        mem="#4 RAM #5$perc%"
    fi
    echo "M$mem"
    sleep 1;
done > $status_fifo &

# cpu
while :
do
    echo 'C'$(awk -v a="$(awk '/cpu /{print $2+$4,$2+$4+$5}' /proc/stat; sleep 0.5)" '/cpu /{split(a,b," "); printf "%2.f", 100*($2+$4-b[1])/($2+$4+$5-b[2]) }'  /proc/stat)
    sleep 1;
done > $status_fifo &

# battery
while :
do
    bat=""
    stat=$(acpi | awk '{print $3}' | sed 's/,$//')
    perc=$(acpi | awk '{print $4}' | sed 's/%,$//')
    case $stat in
        'Discharging')
            if [ $perc -lt 20 ]; then
                bat="#8 BAT #9$perc%"
            else
                bat="#4 BAT #5$perc%"
            fi
            ;;
        'Charging')
            bat="#6 BAT #7$perc%"
            ;;
        *)
            bat="#4 BAT #5$perc%"
            ;;
    esac
    echo "B$bat"
    sleep 5
done > $status_fifo &

# SSID
while :
do
    if [ "$(nmcli radio wifi)" == "enabled" ] && [ -n "$(iwgetid -r)" ]; then
        echo "S$(iwgetid -r)"
    else
        echo "Sdisconnected"
    fi
    sleep 3
done > $status_fifo &

# temp
#while :
#do
#    echo 'T'$(cat /sys/class/thermal/thermal_zone0/temp | awk '{print $1/1000}')
#    sleep 3;
#done > $status_fifo &

# email
#while :
#do
#    echo 'E'$(python ~/code/scripts/.mail)
#    sleep 10;
#done > $status_fifo &


## bar
while read -r line ; do
    case $line in
        D*)
            date="${line#?}"
            ;;
        H*)
            clock="#3 ${line#?}"
            ;;
        B*)
            battery="${line#?}"
            ;;
        E*)
            email="MAIL ${line#?}"
            ;;
        M*)
            mem="${line#?}"
            ;;
        C*)
            cpu="CPU #5${line#?}%"
            ;;
        T*)
            tmp="temp ${line#?}°"
            ;;
        S*)
            ssid="WiFi #5${line#?}"
            ;;
    esac
    xsetroot -name  " $ssid $sep $cpu #1 $mem #1 $battery $sep $date #1 $clock "

done < "$status_fifo"

wait
