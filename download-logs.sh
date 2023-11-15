#!/bin/bash

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

# Gzip the new folder
tar -czf "$new_folder.tar.gz" "$new_folder"

# move the tar.gz file to a folder called logs
mkdir 00_LOGS
mv "$new_folder.tar.gz" ./00_LOGS

# Display a message about the created gzip file
echo "Access log files have been processed and saved in the file: $new_folder.tar.gz"
echo "File is ready for download."
echo ""


# Cleanup: Remove the temporary folder and its contents
rm -rf "$new_folder"
echo "Temporary folder has been removed."
echo "Returning to the main menu in 3 seconds..."

# exit to main menu
sleep 3
exec ./main.sh
