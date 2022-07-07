#!/bin/bash

if [ -z "$1" ]; then
    echo -e "\nPlease use '$0 <new host name>' to invoke this command!\n"
    exit 1
fi

# command to change the primary hostname of your Mac
sudo scutil --set HostName $1

#Type the following command to change the Bonjour hostname of your Mac:
#This is the name usable on the local network, for example myMac.local.

sudo scutil --set LocalHostName $1

#If you also want to change the computer name, type the following command:
#This is the user-friendly computer name you see in Finder, for example myMac.

sudo scutil --set ComputerName $1

#Flush the DNS cache by typing:

dscacheutil -flushcache

