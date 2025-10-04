#!/usr/bin/env bash
set -euo pipefail

# --- Paths ---
export XDG_CONFIG_HOME="$HOME/.config"
REALPATH=$(realpath "$0")
DIR=$(dirname "$REALPATH")

# --- Platform detection ---
OS="$(uname)"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64)   LF_ARCH="amd64"; FASTFETCH_ARCH="amd64" ;;
  aarch64|arm64) LF_ARCH="arm64"; FASTFETCH_ARCH="aarch64" ;;
  *) echo "❌ Unsupported architecture: $ARCH"; exit 1 ;;
esac

# --- Linux installs ---
install_linux_packages() {
  local distro
  distro=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')

  case "$distro" in
    "Arch Linux"|"Arch Linux ARM")
      echo "📦 Ensuring packages on Arch..."
      doas pacman -S --noconfirm --quiet zsh mosh bat fzf ripgrep zoxide mc fastfetch >/dev/null 2>&1 || true
      command -v lf >/dev/null || curl -Ls "https://github.com/gokcehan/lf/releases/download/r27/lf-linux-${LF_ARCH}.tar.gz" | sudo tar xzC /usr/bin
      ;;
    "Ubuntu"|"Pop!_OS")
      echo "📦 Ensuring packages on Ubuntu/Pop!_OS..."
      sudo apt-get update -qq >/dev/null
      sudo apt-get install -y -qq zsh mosh bat fzf ripgrep zoxide mc wget curl >/dev/null
      if ! command -v fastfetch >/dev/null; then
        wget -q "https://github.com/fastfetch-cli/fastfetch/releases/download/2.39.1/fastfetch-linux-${FASTFETCH_ARCH}.deb" -O /tmp/fastfetch.deb
        sudo dpkg -i /tmp/fastfetch.deb >/dev/null 2>&1 || sudo apt-get install -f -y -qq >/dev/null
      fi
      command -v lf >/dev/null || curl -Ls "https://github.com/gokcehan/lf/releases/download/r27/lf-linux-${LF_ARCH}.tar.gz" | sudo tar xzC /usr/bin
      ;;
    "CentOS Linux")
      echo "📦 Ensuring packages on CentOS..."
      sudo yum install -y -q zsh mosh unzip wget util-linux-user >/dev/null
      sudo dnf config-manager --set-enabled powertools >/dev/null 2>&1 || true
      sudo dnf install -y -q epel-release fastfetch mc >/dev/null
      command -v bat >/dev/null || { wget -q -O /tmp/bat.rpm http://repo.openfusion.net/centos7-x86_64/bat-0.7.0-1.of.el7.x86_64.rpm; sudo yum install -y -q /tmp/bat.rpm >/dev/null; }
      command -v fzf >/dev/null || { wget -q -O /tmp/fzf.rpm http://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/f/fzf-0.30.0-3.fc37.x86_64.rpm; sudo yum install -y -q /tmp/fzf.rpm >/dev/null; }
      command -v rg >/dev/null || { wget -q -O /tmp/ripgrep.rpm https://github.com/jc21-rpm/ripgrep/releases/download/v13.0.0/ripgrep-13.0.0-1.el8.x86_64.rpm; sudo yum install -y -q /tmp/ripgrep.rpm >/dev/null; }
      sudo dnf -y copr enable atim/zoxide >/dev/null 2>&1 || true
      sudo dnf -y -q install zoxide >/dev/null
      ;;
    *)
      echo "❌ Unsupported Linux distribution: $distro"
      exit 1
      ;;
  esac
  echo "✅ Linux packages ensured"
}

# --- macOS installs ---
install_macos_packages() {
  echo "📦 Ensuring packages on macOS..."
  brew install fastfetch mosh tmux coreutils bat ripgrep fnm fzf zoxide midnight-commander lf starship alacritty >/dev/null 2>&1 || true
  echo "✅ macOS packages ensured"
}

# --- Starship install (Linux only, macOS uses brew) ---
install_starship() {
  if command -v starship >/dev/null; then
    echo "⭐ Starship already installed"
    return
  fi

  echo "⭐ Installing Starship..."
  local STARSHIP_URL
  if [ "$OS" = "Darwin" ]; then
    echo "⚡ Using brew Starship on macOS (already covered)"
    return
  else
    if [ "$LF_ARCH" = "amd64" ]; then
      STARSHIP_URL="https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-musl.tar.gz"
    else
      STARSHIP_URL="https://github.com/starship/starship/releases/latest/download/starship-aarch64-unknown-linux-musl.tar.gz"
    fi
    curl -Ls "$STARSHIP_URL" | sudo tar xzC /usr/local/bin
  fi
  echo "✅ Starship installed"
}

# --- Dotfiles setup ---
setup_dotfiles() {
  echo "🔗 Linking dotfiles..."
  mkdir -p "$XDG_CONFIG_HOME"

  ln -sf "$DIR/starship.toml" "$XDG_CONFIG_HOME/starship.toml"
  touch "$DIR/.custom.zsh"
  ln -sf "$DIR/.custom.zsh" "$HOME/.custom.zsh"
  ln -sf "$DIR/.tmux.conf" "$HOME/.tmux.conf"

  mkdir -p "$XDG_CONFIG_HOME/alacritty"
  if [ ! -d "$XDG_CONFIG_HOME/alacritty/themes/.git" ]; then
    echo "🌈 Installing Alacritty themes..."
    rm -rf "$XDG_CONFIG_HOME/alacritty/themes"
    git clone --quiet --depth 1 https://github.com/alacritty/alacritty-theme "$XDG_CONFIG_HOME/alacritty/themes"
  else
    echo "🌈 Updating Alacritty themes..."
    git -C "$XDG_CONFIG_HOME/alacritty/themes" pull --quiet --ff-only
  fi
  ln -sf "$DIR/alacrity.toml" "$XDG_CONFIG_HOME/alacritty/alacritty.toml"

  mkdir -p "$HOME/libs" "$XDG_CONFIG_HOME/nvim/"
  ln -sf "$DIR/init.vim" "$XDG_CONFIG_HOME/nvim/init.vim"

  cd "$HOME/libs"
  [ -d zsh-syntax-highlighting ] || git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting.git
  [ -d zsh-autosuggestions ] || git clone --quiet https://github.com/zsh-users/zsh-autosuggestions.git
  [ -d zsh-history-substring-search ] || git clone --quiet https://github.com/zsh-users/zsh-history-substring-search.git

  ln -sf "$DIR/.zshrc" "$HOME/.zshrc"
  ln -sf "$DIR/.aliasrc" "$XDG_CONFIG_HOME/.aliasrc"
  ln -sf "$DIR/.vimrc" "$HOME/.vimrc"

  echo "✅ Dotfiles linked"
}

# --- Main ---
case "$OS" in
  Linux)  install_linux_packages ;;
  Darwin) install_macos_packages ;;
  *) echo "❌ Unsupported OS: $OS"; exit 1 ;;
esac

install_starship
setup_dotfiles

echo "🎉 Setup complete!"
