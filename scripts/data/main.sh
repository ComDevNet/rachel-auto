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
echo "1. Collect Data"
echo "2. Process Data"
echo "3. Upload Data"
echo -e "${GREEN}4. Go Back"
echo -e "${RED}5. Exit"

echo -e "${NC}"
# Prompt the user for input
read -p "Choose an option (1-5): " choice

# Check the user's choice and execute the corresponding script
case $choice in
    1)
        ./scripts/data/collection/main.sh
        ;;
    2)
        ./scripts/data/process/main.sh
        ;;
    3)
        ./scripts/data/upload.sh
        ;;
    4)
        ./main.sh
        ;;
    5)
        ./exit.sh
        ;;
    *)
        echo -e "${RED}Invalid choice. Please choose a number between 1 and 5."
        echo -e "${NC}"
        sleep 4
        exec ./scripts/data/main.sh
        ;;
esac