#!/bin/sh

eval $(dbus-launch --sh-syntax --exit-with-session)
pipewire &
pipewire-pulse &
wireplumber &

while true; do
    battery=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo N/A)
    time=$(date +"%H:%M")
    xsetroot -name "🔋 $battery% | 🕒 $time"
    sleep 30
done &

exec dwm
