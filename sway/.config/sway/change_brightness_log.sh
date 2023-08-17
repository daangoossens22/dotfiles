#!/bin/sh
# usage: change_brightness_log [+/-] [args: --notification => send a notification]
# changes brightness in a logarithmic fassion
# NOTE: need to add user to video group for this to work

max_brightness_loc="/sys/class/backlight/intel_backlight/max_brightness"
cur_brightness_loc="/sys/class/backlight/intel_backlight/brightness"

max_brightness=$(cat "$max_brightness_loc")
cur_brightness=$(cat "$cur_brightness_loc")

if [ "$1" = "+" ] && [ "$cur_brightness" -eq 0 ]; then
    # hardcoded last brightness before brightness is set to 0
    cur_brightness=10
elif [ "$1" = "+" ]; then
    cur_brightness=$(( cur_brightness * 12 / 10 ))
    # brightness cannot exceed the max brightness
    cur_brightness=$(( cur_brightness > max_brightness ? max_brightness : cur_brightness ))
    cur_brightness=$(( cur_brightness <= 0 ? 2 : cur_brightness ))
elif [ "$1" = "-" ]; then
    cur_brightness=$(( cur_brightness * 10 / 12 ))
    # brightness cannot got below 0
    cur_brightness=$(( cur_brightness < 0 ? 0 : cur_brightness ))
fi

# set the calculated brightness
echo "$cur_brightness" > "$cur_brightness_loc"

if  [ "$2" = "--notification" ]; then
    # send notification to indicate current brightness (usefull when in fullscreen mode and can't see waybar)
    brightness_percentage=$(( cur_brightness * 100 / max_brightness ))
    dunstify -i brightness-display-symbolic -h string:x-dunst-stack-tag:brightness -h int:value:"$brightness_percentage" "Brighness: $brightness_percentage%"
fi
