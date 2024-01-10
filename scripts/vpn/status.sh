#!/bin/bash

# This script checks the status of your vpn connection

# Run sudo zerotier-cli listnetworks and display the result
echo "Current ZeroTier Networks:"
sudo zerotier-cli listnetworks

# Ask the user if they want to connect to another network or go back
read -p "Do you want to connect to a different network? (y/n): " user_response

if [[ "$user_response" =~ ^[Yy]$ ]]; then
    exec ./scripts/vpn/connect.sh
else
    echo "Returning to the main menu..."
    sleep 1.5
    exec ./scripts/vpn/main.sh
fi