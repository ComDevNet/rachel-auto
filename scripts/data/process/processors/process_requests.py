import os
import csv
from io import StringIO
import sys

def process_requests_file(file_path):
    requests_data = []

    with open(file_path, 'r', encoding='utf-8') as requests_file:
        # Read each line and append it to the requests_data list
        for line in requests_file:
            # Remove leading/trailing whitespaces and add to requests_data
            requests_data.append([line.strip()])

    return requests_data

def save_processed_requests_file(selected_folder, file_path, requests_data):
    processed_folder_path = os.path.join("00_DATA", "PROCESSED", selected_folder)

    if not os.path.exists(processed_folder_path):
        os.makedirs(processed_folder_path)

    output_csv = StringIO()
    csv_writer = csv.writer(output_csv)
    csv_writer.writerow(['Requests'])
    csv_writer.writerows(requests_data)

    output_csv.seek(0)

    processed_file_path = os.path.join(processed_folder_path, f"{os.path.splitext(os.path.basename(file_path))[0]}.csv")
    with open(processed_file_path, 'w', encoding='utf-8') as output_file:
        output_file.write(output_csv.getvalue())

if __name__ == '__main__':
    selected_folder = sys.argv[1]
    file_path = os.path.join("00_DATA", selected_folder, "request.txt")

    requests_data = process_requests_file(file_path)
    save_processed_requests_file(selected_folder, file_path, requests_data)

    print("Requests file processed successfully.")
