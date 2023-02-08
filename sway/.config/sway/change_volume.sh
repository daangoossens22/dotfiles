#!/bin/sh
# usage: change_volume [+/-/m] [args: --notification => send a notification]

volume_amount=5

if [ "$1" = "+" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ +$volume_amount%
elif [ "$1" = "-" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ -$volume_amount%
elif [ "$1" = "m" ]; then
    pactl set-sink-mute @DEFAULT_SINK@ toggle
fi

if  [ "$2" = "--notification" ]; then
    volume_percentage=$(pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | sed -E 's/.* ([0-9]+)%.*/\1/')
    volume_mute=$(pactl get-sink-mute @DEFAULT_SINK@ | sed -E 's/Mute: (.*)/\1/')
    icon=audio-volume-low-symbolic
    title="Volume"
    hint_bar_color=""
    if [ "$volume_mute" = "yes" ] || [ "$volume_percentage" -eq 0 ]; then
        # icon=/usr/share/icons/Adwaita/scalable/status/audio-volume-muted-symbolic.svg
        icon=audio-volume-muted-symbolic
        title="Mute"
        hint_bar_color="-h string:hlcolor:#363646"
    elif [ "$volume_percentage" -gt 80 ]; then
        icon=audio-volume-high-symbolic
    elif [ "$volume_percentage" -gt 40 ]; then
        icon=audio-volume-medium-symbolic
    fi

    # send notification to indicate current volume (usefull when in fullscreen mode and can't see waybar)
    dunstify -i $icon $hint_bar_color -h string:x-dunst-stack-tag:volume -h int:value:"$volume_percentage" "$title: $volume_percentage%"
fi
