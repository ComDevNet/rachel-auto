#!/bin/bash

# clear the screen
clear

echo ""
echo ""

# Display the name of the tool
figlet -c -t -f 3d "PROCESS  DATA" | lolcat

echo ""

# A border to cover the description and its centered
echo  "============================"
echo "Proess your data with ease"
echo "============================"

echo ""

# variables
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

# Display menu options
echo "1. All"
echo "2. Logs"
echo "3. Requests"
echo -e "${GREEN}4. Go Back"
echo -e "${RED}5. Exit"

echo -e "${NC}"
# Prompt the user for input
read -p "Choose an option (1-5): " choice

# Check the user's choice and execute the corresponding script
case $choice in
    1)
        ./scripts/data/process/all.sh
        ;;
    2)
        ./scripts/data/process/logs.sh
        ;;
    3)
        ./scripts/data/process/requests.sh
        ;;
    4)
        ./scripts/data/main.sh
        ;;
    5)
        ./exit.sh
        ;;
    *)
        echo "Invalid choice. Please choose a number between 1 and 5."
        ;;
esac
