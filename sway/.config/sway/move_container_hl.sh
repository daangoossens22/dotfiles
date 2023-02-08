#!/bin/sh

# usage: move_container_hl [c/m] [int; relative location e.g -1/+1 => left/right]
cur_container=$(swaymsg -r -t get_outputs | python -c "import sys, json; obj=json.load(sys.stdin); val=int(obj[0]['current_workspace']); print(val)")
container=$((cur_container+$2))
if [ "$container" -lt 1 ]; then
    container=1
fi

if [ "$1" = "c" ]; then
    swaymsg move container to workspace "$container"
fi
swaymsg workspace number "$container"
