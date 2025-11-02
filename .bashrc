# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
alias config='/usr/bin/git --git-dir=/home/fecavmi/mydotfiles --work-tree=/home/fecavmi'

alias codemydotfiles='GIT_DIR=/home/fecavmi/mydotfiles GIT_WORK_TREE=/home/fecavmi code /home/fecavmi'

# Locale settings (added by setup_us_intl_locale.sh)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
