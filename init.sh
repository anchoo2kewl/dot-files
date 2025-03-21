export XDG_CONFIG_HOME="$HOME"/.config

# Detect the platform (similar to $OSTYPE)
OS="$(uname)"
case $OS in
  'Linux')
    echo "Linux detected. Probing OS further ..."
    LINUX_OS=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')
    echo "$LINUX_OS"
    case $LINUX_OS in
      'Arch Linux'|'Arch Linux ARM' )
        echo "Arch detected ..."
        doas -- pacman -S --noconfirm zsh mosh bat fzf ripgrep zoxide mc fastfetch
        doas -- curl -L https://github.com/gokcehan/lf/releases/download/r27/lf-linux-amd64.tar.gz | tar xzC /usr/bin ;;
      'Ubuntu'|'Pop!_OS' )
        echo "Ubuntu detected ..."
        wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.39.1/fastfetch-linux-aarch64.deb -P /tmp
        sudo dpkg -i /tmp/fastfetch-linux-aarch64.deb
        sudo apt-get install -y zsh mosh bat fzf ripgrep zoxide mc        sudo curl -L https://github.com/gokcehan/lf/releases/download/r27/lf-linux-amd64.tar.gz | sudo tar xzC /usr/bin ;;
      'CentOS Linux')
        echo "CentOS detected ..."
        sudo yum install -y zsh mosh unzip wget util-linux-user
        sudo dnf config-manager --set-enabled powertools
        sudo dnf install -y epel-release fastfetch mc
        wget -O /tmp/bat.rpm http://repo.openfusion.net/centos7-x86_64/bat-0.7.0-1.of.el7.x86_64.rpm
        sudo yum install -y /tmp/bat.rpm
        wget -O /tmp/fzf.rpm http://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/f/fzf-0.30.0-3.fc37.x86_64.rpm
        sudo yum install -y /tmp/fzf.rpm
        wget -O /tmp/ripgrep.rpm https://github.com/jc21-rpm/ripgrep/releases/download/v13.0.0/ripgrep-13.0.0-1.el8.x86_64.rpm
        sudo yum install -y /tmp/ripgrep.rpm
        sudo dnf copr enable -y atim/zoxide
        sudo dnf install -y zoxide ;;
      *)
        echo "Unsupported Linux distribution."
        exit 1 ;;
    esac

    echo "Done NIX" ;;
  'Darwin')
    echo "macOS detected ..."
    brew install fastfetch mosh tmux coreutils bat ripgrep fnm fzf zoxide \
      midnight-commander lf
    brew install --cask alacritty ;;
  *)
    echo "OS not detected ..."
    exit 1 ;;
esac

chsh -s /usr/bin/zsh

sudo mkdir -p /usr/local/bin

curl -sS https://starship.rs/install.sh | sh

REALPATH=$(realpath "$0")
DIR=$(dirname "$REALPATH")
mkdir -p "$HOME"/.config && ln -sf "$DIR"/starship.toml "$HOME"/.config/starship.toml
touch "$DIR"/.custom.zsh
[ -f '.custom.zsh' ] && ln -sf "$DIR"/.custom.zsh "$HOME"/.custom.zsh

ln -sf "$DIR"/.tmux.conf "$HOME"/.tmux.conf
git clone https://github.com/alacritty/alacritty-theme "$XDG_CONFIG_HOME"/alacritty/themes

ln -sf "$DIR"/alacrity.toml "$XDG_CONFIG_HOME"/alacritty/alacritty.toml

mkdir -p "$HOME"/libs
mkdir -p "$XDG_CONFIG_HOME"/nvim/

ln -sf "$DIR"/init.vim "$XDG_CONFIG_HOME"/nvim/init.vim

cd "$HOME"/libs

[ ! -d 'zsh-syntax-highlighting' ] && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
[ ! -d 'zsh-autosuggestions' ] && \
  git clone https://github.com/zsh-users/zsh-autosuggestions.git
[ ! -d 'zsh-history-substring-search' ] && \
  git clone https://github.com/zsh-users/zsh-history-substring-search.git

ln -sf "$DIR"/.zshrc "$HOME"/.zshrc
ln -sf "$DIR"/.aliasrc "$HOME"/.config/.aliasrc
ln -sf "$DIR"/.vimrc "$HOME"/.vimrc
