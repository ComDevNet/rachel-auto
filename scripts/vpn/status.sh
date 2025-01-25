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
active_networks=$(sudo zerotier-cli listnetworks | grep "OK")

if [[ -z "$active_networks" ]]; then
    echo -e "${RED}No active ZeroTier networks found.${NC}"
else
    echo -e "${GREEN}Active ZeroTier Networks:${NC}"
    echo -e "${CYAN}Network ID          Name                     Status${NC}"
    echo "--------------------------------------------------"
    echo "$active_networks" | awk '{printf "%-18s %-25s %s\n", $1, $3, $5}'
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
