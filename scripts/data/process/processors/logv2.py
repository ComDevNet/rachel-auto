import os
import csv
import re
from datetime import datetime
from user_agents import parse
import sys


def process_log_file(file_path):
    """Process a single log file and extract data."""
    log_data = []

    with open(file_path, 'r', encoding='utf-8') as log_file:
        lines = log_file.read().splitlines()
        for line in lines:
            match = re.search(
                r'(?P<ip>[\d.]+) - - \[(?P<timestamp>[^\]]+)\] "(?P<request>GET|POST) (?P<path>[^\s]+) HTTP/1.1" (?P<status_code>\d+) (?P<size>\d+) "(?P<referrer>[^"]*)" "(?P<user_agent>[^"]*)"',
                line,
            )
            if match:
                groups = match.groupdict()

                # Parse timestamp
                timestamp = datetime.strptime(groups["timestamp"], "%d/%b/%Y:%H:%M:%S %z").strftime("%Y-%m-%d")

                # Extract module name from path
                module_match = re.search(r'/modules/([^/]+)/', groups["path"])
                module_name = module_match.group(1) if module_match else "none"

                # Parse user agent
                user_agent = parse(groups["user_agent"])
                device_type = user_agent.os.family
                browser_name = user_agent.browser.family if user_agent.browser.family else "unknown"

                # Convert response size to GB
                response_size_gb = format(int(groups["size"]) / 1073741824, ".5f")

                # Append the data to the log_data list
                log_data.append([
                    groups["ip"],
                    timestamp,
                    module_name,
                    groups["status_code"],
                    response_size_gb,
                    device_type,
                    browser_name,
                ])

    return log_data


def save_processed_log_file(folder_path, file_path, log_data):
    """Save the processed log data to a CSV file."""
    os.makedirs(folder_path, exist_ok=True)
    processed_file_path = os.path.join(folder_path, f"{os.path.splitext(os.path.basename(file_path))[0]}.csv")
    with open(processed_file_path, 'w', encoding='utf-8', newline='') as output_file:
        csv_writer = csv.writer(output_file)
        csv_writer.writerow(['IP Address', 'Access Date', 'Module Viewed', 'Status Code', 'Data Saved (GB)', 'Device Used', 'Browser Used'])
        csv_writer.writerows(log_data)


def create_master_csv(folder_path, all_log_data):
    """Create a master CSV file combining all log data."""
    master_csv_path = os.path.join(folder_path, "summary.csv")
    os.makedirs(folder_path, exist_ok=True)
    with open(master_csv_path, 'w', encoding='utf-8', newline='') as master_csv:
        csv_writer = csv.writer(master_csv)
        csv_writer.writerow(['IP Address', 'Access Date', 'Module Viewed', 'Status Code', 'Data Saved (GB)', 'Device Used', 'Browser Used'])
        for log_data in all_log_data:
            csv_writer.writerows(log_data)


if __name__ == '__main__':
    selected_folder = sys.argv[1]
    folder_path = os.path.join("00_DATA", selected_folder)
    processed_folder_path = os.path.join("00_DATA", "00_PROCESSED", selected_folder)

    if not os.path.exists(folder_path):
        print(f"Error: Folder '{folder_path}' does not exist.")
        sys.exit(1)

    all_log_data = []
    total_files = sum(len(files) for _, _, files in os.walk(folder_path))
    processed_files = 0

    for root, _, files in os.walk(folder_path):
        for file in files:
            if file.endswith(".log"):
                file_path = os.path.join(root, file)
                log_data = process_log_file(file_path)
                save_processed_log_file(processed_folder_path, file_path, log_data)
                all_log_data.append(log_data)
                processed_files += 1
                progress = (processed_files / total_files) * 100
                print(f"\rProcessing files: {processed_files}/{total_files} [{int(progress)}%]", end='', flush=True)

    create_master_csv(processed_folder_path, all_log_data)
    print("\nProcessing completed. All log files have been processed.")
