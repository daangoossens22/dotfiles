#!/bin/sh

# usage: move_container_hl [c/m] [int; relative location e.g -1/+1 => left/right]
outputs=$(swaymsg -r -t get_outputs)
output=$(echo "$outputs" | python -c '
import sys, json;
obj = json.load(sys.stdin)
i = 0
for v in obj:
    if v["focused"] == True:  
        print(i)
    i += 1
')
echo "$output"
cur_container=$(echo "$outputs" | python -c "import sys, json; obj=json.load(sys.stdin); val=int(obj[$output]['current_workspace']); print(val)")
echo "$cur_container"
container=$((cur_container+$2))
if [ "$container" -lt 1 ]; then
    container=1
fi

if [ "$1" = "c" ]; then
    swaymsg move container to workspace number "$container"
fi
swaymsg workspace number "$container"
