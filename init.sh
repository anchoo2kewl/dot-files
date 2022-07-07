# Detect the platform (similar to $OSTYPE)
OS="`uname`"
case $OS in
  'Linux')   
       echo "Linux detected ..." 
       sudo apt-get install -y zsh
       sudo apt-get install -y mosh
       sudo apt-get install -y exa
       sudo apt install -y bat
       sudo apt install -y fzf
       sudo apt install -y ripgrep
       sudo apt install -y zoxide
       sudo apt-get install -y mc
       curl -L https://github.com/gokcehan/lf/releases/download/r13/lf-linux-amd64.tar.gz | tar xzC ~/.local/bin ;;
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
[ -f '.custom.zsh' ] && ln -sf $DIR/.custom.zsh $HOME/.custom.zsh

ln -sf $DIR/.tmux.conf $HOME/.tmux.conf


mkdir -p $HOME/libs

cd $HOME/libs

[ ! -d 'zsh-syntax-highlighting' ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
[ ! -d 'zsh-autosuggestions' ] && git clone https://github.com/zsh-users/zsh-autosuggestions.git
[ ! -d 'zsh-history-substring-search' ] && git clone https://github.com/zsh-users/zsh-history-substring-search.git

ln -sf $DIR/.zshrc $HOME/.zshrc
ln -sf $DIR/.aliasrc $HOME/.config/.aliasrc
