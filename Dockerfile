FROM ubuntu:18.04

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV PROJECT_NAME shng-classic-project-1

#ARG PYTHON_PIP_VERSION="== 21.2.*"
ARG PYTHON_PIP_VERSION="< 20.3"
ARG PYTHON_SETUPTOOLS_VERSION="< 58"
ARG PYTHON_PROJECT_INSTALL_WITH_PIP="false"
ARG PYTHON_PROJECT_TEST_WITH_PYTEST="false"

ENV PYTHON_PIP_VERSION ${PYTHON_PIP_VERSION}
ENV PYTHON_SETUPTOOLS_VERSION ${PYTHON_SETUPTOOLS_VERSION}
ENV PYTHON_PROJECT_INSTALL_WITH_PIP ${PYTHON_PROJECT_INSTALL_WITH_PIP}
ENV PYTHON_PROJECT_TEST_WITH_PYTEST ${PYTHON_PROJECT_TEST_WITH_PYTEST}

RUN set -eu -x; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get -y install \
        bash \
        wget \
        curl \
        git \
        sudo; \
    apt-get -y install \
        ca-certificates \
        build-essential \
        libpq-dev \
        libsqlite3-dev \
        libxslt1-dev \
        libyaml-dev \
        libffi-dev; \
    apt-get -y install \
        python3.6 \
        python3.6-dev \
        python3.6-venv; \
    pushd /usr/local/bin \
	    && ln -s idle3 idle \
	    && ln -s pydoc3 pydoc \
	    && ln -s python3 python \
	    && ln -s python3-config python-config \
        && popd; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    apt list --installed 'python*';

# https://github.com/pypa/get-pip/commits/main/public/get-pip.py
# a1675ab6c2bd898ed82b1f58c486097f763c74a9 => (21.1.3)
ENV PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/blob/a1675ab6c2bd898ed82b1f58c486097f763c74a9/public/get-pip.py?raw=true
ENV PYTHON_GET_PIP_SHA256=6665659241292b2147b58922b9ffe11dda66b39d52d8a6f3aa310bc1d60ea6f7

RUN set -eu -x; \
    wget -O get-pip.py "${PYTHON_GET_PIP_URL}"; \
    echo "${PYTHON_GET_PIP_SHA256} *get-pip.py" | sha256sum --check --strict -; \
    python3 get-pip.py --disable-pip-version-check --no-cache-dir "pip ${PYTHON_PIP_VERSION}"; \
    find /usr/local -depth \( \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \) -exec rm -rf '{}' +; \
    rm -f get-pip.py; \
    pip --version; \
    pip list; \
    pip install --upgrade --force-reinstall "setuptools ${PYTHON_SETUPTOOLS_VERSION}" "wheel" "chardet"; \
    pip --version; \
    pip config debug; \
    pip debug; \
    pip list;


### WORKDIR /
### USER root
### RUN set -eu -x; \
###     useradd -D; \
###     useradd --user-group --uid 1001 --create-home tools; \
###     ls -l /home/tools/;
###
### WORKDIR /home/tools/
### USER tools
### ENV PATH=/home/tools/.local/bin/:${PATH}
###
### RUN set -eu -x; \
###     pip install --user pipx; \
###     pipx install ipython; \
###     pipx install pipdeptree; \
###     pipx install pip-tools; \
###     pipx install httpie; \
###     pipx list; \
###     pip list; \
###     chmod +rx /home/tools/.local/; \
###     chmod +rx /home/tools/.local/bin/; \
###     ls -lh /home/tools/.local/bin/;

WORKDIR /
USER root
RUN set -eu -x; \
    useradd -D; \
    useradd --user-group --uid 1000 --create-home app; \
    echo "app ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers; \
    ls -l /home/app/; \
    mkdir /app/; \
    chown app:app /app; \
    ls -ld /app/;

WORKDIR /app
USER app
ENV PATH=/home/app/.local/bin:${PATH}

ENV PROJECT_CODE_DIRPATH="/app/code/${PROJECT_NAME}"

RUN mkdir -p ${PROJECT_CODE_DIRPATH}

# Copy & Install project
COPY --chown=app:app . ${PROJECT_CODE_DIRPATH}

RUN bash ${PROJECT_CODE_DIRPATH}/build/project-install.sh

CMD bash ${PROJECT_CODE_DIRPATH}/build/project-test.sh
