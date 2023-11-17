#!/bin/bash

# Check if zerotier-cli is installed
if ! command -v zerotier-cli &> /dev/null; then
    echo "Error: zerotier-cli is not installed. Please install it before running this script."
    sleep 4
    exec ./scripts/vpn/main.sh
fi

# Disconnect from all ZeroTier networks
zerotier-cli leave all

# Check the exit status of the zerotier-cli command
if [ $? -eq 0 ]; then
    echo "Disconnected from all ZeroTier networks."
    sleep 4
    exec ./scripts/vpn/main.sh
else
    echo "Error: Failed to disconnect from ZeroTier networks."
    sleep 4
    exec ./scripts/vpn/main.sh
fi
