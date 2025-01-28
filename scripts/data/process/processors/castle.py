import os
import csv
import json
import re
from urllib.parse import unquote
from user_agents import parse
from io import StringIO
from datetime import datetime
import sys

def process_log_file(file_path):
    """
    Process a log file of JSON lines, each with a "message"
    that looks like an Apache-like access log.

    Key points:
      - Strip off ::ffff: if present in IP.
      - /modules/<folder>/ => module name = <folder>, location from final file name.
      - /interactive-map/<digits>-<anything> => module name = "interactive-map", location viewed is that segment.
        If it doesn't match the digits-dash pattern, location remains "none".
      - If location is "card", change it to "none".
    """
    log_data = []

    with open(file_path, 'r', encoding='utf-8') as log_file:
        for line in log_file:
            line = line.strip()
            if not line:
                continue

            # 1) Attempt to parse JSON
            try:
                log_entry = json.loads(line)
                message = log_entry.get("message", "")
            except json.JSONDecodeError:
                continue  # skip lines not valid JSON

            # 2) Regex for combined-like log in the message
            # e.g. ::ffff:192.168.4.230 - [2025-01-28T12:35:52.164Z] "GET /interactive-map/19-door-of-no-return HTTP/1.1" 200 - "ref" "UA"
            pattern = (
                r'^(\S+)\s-'            # IP
                r'\s\[(.*?)\]\s'        # [timestamp]
                r'"(.+?)"\s'            # "GET /path HTTP/1.1"
                r'(\d+)\s'              # status code
                r'(\S+)\s'              # size (or '-')
                r'"(.*?)"\s'            # referrer
                r'"(.*?)"$'             # user agent
            )
            match = re.match(pattern, message)
            if not match:
                continue

            ip_address, timestamp_str, request, status_code, response_size_bytes, _, user_agent_string = match.groups()

            # 3) Strip off "::ffff:" prefix if present (IPv4-mapped IPv6)
            if ip_address.startswith("::ffff:"):
                ip_address = ip_address[7:]

            # 4) Parse ISO-8601 timestamp (e.g. 2025-01-28T12:35:52.164Z)
            try:
                timestamp = datetime.strptime(timestamp_str, "%Y-%m-%dT%H:%M:%S.%fZ")
            except ValueError:
                continue

            access_date = timestamp.strftime("%Y-%m-%d")
            access_time = timestamp.strftime("%H:%M:%S")

            # 5) Extract the path from the request, e.g. GET /path HTTP/1.1
            path_match = re.match(r'^[A-Z]+\s+(.*?)\s+HTTP/\d\.\d$', request)
            path = path_match.group(1) if path_match else request

            # 6) URL-decode the path
            cleaned_path = unquote(path)

            # Default fields
            module_name = 'none'
            location_viewed = 'none'

            # 7) Check for /modules/<folder>/...
            modules_match = re.search(r'/modules/([^/]+)/', cleaned_path)
            if modules_match:
                module_name = modules_match.group(1)
                # Extract the final file part, e.g. card.webp → card
                location_match = re.search(r'/modules/[^/]+/([^/]+)\.\w+$', cleaned_path)
                if location_match:
                    location_viewed = location_match.group(1)
                    # "index" → "Home Page"
                    if location_viewed.lower() == 'index':
                        location_viewed = 'Home Page'

            else:
                # 8) Check for /interactive-map/<digits>-<anything>
                #    e.g. /interactive-map/19-door-of-no-return
                #    If not matching digits-dash, location remains "none".
                interactive_match = re.search(r'/interactive-map/(\d+-[^/]+)', cleaned_path)
                if interactive_match:
                    module_name = 'interactive-map'
                    location_viewed = interactive_match.group(1)

            # 9) If location is 'card', show none
            if location_viewed.lower() == 'card':
                location_viewed = 'none'

            # 10) Parse user agent
            user_agent = parse(user_agent_string)
            os_family = user_agent.os.family.lower() if user_agent.os.family else 'unknown'
            browser_name = user_agent.browser.family if user_agent.browser.family else 'unknown'

            # 11) Convert response size to GB
            if response_size_bytes.isdigit():
                response_size = int(response_size_bytes)
            else:
                response_size = 0
            response_size_gb = format(response_size / 1073741824, ".5f")

            # 12) Append row
            log_data.append([
                ip_address,
                access_date,
                access_time,
                module_name,
                location_viewed,
                status_code,
                response_size_gb,
                os_family,
                browser_name
            ])

    return log_data


def save_processed_log_file(selected_folder, file_path, log_data):
    """
    Saves processed data to a CSV named after the log file, inside
    00_DATA/00_PROCESSED/<selected_folder>.
    """
    processed_folder = os.path.join("00_DATA", "00_PROCESSED", selected_folder)
    os.makedirs(processed_folder, exist_ok=True)

    output_csv = StringIO()
    writer = csv.writer(output_csv)
    writer.writerow([
        'IP Address',
        'Access Date',
        'Access Time',
        'Module Viewed',
        'Location Viewed',
        'Status Code',
        'Data Saved (GB)',
        'Device Used',
        'Browser Used'
    ])
    writer.writerows(log_data)

    output_csv.seek(0)
    output_filename = f"{os.path.splitext(os.path.basename(file_path))[0]}.csv"
    output_path = os.path.join(processed_folder, output_filename)

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(output_csv.getvalue())


def create_master_csv(selected_folder, all_log_data):
    """
    Combines all processed log data into a single master CSV (summary.csv).
    """
    master_path = os.path.join("00_DATA", "00_PROCESSED", selected_folder, "summary.csv")

    with open(master_path, 'w', encoding='utf-8', newline='') as master_csv:
        writer = csv.writer(master_csv)
        writer.writerow([
            'IP Address',
            'Access Date',
            'Access Time',
            'Module Viewed',
            'Location Viewed',
            'Status Code',
            'Data Saved (GB)',
            'Device Used',
            'Browser Used'
        ])
        for data_chunk in all_log_data:
            writer.writerows(data_chunk)


if __name__ == '__main__':
    selected_folder = sys.argv[1]
    source_folder = os.path.join("00_DATA", selected_folder)
    
    if not os.path.exists(source_folder):
        print(f"Error: Source folder {source_folder} not found")
        sys.exit(1)

    all_log_data = []
    total_files = sum(len(files) for _, _, files in os.walk(source_folder))
    processed_files = 0

    for root, _, files in os.walk(source_folder):
        for file in files:
            # Adjust the extension if your logs are not .log
            if file.endswith(".log"):
                file_path = os.path.join(root, file)
                log_data = process_log_file(file_path)
                save_processed_log_file(selected_folder, file_path, log_data)
                all_log_data.append(log_data)

                processed_files += 1
                progress = int((processed_files / total_files) * 100)
                print(
                    f"\rProcessing: {progress}% "
                    f"[{'#' * (progress // 2)}{' ' * (50 - progress // 2)}]",
                    end=''
                )

    # Create a combined master summary
    create_master_csv(selected_folder, all_log_data)
    print("\nProcessing completed. Master summary created.")
