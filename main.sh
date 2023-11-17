#!/bin/bash

# clear the screen
clear

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

# Display menu options
echo "1. Update"
echo "2. VPN"
echo "3. Data"
echo "4. System"
echo -e "${RED}5. Exit"

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
        echo "Invalid choice. Please choose a number between 1 and 5."
        ;;
esac
