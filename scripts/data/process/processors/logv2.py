import os
import csv
import json
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

                # Extract fields using simple splitting logic
                parts = message.split(" ")
                ip_address = parts[0]
                timestamp = parts[3][1:]  # Remove the starting '[' from the timestamp
                request = parts[5][1:]    # Remove the starting '"' from the request
                path = parts[6]
                status_code = parts[8]
                user_agent = " ".join(parts[11:]).strip('"')

                # Simplified processing for module name
                module_name = "none"
                if "/modules/" in path:
                    module_name = path.split("/modules/")[1].split("/")[0]

                # Default values for data not in logs
                response_size_gb = "0.00000"
                device_type = "unknown"
                browser_name = "unknown"

                # Append the data to the log_data list
                log_data.append([
                    ip_address,
                    timestamp.split(":")[0],  # Use date only
                    module_name,
                    status_code,
                    response_size_gb,
                    device_type,
                    browser_name,
                ])
            except Exception as e:
                print(f"Error processing line: {line.strip()}, Error: {e}")

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
                all_log_data.extend(log_data)
                processed_files += 1
                print(f"\rProcessing files: {processed_files}/{total_files} [{int((processed_files / total_files) * 100)}%]", end='', flush=True)

    create_master_csv(processed_folder_path, all_log_data)
    print("\nProcessing completed. All log files have been processed.")
