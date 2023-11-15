#!/bin/bash

# Ask the user to input a network ID
read -p "Enter the network ID: " network_id

# Join the ZeroTier network
sudo zerotier-cli join "$network_id"

# Create a ZeroTier configuration file
sudo touch "/var/lib/zerotier-one/networks.d/$network_id.conf"

# Display a success message and wait for 5 seconds
echo "ZeroTier network joined successfully. Returning to the main menu in 3 seconds..."
sleep 3

# Return to the main script
exec ./main.sh