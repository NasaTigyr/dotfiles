#!/bin/bash

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
nvim +'PlugInstall --sync' +qall

source ~/.bashrc

echo "Source and config files have been set."


