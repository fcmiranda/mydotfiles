
# Source the Omarchy initialization script
source ~/.zsh/init.sh

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# source from Omarchy
source ~/.local/share/omarchy/default/bash/aliases
source ~/.local/share/omarchy/default/bash/functions
source ~/.local/share/omarchy/default/bash/envs

alias omc='/usr/bin/git --git-dir=/home/fecavmi/.omc --work-tree=/home/fecavmi'

alias code.omc='GIT_DIR=/home/fecavmi/.omc GIT_WORK_TREE=/home/fecavmi code /home/fecavmi'
