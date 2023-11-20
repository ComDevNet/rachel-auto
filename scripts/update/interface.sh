#!/bin/bash

# This script updates the Rachel Interface,
# The interface can be found on comdevnet GitHub Organization

# Save the current directory
current_directory=$(pwd)

# Move to the /var/www/ directory
cd /var/www/ || exit

# Get the current version
current_version=$(git describe --tags --abbrev=0)

# Display the current version
echo "Current System Version: $current_version"

# Run git fetch to get the latest changes
sudo git fetch

# Get the latest release version
latest_version=$(git tag -l | sort -V | tail -n 1)

# Display the latest release version
echo "Latest Release Version: $latest_version"

# Ask the user if they want to pull the new release
read -p "Do you want to update to the latest release? (y/n): " user_response

if [ "$user_response" == "y" ]; then
    # Perform a git pull
    git reset --hard HEAD
    sudo git pull
    echo ""
    echo "New release pulled successfully. Returning to the main menu in 4 seconds..."
else
    echo "Interface is the latest version. Returning to the main menu in 4 seconds..."
fi

cd "$current_directory"
sleep 4
# Return to the main script
exec ./scripts/update/main.sh
