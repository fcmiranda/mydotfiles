if command -v atuin &> /dev/null; then
  export ATUIN_NOBIND=true
  eval "$(atuin init zsh)"
  bindkey "^R" atuin-search
fi

# incremental history search with arrow keys
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward]]