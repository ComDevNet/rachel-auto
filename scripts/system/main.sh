#!/bin/bash

# clear the screen
clear

echo ""
echo ""

# Display the name of the tool
figlet -c -t -f 3d "SYSTEM" | lolcat

echo ""

# A border to cover the description and its centered
echo  "================================================================================="
echo "All basic system settings, Be careful here though, you might mess up the system"
echo "================================================================================="

echo ""

# variables
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

# Display menu options
echo "1. Change Interface"
echo "2. Change WIFI Name"
echo "3. Raspberry Pi Configuration"
echo "4. Reboot"
echo "5. Shutdown"
echo -e "${GREEN}6. Go Back"
echo -e "${RED}7. Exit"

echo -e "${NC}"
# Prompt the user for input
read -p "Choose an option (1-6): " choice

# Check the user's choice and execute the corresponding script
case $choice in
    1)
        ./scripts/system/change-interface.sh
        ;;
    2) 
        ./scripts/system/wifi-name.sh
        ;;
    3)
        ./scripts/system/raspi-config.sh
        ;;
    4)
        ./scripts/system/reboot.sh
        ;;
    5)
        ./scripts/system/shutdown.sh
        ;;
    6)
        ./main.sh
        ;;
    7)
        ./exit.sh
        ;;
    *)
        echo "Invalid choice. Please choose a number between 1 and 7."
        ;;
esac
