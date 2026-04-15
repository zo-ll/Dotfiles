#!/usr/bin/env sh

# Terminate already running Polybar instances
killall -q polybar
killall -q fullscreen-hide.sh

# Wait until the process have been shut down
while pgrep -x polybar > /dev/null; do sleep 1; done

# Launch Polybar
polybar mybar -c ~/.config/polybar/config.ini &

# Start fullscreen monitor
~/.config/polybar/fullscreen-hide.sh &
