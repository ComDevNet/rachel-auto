#!/bin/bash

echo ""
# Prompt the user for confirmation
read -p "Are you sure you want to shutdown? (y/n): " user_response

# Check the user's response
if [ "$user_response" == "y" ]; then
    # Execute the reboot command
    sudo shutdown -h now
else
    echo "Shutdown canceled. Returning to main menu..."
    sleep 1.5
    exec ./scripts/system/main.sh
fi

