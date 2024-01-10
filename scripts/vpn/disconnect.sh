#!/bin/bash

# Check if zerotier-cli is installed
if ! command -v zerotier-cli &> /dev/null; then
    echo "Error: zerotier-cli is not installed. Please install it before running this script."
    sleep 2
    exec ./scripts/vpn/main.sh
fi

# Disconnect from all ZeroTier networks
zerotier-cli leave 0.0.0.0

# Check the exit status of the zerotier-cli command
if [ $? -eq 0 ]; then
    echo "Disconnected from all ZeroTier networks."
    sleep 1.5
    exec ./scripts/vpn/main.sh
else
    echo "Error: Failed to disconnect from ZeroTier networks."
    sleep 1.5
    exec ./scripts/vpn/main.sh
fi
