#!/bin/sh

battery_info=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)
percentage=$(echo "$battery_info" | grep "percentage:" | sed -E 's/.* ([0-9]+)%.*/\1/')
charging_state=$(echo "$battery_info" | grep "state:" | awk '{print $2}')

if [ "$percentage" = "15" ] && [ "$charging_state" = "discharging" ]; then
    dunstify -i battery-empty-symbolic -u critical "Battery almost empty"
fi
