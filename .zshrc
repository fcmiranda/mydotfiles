
# Source the Omarchy initialization script
source ~/.zsh/init.zsh

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# source from Omarchy
source ~/.local/share/omarchy/default/bash/aliases
source ~/.local/share/omarchy/default/bash/functions
source ~/.local/share/omarchy/default/bash/envs

alias omc='/usr/bin/git --git-dir=/home/fecavmi/.omc --work-tree=/home/fecavmi'

alias code.omc='GIT_DIR=/home/fecavmi/.omc GIT_WORK_TREE=/home/fecavmi code /home/fecavmi'
alias code.here='GIT_DIR=$(pwd) GIT_WORK_TREE=$(pwd) code $(pwd)'
alias reload='source ~/.zshrc'

# Locale settings (added by us-intl-locale.sh)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
