#!/bin/bash

# Example setup script
sudo apt update

sudo apt install nala
sudo nala update 

sudo nala install -y openssh-client yt-dlp curl ranger git vim node npm openjdk-17 snap flatpak htop btop neofetch figlet mpv tmux xsel qBittorrent

#VimPlug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

#compile neovim from source: 

sudo apt update
sudo apt install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

git clone https://github.com/neovim/neovim.git
cd neovim

make CMAKE_BUILD_TYPE=Release

sudo make install

nvim --version

#install LaTeX enviorment for neovim(the other stuff is inside the init.vim file 
sudo apt update
sudo apt install -y texlive-full latexmk zathura zathura-pdf-poppler

# Bashrc
#cp ./bashrc ~/.bashrc
mv ~/.bashrc ~/.bashrc.backup
ln -s ~/dotfiles/.bashrc ~/.bashrc

# Neovim
#mkdir -p ~/.config
#cp -r ./nvim ~/.config/


# Tmux
#cp -r ./tmux ~/.config/

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

echo "The config files should be mostly done. You have to go and run :PlugInstall and :CocInstall coc-java :CocInstall coc-tsserver"
echo "Config files restored!"

