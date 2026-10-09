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
#
# ---------- project variables ----------
STM32_DIR_PATH=""
PROJECT_NAME=""
PROJECT_DIR=""
STM32MODEL=""

# ---------- helpers ----------
log() { printf '\n\033[1;32m==>\033[0m %s\n' "$1"; }
dot() { printf '\n\033[1;32m*\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$1"; }
err() { printf '\033[1;31m[error]\033[0m %s\n' "$1" >&2; }

require_root_actions() {
  if [[ $EUID -eq 0 ]]; then
    err "Don't run this whole script as root — it uses sudo where needed."
    exit 1
  fi
}

# ---------- menu ----------
menu() {
  log "STM32 Dev script"
  dot "Menu"
  echo "1.Run full script"
  echo "2.Install packages "
  echo "3.Verify toolchain "
  echo "4.Create stm32dev directory "
  echo "5.Cloning git base"
  echo "6.Create new project "
  echo "7.Quit"

  read -p "Insert the number of the answer: " answer

  case $answer in
  1)
    dot "Full script in action: "
    require_root_actions
    install_packages
    verify_toolchain
    setup_udev
    setup_groups
    create_dev_dir
    cloning_git_blueprint
    create_project
    menu
    ;;
  2)
    dot " Install packages"
    require_root_actions
    install_packages
    menu
    ;;
  3)
    dot " Verify toolchain"
    verify_toolchain
    menu
    ;;
  4)
    dot " Create esp32dev directory"
    create_dev_dir
    menu
    ;;
  5)
    dot "Git clone "
    cloning_git_blueprint
    menu
    ;;
  6)
    dot " Create new project"
    create_project
    menu
    ;;
  7)
    log " Quit"
    quit
    ;;
  esac

}

# --------- quit ---------
quit() {
  dot "Quiting script"
  exit 0
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

# ---------- create working directory? ----------
create_dev_dir() {
  # read -p "Do you want to create a home directory for the ESP32 project? (yes or no): " answer
  log "Creating an STM32 dev enviorment"

  dot "Creating the development enviorment directory"
  read -p "Insert path for it dir: " STM32_DIR_PATH
  STM32_DIR_PATH="${STM32_DIR_PATH/#\~/$HOME}"

  echo "Path: [$STM32_DIR_PATH]"

  if [[ -d "$STM32_DIR_PATH" ]]; then
    dot "The directory exists, moving on"
  else
    dot "Creating ${STM32_DIR_PATH} "
    mkdir -p "$STM32_DIR_PATH"
    dot "Created it"
  fi
}

# ---------- cloning git blueprint ----------

cloning_git_blueprint() {

  if [[ -z "$STM32_DIR_PATH" ]]; then
    read -p "What is the path of the STM32 dev dir? " STM32_DIR_PATH
    STM32_DIR_PATH="${STM32_DIR_PATH/#\~/$HOME}"
    echo "Path: [ $STM32_DIR_PATH]"
  fi

  log "Cloning STM32 blueprint"

  read -p "Do you want to clone the STM32 toolchain(yes or no): " answer
  if [[ "$answer" == "yes" || "$answer" == "y" ]]; then

    if [[ ! -d "$STM32_DIR_PATH/libopencm3" ]]; then
      #  cd "$STM32_DIR_PATH"
      git clone --recurse-submodules https://github.com/libopencm3/libopencm3-template "$STM32_DIR_PATH"
    else
      dot "libraries are already present, skipping clone"
    fi

  fi

  dot "DevEnviorment set"

}

# ---------- create_project ----------

create_project() {

  if [[ -z "$STM32_DIR_PATH" ]]; then
    STM32_DIR_PATH=$(pwd)
    if [[ ! -d "$STM32_DIR_PATH/libopencm3" ]]; then
      dot "You are already in the root of the project"
      echo "Setting STM32_DIR_PATH to current working directory"
    else
      read -p "You are not in the STM32 DevEnv. Insert path to it: " STM32_DIR_PATH
    fi
  fi

  log "Project creation"
  read -p "Would you like to create a project dir inside of it now?(yes or no): " answer
  if [[ "$answer" == "yes" || "$answer" == "y" ]]; then
    read -p "Insert name of the project dir: " PROJECT_NAME

    PROJECT_DIR="$STM32_DIR_PATH/$PROJECT_NAME"
    #    mkdir "$PROJECT_DIR"

    #dot "Creating esp-idf project: $PROJECT_NAME"
    cd "$STM32_DIR_PATH"
    mkdir "$PROJECT_DIR"
    touch "$PROJECT_DIR"/main.c
    cp ./my-project/Makefile "$PROJECT_DIR"/Makefile

    dot "Project created"
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
  menu
  require_root_actions
  install_packages
  verify_toolchain
  setup_udev
  setup_groups
  setup_lazyvim
  print_summary
}

main "$@"
