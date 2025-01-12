#!/bin/bash
# Directories containing the scripts
DIRECTORIES=("Initialize" "Functions" "Core")
CSV_FILE="/mnt/hgfs/Batlinux/Packages/pkg.csv"
OUTPUT_FILE="Batlinux.sh"

function update_packages() {
    local CSV_FILE="/mnt/hgfs/Batlinux/Packages/pkg.csv"
    local TARGET_FILE="Batlinux.sh"

    # Check if CSV file exists
    if [[ ! -f "$CSV_FILE" ]]; then
        echo -e "\e[31mError: File not found $CSV_FILE\e[0m"
        return 1
    fi

    # Check if target script exists
    if [[ ! -f "$TARGET_FILE" ]]; then
        echo -e "\e[31mError: File not found $TARGET_FILE\e[0m"
        return 1
    fi

    # Prepare array
    local options="Packages=("

    # Read data from CSV and convert to required format
    while IFS=',' read -r name pkg description; do
        # Skip header row
        if [[ "$name" == "Name" ]]; then
            continue
        fi

        # Remove extra spaces around text (if any)
        name=$(echo "$name" | xargs)
        pkg=$(echo "$pkg" | xargs)
        description=$(echo "$description" | xargs)

        # Check if columns contain data before adding
        if [[ -n "$name" && -n "$pkg" && -n "$description" ]]; then
            # Add data to array in required format
            options="$options\n    \"$name:$pkg:$description\""
        fi
    done < "$CSV_FILE"

    # Close array
    options="$options\n)"

    # Replace # PACK with array
    sed -i "s/# Packages/$options/" "$TARGET_FILE"

    # Inform user of successful update
    echo -e "\e[32mSuccessfully updated packages in: $TARGET_FILE\e[0m"
    return 0
}

if [ -f "Batlinux.sh" ]; then
    rm Batlinux.sh
fi

echo "#!/bin/bash" >> "$OUTPUT_FILE"

# Loop through each directory and group files under one region
for DIR in "${DIRECTORIES[@]}"; do
    if [[ -d "$DIR" ]]; then
        echo "#region $DIR" >> "$OUTPUT_FILE"  # Add #region with directory name
        for FILE in "$DIR"/*; do
            if [[ -f "$FILE" ]]; then
                # Append the content of each script file directly to the output
                cat "$FILE" >> "$OUTPUT_FILE"
                echo "" >> "$OUTPUT_FILE"  # Add a newline after each file content
            fi
        done
        echo "#endregion $DIR" >> "$OUTPUT_FILE"  # Add #endregion with directory name
    else
        echo "Warning: Directory '$DIR' not found. Skipping."
    fi
done

# update packages
update_packages

# Convert Windows line endings to Unix
dos2unix "$OUTPUT_FILE" 2>/dev/null || true

./Batlinux.sh
echo "Build complete! Output written to '$OUTPUT_FILE'."