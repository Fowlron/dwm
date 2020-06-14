#!/bin/bash

getdate() {
    echo $(date +"%Y-%m-%d %H:%M")
}

getbattery() {
    state=$(cat /sys/class/power_supply/BAT0/status) 
    if [[ $state == "Discharging" ]]
    then
        echo "Discharging $(cat /sys/class/power_supply/BAT0/capacity)%"
    else
        echo "Charging $(cat /sys/class/power_supply/BAT0/capacity)%"
    fi
}

getnet() {
    SSID=$(iwgetid -r)
    if [[ $SSID == "" ]]
    then
        echo Disconnected
    else
        echo "$(ip a | grep inet | sed -n 3p | awk '{print $2}' | awk -F/ '{print $1}') | ${SSID}"
    fi
}

getcpu() {
    if [[ -f "/tmp/procstat" ]]
    then
        IFS=' ' read -ra b < /tmp/procstat
    else
        b=(0 0 0 0 0 0 0 0 0)
    fi

    IFS=' ' read -ra a < /proc/stat
    a=("${a[@]:1}")

    echo "${a[*]}" > /tmp/procstat

    if [[ ${b[0]} == 0 ]]
    then
        return
    fi

    sum=$(( (b[0] + b[1] + b[2] + b[3] + b[4] + b[5] + b[6]) - (a[0] + a[1] + a[2] + a[3] + a[4] + a[5] + a[6]) ))

    if [[ $sum == 0 ]]
    then
        return
    fi

    echo - | awk "{printf \"%.0f%\n\", 100 * ((${b[0]} + ${b[1]} + ${b[2]} + ${b[5]} + ${b[6]}) - (${a[0]} + ${a[1]} + ${a[2]} + ${a[5]} + ${a[6]})) / ${sum} }"
}

while :
do
    xsetroot -name "                                                  cpu: $(getcpu) | $(getnet) | $(getbattery) | $(getdate)"
    sleep 1s
done
