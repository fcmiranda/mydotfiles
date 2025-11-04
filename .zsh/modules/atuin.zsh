if command -v atuin &> /dev/null; then
  export ATUIN_NOBIND=true
  eval "$(atuin init zsh)"
  bindkey "^R" atuin-search
fi