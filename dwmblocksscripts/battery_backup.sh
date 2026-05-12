#!/bin/bash
# battery.sh — dwmblocks battery status block
# Shows battery percentage and charging status with an icon.
# Place in ~/.local/bin/ or ~/scripts/ and make executable: chmod +x battery.sh

# Find the first battery (usually BAT0 or BAT1)
BAT_PATH=$(ls /sys/class/power_supply/ | grep -E '^BAT' | head -n1)

if [ -z "$BAT_PATH" ]; then
  echo "No BAT"
  exit 0
fi

BAT_DIR="/sys/class/power_supply/$BAT_PATH"

CAPACITY=$(cat "$BAT_DIR/capacity" 2>/dev/null)
STATUS=$(cat "$BAT_DIR/status" 2>/dev/null) # Charging, Discharging, Full, Unknown

# Pick icon based on level and status
if [ "$STATUS" = "Charging" ]; then
  ICON="⚡"
elif [ "$STATUS" = "Full" ]; then
  ICON=""
elif [ -n "$CAPACITY" ]; then
  if [ "$CAPACITY" -ge 90 ]; then
    ICON="🔋"
  elif [ "$CAPACITY" -ge 60 ]; then
    ICON="🔋"
  elif [ "$CAPACITY" -ge 40 ]; then
    ICON="🪫"
  elif [ "$CAPACITY" -ge 20 ]; then
    ICON="🪫"
  else
    ICON="❗"
  fi
else
  ICON="?"
fi

# Output format: icon + percentage + status hint
if [ "$STATUS" = "Charging" ]; then
  echo "$ICON ${CAPACITY}% +"
elif [ "$STATUS" = "Full" ]; then
  echo "$ICON Full"
else
  echo "$ICON ${CAPACITY}%"
fi
