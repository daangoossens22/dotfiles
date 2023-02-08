#!/bin/sh

con_info="$(bluetoothctl show)"
power_on="$(echo "$con_info" | sed -n 's/.*Powered: //p')"

dev_info="$(bluetoothctl info)"
dev_connected="$?"

dev_extract() {
    echo "$dev_info" | sed -n "s/.*$1: //p"
}

# NOTE: the different icons for bluetooth don't work for the current font
if [ "$power_on" = "no" ]; then
    # icon=""
    echo "Off \n"
elif [ $dev_connected -ne 0 ]; then
    # icon=""
    echo "On \n"
else
    # icon=""
    bat_percentage="$(echo "$dev_info" | sed -n 's/.*Battery Percentage: .*(//p' | sed -n 's/)//p')"
    name="$(dev_extract "Name")"
    # trusted="$(dev_extract "Trusted")"

    echo "$bat_percentage% \n$name"
fi
