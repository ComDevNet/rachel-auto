#!/bin/bash

# Define color variables
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""

# Step 1: Display the raw output of the listnetworks command
echo -e "${YELLOW}Checking current ZeroTier networks...${NC}"
echo ""
sudo zerotier-cli listnetworks
echo ""

# Step 2: Prompt the User
read -p "Do you want to connect to a different network? (y/n): " user_response

echo ""

if [[ "$user_response" =~ ^[Yy]$ ]]; then
    # Navigate to the connect script
    exec ./scripts/vpn/connect.sh
else
    echo -e "${YELLOW}Returning to the main menu...${NC}"
    read -p "Press Enter to continue..."
    exec ./scripts/vpn/main.sh
fi
