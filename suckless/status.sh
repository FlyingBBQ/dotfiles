#!/usr/bin/env bash
#
# FlyingBBQ :: dwm status
#

# Colors
c_bg="#1"
c_fg="#5"
c_hl="#4"
c_iv="#3"
c_gn="#6"
c_gh="#7"
c_rn="#8"
c_rh="#9"

mod_string=""
status_fifo=/tmp/status-fifo

# Make fifo file
[ -e "$status_fifo" ] && rm "$status_fifo"
mkfifo "$status_fifo"

usage () {
cat << EOF
    Status script for dwm
    Pass modules in preferred order: status.sh [-m | --module]

    Supported modules:
        -d, --date
        -h, --time
        -m, --memory
        -c, --cpu
        -b, --battery
        -s, --ssid
        -t, --temp
        -e, --email
EOF
}

# Modules
mod_date () {
    while :
    do
        echo 'D'$(date "+%a %d %b");
        sleep 60;
    done > $status_fifo &
}

mod_time () {
    while :
    do
        echo 'H'$(date "+%T");
        sleep 1;
    done > $status_fifo &
}

mod_mem () {
    while :
    do
        perc=$(free -m | grep Mem | awk '{printf "%2.f", $3/$2 * 100.0}' | cut -d "%" -f1)
        if [ "$perc" -gt 85 ]; then
            mem="$c_rn RAM $c_rh$perc%"
        else
            mem="$c_hl RAM $c_fg$perc%"
        fi
        echo "M$mem"
        sleep 1;
    done > $status_fifo &
}

mod_cpu () {
    while :
    do
        echo 'C'$(awk -v a="$(awk '/cpu /{print $2+$4,$2+$4+$5}' /proc/stat; sleep 0.5)" '/cpu /{split(a,b," "); printf "%2.f", 100*($2+$4-b[1])/($2+$4+$5-b[2]) }'  /proc/stat)
        sleep 1;
    done > $status_fifo &
}

mod_bat () {
    while :
    do
        bat=""
        stat=$(acpi | awk '{print $3}' | sed 's/,$//')
        perc=$(acpi | awk '{print $4}' | sed 's/%,$//')
        case $stat in
            'Discharging')
                if [ "$perc" -lt 20 ]; then
                    bat="$c_rn BAT $c_rh$perc%"
                else
                    bat="$c_hl BAT $c_fg$perc%"
                fi
                ;;
            'Charging')
                bat="$c_gn BAT $c_gh$perc%"
                ;;
            *)
                bat="$c_hl BAT $c_fg$perc"
                ;;
        esac
        echo "B$bat"
        sleep 5
    done > $status_fifo &
}

mod_ssid () {
    while :
    do
        if [ "$(nmcli radio wifi)" == "enabled" ] && [ -n "$(iwgetid -r)" ]; then
            echo "S$(iwgetid -r)"
        else
            echo "Sdisconnected"
        fi
        sleep 3
    done > $status_fifo &
}

mod_temp () {
    while :
    do
        echo 'T'$(sensors | awk '/CPU Temperature/ {print $3}' | tr -d +)
        sleep 3;
    done > $status_fifo &
}

mod_mail () {
    while :
    do
        echo 'E'$(python ~/code/scripts/.mail)
        sleep 10;
    done > $status_fifo &
}

# Parse arguments, start modules, and create module string
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--date)      mod_date;  mod_string="${mod_string} \$date" ;;
        -h|--time)      mod_time;  mod_string="${mod_string} \$clock" ;;
        -m|--memory)    mod_mem;   mod_string="${mod_string} \$mem" ;;
        -c|--cpu)       mod_cpu;   mod_string="${mod_string} \$cpu" ;;
        -b|--battery)   mod_bat;   mod_string="${mod_string} \$battery" ;;
        -s|--ssid)      mod_ssid;  mod_string="${mod_string} \$ssid" ;;
        -t|--temp)      mod_temp;  mod_string="${mod_string} \$temp" ;;
        -e|--email)     mod_email; mod_string="${mod_string} \$clock" ;;
        *)  echo "Unknown parameter passed: $1"; usage;
            exit 1 ;;
    esac
    mod_string="${mod_string} \$c_bg"
    shift
done

# Expand module string with module values
while read -r line ; do
    case $line in
        D*) date="$c_hl ${line#?}" ;;
        H*) clock="$c_iv ${line#?}" ;;
        B*) battery="${line#?}" ;;
        E*) email="MAIL ${line#?}" ;;
        M*) mem="${line#?}" ;;
        C*) cpu="CPU $c_fg${line#?}%" ;;
        T*) temp="$c_fg ${line#?}" ;;
        S*) ssid="WiFi $c_fg${line#?}" ;;
    esac
    xsetroot -name " $(eval echo "$mod_string")"
done < "$status_fifo"

wait
