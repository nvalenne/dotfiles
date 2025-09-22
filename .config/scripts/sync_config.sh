
#!/bin/bash

# Bash script to synchronising a config folder from a Git repo to ~/.config/
# Usage : ./sync_config.sh /path/to/the/repo/folder_name_config
#
# Author : Nathan
# Date : $(date +%Y-%m-%d)

if [ "$#" -ne 1 ]; then
    echo "Usage : $0 /path/to/the/repo/folder_name_config"
    exit 1
fi

SOURCE_DIR="$1"
TARGET_DIR="$HOME/.config/$(basename "$SOURCE_DIR")"

# Check if source dir exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error : The source folder '$SOURCE_DIR' not exists"
    exit 1
fi

# Create the dir if doesn't exists
mkdir -p "$TARGET_DIR"

# Fonction to create recursively symbolics links
sync_config() {
    local source="$1"
    local target="$2"

    # Loop each file/dir in the source dir
    for item in "$source"/*; do
        local item_name=$(basename "$item")
        local new_source="$source/$item_name"
        local new_target="$target/$item_name"

        if [ -d "$new_source" ]; then
            # If directory, create the source dir and recurse
            mkdir -p "$new_target"
            sync_config "$new_source" "$new_target"
        elif [ -f "$new_source" ]; then
            # If file, create symbolic link
            ln -sf "$new_source" "$new_target"
            echo "Link created : $new_target → $new_source"
        fi
    done
}

# Exec synchronisation
echo "Synchronisation from $SOURCE_DIR to $TARGET_DIR..."
sync_config "$SOURCE_DIR" "$TARGET_DIR"
echo "Synchronisation done !"

