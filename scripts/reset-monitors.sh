#!/bin/bash
# Script to reset monitors to default configuration in Hyprland
# This script reads the monitors.conf file and applies the default settings

CONFIG_FILE="$HOME/.config/hypr/monitors.conf"

# Function to apply monitor configuration
apply_default_monitors() {
    # Read the active monitor configuration from monitors.conf
    # Skip comments and empty lines
    while IFS= read -r line; do
        # Skip empty lines and comments
        if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
            continue
        fi
        
        # Check if line starts with 'monitor='
        if [[ "$line" =~ ^[[:space:]]*monitor[[:space:]]*= ]]; then
            # Extract the monitor configuration
            config="${line#*=}"
            config=$(echo "$config" | xargs)  # Trim whitespace
            
            # Apply the monitor configuration using hyprctl
            hyprctl keyword monitor "$config"
        fi
    done < "$CONFIG_FILE"
    
    notify-send "Monitors Reset" "Monitor configuration has been reset to defaults" -u normal -t 3000
}

# Main execution
if [[ ! -f "$CONFIG_FILE" ]]; then
    notify-send "Error" "Monitor configuration file not found: $CONFIG_FILE" -u critical
    exit 1
fi

apply_default_monitors
