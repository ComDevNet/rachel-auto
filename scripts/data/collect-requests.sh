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

echo "Returning to the main menu in 10 seconds..."

# exit to main menu
sleep 10
exec ./scripts/data/main.sh
