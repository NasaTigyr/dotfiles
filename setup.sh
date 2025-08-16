#!/bin/bash

# Example setup script
sudo apt update

sudo apt install nala

sudo apt install curl nodejs vim ffmpeg openssh-client yt-dlp curl ranger git npm default-jdk snap flatpak htop btop figlet mpv tmux xsel qbittorrent

if ! command -v neofetch &> /dev/null; then
    echo "neofetch not found, trying fastfetch..."
    
    # Try to use fastfetch
    if command -v fastfetch &> /dev/null; then
        echo "Using fastfetch"
        fastfetch
    else
        echo "fastfetch not found either. Please install neofetch or fastfetch."
    fi
else
    echo "neofetch found, using it"
    neofetch
fi

sudo apt install nasm build-essential

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#VimPlug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

#compile neovim from source: 
sudo apt install lua5.3 liblua5.3-dev

sudo apt update
sudo apt install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

cd ~
git clone https://github.com/neovim/neovim.git
cd neovim

make CMAKE_BUILD_TYPE=Release

sudo make install

nvim --version
cd dotfiles

# Bashrc
#cp ./bashrc ~/.bashrc
mv ~/.bashrc ~/.bashrc.backup
ln -s ~/dotfiles/.bashrc ~/.bashrc

#vimrc file and link
ln -s ~/dotfiles/.vimrc ~/.vimrc
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sudo apt install ripgrep

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

# Create ~/.config if it doesn't exist
if [ ! -d "$CONFIG_DIR" ]; then
  echo "Creating $CONFIG_DIR"
  mkdir -p "$CONFIG_DIR"
fi

# Function to check dir, create if needed, then link
setup_link() {
  local name=$1    # nvim or tmux
  local target="$DOTFILES_DIR/$name"
  local dest="$CONFIG_DIR/$name"

  # Check if dest exists
  if [ -d "$dest" ]; then
    # Check if empty
    if [ "$(ls -A $dest)" ]; then
      echo "$dest exists and is not empty. Removing it to link."
      rm -rf "$dest"
    else
      echo "$dest exists and is empty. Will use it."
      rm -rf "$dest"  # We remove it anyway because we want to link, not keep empty folder
    fi
  else
    echo "$dest does not exist. Creating it."
    mkdir -p "$dest"
    rm -rf "$dest"  # remove to link
  fi

  # Create the symlink
  ln -s "$target" "$dest"
  echo "Linked $dest -> $target"
}

# Setup nvim and tmux
setup_link "nvim"
setup_link "tmux"

#installing LaTeX
sudo apt update 
sudo apt install -y texlive-full latexmk zathura zathura-pdf-poppler
nvim +'PlugInstall --sync' +qall

source ~/.bashrc

echo "The config files should be mostly done. You have to go and run :PlugInstall and :CocInstall coc-java :CocInstall coc-tsserver"
echo "Config files restored!"


