# Kanshi Setup Guide

Kanshi is a dynamic output configuration tool for Wayland compositors that automatically applies monitor configurations based on the connected displays.

## What is Kanshi?

Kanshi monitors your display setup and automatically applies the appropriate configuration when monitors are connected or disconnected. It's particularly useful for laptops that frequently connect to external displays.

## Installation

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install kanshi
```

### Arch Linux
```bash
sudo pacman -S kanshi
```

### Fedora
```bash
sudo dnf install kanshi
```

## Configuration

Kanshi reads its configuration from `~/.config/kanshi/config`. The configuration file has already been created with some example profiles.

### Configuration File Structure

The configuration file uses profiles that define monitor setups:

```
profile "profile-name" {
    output "OUTPUT-NAME" mode WIDTHxHEIGHT@REFRESH position X,Y scale SCALE
    output "OUTPUT-NAME-2" mode WIDTHxHEIGHT@REFRESH position X,Y scale SCALE
}
```

### Getting Monitor Information

To see your available monitors and their capabilities:

```bash
# List connected monitors
hyprctl monitors

# Get detailed monitor information including supported modes
hyprctl monitors all
```

### Example Configurations

The provided configuration includes several profiles:

1. **hdmi-external**: External HDMI monitor only
2. **internal-only**: Laptop display only
3. **dual-hdmi-primary**: Dual monitor with HDMI as primary
4. **dual-internal-primary**: Dual monitor with laptop display as primary
5. **retina-hdmi**: High-DPI external display

## Customizing Your Setup

### Step 1: Identify Your Monitors

1. Connect your monitor(s)
2. Run `hyprctl monitors` to see monitor names and current configuration
3. Note the output names (e.g., "HDMI-A-1", "eDP-1", "DP-1")

### Step 2: Edit the Configuration

Edit `~/.config/kanshi/config` to match your setup:

```bash
# Example for a specific monitor setup
profile "office-setup" {
    output "HDMI-A-1" mode 2560x1440@60Hz position 0,0 scale 1.0
    output "eDP-1" mode 1920x1080@60Hz position 2560,0 scale 1.0
}

profile "mobile" {
    output "eDP-1" mode 1920x1080@60Hz position 0,0 scale 1.0
}
```

### Step 3: Test Your Configuration

```bash
# Kill any running kanshi instance
pkill kanshi

# Start kanshi in foreground to see any errors
kanshi

# Or start in background
kanshi &
```

## Integration with Hyprland

Kanshi is automatically started with Hyprland through the `autostart.conf` file:

```bash
exec-once = kanshi
```

## Troubleshooting

### Check if Kanshi is Running
```bash
pgrep kanshi
```

### View Kanshi Logs
```bash
# If using systemd user service
journalctl --user -u kanshi -f

# Or check general logs
journalctl -f | grep kanshi
```

### Common Issues

1. **Monitor not detected**: Check `hyprctl monitors` to verify the monitor name
2. **Configuration not applied**: Ensure monitor names match exactly
3. **Kanshi not starting**: Check for syntax errors in the config file

### Manual Configuration Reset

If you need to manually reset monitors (for testing):

```bash
# Disable all outputs except primary
hyprctl keyword monitor "HDMI-A-1,disable"

# Re-enable with specific configuration
hyprctl keyword monitor "HDMI-A-1,1920x1080@60,0x0,1"
```

## Advanced Features

### Conditional Profiles

Kanshi automatically selects the best matching profile based on connected displays. You can create multiple profiles and kanshi will choose the most appropriate one.

### Hot-plugging

Kanshi automatically detects when monitors are connected or disconnected and applies the appropriate profile without manual intervention.

### Multiple Configurations

You can create different profiles for different environments (home, office, presentation, etc.) and kanshi will automatically switch between them.

## References

- [Kanshi GitHub Repository](https://github.com/emersion/kanshi)
- [Hyprland Monitor Configuration](https://wiki.hyprland.org/Configuring/Monitors/)
- [Wayland Output Management](https://wayland.freedesktop.org/docs/html/apa.html#protocol-spec-wlr-output-management)