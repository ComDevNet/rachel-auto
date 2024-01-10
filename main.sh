#!/bin/bash

# clear the screen
clear

# Change directory to the script's location
cd "$(dirname "$(readlink -f "$0")")"

echo ""
echo ""

# Display the name of the tool
figlet -c -t -f 3d "RACHEL  AUTO" | lolcat

echo ""

echo  "============================================================================================================================"
echo "This tool is used to automate some actions on the Rachel, this tool is bought to you by Community Development Network (CDN)"
echo "============================================================================================================================"

echo ""

echo "Things that can be automated:"
echo ""

# variables
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
DARK_GRAY='\033[1;30m'

# Display menu options
echo -e "1. Update   ${DARK_GRAY}-| Update the Raspberry pi, Rachel Interface, and Program${NC}"
echo -e "2. VPN      ${DARK_GRAY}-| Install and configure the Zero-tier VPN${NC}"
echo -e "3. Data     ${DARK_GRAY}-| Collect, Process and Ppload the access logs and request file${NC}"
echo -e "4. System   ${DARK_GRAY}-| Change the system settings${NC}"
echo -e "${RED}5. Exit     ${DARK_GRAY}-| Exit the program${NC}"

echo -e "${NC}"
# Prompt the user for input
read -p "Choose an option (1-5): " choice

# Check the user's choice and execute the corresponding script
case $choice in
    1)
        ./scripts/update/main.sh
        ;;
    2)
        ./scripts/vpn/main.sh
        ;;
    3)
        ./scripts/data/main.sh
        ;;
    4)
        ./scripts/system/main.sh
        ;;
    5)
        ./exit.sh
        ;;
    *)
        echo -e "${RED}Invalid choice. Please choose a number between 1 and 5.${NC}"
        sleep 1.5
        exec ./main.sh
        ;;
esac
