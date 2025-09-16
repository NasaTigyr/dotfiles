sudo apt update

sudo apt install nala

sudo apt install curl nodejs vim ffmpeg openssh-client yt-dlp ranger git npm default-jdk snap flatpak htop btop figlet mpv tmux xsel qbittorrent

if sudo apt install -y neofetch; then 
    echo "neofetch installed successfully" 
else 
    echo "Failed to install neofetch, trying fastfetch" 
    sudo apt install -y fastfetch 
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


#vimrc file and link
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sudo apt install ripgrep

#installing LaTeX
nvim +'PlugInstall --sync' +qall

sudo apt update 
sudo apt install -y texlive-full latexmk zathura zathura-pdf-poppler

echo "The config files should be mostly done. You have to go and run :PlugInstall and :CocInstall coc-java :CocInstall coc-tsserver"
echo "Config files restored!"
