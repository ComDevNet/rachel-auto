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
GREEN='\033[0;32m'

# Display menu options
echo "1. Start"
echo "2. Collect Data"
echo "3. Process Data"
echo "4. Upload Data"
echo -e "${GREEN}5. Go Back"
echo -e "${RED}6. Exit"

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
        ./scripts/data/upload/upload.sh
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
        sleep 4
        exec ./scripts/data/main.sh
        ;;
esac
