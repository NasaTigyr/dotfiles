# dotfiles
Repository to be able to set up a formated and reinstalled new linux systems. (bash script for automatic setting of the source files)

# Git
Set Git to be able to upload to github using the ssh-client(it's installed with the script).
After installing git: 
use 
    git config command to set the --global user.name/email "name/email" 

You have to create an ssh key and connect it to your github. 
ssh-keygen (use the man page if you have the guts..., or just go use chatgpt or some other shit)> 

# VIM and Neovim setup: 
The setups are minimal and are almost identicall. The idea is to have the same working setup for both. I have an old laptop, that actually really doesn't like Neovim, so this is the result.

Vim custom keymaps: 
    y  - copies into the "ay
    py - pastes from the "ay
    yp - copies into the "+y (from the pc clipboard)
    pp - pastes into the "+y (from the pc clipboard)

It uses: xsel for the pasting, so it's important to have it installed before hand or run the script. 

# Tmux custom setup: 
    Cntr + b + [ - visual mode in tmux.
    Use vim motions to sellectj
    y - copy text from the visual mode.
    Enter - you can use enter to copy again from the visual mode.
    
    From time to time i like using the enter(it's a bigger button xd).

# Lean how to use ffmpeg, 
This command will start recording for the x11 session:

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

# Fuzzy finder
To learn: 
-Fuzzy Finder: 
    -> :Files
    -> :Buffers
    -> :Lines
    -> :Rg
    -> :BLines


# installing other stuff ussing flatpak!!! 
discord, viber, signal, steam, sober(roblox), wine -> half life., stremio. spotify
NetworkManager

# For volume on the dell studio 1735 : 
I use amixer, alsamixer


# Usage of nmcli ( NetworkManager cli): 
install NetworkManager, 
link it from the /etc/sv dir to the /var/service. 
then use, main commands: 

nmcli dev wifi list
nmcli dev wifi connect  "Your ssid" password "password"
