# battery-profile

Switches between TLP power profiles (`normal` / `maxsave`) on Void Linux,
applies the matching amdgpu power state, and records the active profile to
`/var/lib/battery-profile/current` for statusbar integration (e.g.
dwmblocks).

**Install location**: `/usr/local/bin/battery-profile`

**Requires**:
- `tlp` installed and its runit service linked (`/etc/sv/tlp` →
  `/var/service/tlp`)
- Profile configs in `/etc/tlp-profiles/` (`normal.conf`, `maxsave.conf`)

## Usage

```bash
battery-profile normal     # balanced profile
battery-profile maxsave    # max battery runtime
battery-profile status     # print current profile name
```

## Script

```sh
#!/bin/sh
# Usage: battery-profile [normal|maxsave|status]
set -e

PROFILE="$1"
STATE_FILE="/var/lib/battery-profile/current"
SRC_DIR="/etc/tlp-profiles"
DEST_DIR="/etc/tlp.conf.d"
DEST="$DEST_DIR/99-active-profile.conf"

if [ "$PROFILE" = "status" ]; then
    [ -f "$STATE_FILE" ] && cat "$STATE_FILE" || echo "unknown"
    exit 0
fi

if [ ! -f "$SRC_DIR/$PROFILE.conf" ]; then
    echo "Unknown profile: $PROFILE"
    echo "Available: $(ls "$SRC_DIR" | sed 's/\.conf//')"
    exit 1
fi

sudo mkdir -p "$DEST_DIR"
sudo mkdir -p "$(dirname "$STATE_FILE")"

sudo cp "$SRC_DIR/$PROFILE.conf" "$DEST"
sudo tlp start

if [ -e /sys/class/drm/card0/device/power_dpm_force_performance_level ]; then
    if [ "$PROFILE" = "maxsave" ]; then
        echo low | sudo tee /sys/class/drm/card0/device/power_dpm_force_performance_level >/dev/null
    else
        echo auto | sudo tee /sys/class/drm/card0/device/power_dpm_force_performance_level >/dev/null
    fi
fi

echo "$PROFILE" | sudo tee "$STATE_FILE" >/dev/null
echo "Switched to: $PROFILE"
```

## Install

```bash
sudo cp battery-profile /usr/local/bin/battery-profile
sudo chmod +x /usr/local/bin/battery-profile
```

## dwmblocks integration (planned)

```sh
#!/bin/sh
PROFILE=$(cat /var/lib/battery-profile/current 2>/dev/null || echo "?")
case "$PROFILE" in
    normal)  echo "⚡NORM" ;;
    maxsave) echo "🔋MAX" ;;
    *)       echo "?PWR" ;;
esac
```
