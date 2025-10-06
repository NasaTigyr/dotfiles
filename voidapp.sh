# Update system
sudo xbps-install -Syu

# Install core tools
sudo xbps-install -Sy curl nodejs vim ffmpeg yt-dlp ranger git openjdk flatpak htop btop figlet mpv tmux xsel qbittorrent ripgrep fastfetch

# Optional: OpenSSH client
 sudo xbps-install -Sy openssh

# Flatpak setup
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# VimPlug for Neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Build dependencies for compiling Neovim
sudo xbps-install -Sy ninja gettext libtool autoconf automake cmake g++ pkg-config unzip curl doxygen

# Clone and build Neovim
cd ~
git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=Release
sudo make install

# Verify Neovim installation
nvim --version

# Install VimPlug for Vim (if you use both Vim and Neovim)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install Zathura for PDF preview
sudo xbps-install -Sy zathura zathura-pdf-poppler

# Install LaTeX
sudo xbps-install -Sy texlive-base texlive-bin texlive-latexextra texlive-fontsrecommended latexmk

# Final instructions
echo "Run :PlugInstall inside nvim"
echo "Run :CocInstall coc-java coc-tsserver for language servers"
echo "Config files restored!"

