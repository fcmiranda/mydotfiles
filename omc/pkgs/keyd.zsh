#!/bin/zsh

# Install keyd if not present
if ! command -v keyd >/dev/null 2>&1; then
    echo "Installing keyd..."

    if command -v yay >/dev/null 2>&1; then
        yay -S keyd
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm keyd
    else
        echo "Neither yay nor pacman found. Please install keyd manually."
        exit 1
    fi

    echo "Keyd installed."
else
    echo "Keyd is already installed."
fi

# Setup capslock remapping
if [ -f "$(dirname "$0")/caps-2-esc-ctrl.zsh" ]; then
    zsh "$(dirname "$0")/caps-2-esc-ctrl.zsh"
else
    echo "caps-2-esc-ctrl.zsh not found, skipping keyd setup"
fi

echo "Keyd is ready. Configure it in /etc/keyd/default.conf"