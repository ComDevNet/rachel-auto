#!/bin/bash

# Define color variables for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Check if zerotier-cli is installed
if ! command -v zerotier-cli &> /dev/null; then
    echo -e "${RED}Error:${NC} zerotier-cli is not installed. Please install it before running this script."
    echo -e "${YELLOW}Press Enter to return to the main menu...${NC}"
    read -p ""
    exec ./scripts/vpn/main.sh
fi

# Disconnect from all ZeroTier networks
echo -e "${YELLOW}Disconnecting from all ZeroTier networks...${NC}"
sudo zerotier-cli leave 0.0.0.0

# Check if the command succeeded
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully disconnected from all ZeroTier networks.${NC}"
else
    echo -e "${RED}Error:${NC} Failed to disconnect from ZeroTier networks."
fi

# Wait for the user to press Enter before returning to the main menu
echo -e "${YELLOW}Press Enter to return to the main menu...${NC}"
read -p ""
exec ./scripts/vpn/main.sh
