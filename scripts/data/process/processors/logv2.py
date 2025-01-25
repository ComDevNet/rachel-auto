import os
import csv
import json
import re
from datetime import datetime
from user_agents import parse
import sys


def process_log_file(file_path):
    """Process a single log file and extract data."""
    log_data = []

    with open(file_path, 'r', encoding='utf-8') as log_file:
        for line in log_file:
            try:
                # Parse the JSON object
                log_entry = json.loads(line)
                message = log_entry.get("message", "")

                # Extract fields using regex
                match = re.search(
                    r'(?P<ip>[\d.:]+) - - \[(?P<timestamp>[^\]]+)\] "(?P<request>GET|POST) (?P<path>[^\s]+) HTTP/1.1" (?P<status_code>\d+) - "(?P<referrer>[^"]*)" "(?P<user_agent>[^"]*)"',
                    message,
                )
                if match:
                    groups = match.groupdict()

                    # Extract IP address and skip unwanted IPs
                    ip_address = groups["ip"]
                    if ip_address.startswith("::ffff:"):
                        continue

                    # Parse timestamp
                    timestamp = datetime.strptime(groups["timestamp"], "%Y-%m-%d %H:%M:%S.%f").strftime("%Y-%m-%d")

                    # Extract module name and skip unwanted paths
                    path = groups["path"]
                    module_name = "none"
                    if "/modules/" in path:
                        module_name = path.split("/modules/")[1].split("/")[0]
                    if "http://oc4d.cdn/categories" in path:
                        continue

                    # Parse user agent
                    user_agent = parse(groups["user_agent"])
                    device_type = user_agent.os.family if user_agent.os.family else "unknown"
                    browser_name = user_agent.browser.family if user_agent.browser.family else "unknown"

                    # Default response size
                    response_size_gb = "0.00000"

                    # Append the data to the log_data list
                    log_data.append([
                        ip_address,
                        timestamp,
                        module_name,
                        groups["status_code"],
                        response_size_gb,
                        device_type,
                        browser_name,
                    ])
                else:
                    print(f"Skipping line (unexpected format): {message}")
            except Exception as e:
                print(f"Error processing line: {line.strip()}, Error: {e}")

    return log_data


def save_processed_log_file(folder_path, file_path, log_data):
    """Save the processed log data to a CSV file."""
    os.makedirs(folder_path, exist_ok=True)
    processed_file_path = os.path.join(folder_path, f"{os.path.splitext(os.path.basename(file_path))[0]}.csv")
    if log_data:  # Only write files that have data
        with open(processed_file_path, 'w', encoding='utf-8', newline='') as output_file:
            csv_writer = csv.writer(output_file)
            csv_writer.writerow(['IP Address', 'Access Date', 'Module Viewed', 'Status Code', 'Data Saved (GB)', 'Device Used', 'Browser Used'])
            csv_writer.writerows(log_data)


def create_master_csv(folder_path):
    """Create a master CSV file combining all processed CSV data."""
    master_csv_path = os.path.join(folder_path, "summary.csv")
    os.makedirs(folder_path, exist_ok=True)

    with open(master_csv_path, 'w', encoding='utf-8', newline='') as master_csv:
        csv_writer = csv.writer(master_csv)
        csv_writer.writerow(['IP Address', 'Access Date', 'Module Viewed', 'Status Code', 'Data Saved (GB)', 'Device Used', 'Browser Used'])

        # Combine all individual CSVs into the master CSV
        for root, _, files in os.walk(folder_path):
            for file in files:
                if file.endswith(".csv") and file != "summary.csv":
                    file_path = os.path.join(root, file)
                    with open(file_path, 'r', encoding='utf-8') as csv_file:
                        csv_reader = csv.reader(csv_file)
                        next(csv_reader)  # Skip header
                        csv_writer.writerows(csv_reader)


if __name__ == '__main__':
    selected_folder = sys.argv[1]
    folder_path = os.path.join("00_DATA", selected_folder)
    processed_folder_path = os.path.join("00_DATA", "00_PROCESSED", selected_folder)

    if not os.path.exists(folder_path):
        print(f"Error: Folder '{folder_path}' does not exist.")
        sys.exit(1)

    total_files = sum(len(files) for _, _, files in os.walk(folder_path))
    processed_files = 0

    for root, _, files in os.walk(folder_path):
        for file in files:
            if file.endswith(".log"):
                file_path = os.path.join(root, file)
                log_data = process_log_file(file_path)
                save_processed_log_file(processed_folder_path, file_path, log_data)
                processed_files += 1
                print(f"\rProcessing files: {processed_files}/{total_files} [{int((processed_files / total_files) * 100)}%]", end='', flush=True)

    # Create the master summary CSV
    create_master_csv(processed_folder_path)

    print("\nProcessing completed. All log files have been processed.")
