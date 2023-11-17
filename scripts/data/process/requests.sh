#!/bin/bash

# Set the path to your Python script
python_script_path="scripts/data/process/processors/process_requests.py"

echo ""
# Prompt the user to pick a folder from '00_DATA' directory
echo "Available requests folders in '00_DATA' directory:"
folders=($(ls -d 00_DATA/*requests*/))  # Filter folders with "requests" in their name

if [ ${#folders[@]} -eq 0 ]; then
    echo "No requests folders found in '00_DATA'. Exiting..."
    sleep 5
    exec ./scripts/data/process/main.sh
fi

for ((i=0; i<${#folders[@]}; i++)); do
    echo "$((i+1)). ${folders[i]#00_DATA/}"
done

# variables
RED='\033[0;31m'
NC='\033[0m' # No Color

echo ""
# Prompt the user for their choice
read -p "Enter the number corresponding to the request folder you want to process: " folder_number

# Validate user input
if [[ ! $folder_number =~ ^[1-9][0-9]*$ || $folder_number -gt ${#folders[@]} ]]; then
    echo ""
    echo -e "${RED}Invalid input. Please enter a valid folder number."
    echo -e "${NC}"
    exec ./scripts/data/process/requests.sh
fi

# Construct the full path to the selected folder
selected_folder=${folders[$((folder_number-1))]#00_DATA/}

# Run the Python script with the selected folder as an argument
python3 "$python_script_path" "$selected_folder"

# Prompt the user for further action
read -p "Do you want to process another request folder? (y/n): " user_response

if [ "$user_response" == "y" ]; then
    exec ./scripts/data/process/requests.sh
else
    echo "Returning to the main menu in 5 seconds..."
    sleep 5
    exec ./scripts/data/process/main.sh
    # Add your requestic for returning to the main menu or other actions
fi
