#!/bin/bash

## This script updates the raspberry pi system

# Ask the user for the current date and time
read -p "Enter the current date and time(24 hours) (YYYY-MM-DD HH:MM): " user_datetime

# Set the system date and time
sudo date --set="$user_datetime"

# Update the system
sudo apt update && sudo apt upgrade -y

echo ""
echo ""

# Display a message about the update
echo "System has been updated successfully."
echo "Returning to the main menu in 2 seconds..."
sleep 2

# Return to the main script
exec ./scripts/update/main.sh