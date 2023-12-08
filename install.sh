#!/bin/bash

# install figlet and lolcat
sudo apt-get install figlet
sudo apt-get install lolcat

# install 3d.tlf figlet font
wget https://raw.githubusercontent.com/xero/figlet-fonts/master/3d.flf
sudo mv 3d.flf /usr/share/figlet/

# install python3 and pip3
pip3 install -r requirements.txt
pip install -r requirements.txt


# make the scripts executable
sudo chmod +x *.sh
sudo chmod +x scripts/vpn/*.sh
sudo chmod +x scripts/update/*.sh
sudo chmod +x scripts/system/*.sh
sudo chmod +x scripts/data/*.sh
sudo chmod +x scripts/data/all/*.sh
sudo chmod +x scripts/data/all/process/*.sh
sudo chmod +x scripts/data/collection/*.sh
sudo chmod +x scripts/data/process/*.sh
sudo chmod +x scripts/data/process/all/*.sh


exec ./main.sh
