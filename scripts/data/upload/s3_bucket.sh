#!/bin/bash

# Read the current s3_bucket variable from upload.sh
s3_bucket=$(grep -oP '(?<=s3_bucket=).+' upload.sh)

# Display the current s3_bucket variable
echo "Current s3_bucket: $s3_bucket"

# Ask the user if they want to change the location
read -p "Do you want to change the s3_bucket location? (y/n): " choice

if [[ $choice == "y" || $choice == "Y" ]]; then
    # Display all the available buckets
    aws s3 ls

    # Ask for the new location
    echo ""
    echo "Enter the full s3_bucket location, e.g. s3://my-bucket-name"
    read -p "Enter the new s3_bucket location: " new_location

    # Update the upload.sh file with the new location
    sudo sed -i "s|s3_bucket=.*|s3_bucket=$new_location|" upload.sh

    echo "s3_bucket location updated successfully."
else
    echo "s3_bucket location remains unchanged."
fi
