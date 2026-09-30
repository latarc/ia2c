#!/bin/bash

path=$PWD

# Creates the virtual environment
python3 -m venv $path/papemls

# Activates the virtual environment
source $path/papemls/bin/activate

# Installs the dependencies from requirements.txt file
pip install -r $path/install/requirements.txt
