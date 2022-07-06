# Detect the platform (similar to $OSTYPE)
OS="`uname`"
case $OS in
  'Linux')   
      echo "Linux detected ..." 
      sudo apt-get install -y zsh
      sudo apt-get install -y mosh;;
  'Darwin')  
       echo "MacOS detected ..."
       brew install mosh
       brew install coreutils ;;
  *) echo "OS not detected ... " ;;

esac

if [ -n "$ZSH_VERSION" ]; then
	chsh -s /usr/bin/zsh
fi

curl -sS https://starship.rs/install.sh | sh

REALPATH=`realpath $0`
DIR=`dirname $REALPATH`
mkdir -p ~/.config && ln -sf $DIR/starship.toml ~/.config/starship.toml
touch $DIR/.custom.zsh

ln -sf $DIR/.tmux.conf $HOME/.tmux.conf

mkdir -p $HOME/libs

cd $HOME/libs

[ ! -d 'zsh-syntax-highlighting' ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
[ ! -d 'zsh-autosuggestions' ] && git clone https://github.com/zsh-users/zsh-autosuggestions.git
[ ! -d 'zsh-history-substring-search' ] && git clone https://github.com/zsh-users/zsh-history-substring-search.git

ln -sf $DIR/.zshrc $HOME/.zshrc
