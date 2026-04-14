#!/bin/bash
# Volume control script with 100% cap

case "${1:-}" in
    up)
        # Get current volume percentage
        current=$(pactl list sinks | grep -E "^\s*Volume:" | head -1 | grep -oE "[0-9]+%" | head -1 | tr -d '%')
        if [ -z "$current" ]; then
            current=0
        fi
        if [ "$current" -lt 100 ]; then
            new=$((current + 5))
            [ "$new" -gt 100 ] && new=100
            pactl set-sink-volume @DEFAULT_SINK@ "${new}%"
        fi
        ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
esac