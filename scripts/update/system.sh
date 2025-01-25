#!/bin/bash

## This script updates the raspberry pi system

# Ask the user for the current date and time
read -p "Enter the current date and time(24 hours) (YYYY-MM-DD HH:MM): " user_datetime

# Set the system date and time
sudo date --set="$user_datetime"

# Color variables
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Update the system
sudo apt update && sudo apt upgrade -y

echo ""
echo ""

# Display a message about the update
echo "${GREEN}System has been updated successfully.${NC}"
echo ""

# Prompt the user to press Enter before returning to the main menu
echo ""
echo "Press Enter to return to the main menu..."
read -p ""

# Return to the main menu
exec ./scripts/update/main.sh