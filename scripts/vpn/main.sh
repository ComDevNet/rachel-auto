#!/bin/bash

# clear the screen
clear

echo ""
echo ""

# Display the name of the tool
figlet -c -t -f 3d "VPN" | lolcat

echo ""

# A border to cover the description and its centered
echo  "========================================"
echo "VPN Connection to the Zerotier Network"
echo "========================================"

echo ""

# variables
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

# Display menu options
echo "1. Connect"
echo "2. Status"
echo -e "${GREEN}3. Go Back"
echo -e "${RED}4. Exit"

echo -e "${NC}"
# Prompt the user for input
read -p "Choose an option (1-4): " choice

# Check the user's choice and execute the corresponding script
case $choice in
    1)
        ./scripts/vpn/connect.sh
        ;;
    2)
        ./scripts/vpn/status.sh
        ;;
    3)
        ./main.sh
        ;;
    4)
        ./exit.sh
        ;;
    *)
        echo "Invalid choice. Please choose a number between 1 and 4."
        ;;
esac
