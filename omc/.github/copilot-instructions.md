# Copilot Instructions for .omc Dotfiles Repository

## Architecture Overview
This repository manages dotfiles using a bare Git repository approach. The core setup uses `~/.omc` as the bare repo and `$HOME` as work tree. Key components:
- `sh/omc.sh`: Bootstrap script that clones/checks out dotfiles, configures aliases, and sets Git options
- `sh/`: Installation scripts for system components (zsh, locale, kanshi)
- `pkgs/`: Package-specific Zsh configurations (e.g., atuin.zsh for shell history sync)

## Developer Workflows
- **Adding dotfiles**: Use `omc add <file>`, `omc commit -m "msg"`, `omc push` (alias set by omc.sh)
- **Bootstrapping new machine**: Run `zsh sh/install.sh` then `zsh sh/omc.sh` to set up
- **Testing scripts**: Run with `zsh sh/<script>.sh` and check .zshrc modifications
- **Debugging**: Check `~/.omc` bare repo, verify aliases with `alias omc`

## Project Conventions
- **Scripts**: Written in Zsh, start with shebang `#!/bin/zsh`
- **Installation pattern**: Check `command -v <tool>`, install via pacman or yay (Arch Linux only), add configs to `~/.zshrc`
- **Package detection**: Prefer yay (for AUR) > pacman > fallback installer
- **Zsh integration**: Add `eval "$(<tool> init zsh)"` or aliases to .zshrc, check with `grep -qF`
- **Error handling**: Use `set -eu` in scripts, log with printf '[INFO/OK/ERR]'

## Key Files
- `sh/omc.sh`: Exemplifies bare repo setup and alias configuration
- `pkgs/atuin.zsh`: Shows package install + Zsh init pattern
- `README.md`: Lists install commands for components
- `md/kanshi-setup.md`: Detailed setup guide for complex components

## Patterns to Follow
- For new packages: Create `pkgs/<package>.zsh` with install check, package manager logic, and .zshrc additions
- Every time you create a package install script, add it to `install.zsh` and add its `.zsh/modules` if applicable
- For system installs: Add to `sh/<component>.sh` with distro detection
- Always verify installations work on target systems before committing</content>
<parameter name="filePath">/home/fecavmi/omc/.github/copilot-instructions.md