#!/usr/bin/env bash
set -euo pipefail

get_current() {
    powerprofilesctl get 2>/dev/null || echo "balanced"
}

case "${1:-}" in
    status)
        current="$(get_current)"
        case "$current" in
            performance)  echo "%{F#BF616A} ● %{F-}%{F#4C566A} ○  ○ %{F-}" ;;
            balanced)     echo "%{F#4C566A} ○ %{F-}%{F#EBCB8B} ● %{F-}%{F#4C566A} ○ %{F-}" ;;
            power-saver)  echo "%{F#4C566A} ○  ○ %{F-}%{F#81A1C1} ● %{F-}" ;;
        esac
        ;;
    *)
        profiles="performance
balanced
power-saver"
        current="$(get_current)"
        selected="$(echo "$profiles" | while read -r p; do
            if [[ "$p" == "$current" ]]; then
                echo "* $p"
            else
                echo "  $p"
            fi
        done | rofi -dmenu -i -p "power profile" -no-show-icons | sed 's/^[* ] //')"

        if [[ -n "$selected" ]]; then
            powerprofilesctl set "$selected" 2>/dev/null || pkexec powerprofilesctl set "$selected"
        fi
        ;;
esac