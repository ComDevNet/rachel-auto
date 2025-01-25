import os
import csv
from urllib.parse import unquote
from user_agents import parse
from io import StringIO
from datetime import datetime
import re
import sys


def process_log_file(file_path):
    """Process a single log file and extract data."""
    log_data = []

    with open(file_path, 'r', encoding='utf-8') as log_file:
        lines = log_file.read().splitlines()
        for line in lines:
            match = re.match(r'^(.*?) - - \[(.*?)\] "(.*?)" (\d+) (\d+) "(.*?)" "(.*?)"$', line)
            if match:
                ip_address, timestamp, request, status_code, response_size_bytes, _, user_agent_string = match.groups()

                # Parse timestamp
                timestamp = datetime.strptime(timestamp, "%d/%b/%Y:%H:%M:%S %z").strftime("%Y-%m-%d")

                # Extract module name
                path_to_modules = re.sub(r'^GET (.*) HTTP/1.1$', r'\1', request)
                decoded_path = unquote(path_to_modules)
                module_name_match = re.search(r'/modules/([^/]+)/', decoded_path)
                module_name = module_name_match.group(1) if module_name_match else 'none'

                # User agent parsing
                user_agent = parse(user_agent_string)
                device_type = user_agent.os.family
                browser_name = user_agent.browser.family if user_agent.browser.family else 'unknown'

                # Convert response size from bytes to GB
                response_size_gb = format(int(response_size_bytes) / 1073741824, ".5f")

                log_data.append([ip_address, timestamp, module_name, status_code, response_size_gb, device_type, browser_name])

    return log_data


def save_processed_log_file(folder_path, file_path, log_data):
    """Save the processed log data to a CSV file."""
    # Ensure the processed folder exists
    os.makedirs(folder_path, exist_ok=True)

    # Save the processed log file
    processed_file_path = os.path.join(folder_path, f"{os.path.splitext(os.path.basename(file_path))[0]}.csv")
    with open(processed_file_path, 'w', encoding='utf-8', newline='') as output_file:
        csv_writer = csv.writer(output_file)
        csv_writer.writerow(['IP Address', 'Access Date', 'Module Viewed', 'Status Code', 'Data Saved (GB)', 'Device Used', 'Browser Used'])
        csv_writer.writerows(log_data)


def create_master_csv(folder_path, all_log_data):
    """Create a master CSV file combining all log data."""
    master_csv_path = os.path.join(folder_path, "summary.csv")

    with open(master_csv_path, 'w', encoding='utf-8', newline='') as master_csv:
        csv_writer = csv.writer(master_csv)
        csv_writer.writerow(['IP Address', 'Access Date', 'Module Viewed', 'Status Code', 'Data Saved (GB)', 'Device Used', 'Browser Used'])

        for log_data in all_log_data:
            csv_writer.writerows(log_data)


if __name__ == '__main__':
    # Get the folder to process from command-line arguments
    selected_folder = sys.argv[1]
    folder_path = os.path.join("00_DATA", selected_folder)
    processed_folder_path = os.path.join("00_DATA", "00_PROCESSED", selected_folder)

    if not os.path.exists(folder_path):
        print(f"Error: Folder '{folder_path}' does not exist.")
        sys.exit(1)

    all_log_data = []
    total_files = sum(len(files) for _, _, files in os.walk(folder_path))
    processed_files = 0

    # Process each log file in the folder
    for root, _, files in os.walk(folder_path):
        for file in files:
            if file.endswith(".log"):
                file_path = os.path.join(root, file)
                log_data = process_log_file(file_path)

                # Save the processed log file
                save_processed_log_file(processed_folder_path, file_path, log_data)
                all_log_data.extend(log_data)

                # Update progress
                processed_files += 1
                progress = (processed_files / total_files) * 100
                print(f"\rProcessing files: {processed_files}/{total_files} [{int(progress)}%]", end='', flush=True)

    # Create the master summary CSV
    create_master_csv(processed_folder_path, all_log_data)

    print("\nProcessing completed. All log files have been processed.")
