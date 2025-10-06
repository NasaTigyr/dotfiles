#!/bin/bash
set -e
sudo -v

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}=== Detecting system type... ===${NC}"

if command -v xbps-install >/dev/null 2>&1; then
    DISTRO="void"
elif command -v apt >/dev/null 2>&1; then
    DISTRO="debian"
else
    echo -e "${RED}Unsupported system. Only Void Linux and Debian/Ubuntu are supported.${NC}"
    exit 1
fi

echo -e "${GREEN}Detected system:${NC} $DISTRO"
echo -e "${YELLOW}=== Updating system ===${NC}"

if [ "$DISTRO" = "void" ]; then
    sudo xbps-install -Syu
else
    sudo apt update
    sudo apt install -y nala
fi

echo -e "${YELLOW}=== Installing core packages ===${NC}"

if [ "$DISTRO" = "void" ]; then
    sudo xbps-install -Sy curl nodejs vim ffmpeg openssh yt-dlp ranger git openjdk flatpak htop btop mpv tmux xsel qbittorrent ripgrep fastfetch 
else
    sudo apt install -y curl nodejs vim ffmpeg openssh-client yt-dlp ranger git npm default-jdk flatpak htop btop mpv tmux xsel qbittorrent \
        nasm build-essential lua5.3 liblua5.3-dev ninja-build gettext libtool libtool-bin autoconf ripgrep automake cmake g++ pkg-config unzip curl doxygen
    if ! sudo apt install -y neofetch; then
        echo "Neofetch failed, installing fastfetch..."
        sudo apt install -y fastfetch
    fi
fi

echo -e "${YELLOW}=== Setting up Flatpak ===${NC}"
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo -e "${YELLOW}=== Checking essential build tools ===${NC}"
for cmd in git make gcc curl; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo -e "${RED}Missing: $cmd — please install it before continuing.${NC}"
        exit 1
    fi
done

echo -e "${YELLOW}=== Cloning and building Neovim from source ===${NC}"
cd ~
if [ -d "neovim" ]; then
    echo "Neovim directory exists, updating..."
    cd neovim
    git pull
else
    git clone https://github.com/neovim/neovim.git
    cd neovim
fi

make CMAKE_BUILD_TYPE=Release
sudo make install

echo -e "${GREEN}=== Verifying Neovim installation ===${NC}"
nvim --version

if [ -d ~/.config/dotfiles ]; then
    cd ~/.config/dotfiles
    echo "Moved to ~/.config/dotfiles"
fi

echo -e "${YELLOW}=== Installing VimPlug for Vim and Neovim ===${NC}"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo -e "${GREEN}=== Setup complete! ===${NC}"
echo "Installed versions:"
vim --version | head -n 1
nvim --version | head -n 1
node -v
git --version

echo -e "${YELLOW}=== Linking dotfiles and setting up configs ===${NC}"

DOTFILES_DIR="$HOME/.config/dotfiles"
CONFIG_DIR="$HOME/.config"

# Optional: link .bashrc from dotfiles
if [ -f "$HOME/.bashrc" ]; then
    mv ~/.bashrc ~/.bashrc.backup
    echo "Backed up existing .bashrc"
fi
ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"

# Link Vim config
if [ -f "$DOTFILES_DIR/.vimrc" ]; then
    ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
    echo "Linked ~/.vimrc -> $DOTFILES_DIR/.vimrc"
else
    echo "No .vimrc found in dotfiles, skipping."
fi

# Ensure Vim-Plug installed
#curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  #https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install ripgrep and vim-gtk3 (Debian only)
if [ "$DISTRO" = "debian" ]; then
    sudo apt install -y ripgrep vim-gtk3
elif [ "$DISTRO" = "void" ]; then
    sudo xbps-install -Sy ripgrep vim
fi

# Ensure ~/.config exists
if [ ! -d "$CONFIG_DIR" ]; then
  echo "Creating $CONFIG_DIR"
  mkdir -p "$CONFIG_DIR"
fi

# Function to safely replace and link
setup_link() {
  local name=$1    # nvim or tmux
  local target="$DOTFILES_DIR/$name"
  local dest="$CONFIG_DIR/$name"

  if [ -L "$dest" ] || [ -d "$dest" ]; then
    echo "$dest exists — removing it before linking."
    rm -rf "$dest"
  fi

  ln -s "$target" "$dest"
  echo "Linked $dest -> $target"
}

# Set up Neovim and tmux configs
setup_link "nvim"
setup_link "tmux"

# Install plugins (Neovim)
if command -v nvim >/dev/null 2>&1; then
    echo "Installing Neovim plugins..."
    nvim +'PlugInstall --sync' +qall || true
fi

# Reload bash config if applicable
if [ -f ~/.bashrc ]; then
    echo "Reloading .bashrc..."
    source ~/.bashrc || true
fi

echo -e "${GREEN}Dotfiles and configs have been set up successfully.${NC}"
