#!/bin/bash

# Set the path to your Python script
python_script_path="scripts/data/process/processors/process_requests.py"

echo ""
# Prompt the user to pick a folder from '00_DATA' directory
echo "Select one of the available requests folders in '00_DATA' directory:"
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
    exec ./scripts/data/all/process/requests.sh
fi

# Construct the full path to the selected folder
selected_folder=${folders[$((folder_number-1))]#00_DATA/}

# Run the Python script with the selected folder as an argument
python3 "$python_script_path" "$selected_folder"

echo "Running upload script..."
sleep 1.5

exec ./scripts/data/upload/upload.sh