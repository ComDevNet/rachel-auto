#!/bin/bash

# clear the screen
clear

echo ""
echo ""

# Display the name of the tool
figlet -c -t -f 3d "DATA" | lolcat

echo ""

# A border to cover the description and its centered
echo  "=============================================================="
echo "Collect, Process, and Upload all your data to a server or not"
echo "=============================================================="

echo ""

# variables
RED='\033[0;31m'
NC='\033[0m' # No Color
DARK_GRAY='\033[1;30m'
GREEN='\033[0;32m'

# Display menu options
echo -e "1. Start            ${DARK_GRAY}-| Collect, Process, and Upload all your data${NC}"
echo -e "2. Collect          ${DARK_GRAY}-| Collect your Rachel logs and request files${NC}"
echo -e "3. Process          ${DARK_GRAY}-| Process your Rachel logs and request files${NC}"
echo -e "4. Upload           ${DARK_GRAY}-| Upload your Rachel logs to an AWS s3 Bucket${NC}"
echo -e "${GREEN}5. Go Back          ${DARK_GRAY}-| Go back to the main menu${NC}"
echo -e "${RED}6. Exit             ${DARK_GRAY}-| Exit the program${NC}"

echo -e "${NC}"
# Prompt the user for input
read -p "Choose an option (1-6): " choice

# Check the user's choice and execute the corresponding script
case $choice in
    1)
        ./scripts/data/all.sh
        ;; 
    2)
        ./scripts/data/collection/main.sh
        ;;
    3)
        ./scripts/data/process/main.sh
        ;;
    4)
        ./scripts/data/upload/main.sh
        ;;
    5)
        ./main.sh
        ;;
    6)
        ./exit.sh
        ;;
    *)
        echo -e "${RED}Invalid choice. Please choose a number between 1 and 6."
        echo -e "${NC}"
        sleep 1.5
        exec ./scripts/data/main.sh
        ;;
esac
