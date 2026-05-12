#!/bin/sh

# Start a session DBus if not already running
if command -v dbus-launch >/dev/null && [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
  eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

# Start compositor
picom --backend xrender &

# Set wallpaper
feh --bg-scale /home/tgr/background.jpg &

# Status bar
dwmblocks &

# Keyboard layout (no sudo needed)
setxkbmap us,bg -variant dvorak,phonetic -option grp:shifts_toggle

# Auto-start Discord Flatpak
#flatpak run --env=ZYPAK_DISABLE_SANDBOX=1 com.discordapp.Discord &

# Finally, start dwm
exec dwm
