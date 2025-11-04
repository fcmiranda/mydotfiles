#!/bin/zsh

# Install atuin if not present
if ! command -v atuin >/dev/null 2>&1; then
    echo "Installing atuin..."
    if command -v yay >/dev/null 2>&1; then
        yay -S atuin
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm atuin
    else
        echo "Neither yay nor pacman found. Falling back to official installer."
        curl --proto '=https' --tlsv1.2 -sSf https://install.atuin.sh | sh
    fi
    echo "Atuin installed."
    if command -v atuin >/dev/null 2>&1; then
        echo "Logging into Atuin..."
        atuin login
    else
        echo "Atuin command not found after installation; skipping login."
    fi
else
    echo "Atuin is already installed."
fi