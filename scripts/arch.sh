#!/bin/bash

if [ -z "$1" ]
  then
    echo "No argument supplied. Please provide the username"
    exit 0
fi

doas timedatectl set-timezone America/Toronto

doas -- pacman -S --noconfirm base-devel

SUDOERS_FILE=/etc/sudoers
doas grep -q "$1" $SUDOERS_FILE && echo "User ($1) already in sudoers file" || doas echo "$1 ALL=(ALL) NOPASSWD:ALL" | doas tee -a /etc/sudoers > /dev/null
pacman -Sy --noconfirm  archlinux-keyring && pacman -Su
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

RESOLUTION=2560x1440
if [ -z "$2" ]
  then
    echo "No resolution argument supplied. Using $RESOLUTION"
  else
  	RESOLUTION=$2
  	echo "Resolution argument supplied. Using $RESOLUTION"
fi

cat <<EOT >> ~/.custom.zsh
[[ \$(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1
xrandr -s $RESOLUTION
EOT

yay -S --noconfirm google-chrome

doas -- pacman -S --noconfirm docker

doas systemctl start docker.service
doas systemctl enable docker.service
sudo usermod -aG docker $1
yay -S --noconfirm docker-compose
yay -S --noconfirm expect

git clone https://aur.archlinux.org/snapd.git
cd snapd
makepkg -si
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

yay -S --noconfirm gnupg
doas -- pacman -S --noconfirm jdk8-openjdk
yay -S --noconfirm maven

cat <<EOT >> ~/.custom.zsh
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk/
export M2_HOME=/opt/maven/
export PATH=$PATH:$JAVA_HOME/bin:$M2_HOME/bin
EOT

yay -S --noconfirm lsof

yay -S --noconfirm intellij-idea-community-edition

yay -S --noconfirm pycharm-community-edition

yay -S --noconfirm visual-studio-code-bin
