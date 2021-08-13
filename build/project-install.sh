#!/bin/bash

# PYTHON_PROJECT_INSTALL_WITH_PIP

if [[ "${PYTHON_PROJECT_INSTALL_WITH_PIP}" == "true" || "${PYTHON_PROJECT_INSTALL_WITH_PIP}" == "false" ]]
then
    echo "Args:"
    echo "PYTHON_PROJECT_INSTALL_WITH_PIP=${PYTHON_PROJECT_INSTALL_WITH_PIP}"
else
    echo "PYTHON_PROJECT_INSTALL_WITH_PIP=${PYTHON_PROJECT_INSTALL_WITH_PIP} build argument must be 'true' (default) or 'false'"
    exit 1;
fi


set -eu -x

# Meta-Data
id
pwd
printenv
pip list --user
ls -lhd ${PROJECT_CODE_DIRPATH}

cd ${PROJECT_CODE_DIRPATH}

# Install project requirements
nl requirements.txt
pip --verbose --no-cache-dir install --user -r requirements.txt
pip list --user;

# Install project
nl setup.py
if [[ "${PYTHON_PROJECT_INSTALL_WITH_PIP}" = "true" ]]
then
    pip --no-cache-dir install --user -e .
else
    python3 setup.py develop --user
fi
pip list --user;
