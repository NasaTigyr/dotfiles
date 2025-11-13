#!/bin/sh

while true; do
    battery=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo N/A)
    time=$(date +"%H:%M")
    xsetroot -name "🔋 $battery% | 🕒 $time"
    sleep 30
done &

exec dwm
