#!/bin/bash

MONITOR="DP-2"
CURRENT=$(xrandr --verbose | awk '/Brightness/{print $2}')

case "$1" in
  up)
    NEW=$(awk "BEGIN{val=$CURRENT+0.1; if(val>1)val=1; printf\"%.1f\",val}")
    xrandr --output $MONITOR --brightness $NEW
    ;;
  down)
    NEW=$(awk "BEGIN{val=$CURRENT-0.1; if(val<0.2)val=0.2; printf\"%.1f\",val}")
    xrandr --output $MONITOR --brightness $NEW
    ;;
  get)
    PCT=$(awk "BEGIN{printf\"%.0f\",$CURRENT*100}")
    echo "${PCT}%"
    ;;
esac