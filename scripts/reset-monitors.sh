#!/bin/bash
# Script to reset monitors to default configuration in Hyprland
# This script detects connected monitors and configures them appropriately

# Set PATH explicitly for keybinding execution
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

CONFIG_FILE="$HOME/.config/hypr/monitors.conf"

# Function to reset monitor configuration to defaults
reset_to_default_monitors() {
    echo "Detecting connected monitors..." >&2

    # Get currently connected monitors
    connected_monitors=$(/usr/bin/hyprctl monitors 2>/dev/null | grep "Monitor" | awk '{print $2}' | tr '\n' ' ')

    echo "Connected monitors: $connected_monitors" >&2

    # Create new monitor configuration based on connected monitors
    CONFIG_CONTENT="# See https://wiki.hyprland.org/Configuring/Monitors/
# List current monitors and resolutions possible: hyprctl monitors
# Format: monitor = [port], resolution, position, scale

# Optimized for retina-class 2x displays, like 13\" 2.8K, 27\" 5K, 32\" 6K.
env = GDK_SCALE,2"

    # Add monitor configurations for each connected monitor
    position_x=0
    for monitor in $connected_monitors; do
        CONFIG_CONTENT="$CONFIG_CONTENT
monitor=$monitor,preferred,${position_x}x0,auto"
        position_x=$((position_x + 1920))  # Assume 1920 width for positioning
    done

    echo "Writing new monitor configuration..." >&2
    echo "$CONFIG_CONTENT" > "$CONFIG_FILE"

    echo "Reloading Hyprland configuration..." >&2

    # Reload Hyprland to apply the new configuration
    if /usr/bin/hyprctl reload 2>/dev/null; then
        /usr/bin/notify-send "Monitors Reset" "Detected $(echo $connected_monitors | wc -w) monitor(s): $connected_monitors" -u normal -t 3000
        echo "Configuration reloaded successfully" >&2
        return 0
    else
        /usr/bin/notify-send "Error" "Failed to reload Hyprland configuration" -u critical
        echo "Failed to reload configuration" >&2
        return 1
    fi
}

# Main execution
echo "Starting monitor reset..." >&2
if reset_to_default_monitors; then
    echo "Monitor reset completed successfully" >&2
else
    echo "Monitor reset failed" >&2
fi