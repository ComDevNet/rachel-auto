#!/bin/bash

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Clear the screen and display the title
echo ""

# Step 1: List Active ZeroTier Networks
echo -e "${YELLOW}Checking current ZeroTier networks...${NC}"
echo ""

# Fetch active networks
active_networks=$(sudo zerotier-cli listnetworks | grep "OK")

# Check if there are active networks
if [[ -z "$active_networks" ]]; then
    echo -e "${RED}No active ZeroTier networks found.${NC}"
else
    echo -e "${GREEN}Active ZeroTier Networks:${NC}"
    echo ""
    echo -e "${CYAN}Details for each active connection:${NC}"
    echo "--------------------------------------------------------"

    # Loop through each active network and extract details
    while IFS= read -r line; do
        network_id=$(echo "$line" | awk '{print $1}')
        network_name=$(echo "$line" | awk '{print $3}')
        ip_address=$(sudo zerotier-cli get "$network_id" ip | awk '{print $1}')
        status=$(echo "$line" | awk '{print $5}')

        echo -e "${YELLOW}Network ID:${NC} $network_id"
        echo -e "${YELLOW}Name:${NC} $network_name"
        echo -e "${YELLOW}IP Address:${NC} ${GREEN}${ip_address}${NC}"
        echo -e "${YELLOW}Status:${NC} ${GREEN}$status${NC}"
        echo "--------------------------------------------------------"
    done <<< "$active_networks"
fi

echo ""

# Step 2: Prompt the User
read -p "Do you want to connect to a different network? (y/n): " user_response

echo ""

if [[ "$user_response" =~ ^[Yy]$ ]]; then
    # Navigate to the connect script
    exec ./scripts/vpn/connect.sh
else
    echo -e "${YELLOW}Returning to the main menu...${NC}"
    sleep 1.5
    exec ./scripts/vpn/main.sh
fi
