#!/bin/bash

# ==============================================================================
# Script to initialize a Git Bare repository for dotfiles management
# ==============================================================================

# -- Configuration Variables --
# Defines the location of the bare repository and the ignore file name
DOTFILES_DIR="$HOME/.omc"
IGNORE_FILE="$HOME/.omc-ignore"

# -- Initial Verification --
# Ensures the script doesn't overwrite an existing configuration
if [ -d "$DOTFILES_DIR" ]; then
    echo "ℹ️ The directory '$DOTFILES_DIR' already exists."
    echo "Skipping repository initialization..."
else
    echo "--- Step 1: Initializing the Git Bare repository in '$DOTFILES_DIR' ---"
    git init --bare "$DOTFILES_DIR"
    echo "✅ Bare repository created successfully."
fi
echo

# -- Alias Configuration --
# The 'config' alias simplifies all future commands
echo "--- Step 2: Configuring the 'config' alias in your ~/.bashrc ---"
ALIAS_CMD="alias config='/usr/bin/git --git-dir=$DOTFILES_DIR --work-tree=$HOME'"
ALIAS_CODE="alias codeomc='GIT_DIR=\$HOME/.omc GIT_WORK_TREE=\$HOME code \$HOME'"
SHELL_CONFIG="$HOME/.bashrc" # Change to ~/.zshrc if you use Zsh

if ! grep -qF "$ALIAS_CMD" "$SHELL_CONFIG"; then
    echo "" >> "$SHELL_CONFIG"
    echo "$ALIAS_CMD" >> "$SHELL_CONFIG"
    echo "✅ Alias 'config' added to '$SHELL_CONFIG'."
else
    echo "ℹ️ The alias 'config' already exists in your '$SHELL_CONFIG'."
fi

if ! grep -qF "$ALIAS_CODE" "$SHELL_CONFIG"; then
    echo "" >> "$SHELL_CONFIG"
    echo "$ALIAS_CODE" >> "$SHELL_CONFIG"
    echo "✅ Alias 'code.omc' added to '$SHELL_CONFIG'."
else
    echo "ℹ️ The alias 'code.omc' already exists in your '$SHELL_CONFIG'."
fi
echo

# -- Activate Alias for Current Session --
# Activates the alias for the current script session
eval "$ALIAS_CMD"

# -- Ignore File Creation --
echo "--- Step 3: Creating the ignore file in '$IGNORE_FILE' ---"
cat <<EOF > "$IGNORE_FILE"
# Ignore everything by default
*

# Whitelist for files and folders we want to version
!.omcignore
EOF
echo "✅ File '$IGNORE_FILE' created with the specified content."
echo

# -- Repository Configuration --
echo "--- Step 4: Configuring the repository to use the ignore file ---"
/usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" config --local core.excludesFile "$IGNORE_FILE"
# Extra configuration to not show all untracked files in status
/usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" config --local status.showUntrackedFiles no
echo "✅ Repository configured to use the ignore file."
echo

# -- Initial Commit --
echo "--- Step 5: Performing the initial commit ---"
# Adds the ignore file itself for versioning
/usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" add "$IGNORE_FILE"

# Performs the first commit with the ignore file
/usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" commit -m "Initial Commit: Setup dotfiles structure"
echo "✅ Initial commit performed successfully!"
echo

# -- Second Commit (Hyprland Config) --
echo "--- Step 5.1: Adding Hyprland configuration ---"
# Adds the Hypr configuration folder, if it exists
if [ -d "$HOME/.config/hypr" ]; then
    # Update ignore file to include hypr config
    cat <<EOF > "$IGNORE_FILE"
# Ignore everything by default
*

# Whitelist for files and folders we want to version
!.omcignore
!.config/hypr
EOF
    
    # Add updated ignore file and hypr config
    /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" add "$IGNORE_FILE"
    /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" add -f "$HOME/.config/hypr"
    echo "ℹ️ Adding the folder '$HOME/.config/hypr' to the commit."
    
    # Performs the second commit with Hyprland config
    /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" commit -m "Add Hyprland configuration files"
    echo "✅ Hyprland configuration committed successfully!"
else
    echo "⚠️ WARNING: The folder '$HOME/.config/hypr' was not found and will not be added."
fi
echo

# -- Remote Repository Configuration --
echo "--- Step 6: Configuring remote repository ---"
REMOTE_URL="https://github.com/fcmiranda/mydotfiles.git"

# Check if remote already exists
if /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" remote | grep -q "^origin$"; then
    echo "ℹ️ Remote 'origin' already exists. Updating URL..."
    /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" remote set-url origin "$REMOTE_URL"
else
    echo "Adding remote 'origin'..."
    /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" remote add origin "$REMOTE_URL"
fi
echo "✅ Remote 'origin' configured: $REMOTE_URL"
echo

# -- Push to Remote --
echo "--- Step 7: Pushing to remote repository ---"
echo "Attempting to push to remote..."
if /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" push -u origin master; then
    echo "✅ Successfully pushed to remote repository!"
else
    echo "⚠️ Failed to push to remote. You may need to:"
    echo "   1. Verify your GitHub credentials"
    echo "   2. Ensure the repository exists on GitHub"
    echo "   3. Manually push later with: config push -u origin master"
fi
echo

# -- Final Instructions --
echo "=========================================================="
echo "🎉 Configuration completed successfully! 🎉"
echo
echo "IMPORTANT: For the 'config' alias to work in your"
echo "terminal, you need to restart your terminal or run:"
echo
echo "    source $SHELL_CONFIG"
echo "=========================================================="
