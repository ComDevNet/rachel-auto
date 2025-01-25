#!/bin/bash

# clear the screen
clear

echo ""
echo ""

# Display the name of the tool
figlet -t -f 3d "VPN" | lolcat

echo ""

# A border to cover the description and its centered
echo  "========================================"
echo "Connection to the Zerotier Network"
echo "========================================"

echo ""

# variables
RED='\033[0;31m'
NC='\033[0m' # No Color
DARK_GRAY='\033[1;30m'
GREEN='\033[0;32m'

# Display menu options
echo -e "1. Connect           ${DARK_GRAY}-| Connect to the Zerotier Network${NC}"
echo -e "2. Check Status      ${DARK_GRAY}-| Check the status of the Zerotier Network${NC}"
echo -e "3. Disconnect        ${DARK_GRAY}-| Disconnect from the Zerotier Network${NC}"
echo -e "${GREEN}4. Go Back           ${DARK_GRAY}-| Go back to the main menu${NC}"
echo -e "${RED}5. Exit              ${DARK_GRAY}-| Exit the program${NC}"

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
        ./scripts/vpn/disconnect.sh
        ;;
    4)
        ./main.sh
        ;;
    5)
        ./exit.sh
        ;;
    *)
        echo "Invalid choice. Please choose a number between 1 and 4."
        sleep 1.5
        exec ./scripts/vpn/main.sh
        ;;
esac
