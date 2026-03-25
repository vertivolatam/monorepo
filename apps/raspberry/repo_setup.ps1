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
python.exe --version
python.exe -m pip install --upgrade pip
python.exe -m pip install virtualenv

############################################
#### Activate virtual environment
python.exe -m venv .venv
.\.venv\Scripts\Activate.ps1

############################################
#### Initial repo setup
python.exe -m pip install --upgrade pip
# Install all required libraries
python.exe -m pip install -r .\requirements.txt