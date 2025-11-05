#!/bin/zsh

# Script to install packages: kanshi, atuin, and ghostty

set -e

echo "Installing packages..."

# Install kanshi
if [ -f "$(dirname "$0")/kanshi.zsh" ]; then
    zsh "$(dirname "$0")/kanshi.zsh"
else
    echo "kanshi.zsh not found, skipping kanshi installation"
fi

# Install atuin
if [ -f "$(dirname "$0")/atuin.zsh" ]; then
    zsh "$(dirname "$0")/atuin.zsh"
else
    echo "atuin.zsh not found, skipping atuin installation"
fi

# Install ghostty
if [ -f "$(dirname "$0")/ghostty.zsh" ]; then
    zsh "$(dirname "$0")/ghostty.zsh"
else
    echo "ghostty.zsh not found, skipping ghostty installation"
fi

echo "Packages installed."