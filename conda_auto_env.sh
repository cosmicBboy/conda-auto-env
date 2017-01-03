#!/bin/bash

# conda-auto-env automatically activates a conda environment when
# entering a folder with an conda-env.yml file.
#
# If the environment doesn't exist, conda-auto-env creates it and
# activates it for you.
#
# To install add this line to your .bashrc or .bash-profile:
#
#       source /path/to/conda_auto_env.sh
#

function conda_auto_env() {
  if [ -e "conda-env.yml" ]; then
    ENV=$(head -n 1 conda-env.yml | cut -f2 -d ' ')
    # Check if you are already in the environment
    if [[ $PATH != *$ENV* ]]; then
      # Check if the environment exists
      source activate $ENV
    fi
  else
    source deactivate
  fi
}

export PROMPT_COMMAND=conda_auto_env
