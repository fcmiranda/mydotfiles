ZSH="${ZSH_PLUGINS:-${HOME}/.zsh}"
ZSH_MODULE_DIR="${ZSH_MODULE_DIR:-${HOME}/.zsh/modules}"
ZSH_PLUGINS="${ZSH_PLUGINS:-${HOME}/.zsh/plugins}"

# fastfetch --logo-type kitty-direct --logo ~/.config/fastfetch/control.png --logo-width 25 --logo-height 12
fastfetch

# shellcheck source=/dev/null
[[ -f "${ZSH}/binds.zsh" ]] && `source "${ZSH}/binds.zsh"`
# shellcheck source=/dev/null
source "${ZSH_MODULE_DIR}/mise.zsh"
# shellcheck source=/dev/null
source "${ZSH_MODULE_DIR}/starship.zsh"
# shellcheck source=/dev/null
source "${ZSH_MODULE_DIR}/zoxide.zsh"
# shellcheck source=/dev/null
source "${ZSH_MODULE_DIR}/fzf.zsh"
# shellcheck source=/dev/null
source "${ZSH_MODULE_DIR}/atuin.zsh"
# shellcheck source=/dev/null
source "${ZSH_PLUGINS}/zsh-autosuggestions.zsh"
# shellcheck source=/dev/null
source "${ZSH_PLUGINS}/zsh-syntax-highlighting.zsh"
# shellcheck source=/dev/null
source "${ZSH_PLUGINS}/zsh-transient-prompt.zsh"