# Detect the platform (similar to $OSTYPE)
OS="`uname`"
case $OS in
  'Linux')
       echo "Linux detected. Probing OS further ..."
       LINUX_OS=`awk -F= '/^NAME/{print $2}' /etc/os-release  | cut -d '"' -f2`
       echo $LINUX_OS
       case $LINUX_OS in
	   'Arch Linux' )
	       echo "Arch detected ..."
	       sudo pacman -S --noconfirm zsh
               sudo pacman -S --noconfirm mosh
	       sudo pacman -S --noconfirm exa
	       sudo pacman -S --noconfirm bat
	       sudo pacman -S --noconfirm fzf
	       sudo pacman -S --noconfirm ripgrep
	       sudo pacman -S --noconfirm zoxide
	       sudo pacman -S --noconfirm mc
	       sudo pacman -S --noconfirm neofetch
	       sudo curl -L https://github.com/gokcehan/lf/releases/download/r27/lf-linux-amd64.tar.gz | sudo tar xzC /usr/bin ;;
           'Ubuntu' )
               echo "Ubuntu detected ..." 
               sudo apt-get install -y zsh
               sudo apt-get install -y mosh
               sudo apt-get install -y exa
               sudo apt install -y bat
               sudo apt install -y fzf
               sudo apt install -y ripgrep
               sudo apt install -y zoxide
               sudo apt-get install -y mc
	       sudo apt-get install -y neofetch
               sudo curl -L https://github.com/gokcehan/lf/releases/download/r27/lf-linux-amd64.tar.gz | tar xzC /usr/bin ;;
            'CentOS Linux')
	       echo "Centos detected ..."
	       sudo yum install -y zsh
	       sudo dnf config-manager --set-enabled powertools
	       sudo dnf install -y epel-release
	       sudo yum -y install mosh
	       sudo yum install -y unzip wget
	       sudo dnf install -y neofetch
	       wget -O https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip /tmp
	       unzip /tmp/exa-linux-x86_64-0.8.0.zip
	       sudo mv /tmp/exa-linux-x86_64 /usr/local/bin/exa
	       wget -O -c http://repo.openfusion.net/centos7-x86_64/bat-0.7.0-1.of.el7.x86_64.rpm /tmp
	       sudo yum install -y tmp/bat-0.7.0-1.of.el7.x86_64.rpm
               wget -O -c http://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/f/fzf-0.30.0-3.fc37.x86_64.rpm /tmp
               sudo yum install -y /tmp/fzf-0.30.0-3.fc37.x86_64.rpm
               wget -O -c https://github.com/jc21-rpm/ripgrep/releases/download/v13.0.0/ripgrep-13.0.0-1.el8.x86_64.rpm /tmp
	       sudo yum install -y /tmp/ripgrep-13.0.0-1.el8.x86_64.rpm
               sudo dnf copr enable -y atim/zoxide
               sudo dnf install -y zoxide
	       sudo dnf install -y mc
	       sudo yum install -y util-linux-user ;;
       esac ;;
  'Darwin')  
        echo "MacOS detected ..."
        brew install mosh
        brew instal tmux
        brew install coreutils
        brew instal exa
        brew install bat
        brew install ripgrep
        brew install fzf
        brew install zoxide
        brew install midnight-commander
        brew install lf ;;
  *) echo "OS not detected ... " 
     exit 1  ;;

esac

chsh -s /usr/bin/zsh

curl -sS https://starship.rs/install.sh | sh

REALPATH=`realpath $0`
DIR=`dirname $REALPATH`
mkdir -p ~/.config && ln -sf $DIR/starship.toml ~/.config/starship.toml
touch $DIR/.custom.zsh
[ -f '.custom.zsh' ] && ln -sf $DIR/.custom.zsh $HOME/.custom.zsh

ln -sf $DIR/.tmux.conf $HOME/.tmux.conf


mkdir -p $HOME/libs

cd $HOME/libs

[ ! -d 'zsh-syntax-highlighting' ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
[ ! -d 'zsh-autosuggestions' ] && git clone https://github.com/zsh-users/zsh-autosuggestions.git
[ ! -d 'zsh-history-substring-search' ] && git clone https://github.com/zsh-users/zsh-history-substring-search.git

ln -sf $DIR/.zshrc $HOME/.zshrc
ln -sf $DIR/.aliasrc $HOME/.config/.aliasrc
