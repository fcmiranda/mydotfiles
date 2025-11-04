#!/bin/zsh

# -----------------------------------------------------------------------------
# Configure a bare dotfiles repository and aliases in the current workstation.
# The script will ensure the repository exists, check out the tracked files,
# configure local git defaults, and register helper aliases in the shell config.
# -----------------------------------------------------------------------------

set -eu
set -o pipefail

: "${DOTFILES_DIR:=$HOME/.omc}"
: "${DOTFILES_REPO:=https://github.com/fcmiranda/.omc.git}"
: "${GIT_BIN:=/usr/bin/git}"
: "${SHELL_CONFIG:=$HOME/.zshrc}"

readonly DOTFILES_DIR DOTFILES_REPO GIT_BIN SHELL_CONFIG

log_info() {
    printf '[INFO] %s\n' "$*"
}

log_success() {
    printf '[ OK ] %s\n' "$*"
}

log_error() {
    printf '[ERR ] %s\n' "$*" >&2
}

dotfiles_git() {
    "$GIT_BIN" --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

ensure_bare_repo() {
    if [ -d "$DOTFILES_DIR" ]; then
        log_info "Bare repository found at $DOTFILES_DIR"
        return
    fi

    log_info "Cloning bare repository from $DOTFILES_REPO"
    if "$GIT_BIN" clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"; then
        log_success "Bare repository cloned into $DOTFILES_DIR"
    else
        log_error "Failed to clone bare repository from $DOTFILES_REPO"
        exit 1
    fi
}

checkout_dotfiles() {
    log_info "Checking out dotfiles into $HOME"
    if dotfiles_git checkout --force; then
        log_success "Dotfiles checked out"
    else
        log_error "Checkout failed. Resolve conflicts and retry"
        exit 1
    fi
}

configure_local_repo() {
    log_info "Applying local git configuration"
    dotfiles_git config --local status.showUntrackedFiles no
    dotfiles_git config --local core.excludesFile "$HOME/.omcignore"
    log_success "Local git options applied"
}

ensure_alias() {
    local alias_line=$1
    local label=$2

    if grep -qF "$alias_line" "$SHELL_CONFIG" 2>/dev/null; then
        log_info "$label already present in $SHELL_CONFIG"
        return
    fi

    [ -f "$SHELL_CONFIG" ] || touch "$SHELL_CONFIG"
    if [ -s "$SHELL_CONFIG" ]; then
        printf '\n' >> "$SHELL_CONFIG"
    fi
    printf '%s\n' "$alias_line" >> "$SHELL_CONFIG"
    log_success "$label added to $SHELL_CONFIG"
}

configure_aliases() {
    log_info "Registering omc helper aliases"
    ensure_alias "alias omc='$GIT_BIN --git-dir=$DOTFILES_DIR --work-tree=$HOME'" "Alias omc"
    ensure_alias "alias code.omc='GIT_DIR=$DOTFILES_DIR GIT_WORK_TREE=$HOME code $HOME'" "Alias code.omc"
}

print_completion() {
    cat <<EOF
==========================================================
Setup complete.

Reload your shell configuration to enable the aliases:

    source $SHELL_CONFIG

New terminals will load the settings automatically.
==========================================================
EOF
}

ensure_bare_repo
checkout_dotfiles
configure_local_repo
configure_aliases
print_completion
