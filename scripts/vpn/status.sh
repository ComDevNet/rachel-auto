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

# Fetch all networks and ensure output is valid
zerotier_output=$(sudo zerotier-cli listnetworks)
if [[ -z "$zerotier_output" ]]; then
    echo -e "${RED}No ZeroTier networks found.${NC}"
    echo -e "${YELLOW}Press Enter to return to the main menu...${NC}"
    read -p ""
    exec ./scripts/vpn/main.sh
fi

# Extract header and data lines
data_lines=$(echo "$zerotier_output" | tail -n +2)

# Check if there are any networks listed
if [[ -z "$data_lines" ]]; then
    echo -e "${RED}No active ZeroTier networks found.${NC}"
else
    echo -e "${GREEN}Active ZeroTier Networks:${NC}"
    echo ""
    echo -e "${CYAN}Details for each connection:${NC}"
    echo "--------------------------------------------------------"

    # Loop through each line and parse the details
    while IFS= read -r line; do
        network_id=$(echo "$line" | awk '{print $1}')
        name=$(echo "$line" | awk '{print $2}')
        mac=$(echo "$line" | awk '{print $3}')
        status=$(echo "$line" | awk '{print $4}')
        type=$(echo "$line" | awk '{print $5}')
        ip=$(echo "$line" | awk '{print $6}')

        if [[ "$status" == "OK" ]]; then
            echo -e "${YELLOW}Network ID:${NC} $network_id"
            echo -e "${YELLOW}Name:${NC} $name"
            echo -e "${YELLOW}MAC:${NC} $mac"
            echo -e "${YELLOW}Type:${NC} $type"
            echo -e "${YELLOW}IP Address:${NC} ${GREEN}${ip}${NC}"
            echo "--------------------------------------------------------"
        fi
    done <<< "$data_lines"
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
