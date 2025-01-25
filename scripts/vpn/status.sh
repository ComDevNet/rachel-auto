#!/bin/bash

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""

# Step 1: List Active ZeroTier Networks
echo -e "${YELLOW}Checking current ZeroTier networks...${NC}"
echo ""

# Fetch all networks
zerotier_output=$(sudo zerotier-cli listnetworks)

# Ensure the output is not empty
if [[ -z "$zerotier_output" ]]; then
    echo -e "${RED}No ZeroTier networks found.${NC}"
    echo ""
    echo -e "${YELLOW}Press Enter to return to the main menu...${NC}"
    read -p ""
    exec ./scripts/vpn/main.sh
fi

# Parse the output to extract details
active_networks=$(echo "$zerotier_output" | grep "OK")

# Check if there are active networks
if [[ -z "$active_networks" ]]; then
    echo -e "${RED}No active ZeroTier networks found.${NC}"
else
    echo -e "${GREEN}Active ZeroTier Networks:${NC}"
    echo ""
    echo -e "${CYAN}Details for each connection:${NC}"
    echo "--------------------------------------------------------"

    # Loop through each line of active networks
    while IFS= read -r line; do
        # Extract details
        network_id=$(echo "$line" | awk '{print $1}')
        network_name=$(echo "$line" | awk '{print $2}')
        mac=$(echo "$line" | awk '{print $3}')
        status=$(echo "$line" | awk '{print $4}')
        type=$(echo "$line" | awk '{print $5}')
        ip_address=$(echo "$line" | awk '{print $6}')

        # Display the details
        echo -e "${YELLOW}Network ID:${NC} $network_id"
        echo -e "${YELLOW}Name:${NC} $network_name"
        echo -e "${YELLOW}MAC:${NC} $mac"
        echo -e "${YELLOW}Type:${NC} $type"
        echo -e "${YELLOW}IP Address:${NC} ${GREEN}${ip_address}${NC}"
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
    read -p "Press Enter to continue..."
    exec ./scripts/vpn/main.sh
fi
