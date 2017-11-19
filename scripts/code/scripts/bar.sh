#! /bin/sh
#
# FlyingBBQ @ Bar
# mad props to dkeg
#

## colors
a="#"
bg2="282828"
bg3="3c3836"
bg=$(xrdb -query|awk '/\*background/ {print $2}'|cut -d '#' -f2)
fg=$(xrdb -query|awk '/\*foreground/ {print $2}'|cut -d '#' -f2)
blk=$(xrdb -query|awk '/\*color0:/ {print $2}'|cut -d '#' -f2)
bblk=$(xrdb -query|awk '/\*color8:/ {print $2}'|cut -d '#' -f2)
red=$(xrdb -query|awk '/\*color1:/ {print $2}'|cut -d '#' -f2)
grn=$(xrdb -query|awk '/\*color2:/ {print $2}'|cut -d '#' -f2)
ylw=$(xrdb -query|awk '/\*color3:/ {print $2}'|cut -d '#' -f2)
blu=$(xrdb -query|awk '/\*color4:/ {print $2}'|cut -d '#' -f2)
mag=$(xrdb -query|awk '/\*color5:/ {print $2}'|cut -d '#' -f2)
cyn=$(xrdb -query|awk '/\*color6:/ {print $2}'|cut -d '#' -f2)
wht=$(xrdb -query|awk '/\*color7:/ {print $2}'|cut -d '#' -f2)

normal="%{B$a$bg2}%{F$a$fg}$PR"
highlight="%{B$a$bg2}%{F$a$ylw}$PR"
hlinv="%{B$a$ylw}%{F$a$bg}$PR"

## variables
PL=" "
PR=" "
clr="$PL%{F-}%{B-}"

## functions
function ewhm() {
    monitor=0
    wm_infos=""
    TAGS=( $(herbstclient tag_status $monitor) )
    for i in "${TAGS[@]}" ; do
        case ${i:0:1} in
            '#')
                # focused occupied desktop
                wm_infos="${wm_infos}$hlinv ${i:1}$clr"
                ;;
            '+')
                # focused free desktop
                wm_infos="${wm_infos} ${i:1}"
                ;;
            '!')
                # focused urgent desktop
                wm_infos="${wm_infos} ${i:1}"
                ;;
            ':')
                # occupied desktop
                wm_infos="${wm_infos} ${i:1}"
                ;;
            *)
                # free desktop
                wm_infos="${wm_infos} ${i:1}"
                ;;
        esac
        shift
    done
    echo "$wm_infos"
}

function clock() {
    datetime=$(date "+%a %b %d, %T")
    echo "$normal $datetime "
}

function memory() {
    mem=$(free -m | grep Mem | awk '{printf "%2.f", $3/$2 * 100.0}')
    echo "$normal MEM $highlight${mem}%$clr"
}

function temp() {
    temp=$(cat /sys/class/thermal/thermal_zone0/temp | awk '{print $1/1000}')
    echo "$normal TMP $highlight${temp}°$clr"
}

function cpu() {
#ps -eo pcpu |grep -vE '^\s*(0.0|%CPU)' |sed -n '1h;$!H;$g;s/\n/ +/gp'
    cpu=$(awk -v a="$(awk '/cpu /{print $2+$4,$2+$4+$5}' /proc/stat; sleep 0.5)" '/cpu /{split(a,b," "); printf "%2.f", 100*($2+$4-b[1])/($2+$4+$5-b[2]) }'  /proc/stat)
    echo -e "$normal CPU $highlight${cpu}%$clr"
}

## modules
function modules() {
    left="%{l}$(ewhm)"
    center="%{c}$(clock)"
    right="%{r}$(temp) $(memory)"

    echo "$left$center$right"
}

## bar
fonts="-f -misc-tamsyn-medium-r-normal--16-116-100-100-c-80-iso8859-1"
sw="1920"       # screen width
bw="1500"       # bar width
bh="30"         # bar height
by="10"         # bar y-offset
bx=$(( ($sw - $bw)/2 ))

G="-g ${bw}x${bh}+${bx}+${by}"      # geometry
P=" $fonts -B $a$bg -F $a$fg"       # parameters

bar="lemonbar "$G$P

## output the bar
while true
do
    echo "$(modules)"
    sleep 0.2
done | $bar
