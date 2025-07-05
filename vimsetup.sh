sudo apt install vim curl -y

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

ln -s ~/dotfiles/.vimrc ~/.vimrc

sudo apt install vim-gtk3 # this is for teh clipboard/
sudo apt install ripgrep # this is for greping around in the files.
