#!/bin/bash

# Run sudo zerotier-cli listnetworks and display the result
echo "Current ZeroTier Networks:"
sudo zerotier-cli listnetworks

# Ask the user if they want to connect to another network or go back
read -p "Do you want to connect to another network? (y/n): " user_response

if [ "$user_response" == "y" ]; then
    exec ./connect-vpn.sh
else
    echo "Returning to the main menu in 3 seconds..."
    sleep 3
    exec ./main.sh
fi