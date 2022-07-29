isM1=`sysctl -n sysctl.proc_translated`
re='^[0-9]+$'

#Install HomeBrew
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [[ $isM1 =~ $re ]] ; then 
        export PATH=$PATH:/opt/homebrew/bin;
    fi
else
    brew update
fi

# Install iTerm2
brew install --cask iterm2

# Install Slack
brew install --cask slack

if ! [[ $isM1 =~ $re ]] ; then 
        # Install Teams
        brew install --cask microsoft-teams

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


# Install Bitwarden
brew install --cask bitwarden

# Install Zoom
brew install --cask zoom

# Install Webex
brew install --cask webex

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