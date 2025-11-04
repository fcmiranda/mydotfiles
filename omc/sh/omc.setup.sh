#!/bin/zsh

# ==============================================================================
# SCRIPT TO CONFIGURE A PRE-CLONED BARE DOTFILES REPOSITORY
#
# This script should be run *after* you have manually cloned your bare
# repository into the location specified by DOTFILES_DIR.
#
# It will:
# 1. Ensure the bare repository is present (cloning it if necessary).
# 2. Attempt to checkout your dotfiles into your home directory.
# 3. Set up the 'omc' alias permanently in your shell configuration.
# 4. Configure local Git settings for the bare repository.
# ==============================================================================

# -- Configuration Variables --
# The directory where you cloned your bare repository.
DOTFILES_DIR="$HOME/.omc"
# The remote repository containing your dotfiles.
DOTFILES_REPO="https://github.com/fcmiranda/.omc.git"
# Git binary to use for all operations.
GIT_BIN="/usr/bin/git"
# Your shell's configuration file.
SHELL_CONFIG="$HOME/.zshrc"

# -- Pre-flight Check --
# Ensure the bare repository directory actually exists.
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "ℹ️ Bare repository not found at '$DOTFILES_DIR'."
    echo "--- Cloning bare repository from $DOTFILES_REPO ---"
    if $GIT_BIN clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"; then
        echo "✅ Bare repository cloned into '$DOTFILES_DIR'."
    else
        echo "ERROR: Failed to clone bare repository from '$DOTFILES_REPO'."
        exit 1
    fi
fi


# -- Alias Configuration --
# The 'omc' alias simplifies all future commands
echo "--- Step 0: Configuring the 'omc' alias in your ~/.zshrc ---"
ALIAS_CMD="alias omc='$GIT_BIN --git-dir=$DOTFILES_DIR --work-tree=$HOME'"
ALIAS_CODE="alias code.omc='GIT_DIR=$DOTFILES_DIR GIT_WORK_TREE=$HOME code $HOME'"
SHELL_CONFIG="$HOME/.zshrc"

if ! grep -qF "$ALIAS_CMD" "$SHELL_CONFIG"; then
    echo "" >> "$SHELL_CONFIG"
    echo "$ALIAS_CMD" >> "$SHELL_CONFIG"
    echo "✅ Alias 'omc' added to '$SHELL_CONFIG'."
else
    echo "ℹ️ The alias 'omc' already exists in your '$SHELL_CONFIG'."
fi

if ! grep -qF "$ALIAS_CODE" "$SHELL_CONFIG"; then
    echo "" >> "$SHELL_CONFIG"
    echo "$ALIAS_CODE" >> "$SHELL_CONFIG"
    echo "✅ Alias 'code.omc' added to '$SHELL_CONFIG'."
else
    echo "ℹ️ The alias 'code.omc' already exists in your '$SHELL_CONFIG'."
fi
echo

# -- Step 1: Checkout dotfiles --
# Define the git command for dotfiles management
DOTFILES_GIT="$GIT_BIN --git-dir=$DOTFILES_DIR --work-tree=$HOME"

echo "--- Attempting to checkout dotfiles into $HOME ---"
# This command will fail if there are conflicting local files that cannot be overwritten.
# Force the checkout to ensure dotfiles are applied.
if $DOTFILES_GIT checkout --force; then
    echo "✅ Dotfiles checked out successfully."
else
    echo "❌ ERROR: Checkout failed. Please resolve conflicts manually."
    exit 1
fi

# --- Step 2: Configure local repository settings ---
echo "--- Applying local repository configuration ---"
# Don't show all untracked files in `omc status`.
$DOTFILES_GIT config --local status.showUntrackedFiles no
# Set the custom ignore file (assuming its name based on previous examples).
$DOTFILES_GIT config --local core.excludesFile "$HOME/.omcignore"
echo "✅ Local Git configuration has been set."
echo

# --- Step 3: Set up the permanent alias ---
echo "--- Setting up the permanent 'omc' alias ---"
ALIAS_CMD="alias omc='$GIT_BIN --git-dir=$DOTFILES_DIR --work-tree=$HOME'"
# Add the alias to the shell omc file, but only if it's not already there.
if ! grep -qF "$ALIAS_CMD" "$SHELL_CONFIG"; then
    echo "$ALIAS_CMD" >> "$SHELL_CONFIG"
    echo "✅ Alias 'omc' was added to '$SHELL_CONFIG'."
else
    echo "INFO: The 'omc' alias already exists in '$SHELL_CONFIG'."
fi
echo

# --- Final Instructions ---
echo "=========================================================="
echo "🎉 Setup Complete! 🎉"
echo
echo "To activate the 'omc' alias in your current session,"
echo "you must reload your shell configuration by running:"
echo
echo "    source $SHELL_CONFIG"
echo
echo "Any new terminal you open will have the alias available."
echo "=========================================================="
