#!/usr/bin/env bash

set -euo pipefail
# ---------- project variables ----------
PROJECT_PATH=""
PROJECT_NAME=""
PROJECT_DIR=""

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

# --------- install packages ---------
install_packages() {
  #  sudo xbps-install -S git wget flex bison gperf python3 python3-pip cmake ninja ccache libffi-devel openssl-devel dfu-util

  log "Installing packages via xbps"

  local packages=(
    git
    wget
    flex
    bison
    gperf
    python3
    python3-pip
    cmake
    ninja
    ccache
    libffi-devel
    openssl-devel
    dfu-util
  )

  sudo xbps-install -Sy "${packages[@]}"
}

# ---------- verify toolchain ----------
verify_toolchain() {
  log "Verifying toolchain binaries"

  #  git wget flex bison gperf python3 python3-pip cmake ninja ccache libffi-devel openssl-devel dfu-util
  local bins=(git wget flex bison gperf python3 python3-pip cmake ninja ccache libffi-devel openssl-devel dfu-util)
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

# ---------- create working repository ? ----------
menu_create_rep() {
  # read -p "Do you want to create a repository for the ESP32 project? (yes or no): " answer
  log "Creating an ESP32 dev enviorment"

  read -p "Do you want to create a directory for the ESP32 project? (yes or no): " answer
  if [[ "$answer" != "yes" && "$answer" != "y" ]]; then
    echo "Skipping the ESP32 repository part"
    return 1
  fi

  log "Creating ESP32 repository"

  read -p "Insert path for the project dir: " PROJECT_PATH

  read -p "Insert name of the project dir: " PROJECT_NAME

  PROJECT_PATH="${PROJECT_PATH/#\~/$HOME}"

  PROJECT_DIR="$PROJECT_PATH/$PROJECT_NAME"

  log "Creating: $PROJECT_DIR"
  mkdir -p "$PROJECT_DIR"

  log "Cloning ESP-IDF"
  git clone --recursive https://github.com/espressif/esp-idf.git $PROJECT_DIR

  local espmodels=(
    esp32
    esp32s2
    esp32s3
    esp32c2
    esp32c3
    esp32c5
    esp32c6
    esp32h2
    linux
    all
  )

  log "Installing toolchain"

  while true; do
    read -p "What ESP32 toolchain should be installed? (press 'h'for help): " ESP32MODEL

    if [[ "$ESP32MODEL" == "h" ]]; then

      echo "Available ESP-IDF targets: "
      for espmodel in "${espmodels[@]}"; do
        echo " - $espmodel"
      done
      echo
      continue
    fi

    valid=false
    for espmodel in "${espmodels[@]}"; do
      if [[ "$ESP32MODEL" == "$espmodel" ]]; then
        valid=true
        break
      fi
    done

    if $valid; then
      echo "Selected target: $ESP32MODEL"
      break
    else
      err "Invalid target: $ESP32MODEL"
      echo "Press 'h' for available options"
    fi
  done

  cd $PROJECT_DIR/esp/esp-idf
  ./install.sh "$ESP32MODEL"

  log "Loading the ESP-IDF enviorment"
  source ~/esp/esp-idf/export.sh

  $(verify_install)

}

# ---------- usb permition fix  ----------
fix_usb() {
  log "Setting the usb permitions"
  sudo usermod -a -G dialout $USER
}

# ---------- verify_install ----------
verify_install() {
  log "Verifying of the idf.py installation"
  idf.py --version
  idf.py set-target "$ESP32MODEL"
}

# ---------- main  ----------
main() {
  require_root_actions
  install_packages
  verify_toolchain
  menu_create_rep
  verify_install
}

main "$@"
