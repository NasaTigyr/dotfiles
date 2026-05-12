#!/bin/bash
# battery.sh — dwmblocks battery status block

BAT_PATH=$(ls /sys/class/power_supply/ | grep -E '^BAT' | head -n1)

if [ -z "$BAT_PATH" ]; then
  echo "BAT: N/A"
  exit 0
fi

BAT_DIR="/sys/class/power_supply/$BAT_PATH"

CAPACITY=$(cat "$BAT_DIR/capacity" 2>/dev/null)
STATUS=$(cat "$BAT_DIR/status" 2>/dev/null)

if [ "$STATUS" = "Charging" ]; then
  echo "BAT: ${CAPACITY}% [CHR]"
elif [ "$STATUS" = "Full" ]; then
  echo "BAT: Full"
elif [ -n "$CAPACITY" ]; then
  if [ "$CAPACITY" -le 20 ]; then
    echo "BAT: ${CAPACITY}% [LOW]"
  else
    echo "BAT: ${CAPACITY}%"
  fi
else
  echo "BAT: ?"
fi
