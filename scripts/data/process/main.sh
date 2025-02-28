#!/bin/bash

# clear the screen
clear

echo ""
echo ""

# Display the name of the tool
figlet -t -f 3d "PROCESSING" | lolcat

echo ""

# A border to cover the description and its centered
echo  "=================================================================================="
echo "Process your data with ease, Make Sure you've already run the Collection Scripts"
echo "=================================================================================="

echo ""

# variables
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
DARK_GRAY='\033[1;30m'

# Display menu options
echo -e "1. Start               ${DARK_GRAY}-| Process all your data${NC}"
echo -e "2. Data Collection     ${DARK_GRAY}-| Run the Data Collection Scripts${NC}"
echo -e "3. Data Upload         ${DARK_GRAY}-| Run the Data Upload Scripts${NC}"
echo -e "${GREEN}4. Go Back             ${DARK_GRAY}-| Go back to the main menu${NC}"
echo -e "${RED}5. Exit                ${DARK_GRAY}-| Exit the program${NC}"

echo -e "${NC}"
# Prompt the user for input
read -p "Choose an option (1-5): " choice

# Check the user's choice and execute the corresponding script
case $choice in
    1)
        ./scripts/data/process/logs.sh
        ;;
    2)
        ./scripts/data/collection/main.sh
        ;;
    3)
        ./scripts/data/upload/main.sh
        ;;
    4)
        ./scripts/data/main.sh
        ;;
    5)
        ./exit.sh
        ;;
    *)
        echo -e "${RED}Invalid choice. Please choose a number between 1 and 7.${NC}"
        sleep 1.5
        exec ./scripts/data/process/main.sh
        ;;
esac
