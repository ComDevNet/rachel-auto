#!/bin/bash

# Define the path to the hostapd configuration file
HOSTAPD_CONF="/etc/hostapd/hostapd.conf"

# Function to display current wifi name
show_current_wifi_name() {
    current_wifi_name=$(awk -F= '/^ssid/ {print $2}' "$HOSTAPD_CONF" | tr -d '[:space:]')
    echo "Current WiFi Name: $current_wifi_name"
}

# Function to change wifi name
change_wifi_name() {
    read -p "Enter the new WiFi name: " new_wifi_name
    sudo sed -i "s/^ssid=.*/ssid=$new_wifi_name/" "$HOSTAPD_CONF"
    echo "WiFi name changed to: $new_wifi_name"

    read -p "Needs to restart wifi to apply changes. Do you want to continue? (y/n): " choice
    if [ "${choice,}" == "y" ]; then
        echo "wifi restarting...."
        sleep 3
        sudo systemctl restart hostapd
    else
        echo "Wifi name changes will be applied after device has been rebooted. Returning to main menu...."
        sleep 3
        exec ./scripts/system/main.sh
}

# Display current wifi name
show_current_wifi_name

# Ask user if they want to change the wifi name
read -p "Do you want to change the WiFi name? (y/n): " choice

if [ "${choice,}" == "y" ]; then
    # Call function to change wifi name
    change_wifi_name
elif [ "${choice,}" == "n" ]; then
    echo "Returning to Main Menu....."
    sleep 3
    exec ./scripts/system/main.sh
else
    echo "Invalid choice. Please enter 'y' or 'n'."
fi
