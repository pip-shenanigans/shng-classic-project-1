#!/bin/bash

# PYTHON_PROJECT_TEST_WITH_PYTEST

if [[ "${PYTHON_PROJECT_TEST_WITH_PYTEST}" == "true" || "${PYTHON_PROJECT_TEST_WITH_PYTEST}" == "false" ]]
then
    echo "Args:"
    echo "PYTHON_PROJECT_TEST_WITH_PYTEST=${PYTHON_PROJECT_TEST_WITH_PYTEST}"
else
    echo "PYTHON_PROJECT_TEST_WITH_PYTEST=${PYTHON_PROJECT_TEST_WITH_PYTEST} build argument must be 'true' (default) or 'false'"
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

# Test project
if [[ "${PYTHON_PROJECT_TEST_WITH_PYTEST}" = "true" ]]
then
    pytest .
else
    python3 setup.py test
fi
