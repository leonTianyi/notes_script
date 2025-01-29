#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Usage: $0 <root_folder> <amendment_folder> [parent_folder]"
    echo "  - If parent_folder is provided, amendment_folder will be created under each parent_folder."
    echo "  - If parent_folder is not provided, amendment_folder will be created directly under root_folder."
    exit 1
fi

# Assign arguments to variables
root_folder="$1"
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

# If parent_folder is provided, process all parent_folders under root_folder
if [ -n "$parent_folder" ]; then
    echo "Creating amendment folders under each '$parent_folder'..."
    find "$root_folder" -type d -name "$parent_folder" | while read -r parent_path; do
        process_folder "$parent_path"
    done
else
    echo "Creating amendment folders directly under '$root_folder'..."
    # Process each top-level directory under root_folder
    find "$root_folder" -maxdepth 1 -mindepth 1 -type d | while read -r top_level_path; do
        process_folder "$top_level_path"
    done
fi

echo "Amendment folders created and other script executed successfully!"
