#!/bin/bash

selected=$(nmcli -t -f ssid,in-use,signal,security dev wifi list \
    | grep -v '^[[:space:]]*:' \
    | sort -t: -k3 -rn \
    | awk -F: '!seen[$1]++' \
    | awk -F: '{if($2=="*") printf "* %s (%s%%) %s\n",$1,$3,$4; else printf "  %s (%s%%) %s\n",$1,$3,$4}' \
    | rofi -dmenu -i -p "WiFi" -no-custom)

[ -z "$selected" ] && exit 0

ssid=$(echo "$selected" | sed 's/^[* ] //' | cut -d'(' -f1 | xargs)

nmcli dev wifi connect "$ssid"