#!/usr/bin/env bash

# You can call this script like this:
# $ ./brightnessControl.sh up
# $ ./brightnessControl.sh down

# Script inspired by these wonderful people:
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a

icon_path="/usr/share/icons/Faba/48x48/notifications/"
notify="notify-git"

function get_brightness {
    echo $(($(brightnessctl get)*100/$(brightnessctl max)))
}

function send_notification {
    DIR=`dirname $(dirname "$0")`
    icon_name="${icon_path}notification-display-brightness.svg"
    brightness=`get_brightness`
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq -s "─" 0 $((brightness / 4)) | sed 's/[0-9]//g')
    # Send the notification
    $DIR/$notify/notify-send.sh "$brightness""     ""$bar" -i "$icon_name" -a "brightnessControl" -t 2000  --replace=555
}

case $1 in
    up)
        # increase the backlight by 2%
        brightnessctl set +2%
        send_notification
        ;;
    down)
        # decrease the backlight by 2%
        brightnessctl set 2-%
        send_notification
        ;;
esac
