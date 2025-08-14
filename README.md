# dotfiles
Repository to be able to set up formated and reinstalled new linux systems. (bash script for automatic setting of the dependancies)

Set Git to be able to upload to github using the ssh-client(it's installed with the script).
After installing git: 
use 
    git config command to set the --global user.name/email "name/email" 

You have to create an ssh key and connect it to your github. 
ssh-keygen (use the man page if you have the guts..., or just go use chatgpt or some other shit)> 

Vim custom keymaps: 
    y  - copies into the "ay
    py - pastes from the "ay
    yp - copies into the "+y (from the pc clipboard)
    pp - pastes into the "+y (from the pc clipboard)

Lean how to use ffmpeg, This command will start recording:

ffmpeg \
-f x11grab -video_size 1920x1080 -framerate 30 -i :0.0 \
-f alsa -i default \
-f v4l2 -framerate 60 -i /dev/video0 \
-filter_complex "[2:v]scale=320:240[cam];[0:v][cam]overlay=W-w-10:H-h-10[out]" \
-map "[out]" -map 1:a \
-c:v libx264 -preset ultrafast -c:a aac \
output.mp4

To stop it, just press q to exit it...
these are probably some dependancies that i have to install, so that i can use it. 
sudo apt install ffmpeg xdg-desktop-portal xdg-desktop-portal-gnome pipewire

Learn how to use vim!!!
To learn: 
-Fuzzy Finder: 
    -> :Files
    -> :Buffers
    -> :Lines
    -> :Rg
    -> :BLines


    ok, this will be the software used for the iphone operations: 
    sudo apt install libimobiledevice-utils usbmuxd

# install wine for windows aplications: 

sudo dpkg --add-architecture i386 *this enables the 32 bit architecture.

sudo apt install wget gnupg2 software-properties-common *some dependancies

sudo nala install wget gnupg2 software-properties-common -y
wget -O- https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /usr/share/keyrings/winehq-archive.key
echo "deb [signed-by=/usr/share/keyrings/winehq-archive.key] https://dl.winehq.org/wine-builds/debian/ bookworm main" | sudo tee /etc/apt/sources.list.d/winehq.list
sudo nala update

sudo nala install --install-recommends winehq-stable -y

wine --version

winecfg

# installing other stuff ussing flatpak!!! 
discord, viber, signal, steam, sober(roblox), wine -> half life., stremio. spotify
