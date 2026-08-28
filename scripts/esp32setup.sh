#!/usr/bin/env bash

set -euo pipefail
# ---------- project variables ----------
ESP32_DIR_PATH=""
PROJECT_NAME=""
PROJECT_DIR=""
ESP32MODEL=""

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

# --------- install packages ---------
quit() {
  log "Quiting script"
  exit 0
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
create_dev_dir() {
  # read -p "Do you want to create a repository for the ESP32 project? (yes or no): " answer
  log "Creating an ESP32 dev enviorment"

  dot "Creating the development enviorment directory"
  read -p "Insert path for it dir: " ESP32_DIR_PATH
  ESP32_DIR_PATH="${ESP32_DIR_PATH/#\~/$HOME}"

  if [[ -d "$ESP32_DIR_PATH" ]]; then
    dot "The directory exists, moving on"
  else
    dot "Creating ${ESP32_DIR_PATH} "
    mkdir -p "$ESP32_DIR_PATH"
  fi

  #read -p "Would you like to create a project dir inside of it now?(yes or no): " answer
  #if [[ "$answer" == "yes" || "$answer" == "y" ]]; then
  #log "Creating the project inside"
  #read -p "Insert name of the project dir: " PROJECT_NAME
  #PROJECT_DIR="$ESP32_DIR_PATH/$PROJECT_NAME"
  #mkdir -p "$PROJECT_DIR"
  #fi
}

cloning_idf() {
  log "Cloning ESP-IDF"

  if [[ -d "$ESP32_DIR_PATH/esp-idf" ]]; then
    dot "esp-idf already present, skipping clone"
  else
    git clone --recursive https://github.com/espressif/esp-idf.git "$ESP32_DIR_PATH/esp-idf"
  fi

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
    read -p "What ESP32 toolchain should be installed? ('h' for help, 'n' for skipping): " ESP32MODEL

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

  cd "$ESP32_DIR_PATH/esp-idf"
  ./install.sh "$ESP32MODEL"

  log "Loading the ESP-IDF enviorment"
  source "$ESP32_DIR_PATH/esp-idf/export.sh"

  verify_install

}

# ---------- usb permition fix  ----------
fix_usb() {
  log "Setting the usb permitions"
  sudo usermod -a -G dialout $USER
}

# ---------- verify_install ----------
verify_install() {
  log "Verifying of the idf.py install"
  idf.py --version
}

# ---------- create project  ----------

create_project() {
  log "Project creation"
  read -p "Would you like to create a project dir inside of it now?(yes or no): " answer
  if [[ "$answer" == "yes" || "$answer" == "y" ]]; then
    read -p "Insert name of the project dir: " PROJECT_NAME

    PROJECT_DIR="$ESP32_DIR_PATH/$PROJECT_NAME"

    dot "Creating esp-idf project: $PROJECT_NAME"
    cd "$ESP32_DIR_PATH"

    idf.py create-project "$PROJECT_NAME"
    cd "$PROJECT_NAME"

    dot "Project created"

    dot "Checking version of idf.py"
    idf.py --version

    dot "Setting-target"
    idf.py set-target "${ESP32MODEL}"
  else
    dot "Skipping project creation"
  fi
}

# ---------- menu ----------
menu() {
  log "ESP32 Dev script"
  dot "Menu"
  echo "1.Start from the begining"
  echo "2.Install packages "
  echo "3.Verify toolchain "
  echo "4.Create esp32dev directory "
  echo "5.Create new project "
  echo "6.Quit"

  read -p "Insert the number of the answer: " answer

  case $answer in
  1)
    dot "Full script in action: "
    require_root_actions
    install_packages
    verify_toolchain
    create_dev_dir
    cloning_idf
    create_project
    menu
    ;;
  2)
    dot " Install packages"
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
    cloning_idf
    menu
    ;;
  5)
    dot " Create new project"
    create_project
    menu
    ;;
  6)
    dot " Quit"
    quit
    ;;
  esac

}

# ---------- main  ----------
main() {
  menu
}

main "$@"
