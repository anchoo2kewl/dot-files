# Install XCode + Dev Tools
xcode-select --install

#Install HomeBrew
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    brew update
fi

# Install iTerm2
brew install --cask iterm2

# Install Slack
brew install --cask slack

# Install Teams
brew install --cask microsoft-teams

# Install Outlook
brew install --cask microsoft-outlook

# Install Sublime
brew install --cask sublime-text

# Install VSCode
brew install --cask visual-studio-code

# Install VMWare Fusion
brew install --cask vmware-fusion

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
