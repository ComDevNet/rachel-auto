#!/bin/bash

echo ""
# Prompt the user for confirmation
read -p "Are you sure you want to reboot? (y/n): " user_response

# Check the user's response
if [ "$user_response" == "y" ]; then
    # Execute the reboot command
    sudo reboot
else
    echo "Reboot canceled. Returning to main menu in 2 seconds..."
fi

sleep 2
exec ./scripts/system/main.sh