import os
import csv
from urllib.parse import unquote
from user_agents import parse
from io import StringIO
from datetime import datetime
import re
import sys  # Import sys module to access command line arguments

def process_log_file(file_path):
    log_data = []  # Reset log_data for each conversion

    with open(file_path, 'r', encoding='utf-8') as log_file:
        lines = log_file.read().splitlines()
        for line in lines:
            match = re.match(r'^(.*?) - - \[(.*?)\] "(.*?)" (\d+) (\d+) "(.*?)" "(.*?)"$', line)
            if match:
                ip_address, timestamp, request, status_code, response_size_bytes, _, user_agent_string = match.groups()

                # Add a condition to check for status code 200
                if status_code == '200':
                    # Parse the timestamp into the desired format
                    timestamp = datetime.strptime(timestamp, "%d/%b/%Y:%H:%M:%S %z").strftime("%Y-%m-%d")

                    path_to_modules = re.sub(r'^GET (.*) HTTP/1.1$', r'\1', request)
                    decoded_path = unquote(path_to_modules)
                    cleaned_path = decoded_path.replace('%', '')

                    # Extract the module name from the path
                    module_name_match = re.search(r'/modules/([^/]+)/', cleaned_path)
                    if module_name_match:
                        module_name = module_name_match.group(1)
                    else:
                        module_name = 'none'

                    user_agent = parse(user_agent_string)

                    # Use user_agent.os.family directly as the device_type
                    device_type = user_agent.os.family

                    browser_name = user_agent.browser.family if user_agent.browser.family else 'unknown'

                    # Convert response size from bytes to Gigabytes
                    response_size_gb = format(int(response_size_bytes) / 1073741824, ".5f") 

                    log_data.append([ip_address, timestamp, module_name, status_code, response_size_gb, device_type, browser_name])

    return log_data

def save_processed_log_file(selected_folder, file_path, log_data):
    processed_folder_path = os.path.join("00_DATA", "00_PROCESSED", selected_folder)
    
    # Create the 'PROCESSED' folder if it doesn't exist
    if not os.path.exists(processed_folder_path):
        os.makedirs(processed_folder_path)

    # Save the result to a separate CSV file for each log file
    output_csv = StringIO()
    csv_writer = csv.writer(output_csv)
    csv_writer.writerow(['IP Address', 'Access Date', 'Module Viewed', 'Status Code', 'Data Saved (GB)', 'Device Used', 'Browser Used'])
    csv_writer.writerows(log_data)

    output_csv.seek(0)
    
    # Save the processed log file with the same name as the original log file but with a .csv extension
    processed_file_path = os.path.join(processed_folder_path, f"{os.path.splitext(os.path.basename(file_path))[0]}.csv")
    with open(processed_file_path, 'w', encoding='utf-8') as output_file:
        output_file.write(output_csv.getvalue())

def create_master_csv(selected_folder, all_log_data):
    master_csv_path = os.path.join("00_DATA", "00_PROCESSED", selected_folder, "summary.csv")

    with open(master_csv_path, 'w', encoding='utf-8') as master_csv:
        csv_writer = csv.writer(master_csv)
        csv_writer.writerow(['IP Address', 'Access Date', 'Module Viewed', 'Status Code', 'Data Saved (GB)', 'Device Used', 'Browser Used'])
        
        for log_data in all_log_data:
            csv_writer.writerows(log_data)

if __name__ == '__main__':
    # Specify the folder path to process
    selected_folder = sys.argv[1]  # Access the argument passed from the command line
    folder_path = os.path.join("00_DATA", selected_folder)

    # Get the total number of files for the progress bar
    total_files = sum([len(files) for _, _, files in os.walk(folder_path)])
    all_log_data = []

    # Process each access.log file in the folder
    progress = 0
    for i, (root, dirs, files) in enumerate(os.walk(folder_path)):
        for file in files:
            if file.endswith(".log"):
                file_path = os.path.join(root, file)
                log_data = process_log_file(file_path)

                # Save the result to a separate CSV file for each log file
                save_processed_log_file(selected_folder, file_path, log_data)
                all_log_data.append(log_data)

                # Update progress bar
                progress += 1
                percentage = (progress / total_files) * 100
                print(f"\rProcessing files: [{int(percentage)}%] [{'#' * int(percentage / 2)}]", end='', flush=True)

# Create the master CSV file
    create_master_csv(selected_folder, all_log_data)

    print("\nLog files processed successfully.")
