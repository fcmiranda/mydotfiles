#!/bin/zsh

# Install zsh plugins: zsh-autosuggestions, zsh-syntax-highlighting, and zsh-transient-prompt

PLUGINS_DIR="${HOME}/.zsh-plugins"
mkdir -p "$PLUGINS_DIR"

# Install zsh-autosuggestions
if [ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
    echo "zsh-autosuggestions installed."
else
    echo "zsh-autosuggestions is already installed."
fi

# Install zsh-syntax-highlighting
if [ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGINS_DIR/zsh-syntax-highlighting"
    echo "zsh-syntax-highlighting installed."
else
    echo "zsh-syntax-highlighting is already installed."
fi

# Install zsh-transient-prompt
if [ ! -d "$PLUGINS_DIR/zsh-transient-prompt" ]; then
    echo "Installing zsh-transient-prompt..."
    git clone https://github.com/olets/zsh-transient-prompt.git "$PLUGINS_DIR/zsh-transient-prompt"
    echo "zsh-transient-prompt installed."
else
    echo "zsh-transient-prompt is already installed."
fi