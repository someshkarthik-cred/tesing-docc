import sys
import json
import os

function = sys.argv[1]

file_path = 'Helper Files/asset_extension_data.json'
absolute_path = os.path.abspath(file_path)

with open(absolute_path, 'r') as f:
    extension_data = json.load(f)

if function == "extension_list":
    extension_list = []
    for item in extension_data["size_limit_table"]:
        extension_str = ','.join(item["supported_extensions"] + item["unsupported_extensions"])
        extension_list.append(extension_str)
    print(",".join(extension_list))
elif function == "size_limit":
    size_limit_table = extension_data["size_limit_table"]
    extension = sys.argv[2]
    for item in size_limit_table:
        supported_extenion=item["supported_extensions"]
        if extension in supported_extenion:
            print(item["limit"])
            sys.exit(0)
    sys.exit(1)
elif function == "supported_extensions":
    size_limit_table = extension_data["size_limit_table"]
    print(",".join(",".join(item["supported_extensions"]) for item in size_limit_table))
    sys.exit(0)
elif function == "supported_extension_table":
    markdown = "File type | Format | Threshold\n--- | --- | ---\n"
    for item in extension_data["size_limit_table"]:
        extensions = ', '.join([f"`{ext}`" for ext in item["supported_extensions"]])
        markdown += f"{item['name']} | {extensions} | {item['limit']}KB\n"
    print(markdown)
else:
    print("🚨 Unknown format. please fix the script for any discrepency 🚨")
    sys.exit(1)
