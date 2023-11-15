#!/bin/bash

# install figlet and lolcat
sudo apt-get install figlet
sudo apt-get install lolcat

# install 3d.tlf figlet font
wget https://raw.githubusercontent.com/xero/figlet-fonts/master/3d.flf
sudo mv 3d.flf /usr/share/figlet/

# make the scripts executable
chmod +x main.sh
chmod +x exit.sh
chmod +x system-update.sh
chmod +x interface-update.sh
chmod +x connect-vpn.sh
chmod +x vpn-connection.sh
chmod +x download-logs.sh
chmod +x update-script.sh

exec ./main.sh
