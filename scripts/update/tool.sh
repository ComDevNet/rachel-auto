#!/bin/bash

# This script updates this tool.

# Save the current directory
current_directory=$(pwd)

# Move to the directory of the script
cd "$(dirname "$0")" || exit

# Pull the latest changes from GitHub
git reset --hard HEAD
git pull

# Check if the pull was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "Script updated successfully."
else
    echo "Failed to update the script. Please check for updates manually."
    exit 1
fi

cd ../..

# Set execute permissions for all scripts in the current directory
sudo chmod +x *.sh
sudo chmod +x scripts/vpn/*.sh
sudo chmod +x scripts/update/*.sh
sudo chmod +x scripts/system/*.sh
sudo chmod +x scripts/data/*.sh
sudo chmod +x scripts/data/all/*.sh
sudo chmod +x scripts/data/all/process/*.sh
sudo chmod +x scripts/data/collection/*.sh
sudo chmod +x scripts/data/process/*.sh
sudo chmod +x scripts/data/process/all/*.sh

# Return to the original directory
cd "$current_directory"

# Sleep and return to the main menu
echo "Returning to the main menu in 2 seconds..."
sleep 2
exec ./scripts/update/main.sh