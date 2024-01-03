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
    echo "Restarting WiFi to apply changes..."
    sleep 2
    sudo systemctl restart hostapd
}

# Function to remove the password
remove_password() {
    sudo cp "$HOSTAPD_CONF" "${HOSTAPD_CONF}_pass"
    sudo sed -i -e '/^wpa=/d; /^wpa_passphrase=/d; /^wpa_key_mgmt=/d; /^wpa_pairwise=/d; /^rsn_pairwise=/d; /^ieee80211n=/d; /^ht_capab=/d; /^country_code=/d' "$HOSTAPD_CONF"
    sudo sed -i "s/^wmm_enabled=.*/wmm_enabled=0/" "$HOSTAPD_CONF"
    echo "WiFi password removed."
    echo "Configuration file backed up to ${HOSTAPD_CONF}_pass."
    echo "Restarting WiFi to apply changes..."
    sleep 2
    sudo systemctl restart hostapd
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
country_code=US" | sudo tee -a "$HOSTAPD_CONF" > /dev/null
    sudo sed -i "s/^wmm_enabled=.*/wmm_enabled=1/" "$HOSTAPD_CONF"
    read -p "Enter the new WiFi password: " new_password
    sudo sed -i "s/^\(wpa_passphrase\s*=\s*\).*/\1$new_password/" "$HOSTAPD_CONF"
    echo "WiFi password added."
    echo "Restarting WiFi..."
    sleep 2
    sudo service hostapd restart
}

echo " "
# Main menu
figlet -c -t -f 3d "WIFI PASSWORD MANAGER" | lolcat
echo " "

if check_password_presence; then
    # Prompt user for options
    echo "1. Change Password"
    echo "2. Remove Password"
    echo "3. Go Back"
    read -p "Enter the option number: " option

    case $option in
        1)
            change_password
            ;;
        2)
            remove_password
            ;;
        3)
            echo "Going back to the Main Menu..."
            sleep 3
            exec ./scripts/system/main.sh
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
        echo "No password added. Going back to the main menu..."
        sleep 3
        exec ./scripts/system/main.sh
    fi
fi
