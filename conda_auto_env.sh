#!/bin/bash

# conda-auto-env automatically activates a conda environment when
# entering a folder with an .conda-env file.

# This function does a few things:
# 

# To install add this line to your .bashrc or .bash-profile:
#
#       source /path/to/conda_auto_env.sh
#

BASE_ENV="root" # keeps track of conda environment outside of a directory
                # containing .conda-env
IN_CONDA_DIR=0  # keeps track of whether the user just visited a directory or
                # git repo containing .conda-env

function conda_auto_env() {

  _CONDA_GIT_DIR=$(git rev-parse --show-toplevel 2> /dev/null)
  # get ENV: if .conda-env is in the current directory or in the root 
  # directory of a git repo, then ENV is set to the name of the conda env in
  # .conda-env. If not, then ENV == "" and the BASE_ENV is modified only
  # if the previous directory did not contain a .conda-env file.
  if [ -e ".conda-env" ]; then
    ENV=$(head -n 1 .conda-env | cut -f2 -d ' ')
    IN_CONDA_DIR=1
  elif [ -e "$_CONDA_GIT_DIR/.conda-env" ]; then
    ENV=$(head -n 1 $_CONDA_GIT_DIR/.conda-env | cut -f2 -d ' ')
    IN_CONDA_DIR=1
  else
    ENV=""
    # set base env to current env if user was just in a directory that didn't
    # contain a .conda-env file.
    if [ "$IN_CONDA_DIR" -eq "0" ]; then
      BASE_ENV=$(conda info --envs | grep "*" | awk '{print $1}')
    fi
    IN_CONDA_DIR=0
  fi

  # set new ENV: 
  if [ -n "$ENV" ]; then
    # Check if you are already in the environment
    if [[ $PATH != *$ENV* ]]; then
      source activate $ENV
    fi
  elif [ "$BASE_ENV" == "root" ]; then
    source deactivate
  else
    source activate $BASE_ENV
  fi
}

export PROMPT_COMMAND="$PROMPT_COMMAND conda_auto_env"
