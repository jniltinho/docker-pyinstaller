FROM debian:buster
MAINTAINER Nilton Oliveira <jniltinho@gmail.com>

ARG PYTHON_VERSION=3
ENV PYTHON_VERSION $PYTHON_VERSION
ENV PYTHON python$PYTHON_VERSION

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update && apt-get -y install \
    $PYTHON \
    $PYTHON-dev \
    $PYTHON-pip \
    upx-ucl \
    binutils \
    && rm -rf /var/lib/apt/lists/*

RUN PYI_STATIC_ZLIB=1 pip3 install pyinstaller termcolor distro pyyaml


VOLUME /data
WORKDIR /data

COPY entrypoint.sh pyinstaller-helper /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
