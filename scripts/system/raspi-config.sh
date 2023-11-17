#!/bin/bash

echo ""
# Prompt the user for confirmation
read -p "Are you sure you want to open Raspberry Pi configuration? (y/n): " user_response

# Check the user's response
if [ "$user_response" == "y" ]; then
    # Execute the reboot command
    sudo raspi-config
else
    echo "Returning to main menu in 4 seconds..."
fi

sleep 4
exec ./scripts/system/main.sh