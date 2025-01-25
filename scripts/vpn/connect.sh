#!/bin/bash

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# This script is used to connect to a ZeroTier network and ensure no duplicate connections appear.

echo ""
echo -e "${YELLOW}Stopping the ZeroTier service and removing old identities...${NC}"
# Step 1: Stop the ZeroTier service and remove old identities
sudo systemctl stop zerotier-one
sudo rm -rf /var/lib/zerotier-one/identity.secret
sudo rm -rf /var/lib/zerotier-one/identity.public

# Step 2: Start the ZeroTier service and enable it
sudo systemctl start zerotier-one
sudo systemctl enable zerotier-one

# Step 3: Wait for the ZeroTier service to stabilize
echo "Waiting for ZeroTier service to stabilize..."
echo ""
sleep 5

# Step 4: Ask the user for the network ID
read -p "Enter the network ID: " network_id
echo ""

# Step 5: Join the ZeroTier network
echo -e "${YELLOW}Joining the ZeroTier network...${NC}"
echo ""
join_output=$(sudo zerotier-cli join "$network_id" 2>&1)

# Step 6: Check if the join command was successful
if echo "$join_output" | grep -q "200 join OK"; then
    echo -e "${GREEN}ZeroTier network joined successfully.${NC}"
    echo ""
else
    echo -e "${RED}Failed to join the ZeroTier network. Please check the network ID and try again.${NC}"
    echo "Error: $join_output"
    echo "Press Enter to exit..."
    read -p ""
    exit 1
fi

# Step 7: Wait for authorization
echo "Waiting for authorization in the ZeroTier dashboard..."
echo ""
while true; do
    network_status=$(sudo zerotier-cli listnetworks | grep "$network_id")
    if echo "$network_status" | grep -q "OK"; then
        echo -e "${GREEN}Connection is authorized and active.${NC}"
        echo ""
        break
    else
        echo -e "${RED}Connection is pending authorization. Please authorize it in the ZeroTier dashboard.${NC}"
        sleep 4
    fi
done

# Step 8: Show active connection
echo "Active ZeroTier connection details:"
sudo zerotier-cli listnetworks | grep "$network_id"
echo ""

# Step 9: Prompt the user to press Enter to return to the main menu
echo "Press Enter to return to the main menu..."
read -p ""

# Return to the main menu
exec ./scripts/vpn/main.sh
