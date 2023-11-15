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
sleep 5
exec ./main.sh
