#!/bin/bash

if [ -z "$1" ]
  then
    echo "No argument supplied. Please provide the username"
fi

doas -- pacman -S --noconfirm base-devel

doas su
echo "$1 ALL=(ALL) NOPASSWD:ALL" >>  /etc/sudoers
pacman -Sy --noconfirm  archlinux-keyring && pacman -Su
exit
doas -- pacman -S --noconfirm xf86-video-vmware git xorg xorg-xinit nitrogen picom firefox
git clone https://aur.archlinux.org/yay-git.git

cd yay-git

makepkg -si

doas -- pacman -S --noconfirm libx11 libxft xorg-server xorg-xinit terminus-font
mkdir -p ~/.local/src
git clone git://git.suckless.org/st ~/.local/src/st
git clone git://git.suckless.org/dmenu ~/.local/src/dmenu
git clone git://git.suckless.org/dwm ~/.local/src/dwm

cd ~/.local/src/st
make clean
doas make install

cd ~/.local/src/dmenu

# sed -e '/XINERAMALIBS/ s/^#*/#/' -i config.mk
# sed -e '/XINERAMAFLAGS/ s/^#*/#/' -i config.mk
make clean
doas make install

cd ~/.local/src/dwm

# Copy xinit except last 5 lines
head -n -5 /etc/X11/xinit/xinitrc > ~/.xinitrc

cat <<EOT >> ~/.xinitrc
nitrogen --restore &
picom &
exec dwm
EOT

mkdir ~/projects
cd ~/projects
git clone https://gitlab.com/anchoo2kewl/wallpapers