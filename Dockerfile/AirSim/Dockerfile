ARG BASE_NAME="docker.io/adamrehn/ue4-runtime"
ARG BASE_TAG="22.04-cudagl12-x11"

FROM ${BASE_NAME}:${BASE_TAG} AS apt_cache

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

ENV \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN \
    rm -rf /etc/apt/apt.conf.d/docker-clean \
	&& echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache \
	&& apt-get update

    
FROM ${BASE_NAME}:${BASE_TAG} AS app

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

ENV \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

COPY aptDeps.txt /tmp/aptDeps.txt

# INSTALL APT DEPENDENCIES USING CACHE OF apt_cache
RUN \
    --mount=type=cache,target=/var/cache/apt,from=apt_cache,source=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,from=apt_cache,source=/var/lib/apt \
    --mount=type=cache,target=/etc/apt/sources.list.d,from=apt_cache,source=/etc/apt/sources.list.d \
	apt-get install --no-install-recommends -y $(cat /tmp/aptDeps.txt) \
    && rm -rf /tmp/*

USER ue4
WORKDIR /home/ue4

# INSTALL PYTHON DEPENDENCIES
RUN \
    pip3 install --no-cache-dir \
    numpy \
    msgpack-rpc-python

RUN \
    pip3 install --no-cache-dir \
    airsim

# docker build -t kestr3l/airsim:22.04-cudagl12-x11 -f Dockerfile .