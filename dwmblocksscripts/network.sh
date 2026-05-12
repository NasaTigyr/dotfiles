#!/bin/bash
# network.sh — dwmblocks network status block
# Shows active WiFi SSID or Ethernet connection. Falls back gracefully.
# Requires: iproute2 (ip), iw (for WiFi SSID). Both are standard on most distros.
# Place in ~/.local/bin/ or ~/scripts/ and make executable: chmod +x network.sh

# ── helpers ──────────────────────────────────────────────────────────────────

# Returns "up" if the interface has a carrier and an IP, else "down"
iface_is_up() {
  local iface="$1"
  local state
  state=$(cat "/sys/class/net/$iface/operstate" 2>/dev/null)
  [ "$state" = "up" ] && return 0
  return 1
}

# ── detect active interfaces ──────────────────────────────────────────────────

WIFI_IFACE=""
ETH_IFACE=""

for iface in $(ls /sys/class/net/); do
  [ "$iface" = "lo" ] && continue

  # Wireless interfaces usually live under /sys/class/net/<iface>/wireless
  if [ -d "/sys/class/net/$iface/wireless" ]; then
    if iface_is_up "$iface"; then
      WIFI_IFACE="$iface"
    fi
  else
    # Treat everything else that's up as a wired interface
    if iface_is_up "$iface"; then
      ETH_IFACE="$iface"
    fi
  fi
done

# ── build output ──────────────────────────────────────────────────────────────

OUTPUT=""

# WiFi block
if [ -n "$WIFI_IFACE" ]; then
  SSID=$(iw dev "$WIFI_IFACE" info 2>/dev/null | awk '/ssid/ {print $2}')
  if [ -n "$SSID" ]; then
    OUTPUT="NET: $SSID"
  else
    OUTPUT="NET: WiFi"
  fi
fi

# Ethernet block
if [ -n "$ETH_IFACE" ]; then
  ETH_LABEL="NET: ETH ($ETH_IFACE)"
  if [ -n "$OUTPUT" ]; then
    OUTPUT="$OUTPUT | $ETH_LABEL"
  else
    OUTPUT="$ETH_LABEL"
  fi
fi

# Nothing connected
if [ -z "$OUTPUT" ]; then
  OUTPUT="NET: down"
fi

echo "$OUTPUT"
