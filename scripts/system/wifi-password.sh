#!/bin/bash

# Define the path to the hostapd configuration file
HOSTAPD_CONF="/etc/hostapd/hostapd.conf"

# Function to check if wpa_passphrase is present in the configuration file
check_password_presence() {
    grep -E -q "^\s*wpa_passphrase=" "$HOSTAPD_CONF"
}

# Function to display the current password
show_current_password() {
    current_password=$(awk -F= '/^wpa_passphrase/ {print $2}' "$HOSTAPD_CONF" | tr -d '[:space:]')
    echo "Current WiFi Password: $current_password"
}

# Function to change the password
change_password() {
    show_current_password
    read -p "Enter the new WiFi password: " new_password
    sudo sed -i "s/^\(wpa_passphrase\s*=\s*\).*/\1$new_password/" "$HOSTAPD_CONF"
    echo "WiFi password changed."
}

# Function to remove the password
remove_password() {
    cp "$HOSTAPD_CONF" "${HOSTAPD_CONF}_pass"
    sudo sed -i -e '/^interface=/!d; /^driver=/!d; /^ssid=/!d; /^hw_mode=/!d; /^channel=/!d; /^auth_algs=/!d; /^wmm_enabled=/!d' "$HOSTAPD_CONF"
    echo "WiFi password removed."
    echo "Configuration file backed up to ${HOSTAPD_CONF}_pass."
    echo "Please restart the machine to apply changes."
}

# Function to add password lines
add_password() {
    echo "wpa=2
wpa_passphrase=
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP	
rsn_pairwise=CCMP
ieee80211n=1
ht_capab=[HT40+][SHORT-GI-20][DSSS_CCK-40]
country_code=US" >> "$HOSTAPD_CONF"
     sudo sed -i "s/^wmm_enabled=.*/wmm_enabled=1/" "$HOSTAPD_CONF"
    read -p "Enter the new WiFi password: " new_password
    sudo sed -i "s/^\(wpa_passphrase\s*=\s*\).*/\1$new_password/" "$HOSTAPD_CONF"
    echo "WiFi password added."
}

# Main menu
echo "Welcome to WiFi Password Manager"

if check_password_presence; then
    # Prompt user for options
    read -p "Options: (1) Change Password, (2) Remove Password, (3) Go Back - Enter the option number: " option

    case $option in
        1)
            change_password
            ;;
        2)
            remove_password
            ;;
        3)
            echo "Going back to the main menu."
            ;;
        *)
            echo "Invalid option. Going back to the main menu."
            ;;
    esac
else
    # If no password lines are present, ask if the user wants to add a password
    read -p "No WiFi password found. Do you want to add a password? (y/n): " add_password

    if [ "${add_password,}" == "y" ]; then
        add_password
    else
        echo "No password added. Going back to the main menu."
    fi
fi
