#!/bin/bash
# batteryprofile.sh — dwmblocks battery profile status block

BATSTAT=$(battery-profile status)

if [ "$BATSTAT" = "normal" ]; then
  echo "BatStat: Norm"
elif [ "$BATSTAT" = "save" ]; then
  echo "BatStat: Save"
else
  echo "BatStat: Err"
fi
