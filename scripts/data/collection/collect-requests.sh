#!/bin/bash

# This script collects the "request.txt" file from the www folder and organizes it

# variables
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

# Prompt the user for the location of the device
read -p "Enter the location of the device: " device_location
# Replace spaces with underscores
device_location=${device_location// /_}

# Specify the www directory
www_directory="/var/www"

# Create a new folder with location and timestamp
new_folder="${device_location}_requests_$(date '+%Y_%m_%d')"
mkdir "$new_folder"

# Copy the "request.txt" file from the www folder to the new folder
cp "$www_directory/request.txt" "$new_folder/"

# Display a message about the collected file
echo "'request.txt' is ready in the $new_folder directory."
echo ""

# Check if the "00_DATA" folder exists, and create it if not
if [ ! -d "00_DATA" ]; then
    mkdir "00_DATA"
fi

# Move the new folder to a folder called data
mv "$new_folder" "00_DATA"

# Prompt the user for further action
echo "What do next?"
echo "1. Collect Logs"
echo "2. Process 'request.txt' File"
echo -e "${GREEN}3. Return to the Main Menu"

echo -e "${NC}"
read -p "Enter your choice (1-3): " user_choice

case $user_choice in
    1)
        exec ./scripts/data/collection/collect-logs.sh
        ;;
    2)
        exec ./scripts/data/process/requests.sh
        ;;
    3)
        echo "Returning to the main menu in 2 seconds..."
        sleep 2
        exec ./scripts/data/collection/main.sh
        ;;
    *)
        echo -e "${RED}Invalid choice. Please choose a number between 1 and 3."
        echo -e "${NC}"
        sleep 3
        exec ./scripts/data/collection/collect-requests.sh
        ;;
esac
