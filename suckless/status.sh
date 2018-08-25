#! /bin/sh
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
    echo 'M'$(free -m | grep Mem | awk '{printf "%2.f", $3/$2 * 100.0}' | cut -d "%" -f1)
    sleep 1;
done > $status_fifo &

# cpu
while :
do
    echo 'C'$(awk -v a="$(awk '/cpu /{print $2+$4,$2+$4+$5}' /proc/stat; sleep 0.5)" '/cpu /{split(a,b," "); printf "%2.f", 100*($2+$4-b[1])/($2+$4+$5-b[2]) }'  /proc/stat)
    sleep 1;
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
            clock="${line#?}"
            ;;
        I*)
            window="${line#?}"
            ;;
        E*)
            email="MAIL ${line#?}"
            ;;
        M*)
            mem="RAM #5${line#?}%"
            ;;
        C*)
            cpu="CPU #5${line#?}%"
            ;;
        T*)
            tmp="temp ${line#?}°"
            ;;
    esac
    xsetroot -name  " $cpu $sep $mem $sep $date #1 #5 $clock "

done < "$status_fifo"

wait
