#!/bin/bash

# Function to display the banner in red
function display_banner() {
    echo -e "\033[31m"
    echo "==============================="
    echo "       HEXA VIRUS INJECT       "
    echo "==============================="
    echo "WARNING: This script will delete specified file types from your device."
    echo "Use with caution and ensure you have backups."
    echo -e "\033[0m"
}

# Function to check if the script is running with the necessary permissions
function check_permissions() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "This script requires root privileges. Please run as root."
        exit 1
    fi
}

# Function to log messages to a log file
function log_message() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$log_file"
}

# Function to delete specified file types
function delete_files() {
    local file_type="$1"
    local target_dir="$2"
    
    echo "Searching for and deleting *.$file_type files in $target_dir..."
    find "$target_dir" -type f -name "*.$file_type" -exec rm -f {} \; 
    log_message "Deleted all *.$file_type files from $target_dir."
    echo "Deletion of *.$file_type files completed."
}

# Detect platform (Linux or Termux)
if [[ -d /data/data/com.termux ]]; then
    platform="termux"
else
    platform="linux"
fi

# Set the log file path
log_file="$HOME/file_cleaner_log.txt"

# Display the banner
display_banner

# Check for necessary permissions
check_permissions

# Automatically detect the script's path
script_path="$(realpath "$0")"

# Specify the target directory (change as needed)
target_directory="/path/to/your/directory"  # Change to the desired directory

# Specify the file types you want to delete (e.g., txt, log, tmp)
file_types=("log" "tmp" "bak")  # Add more extensions as needed

# Delete specified file types
for file_type in "${file_types[@]}"; do
    delete_files "$file_type" "$target_directory"
done

echo "Script execution completed. Check $log_file for details."

# End of script
