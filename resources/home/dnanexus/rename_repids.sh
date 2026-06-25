#!/bin/bash

# Check for the required arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input_file> <rename_file> <output_file>"
    exit 1
fi

input_file="$1"       # The file to process
rename_file="$2"      # The file containing REPID mappings (rename.txt)
output_file="$3"      # The modified output file

# Create an associative array to hold the REPID mapping
declare -A repid_map

# Read the rename_file and fill the associative array
while IFS=$'\t' read -r old_repid new_repid; do
    repid_map["$old_repid"]="$new_repid"
done < "$rename_file"

# Temporary file to hold the modified contents
temp_file=$(mktemp)  # Creates a temporary file in the system's temp directory

# Read input_file and replace REPID values
while IFS=$'\t' read -r repid ref alt gt; do
    # Replace the REPID with the new value from the mapping if it exists
    if [[ ${repid_map[$repid]} ]]; then
        repid=${repid_map[$repid]}
    fi
    # Write the possibly modified line to the temp file
    echo -e "$repid\t$ref\t$alt\t$gt" >> "$temp_file"
done < "$input_file"

# Replace the original output file with the modified contents
mv "$temp_file" "$output_file"

echo "REPID values have been replaced where applicable in $output_file."
