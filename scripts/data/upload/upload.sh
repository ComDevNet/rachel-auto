#!/bin/bash

s3_bucket="s3://rachel-upload-test"

# Display all folders with 'log' in their name
echo "Available folders:"
folders=(00_DATA/00_PROCESSED/*log*/)

PS3="Please enter the number of the folder you want to select: "

select folder in "${folders[@]}"; do
    if [ -n "$folder" ]; then
        echo "You selected $folder"
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

# Ask user for the location name
echo "Please enter the name of the location:"
read location

# Ask user for the desired month
while true; do
    read -p "Please enter the starting month for filtering (1-12): " month
    if [[ $month =~ ^[1-9]$|^1[0-2]$ ]]; then
        # Format month with two digits
        month=$(printf "%02d" "$month")
        break
    else
        echo "Invalid input. Please enter a number between 1 and 12."
    fi
done

# Create a copy of the summary.csv file
cp "$folder/summary.csv" "$folder/summary_copy.csv"

# Call Python script to process the copied CSV file and get the year
year=$(python3 scripts/data/upload/process_csv.py "$folder" "$location" "$month" "access_logs.csv")

# Display all AWS S3 buckets
echo "Available S3 buckets:"
aws s3 ls $s3_bucket/

# Ask the user to pick a bucket
read -p "Enter the selected S3 bucket: " selected_bucket

# Check if the processed file exists before attempting to upload
processed_filename="${location}_${month}_${year}_access_logs.csv"
if [ -e "$folder/$processed_filename" ]; then
    # Upload the new file to S3
    aws s3 cp "$folder/$processed_filename" "$s3_bucket/${selected_bucket}/Rachel/$processed_filename"

    echo "Data upload completed successfully. Returning to main menu..."
    sleep 5
    exec ./scripts/data/upload/main.sh
else
    echo "Exiting. The processed file does not exist or the process was not successful."
    sleep 2
    exec ./scripts/data/upload/main.sh
fi
