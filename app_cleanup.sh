#!/bin/bash

# Set the directories where apps are installed
APP_DIRS=(
    "/volume1/@appstore"
    "/volume1/@appshare"
    "/volume1/@appconf"
    "/volume1/@appdata"
    "/volume1/@apptemp"
    "/volume1/@apphome"
)

# Log file for actions taken
LOG_FILE="/var/log/cleanup_uninstalled_apps.log"

# Function to remove directories of uninstalled apps
remove_uninstalled_app_dirs() {
    echo "$(date): Starting cleanup of uninstalled apps..." >> "$LOG_FILE"
    for app_dir in "${APP_DIRS[@]}"; do
        for dir in "$app_dir"/*; do
            # Check if the directory is valid
            if [ -d "$dir" ]; then
                app_name=$(basename "$dir")
                # Check if the app is uninstalled
                if ! synopkg status "$app_name" > /dev/null 2>&1; then
                    echo "$(date): Removing directory for uninstalled app: $dir" >> "$LOG_FILE"
                    rm -rf "$dir"
                else
                    echo "$(date): App $app_name is still installed, skipping..." >> "$LOG_FILE"
                fi
            fi
        done
    done
    echo "$(date): Cleanup completed." >> "$LOG_FILE"
}

# Execute the function
remove_uninstalled_app_dirs
