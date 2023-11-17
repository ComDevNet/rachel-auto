#!/bin/bash

# Save the current directory
current_directory=$(pwd)

# Move to the directory of the script
cd "$(dirname "$0")" || exit

# Pull the latest changes from GitHub
git reset --hard HEAD
git pull

# Check if the pull was successful
if [ $? -eq 0 ]; then
    echo "Script updated successfully."
    echo "Returning to the main menu in 5 seconds..."
else
    echo "Failed to update the script. Please check for updates manually."
    echo "Returning to the main menu in 5 seconds..."
fi

# Return to the original directory
cd "$current_directory"

chmod +x exit.sh
chmod +x system-update.sh
chmod +x interface-update.sh
chmod +x connect-vpn.sh
chmod +x vpn-connection.sh
chmod +x download-logs.sh
chmod +x update-script.sh

sleep 5
exec ./main.sh
