import os
import json
from typing import Dict, List


def read_json_files(folder_path: str) -> Dict[str, Dict]:
    json_files_content = {}
    for filename in os.listdir(folder_path):
        if filename.endswith(".json"):
            file_path = os.path.join(folder_path, filename)
            with open(file_path, 'r', encoding='utf-8') as file:
                try:
                    json_files_content[filename] = json.load(file)
                except json.JSONDecodeError:
                    print(f"Failed to decode JSON in the file: {filename}")
    return json_files_conten

def compare_json_keys(json_files: Dict[str, Dict]) -> None:
    all_keys = {filename: set(content.keys()) for filename, content in json_files.items()}
    for filename, keys in all_keys.items():
        unique_keys = keys.copy()
        for other_filename, other_keys in all_keys.items():
            if filename != other_filename:
                unique_keys -= other_keys
        if unique_keys:
            print(f"Unique keys for {filename}: {', '.join(unique_keys)}")
        else:
            print(f"{filename} does not contain unique keys")

def main(folder_path: str) -> None:
    json_files = read_json_files(folder_path)
    compare_json_keys(json_files)


if __name__ == "__main__":
    folder_path = input("Path to JSON's folder: ")
    main(folder_path)