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
