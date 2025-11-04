#!/bin/zsh

# Install kanshi if not present
if ! command -v kanshi >/dev/null 2>&1; then
    echo "Installing kanshi..."

    if command -v yay >/dev/null 2>&1; then
        yay -S kanshi
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm kanshi
    else
        echo "Neither yay nor pacman found. Please install kanshi manually."
        exit 1
    fi

    echo "Kanshi installed."
else
    echo "Kanshi is already installed."
fi

echo "Kanshi is ready. Configure it in ~/.config/kanshi/config"