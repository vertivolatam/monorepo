# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

############################################
#### Initial python setup
# Running with admin rights
python3 --version
sudo apt-get update
sudo apt-get install python3-pip
sudo apt-get install python3.12-venv

############################################
#### Activate virtual environment
python3 -m venv .venv
. .venv/bin/activate

############################################
#### Initial repo setup
python3 -m pip install --upgrade pip
# Install all required libraries
python3 -m pip install -r '.\requirements.txt'

############################################

