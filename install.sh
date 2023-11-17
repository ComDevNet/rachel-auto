#!/bin/bash

# install figlet and lolcat
sudo apt-get install figlet
sudo apt-get install lolcat

# install 3d.tlf figlet font
wget https://raw.githubusercontent.com/xero/figlet-fonts/master/3d.flf
sudo mv 3d.flf /usr/share/figlet/

# make the scripts executable
chmod +x *.sh

exec ./main.sh
