#!/bin/bash

# install figlet and lolcat
sudo apt-get install figlet
sudo apt-get install lolcat

# install 3d.tlf figlet font
wget https://raw.githubusercontent.com/xero/figlet-fonts/master/3d.flf
sudo mv 3d.flf /usr/share/figlet/

# install python3 and pip3
pip install -r requirements.txt

# make the scripts executable
chmod +x scripts/vpn/*.sh
chmod +x scripts/update/*.sh
chmod +x scripts/data/*.sh
chmod +x scripts/system/*.sh
chmod +x *.sh

exec ./main.sh
