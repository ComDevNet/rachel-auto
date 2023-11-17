#!/bin/bash

# clear the screen
clear

echo ""
echo ""

# Display the name of the tool
figlet -c -t -f 3d "RACHEL AUTO" | lolcat

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
echo "2. Update Rachel Interface"
echo "3. VPN Network"
echo "4. Check VPN Status"
echo "5. Download Rachel Logs"
echo -e "${GREEN}6. Update Script"
echo -e "${RED}7. Exit"

echo -e "${NC}"
# Prompt the user for input
read -p "Choose an option (1-5): " choice

# Check the user's choice and execute the corresponding script
case $choice in
    1)
        ./scripts/update/main.sh
        ;;
    2)
        ./interface-update.sh
        ;;
    3)
        ./connect-vpn.sh
        ;;
    4)
        ./vpn-connection.sh
        ;;
    5)
        ./download-logs.sh
        ;;
    6)
        ./update-script.sh
        ;;
    7)
        ./exit.sh
        ;;
    *)
        echo "Invalid choice. Please choose a number between 1 and 5."
        ;;
esac
