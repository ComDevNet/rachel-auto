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

# Display menu options
echo "1. Start"
echo "2. Collect Logs"
echo "3. Collect Request File"
echo "4. Data Processing"
echo -e "${GREEN}5. Go Back"
echo -e "${RED}6. Exit"

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
        echo -e "${RED}Invalid choice. Please choose a number between 1 and 6."
        sleep 3
        exec ./scripts/data/collection/main.sh
        ;;
esac
