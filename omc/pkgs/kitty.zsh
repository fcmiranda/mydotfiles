#!/bin/zsh

# Install kitty to provide kitty +kitten tools for Ghostty image rendering
if ! command -v kitty >/dev/null 2>&1; then
    echo "Installing kitty..."

    if command -v yay >/dev/null 2>&1; then
        yay -S kitty
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm kitty
    else
        echo "Neither yay nor pacman found. Please install kitty manually."
        echo "See https://sw.kovidgoyal.net/kitty/binary/#pre-built-packages for options."
        exit 1
    fi

    echo "Kitty installed."
else
    echo "Kitty is already installed."
fi

# Ensure kitty icat kitten is available
if command -v kitty >/dev/null 2>&1; then
    echo "You can now run 'kitty +kitten icat <image>' inside Ghostty to render images."
fi
