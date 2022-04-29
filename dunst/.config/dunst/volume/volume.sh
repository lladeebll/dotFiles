#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh toggle

icon_path="/usr/share/icons/Faba/48x48/notifications/"

function get_volume {
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
    DIR=`dirname "$0"`
    volume=`get_volume`
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    # bar=$(seq -s "─" $(($volume/5)) | sed 's/[0-9]//g')
    if [ "$volume" = "0" ]; then
        icon_name="${icon_path}notification-audio-volume-muted.svg"
        $DIR/notify-send.sh "$volume""      " -i "$icon_name" -t 2000 --replace=555
    else
        if [  "$volume" -lt "10" ]; then
            icon_name="${icon_path}notification-audio-volume-low.svg"
            $DIR/notify-send.sh "$volume""     " -i "$icon_name" --replace=555 -t 2000
        else
            if [ "$volume" -lt "30" ]; then
                icon_name="${icon_path}notification-audio-volume-low.svg"
            else
                if [ "$volume" -lt "70" ]; then
                    icon_name="${icon_path}notification-audio-volume-medium.svg"
                else
                    icon_name="${icon_path}notification-audio-volume-high.svg"
                fi
            fi
        fi
    fi
    bar=$(seq -s "─" $(($volume/5)) | sed 's/[0-9]//g')
    # Send the notification
    $DIR/notify-send.sh "$volume""     ""$bar" -i "$icon_name" -t 2000  --replace=555

}

case $1 in
    up)
        # Set the volume on (if it was muted)
        amixer set Master on > /dev/null
        # Up the volume (+ 5%)
        amixer sset Master 5%+ > /dev/null
        send_notification
        ;;
    down)
        amixer set Master on > /dev/null
        amixer sset Master 5%- > /dev/null
        send_notification
        ;;
    toggle)
        # Toggle mute
        amixer set Master 1+ toggle > /dev/null
        if is_mute ; then
            DIR=`dirname "$0"`
            $DIR/notify-send.sh -i "${icon_path}notification-audio-volume-muted.svg" --replace=555 -u normal "Mute" -t 2000
        else
            send_notification
        fi
        ;;
esac