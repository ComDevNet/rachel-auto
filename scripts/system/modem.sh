#!/usr/bin/env bash
#
# manage_modem.sh
# An interactive script to enable and connect a USB modem to the internet using mmcli.
# 
# Usage: 
#   ./manage_modem.sh
#

########################
# Helper Functions
########################

pause_for_confirmation() {
  local prompt_msg="$1"
  read -r -p "$prompt_msg [y/N]: " answer
  case "$answer" in
    [Yy]* ) return 0 ;;  # user said yes
    * )     echo "Cancelled."; exit 1 ;;
  esac
}

########################
# 1) Check for mmcli
########################
if ! command -v mmcli &> /dev/null; then
  echo "Error: 'mmcli' command not found. Please install ModemManager."
  exit 1
fi

echo "mmcli is installed: $(mmcli -V)"
pause_for_confirmation "Do you want to continue?"

########################
# 2) Scan for modems
########################
echo "Scanning for modems..."
sudo mmcli --scan-modems
pause_for_confirmation "Continue?"

########################
# 3) List available modems
########################
modem_list=$(sudo mmcli --list-modems 2>&1)
echo "List of modems:"
echo "$modem_list"

# If no modems found, exit
if echo "$modem_list" | grep -q "No modems were found"; then
  echo "No modems found. Please ensure your USB modem is plugged in."
  exit 1
fi

pause_for_confirmation "Continue?"

########################
# 4) Ask user which modem to manage
########################
echo "Which modem index do you want to manage?"
# Typically, mmcli --list-modems shows something like: /org/freedesktop/ModemManager1/Modem/0 
# We can parse out the last digit as the modem index. Or ask the user to specify.
read -r -p "Enter modem index (e.g. 0): " MODEM_INDEX
if [ -z "$MODEM_INDEX" ]; then
  echo "No modem index provided. Exiting."
  exit 1
fi

pause_for_confirmation "Use modem index $MODEM_INDEX and continue?"

########################
# 5) Check modem info & status
########################
echo "Fetching modem info..."
modem_info=$(sudo mmcli --modem="$MODEM_INDEX" 2>&1)
if echo "$modem_info" | grep -iq "error"; then
  echo "Error fetching modem info. Please check the index or connections."
  exit 1
fi

echo "$modem_info"
pause_for_confirmation "Continue?"

# A quick way to see if modem is connected:
# We can parse the status from the mmcli output. 
# If "state: connected" or "Status: connected" is present, assume it's online.
echo "Checking modem state..."
modem_state=$(echo "$modem_info" | grep -i "state" | grep -oE "connected|connecting|registered|disabled|enabling|enabled|failed|unknown")
if [ -z "$modem_state" ]; then
  modem_state="unknown"
fi
echo "Modem state appears to be: $modem_state"

# Check if connected
if [ "$modem_state" = "connected" ]; then
  echo "It appears your modem is already connected."
  pause_for_confirmation "Do you want to continue (e.g., check IP type)?"
else
  echo "Modem is not fully connected."
  pause_for_confirmation "Would you like to attempt to connect now?"
  
  # 5a) Enable the modem if not enabled
  echo "Enabling modem..."
  sudo mmcli --modem="$MODEM_INDEX" --enable
  pause_for_confirmation "Modem enabled (if it wasn't already). Continue to connect?"
  
  # 5b) Connect (APN & IP type can be adjusted as needed)
  # Prompt user for APN if you like:
  read -r -p "Enter APN (default: data.tre.se): " USER_APN
  APN=${USER_APN:-data.tre.se}
  
  # Prompt user for IP type (ipv4, ipv6, ipv4v6)
  read -r -p "Enter IP type (ipv4, ipv6, or ipv4v6) [default: ipv4v6]: " USER_IPTYPE
  IPTYPE=${USER_IPTYPE:-ipv4v6}
  
  echo "Attempting to activate data connection with APN=$APN, IP_TYPE=$IPTYPE..."
  sudo mmcli -m "$MODEM_INDEX" --simple-connect="apn=$APN,ip-type=$IPTYPE"
  
  # Re-check status
  echo "Re-checking modem status..."
  modem_info=$(sudo mmcli --modem="$MODEM_INDEX")
  echo "$modem_info"
fi

pause_for_confirmation "Continue to check final connection details?"

########################
# 6) Check current bearer (IP type)
########################
# If the modem is connected, it will usually have a bearer (e.g. bearer 0).
# We can parse it from the lines containing 'bearer' references.
bearer_line=$(echo "$modem_info" | grep -iE 'Bearer.*\/Modem')
if [ -n "$bearer_line" ]; then
  # Extract the numeric part from e.g. '/org/freedesktop/ModemManager1/Bearer/0'
  # or just pick the last token:
  bearer_id=$(echo "$bearer_line" | awk -F'/' '{print $NF}')
  echo "Detected bearer ID: $bearer_id"
  
  echo "Fetching bearer info..."
  bearer_info=$(sudo mmcli --bearer="$bearer_id" 2>&1)
  echo "$bearer_info"
  
  # Optional: parse out IP type or addresses
  ip_family=$(echo "$bearer_info" | grep -oE "ipv[46]{1,2}")
  [ -z "$ip_family" ] && ip_family="unknown"
  
  echo "Your current IP family/type appears to be: $ip_family"
else
  echo "No bearer found. The modem might not be fully connected."
fi

pause_for_confirmation "Done checking details. Exit now?"

echo "Returning to main menu..."
sleep 2
exec ./scripts/system/main.sh