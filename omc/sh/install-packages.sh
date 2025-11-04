#!/bin/zsh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=./install-atuin.sh
source "${SCRIPT_DIR}/install-atuin.sh"
