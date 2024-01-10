#!/bin/bash

# clear the screen
clear

echo ""
echo ""

# Display the name of the tool
figlet -c -t -f 3d "COLLECTION" | lolcat

echo ""

# A border to cover the description and its centered
echo  "====================================================="
echo "Collect your Rachel logs and request files with ease"
echo "====================================================="

echo ""

# variables
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
DARK_GRAY='\033[1;30m'

# Display menu options
echo -e "1. Start                  ${DARK_GRAY}-| Start Collection process${NC}"
echo -e "2. Collect Logs           ${DARK_GRAY}-| Collect the logs from the Rachel${NC}"
echo -e "3. Collect Request File   ${DARK_GRAY}-| Collect the request file from the Rachel${NC}"
echo -e "4. Data Processing        ${DARK_GRAY}-| Run processing script${NC}"
echo -e "${GREEN}5. Go Back                ${DARK_GRAY}-| Go back to the main menu${NC}"
echo -e "${RED}6. Exit                   ${DARK_GRAY}-| Exit the program${NC}"

echo -e "${NC}"
# Prompt the user for input
read -p "Choose an option (1-6): " choice

# Check the user's choice and execute the corresponding script
case $choice in
    1)
        ./scripts/data/collection/all.sh
        ;;
    2)
        ./scripts/data/collection/collect-logs.sh
        ;;
    3)
        ./scripts/data/collection/collect-requests.sh
        ;;
    4)
        ./scripts/data/process/main.sh
        ;;
    5)
        ./scripts/data/main.sh
        ;;
    6)
        ./exit.sh
        ;;
    *)
        echo -e "${RED}Invalid choice. Please choose a number between 1 and 6.${NC}"
        sleep 1.5
        exec ./scripts/data/collection/main.sh
        ;;
esac
