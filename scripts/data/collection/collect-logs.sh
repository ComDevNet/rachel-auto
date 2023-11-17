#!/bin/bash

# This script collects access log files from the apache log folder, renames them and keeps them organized

# variables
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

# Prompt the user for the location of the device
read -p "Enter the location of the device: " device_location

# Specify the log directory
log_directory="/var/log/apache2"

# Create a new folder with location and timestamp
new_folder="${device_location}_logs_$(date '+%Y_%m_%d')"
mkdir "$new_folder"

# Copy only access log files to the new folder
find "$log_directory" -type f -name "access.log*" -exec cp {} "$new_folder"/ \;

# Move to the new folder
cd "$new_folder" || exit

# Uncompress all individual log files
for compressed_file in *.gz; do
    gzip -d "$compressed_file"
done

# Rename files based on the date in the first line
for file in *; do
    if [ -f "$file" ]; then
        # Extract the day, month, and year from the first line of the file
        first_line_date=$(head -n 1 "$file" | grep -oP '\[\K[0-9]{2}/[a-zA-Z]+/[0-9]{4}')
        
        # Replace slashes with underscores for a valid filename
        formatted_date=$(echo "$first_line_date" | tr '/' '_')
        
        # Remove numbers and the preceding full stop at the end of the filename
        new_filename=$(echo "$formatted_date"_"$file" | sed 's/\.[0-9]\+$//')
        
        # Rename the file
        mv "$file" "$new_filename"
    fi
done

# Move back to the original directory
cd ..

# move the folder to a folder called logs
# Check if the "00_LOGS" folder exists, and create it if not
if [ ! -d "00_DATA" ]; then
    mkdir "00_DATA"
fi
mv "$new_folder" "00_DATA"

# Display a message about the created gzip file
echo "Logs are ready in the 00_DATA directory."
echo ""

# Prompt the user for further action
echo "What do next?"
echo "1. Collect Request File"
echo "2. Process Log Files"
echo -e "${GREEN}3. Return to the Main Menu"

echo -e "${NC}"
read -p "Enter your choice (1-3): " user_choice

case $user_choice in
    1)
        exec ./scripts/data/collection/collect-requests.sh
        ;;
    2)
        exec ./scripts/data/process/logs.sh
        ;;
    3)
        echo "Returning to the main menu in 4 seconds..."
        sleep 4
        exec ./scripts/data/collection/main.sh
        ;;
    *)
         echo -e "${RED}Invalid choice. Please choose a number between 1 and 3."
        echo -e "${NC}"
        sleep 4
        exec ./scripts/data/collection/collect-logs.sh
        ;;
esac
