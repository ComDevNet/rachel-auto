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

# Fetch all networks and parse them
zerotier_output=$(sudo zerotier-cli listnetworks)

# Check if there are any networks in the output
if ! echo "$zerotier_output" | grep -q "<status>"; then
    echo -e "${RED}No ZeroTier networks found.${NC}"
else
    echo -e "${GREEN}Active ZeroTier Networks:${NC}"
    echo ""
    echo -e "${CYAN}Details for each connection:${NC}"
    echo "--------------------------------------------------------"

    # Loop through each line of the output, skipping the header
    echo "$zerotier_output" | tail -n +2 | while IFS= read -r line; do
        # Extract details from each column
        network_id=$(echo "$line" | awk '{print $1}')
        network_name=$(echo "$line" | awk '{print $2}')
        mac=$(echo "$line" | awk '{print $3}')
        status=$(echo "$line" | awk '{print $4}')
        type=$(echo "$line" | awk '{print $5}')
        ip_address=$(echo "$line" | awk '{print $6}')

        # Only show active networks (status = OK)
        if [[ "$status" == "OK" ]]; then
            echo -e "${YELLOW}Network ID:${NC} $network_id"
            echo -e "${YELLOW}Name:${NC} $network_name"
            echo -e "${YELLOW}MAC:${NC} $mac"
            echo -e "${YELLOW}Type:${NC} $type"
            echo -e "${YELLOW}IP Address:${NC} ${GREEN}${ip_address}${NC}"
            echo "--------------------------------------------------------"
        fi
    done
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
