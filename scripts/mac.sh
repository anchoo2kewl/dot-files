isM1=`sysctl -n sysctl.proc_translated`
re='^[0-9]+$'

#Install HomeBrew
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ $isM1 =~ $re ]] ; then 
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    brew update
fi

# Install iTerm2
brew install --cask iterm2

# Install Slack
brew install --cask slack

if ! [[ $isM1 =~ $re ]] ; then 
        # Install VMWare Fusion
        brew install --cask vmware-fusion

        # Install Docker Desktop
        brew install homebrew/cask/docker        
fi

if [[ $? != 0 ]] ; then
    brew install --cask utm
fi

# Install Docker completion
brew install docker-completion
brew install docker-compose-completion
brew install docker-machine-completion

# Install Zsh completions
brew install zsh-completions

# Install Outlook
brew install --cask microsoft-outlook

# Install Sublime
brew install --cask sublime-text

# Install VSCode
brew install --cask visual-studio-code

# Install Zoom
brew install --cask zoom

# Install OBS
brew install --cask obs

# Install telnet
brew install telnet

# Install RDP
brew install --cask microsoft-remote-desktop

# Install insomnia
brew install --cask insomnia

# Install Notion
brew install --cask notion

# Install Wget
brew install wget

# Install Obsidian
brew install --cask obsidian

# Install Github CLI
brew install gh

# Install DuckDuckGo
brew install --cask duckduckgo

# Install arc
brew install --cask arc

# Install Tailscale
brew install tailscale

# Install Mailsy
brew install mailsy

# Install Taskell
brew install taskell

# Wifi Password
brew install wi-fi password

# Mas
brew install mas

# MPV
brew install mpv

# 2048
brew install c2048

# htop
brew install htop

# Imagemagick
brew install imagemagick

#Bitwarden
mas install 1352778147

#Tailscale
mas install 1475387142
