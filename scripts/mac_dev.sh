#!/bin/bash

brew install openjdk@17
brew install openjdk@23
brew install jenv

#Check
java --version
brew install maven

jenv enable-plugin export
exec $SHELL -l
jenv add "$(/usr/libexec/java_home)"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
