#!/bin/bash

# This script is used to connect to a zerotier network

#creating a new identity
sudo systemctl stop zerotier-one
sudo rm -rf /var/lib/zerotier-one/identity.secret
sudo rm -rf /var/lib/zerotier-one/identity.public
sudo systemctl start zerotier-one

# Ask the user to input a network ID
read -p "Enter the network ID: " network_id

# Join the ZeroTier network
sudo zerotier-cli join "$network_id"

# Create a ZeroTier configuration file
sudo touch "/var/lib/zerotier-one/networks.d/$network_id.conf"

# Display a success message and wait for 5 seconds
echo "ZeroTier network joined successfully. Returning to script in 2 seconds..."
sleep 2

# Return to the main script
exec ./scripts/vpn/main.sh