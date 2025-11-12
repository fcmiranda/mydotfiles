#!/bin/bash

set -euo pipefail

# Handles a new floating window event and re-centers the window when it spawns off-screen.
handle_open_window() {
    echo "Floating window event: $1"
    # The Hyprland event arrives in the format: WINDOWADDRESS,WORKSPACE,CLASS,TITLE.
    # We only need the WINDOWADDRESS to query detailed information.
    local window_address="0x$(echo "$1" | cut -d',' -f1)"
    
    # Give Hyprland a brief moment to populate the client metadata.
    sleep 0.1

    # Collect window and monitor information as JSON documents.
    local window_info=$(hyprctl clients -j | jq --arg addr "$window_address" '.[] | select(.address == $addr)')
    local monitors_json=$(hyprctl monitors -j)

    if [[ -z "$window_info" ]]; then
        echo "Unable to inspect window $window_address; skipping." >&2
        return
    fi

    # Ignore tiled windows.
    if [[ $(echo "$window_info" | jq '.floating') != "true" ]]; then
        return
    fi

    # Extract the window geometry and monitor id in a single jq invocation for efficiency.
    local win_x win_y win_w win_h win_monitor_id
    read -r win_x win_y win_w win_h win_monitor_id < <(
        echo "$window_info" |
        jq -r '[.at[0], .at[1], .size[0], .size[1], .monitor] | @tsv'
    )

    local monitor_info=$(echo "$monitors_json" | jq --argjson id "$win_monitor_id" '.[] | select(.id == $id)')
    if [[ -z "$monitor_info" ]]; then
        echo "Monitor $win_monitor_id not found for window $window_address." >&2
        return
    fi

    local mon_x mon_y mon_w mon_h
    read -r mon_x mon_y mon_w mon_h < <(
        echo "$monitor_info" |
        jq -r '[.x, .y, .width, .height] | @tsv'
    )

    # Compute window center and edges for bounds checking.
    local win_center_x=$((win_x + win_w / 2))
    local win_center_y=$((win_y + win_h / 2))

    local win_right=$((win_x + win_w))
    local win_bottom=$((win_y + win_h))
    local mon_right=$((mon_x + mon_w))
    local mon_bottom=$((mon_y + mon_h))

    if (( win_x < mon_x || win_right > mon_right || win_y < mon_y || win_bottom > mon_bottom ||
          win_center_x < mon_x || win_center_x > mon_right || win_center_y < mon_y || win_center_y > mon_bottom )); then
        # Center the window within the monitor bounds.
        local new_x=$((mon_x + (mon_w - win_w) / 2))
        local new_y=$((mon_y + (mon_h - win_h) / 2))
        echo "Recentering window $window_address to ($new_x,$new_y)."
        hyprctl dispatch movewindowpixel exact "$new_x" "$new_y",address:"$window_address"
    fi
}

# Ensure the script is running inside an active Hyprland session.
if [[ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
    echo "HYPRLAND_INSTANCE_SIGNATURE is not set. Run this script inside a Hyprland session." >&2
    exit 1
fi

# Locate the Hyprland event socket, waiting briefly for the compositor to expose it.
detect_event_socket() {
    local base_path
    local candidate
    for base_path in "${XDG_RUNTIME_DIR:-/tmp}/hypr" "/tmp/hypr"; do
        candidate="$base_path/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
        if [[ -S "$candidate" ]]; then
            echo "$candidate"
            return 0
        fi
    done
    return 1
}

socket_path=""
for _ in {1..50}; do
    if socket_path=$(detect_event_socket); then
        break
    fi
    sleep 0.1
done

if [[ -z "$socket_path" ]]; then
    echo "Unable to locate the Hyprland event socket (.socket2.sock). Ensure the compositor is running." >&2
    exit 1
fi

# Stream events from the Hyprland socket and react to openwindow notifications.
echo "Listening for Hyprland window events..."
socat -U - "UNIX-CONNECT:$socket_path" | while read -r event; do
    
    # Only handle events that originate from new windows.
    if [[ $event == "openwindow>>"* ]]; then
        handle_open_window "${event#*>>}"
    fi
done