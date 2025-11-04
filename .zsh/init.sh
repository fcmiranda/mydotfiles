ZSH_MODULE_DIR="${ZSH_MODULE_DIR:-${HOME}/.zsh/modules}"

if [[ -d "${ZSH_MODULE_DIR}" ]]; then
  for module in "${ZSH_MODULE_DIR}"/*.sh; do
    [[ -e "${module}" ]] || continue
    # shellcheck source=/dev/null
    source "${module}"
  done
fi
