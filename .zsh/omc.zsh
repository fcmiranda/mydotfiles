ZSH="${ZSH_PLUGINS:-${HOME}/.zsh}"
ZSH_MODULE_DIR="${ZSH_MODULE_DIR:-${HOME}/.zsh/modules}"
ZSH_PLUGINS="${ZSH_PLUGINS:-${HOME}/.zsh/plugins}"

# shellcheck source=/dev/null
source "${ZSH}/binds.zsh"
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