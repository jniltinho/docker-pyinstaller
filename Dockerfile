FROM python:3.7-slim-buster
MAINTAINER Nilton Oliveira <jniltinho@gmail.com>

## docker build --no-cache -t jniltinho/pyinstaller .
## docker push jniltinho/pyinstaller


RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update && apt-get install -y --no-install-recommends binutils xz-utils curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archive/*.deb

RUN PYI_STATIC_ZLIB=1 pip install pyinstaller pyyaml && pip cache purge

RUN curl -skLO https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz \
    && tar -xf upx-3.96-amd64_linux.tar.xz && cp upx-3.96-amd64_linux/upx /usr/local/bin/ \
    && chmod +x /usr/local/bin/upx && rm -rf upx-3.96*


VOLUME /data
WORKDIR /data

COPY entrypoint.sh pyinstaller-helper /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
