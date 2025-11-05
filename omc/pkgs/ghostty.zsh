#!/bin/zsh

# Install ghostty if not present
if ! command -v ghostty >/dev/null 2>&1; then
    echo "Installing ghostty..."

    if command -v yay >/dev/null 2>&1; then
        yay -S ghostty
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm ghostty
    else
        echo "Neither yay nor pacman found. Please install ghostty manually."
        echo "See https://ghostty.org/docs/install/binary#linux-(official) for options."
        exit 1
    fi

    echo "Ghostty installed."
else
    echo "Ghostty is already installed."
fi

echo "Ghostty is ready."