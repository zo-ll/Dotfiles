#!/bin/bash
# Get default source (microphone) name
mic_name=$(pactl info | grep "Default Source" | cut -d: -f2 | xargs)

if [ -z "$mic_name" ] || [ "$mic_name" = "" ]; then
    echo "%{F#4C566A}󰍭%{F-}"
    exit 0
fi

# Get mute status
mute=$(pactl list sources | grep -A10 "Name: $mic_name" | grep "Mute:" | head -1 | awk '{print $2}')

# Get volume
volume=$(pactl list sources | grep -A10 "Name: $mic_name" | grep "Volume:" | head -1 | grep -oP '\d+%' | head -1 | tr -d '%')

if [ "$mute" = "yes" ]; then
    echo "%{F#BF616A}󰍭%{F-}"
else
    echo "%{F#88C0D0}󰍬%{F-}"
fi

# Toggle mute if requested
if [ "${1:-}" = "toggle" ]; then
    pactl set-source-mute "$mic_name" toggle
fi