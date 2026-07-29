#!/usr/bin/env bash
#
# setup-stm32-dev.sh
# Sets up an STM32/BlackPill embedded dev environment on Void Linux:
#   - ARM cross toolchain (gcc, binutils, gdb)
#   - Flashing tools (dfu-util, stlink)
#   - OpenOCD (SWD debug bridge)
#   - Neovim + tools LazyVim needs
#   - udev rules + group membership for ST-Link USB access
#
# Usage: ./setup-stm32-dev.sh

set -euo pipefail

# ---------- helpers ----------
log() { printf '\n\033[1;32m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$1"; }
err() { printf '\033[1;31m[error]\033[0m %s\n' "$1" >&2; }

require_root_actions() {
  if [[ $EUID -eq 0 ]]; then
    err "Don't run this whole script as root — it uses sudo where needed."
    exit 1
  fi
}

# ---------- package install ----------
install_packages() {
  log "Installing packages via xbps"

  local packages=(
    cross-arm-none-eabi-binutils
    cross-arm-none-eabi-gcc
    cross-arm-none-eabi-gdb
    dfu-util
    stlink
    openocd
    neovim
    git
    make
    gcc
    ripgrep
    fd
  )

  sudo xbps-install -Sy "${packages[@]}"
}

# ---------- verify toolchain ----------
verify_toolchain() {
  log "Verifying toolchain binaries"

  local bins=(arm-none-eabi-gcc arm-none-eabi-objcopy arm-none-eabi-gdb dfu-util openocd st-info nvim rg fd)
  local missing=()

  for bin in "${bins[@]}"; do
    if command -v "$bin" >/dev/null 2>&1; then
      printf '  [ok] %s -> %s\n' "$bin" "$(command -v "$bin")"
    else
      printf '  [missing] %s\n' "$bin"
      missing+=("$bin")
    fi
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    warn "Some binaries are missing: ${missing[*]}"
    warn "Check package names above — they may differ between Void releases."
  fi
}

# ---------- udev rules for ST-Link ----------
setup_udev() {
  log "Checking udev rules for ST-Link"

  if ls /etc/udev/rules.d/ 2>/dev/null | grep -qi stlink; then
    log "ST-Link udev rules already present"
  else
    warn "No ST-Link udev rules found, installing a basic one"
    sudo tee /etc/udev/rules.d/49-stlinkv2.rules >/dev/null <<'EOF'
# ST-Link V2
SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3748", MODE="0666", GROUP="plugdev"
# ST-Link V2-1
SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374b", MODE="0666", GROUP="plugdev"
EOF
    sudo udevadm control --reload-rules
    sudo udevadm trigger
  fi
}

# ---------- group membership ----------
setup_groups() {
  log "Checking plugdev group membership"

  if ! getent group plugdev >/dev/null; then
    warn "plugdev group doesn't exist, creating it"
    sudo groupadd plugdev
  fi

  if id -nG "$USER" | grep -qw plugdev; then
    log "$USER already in plugdev group"
  else
    log "Adding $USER to plugdev group (log out/in required to take effect)"
    sudo usermod -aG plugdev "$USER"
    warn "You must log out and back in (or reboot) for group changes to apply."
  fi
}

# ---------- LazyVim starter (optional) ----------
setup_lazyvim() {
  local nvim_config="$HOME/.config/nvim"

  if [[ -d "$nvim_config" ]]; then
    log "Neovim config already exists at $nvim_config — skipping LazyVim clone"
    return
  fi

  read -r -p "No Neovim config found. Clone LazyVim starter into $nvim_config? [y/N] " reply
  if [[ "$reply" =~ ^[Yy]$ ]]; then
    git clone https://github.com/LazyVim/starter "$nvim_config"
    log "Cloned LazyVim starter. Run 'nvim' once to let it install plugins."
  else
    log "Skipping LazyVim setup."
  fi
}

# ---------- summary ----------
print_summary() {
  log "Setup complete. Quick reference:"
  cat <<'EOF'

  Flash via DFU:
    make flash            # after entering DFU mode (BOOT0 + reset)

  Flash/debug via ST-Link + OpenOCD:
    openocd -f interface/stlink.cfg -f target/stm32f4x.cfg

  Manual GDB debug session:
    arm-none-eabi-gdb firmware.elf
      target extended-remote localhost:3333
      monitor reset halt
      load
      break main
      continue

  Neovim + nvim-dap:
    Add plugin config pointing gdbPath / adapter command at:
      arm-none-eabi-gdb

  If ST-Link isn't detected, re-check:
    st-info --probe
    groups                # should include plugdev
EOF
}

# ---------- main ----------
main() {
  require_root_actions
  install_packages
  verify_toolchain
  setup_udev
  setup_groups
  setup_lazyvim
  print_summary
}

main "$@"
