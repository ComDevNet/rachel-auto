import os
import csv
from urllib.parse import unquote
from user_agents import parse
from io import StringIO
from datetime import datetime
import re
import sys

def process_log_file(file_path):
    log_data = []  

    with open(file_path, 'r', encoding='utf-8') as log_file:
        lines = log_file.read().splitlines()
        for line in lines:
            match = re.match(r'^(.*?) - - \[(.*?)\] "(.*?)" (\d+) (\d+) "(.*?)" "(.*?)"$', line)
            if match:
                ip_address, timestamp, request, status_code, response_size_bytes, _, user_agent_string = match.groups()

                # Check if the status code is 200
                if status_code == '200':
                    timestamp = datetime.strptime(timestamp, "%d/%b/%Y:%H:%M:%S %z")

                    access_date = timestamp.strftime("%Y-%m-%d")
                    access_time = timestamp.strftime("%H:%M:%S")

                    path_to_modules = re.sub(r'^GET (.*) HTTP/1.1$', r'\1', request)
                    decoded_path = unquote(path_to_modules)
                    cleaned_path = decoded_path.replace('%', '')

                    module_name_match = re.search(r'/modules/([^/]+)/', cleaned_path)
                    if module_name_match:
                        module_name = module_name_match.group(1)
                    else:
                        module_name = 'none'

                    # Extract the location from the path and remove ".html" extension
                    location_match = re.search(r'/modules/[^/]+/([^/]+)\.html', cleaned_path)
                    location_viewed = location_match.group(1) if location_match else 'none'

                    # Replace "index" with "Home Page"
                    location_viewed = 'Home Page' if location_viewed.lower() == 'index' else location_viewed

                    user_agent = parse(user_agent_string)

                    os_family = user_agent.os.family.lower() if user_agent.os.family else 'unknown'

                    browser_name = user_agent.browser.family if user_agent.browser.family else 'unknown'

                    response_size_gb = format(int(response_size_bytes) / 1073741824, ".5f")

                    log_data.append([ip_address, access_date, access_time, module_name, location_viewed, status_code, response_size_gb, os_family, browser_name])

    return log_data

def save_processed_log_file(selected_folder, file_path, log_data):
    processed_folder_path = os.path.join("00_DATA", "00_PROCESSED", selected_folder)
    
    if not os.path.exists(processed_folder_path):
        os.makedirs(processed_folder_path)

    output_csv = StringIO()
    csv_writer = csv.writer(output_csv)
    csv_writer.writerow(['IP Address', 'Access Date', 'Access Time', 'Module Viewed', 'Location Viewed', 'Status Code', 'Data Size (GB)', 'Device Used', 'Browser Used'])
    csv_writer.writerows(log_data)

    output_csv.seek(0)
    
    processed_file_path = os.path.join(processed_folder_path, f"{os.path.splitext(os.path.basename(file_path))[0]}.csv")
    with open(processed_file_path, 'w', encoding='utf-8') as output_file:
        output_file.write(output_csv.getvalue())

def create_master_csv(selected_folder, all_log_data):
    master_csv_path = os.path.join("00_DATA", "00_PROCESSED", selected_folder, "summary.csv")

    with open(master_csv_path, 'w', encoding='utf-8') as master_csv:
        csv_writer = csv.writer(master_csv)
        csv_writer.writerow(['IP Address', 'Access Date', 'Access Time', 'Module Viewed', 'Location Viewed', 'Status Code', 'Data Size (GB)', 'Device Used', 'Browser Used'])
        
        for log_data in all_log_data:
            csv_writer.writerows(log_data)

if __name__ == '__main__':
    selected_folder = sys.argv[1]
    folder_path = os.path.join("00_DATA", selected_folder)

    total_files = sum([len(files) for _, _, files in os.walk(folder_path)])
    all_log_data = []

    progress = 0
    for i, (root, dirs, files) in enumerate(os.walk(folder_path)):
        for file in files:
            if file.endswith(".log"):
                file_path = os.path.join(root, file)
                log_data = process_log_file(file_path)

                save_processed_log_file(selected_folder, file_path, log_data)
                all_log_data.append(log_data)

                progress += 1
                percentage = (progress / total_files) * 100
                print(f"\rProcessing files: [{int(percentage)}%] [{'#' * int(percentage / 2)}]", end='', flush=True)

    create_master_csv(selected_folder, all_log_data)

    print("\nLog files processed successfully.")
