#!/usr/bin/env zsh
# ~/.zsh/init.zsh - ZSH initialization with modular sourcing

# ============================================================================
# Environment Setup
# ============================================================================
typeset -g ZSH="${ZSH:-${HOME}/.zsh}"
typeset -g ZSH_PACKAGE_DIR="${ZSH_PACKAGE_DIR:-${ZSH}/packages}"
typeset -g ZSH_PLUGINS="${ZSH_PLUGINS:-${ZSH}/plugins}"

autoload -Uz is-at-least

# Idempotency cache to prevent double-sourcing
typeset -Ag __zsh_sourced_cache

# ============================================================================
# Helper Functions
# ============================================================================

# Source shell scripts by type and name(s)
# Usage: source_if_exists <type> <name> [<name2> ...]
#   type: utils|packages|plugins
#   name: script name without .zsh extension
source_if_exists() {
	local shell_type="$1"
	shift
	local -a shell_names=("$@")
	echo "Sourcing $shell_type: ${shell_names[*]}"

	if [[ -z "$shell_type" ]] || (( ${#shell_names[@]} == 0 )); then
		print -u2 "init.zsh: source_if_exists requires shell type and at least one name"
		return 1
	fi

	local base_dir
	case "$shell_type" in
		util|utils)
			base_dir="${ZSH}/utils"
			;;
		package|packages)
			base_dir="${ZSH_PACKAGE_DIR}"
			;;
		plugin|plugins)
			base_dir="${ZSH_PLUGINS}"
			;;
		*)
			print -u2 "init.zsh: unknown shell type '$shell_type' (use: utils, packages, or plugins)"
			return 1
			;;
	esac

	local shell_name target_path
	for shell_name in "${shell_names[@]}"; do
		target_path="${base_dir}/${shell_name}.zsh"

		# Skip if already sourced
		[[ -n "${__zsh_sourced_cache[$target_path]:-}" ]] && continue

		if [[ -f "$target_path" ]]; then
			__zsh_sourced_cache[$target_path]=1
			# shellcheck disable=SC1090
			source "$target_path"
		else
			print -u2 "init.zsh: skipping missing -> $target_path"
		fi
	done
}

# Source package only if corresponding command exists
# Usage: source_packages <name> [<name2> ...]
source_packages() {
	local -a package_names=("$@")

	if (( ${#package_names[@]} == 0 )); then
		print -u2 "init.zsh: source_packages requires at least one package name"
		return 1
	fi

	local package_name
	local -a available_packages=()

	for package_name in "${package_names[@]}"; do
		if (( $+commands[$package_name] )); then
			available_packages+=("$package_name")
		fi
	done

	if (( ${#available_packages[@]} > 0 )); then
		source_if_exists packages "${available_packages[@]}"
	fi
}

# Convenience wrappers for common types
source_utils() {
	source_if_exists utils "$@"
}

source_plugins() {
	source_if_exists plugins "$@"
}

# ============================================================================
# Terminal Setup
# ============================================================================
ghosttime -t 1 2>/dev/null || true
printf '\n%.0s' {1..75}
clear

# ============================================================================
# Source Order: Utils → Packages → Plugins
# ============================================================================

# 1. Utilities (unconditional)
source_utils binds

# 2. packages (conditional on command availability)
source_packages mise \
	starship \
	zoxide \
	fzf \
	atuin

# 3. Plugins (unconditional)
source_plugins \
	zsh-autosuggestions \
	zsh-syntax-highlighting \
	zsh-transient-prompt