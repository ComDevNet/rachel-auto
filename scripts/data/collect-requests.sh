#!/bin/bash

# This script collects the "request.txt" file from the www folder and organizes it

# Prompt the user for the location of the device
read -p "Enter the location of the device: " device_location

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
echo "3. Return To The Main Menu"

read -p "Enter your choice (1-3): " user_choice

case $user_choice in
    1)
        exec ./scripts/data/collect-logs.sh
        ;;
    2)
        exec ./scripts/data/process/process-request.sh
        ;;
    3)
        echo "Returning to the main menu in 4 seconds..."
        sleep 4
        exec ./scripts/data/main.sh
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
