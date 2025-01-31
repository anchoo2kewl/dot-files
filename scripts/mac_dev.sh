#!/bin/bash

brew install java
# If 18 is installed, else change this
sudo ln -sfn /usr/local/opt/openjdk@18/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-18.jdk
brew install java11
brew install openjdk@17
brew install jenv

#Check
java --version
brew install maven

jenv enable-plugin export
exec $SHELL -l
jenv add "$(/usr/libexec/java_home)"
jenv add /usr/local/opt/openjdk@8
jenv add /usr/local/opt/openjdk@11

brew install go

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

brew install --cask intellij-idea-ce
brew install --cask pycharm-ce
