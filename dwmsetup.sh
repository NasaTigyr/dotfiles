sudo apt update
sudo apt install build-essential libx11-dev libxft-dev libxinerama-dev

cd /tmp
git clone https://git.suckless.org/dwm
cd dwm
make
sudo make install

touch ~/.xinitrc 
echo "exec dwm" >> ~/.xinitrc

startx
