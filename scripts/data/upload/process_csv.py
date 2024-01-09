#!/usr/bin/env python3

import sys
import os
import csv
from datetime import datetime
from tqdm import tqdm

def read_csv_without_null(file_path):
    with open(file_path, 'r', newline='', encoding='utf-8') as f:
        reader = csv.reader((line.replace('\0', '') for line in f))
        header = next(reader)
        lines = [row for row in tqdm(reader, desc="Reading CSV", unit=" lines")]
    return header, lines

# Get folder, location, month, and processed file name from command line arguments
folder, location, month, processed_file_name = sys.argv[1], sys.argv[2], int(sys.argv[3]), sys.argv[4]

# Load the processed CSV file using the csv module
csv_file_path = os.path.join(folder, 'summary_copy.csv')
try:
    header, lines = read_csv_without_null(csv_file_path)
except Exception as e:
    sys.exit(f"Error reading CSV file: {e}")

# Extract dates and convert to datetime objects
try:
    dates = [datetime.strptime(line[1], '%Y-%m-%d') for line in lines]
except ValueError as e:
    sys.exit(f"Error converting dates: {e}")

# Filter rows based on the selected month
filtered_lines = [line for line in tqdm(lines, desc="Filtering Rows", unit=" lines") if datetime.strptime(line[1], '%Y-%m-%d').month == month]

# Choose the latest year if there are multiple years
year = max(datetime.strptime(line[1], '%Y-%m-%d').year for line in filtered_lines)

# Save the processed CSV file with the chosen year
new_filename = f"{location}_{month:02d}_{year}_access_logs.csv"
output_file_path = os.path.join(folder, new_filename)
with open(output_file_path, 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerows(filtered_lines)

# Print the chosen year (for Bash script to capture)
print(year)
