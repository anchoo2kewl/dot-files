#!/bin/bash

if [ -z "$1" ]
  then
    echo "No argument supplied. Please provide the username"
    exit 0
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

yay -S google-chrome

doas -- pacman -S docker

doas systemctl start docker.service
doas systemctl enable docker.service
sudo usermod -aG docker $1

git clone https://aur.archlinux.org/snapd.git
cd snapd
makepkg -si
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install microk8s --classic
sudo usermod --append --groups microk8s $1
microk8s start
sudo snap enable microk8s
microk8s kubectl get nodes
microk8s.kubectl run httpd --image httpd
microk8s kubectl get services
microk8s.enable registry
microk8s.config
microk8s kubectl delete pod httpd
microk8s kubectl get pods
microk8s kubectl -n kube-system get secret
token=$(microk8s kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
microk8s.enable dashboard dns
microk8s.enable dashboard dnsmicrok8s kubectl create token -n kube-system default --duration=8544h
microk8s kubectl -n kube-system describe secret $token
microk8s.enable storage
microk8s.enable prometheus
# sudo firewall-cmd --zone=public --add-port 9090/tcp --permanent
# sudo firewall-cmd --zone=public --add-port 3000/tcp --permanent
microk8s enable helm
microk8s enable ingress
yay -S helm

# microk8s kubectl port-forward -n monitoring service/grafana --address 0.0.0.0 3000:3000
# microk8s kubectl port-forward -n monitoring service/grafana --address 0.0.0.0 9090:9090
