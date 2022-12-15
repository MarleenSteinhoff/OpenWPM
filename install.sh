#!/bin/bash

# This script automates the creation and installation
# of the conda environmnet. It's useful for working
# in the docker file and on travis, but it's not
# necessary for individual users to use it.

# Developers are encouraged to only run scripts
# that they fully understand, and may prefer to
# run aspects of this script manually to set-up
# openwpm.

# This script will remove an existing openwpm
# conda environment if it exists.

# Arguments:
# --skip-create: Doesn't change the openwpm conda environment


set -e

# Make conda available to shell script
eval "$(conda shell.bash hook)"

if [ "$1" != "--skip-create" ]; then
  echo 'Creating / Overwriting openwpm conda environment.'
  # `PYTHONNOUSERSITE` set so python ignores local user site libraries when building the env
  # See: https://github.com/openwpm/OpenWPM/pull/682#issuecomment-645648939
  PYTHONNOUSERSITE=True conda env create --force -q -f environment.yaml
fi

echo 'Activating environment.'
conda activate openwpm

echo 'Installing firefox.'
./scripts/install-firefox.sh

echo 'Building extension.'
./scripts/build-extension.sh

echo 'Installing additional packages'
apt install xvfb
apt-get install libgtk-3.0
apt-get install libasound2 
apt-get install libdbus-glib-1-2

echo 'Installation complete, activate your new environment by running:'
echo 'conda activate openwpm'


# additionally installed for EC2 virtual instance:
# pyvirtualdisplay, xvfb, gtk3-module
