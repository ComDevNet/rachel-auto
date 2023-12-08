#!/bin/bash

# Set the path to your Python script
python_script_path="scripts/data/process/processors/log.py"

echo ""
# Prompt the user to pick a folder from '00_DATA' directory
echo "Select one of the available available log folders in '00_DATA' directory:"
folders=($(ls -d 00_DATA/*logs*/))  # Filter folders with "logs" in their name

if [ ${#folders[@]} -eq 0 ]; then
    echo "No log folders found in '00_DATA'. Exiting..."
    sleep 5
    exec ./scripts/data/process/main.sh
fi

for ((i=0; i<${#folders[@]}; i++)); do
    echo "$((i+1)). ${folders[i]#00_DATA/}"
done

# Prompt the user for their choice
read -p "Enter the number corresponding to the log folder you want to process: " folder_number

# Validate user input
if [[ ! $folder_number =~ ^[1-9][0-9]*$ || $folder_number -gt ${#folders[@]} ]]; then
    echo "Invalid input. Please enter a valid folder number."
    sleep 5
    exec ./scripts/data/process/main.sh
fi

# Construct the full path to the selected folder
selected_folder=${folders[$((folder_number-1))]#00_DATA/}

# Run the Python script with the selected folder as an argument
python3 "$python_script_path" "$selected_folder"

echo ""
echo "Processing Request file"
    exec ./scripts/data/all/process/requests.sh

