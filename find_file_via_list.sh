#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Usage: $0 <folder_list.txt> <amendment_folder> [parent_folder]"
    echo "  - If parent_folder is provided, amendment_folder will be created under each parent_folder."
    echo "  - If parent_folder is not provided, amendment_folder will be created directly under each folder in the list."
    exit 1
fi

# Assign arguments to variables
folder_list_file="$1"
amendment_folder="$2"
parent_folder="${3:-}"  # Optional: parent_folder (defaults to empty if not provided)

# Function to create amendment_folder and run the other script
process_folder() {
    local target_path="$1"
    # Create the amendment_folder inside the target_path
    mkdir -p "$target_path/$amendment_folder"
    # Run another script using the target_path as an argument
    /path/to/your/other_script.sh "$target_path"
}

# Read the folder list from the file
if [ ! -f "$folder_list_file" ]; then
    echo "Error: Folder list file '$folder_list_file' not found."
    exit 1
fi

# Process each folder in the list
while IFS= read -r folder_path; do
    # Skip empty lines
    if [ -z "$folder_path" ]; then
        continue
    fi

    # If parent_folder is provided, process all parent_folders under the current folder
    if [ -n "$parent_folder" ]; then
        echo "Creating amendment folders under '$parent_folder' in '$folder_path'..."
        find "$folder_path" -type d -name "$parent_folder" | while read -r parent_path; do
            process_folder "$parent_path"
        done
    else
        echo "Creating amendment folders directly under '$folder_path'..."
        process_folder "$folder_path"
    fi
done < "$folder_list_file"

echo "Amendment folders created and other script executed successfully!"
