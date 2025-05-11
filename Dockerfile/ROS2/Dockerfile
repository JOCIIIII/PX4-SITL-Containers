ARG BASEIMAGE=${BASEIMAGE:-"isaac-ros-dev-base"}
ARG BASETAG=${BASETAG:-"cuda12.6-tensorrt10.7-cudnn9.7"}


# STAGE FOR CACHING APT PACKAGE LIST
FROM ${BASEIMAGE}:${BASETAG} AS stage_apt

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

RUN \
    rm -rf /etc/apt/apt.conf.d/docker-clean \
	&& echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache \
	&& apt-get update && apt-get upgrade -y


# STAGE FOR INSTALLING APT DEPENDENCIES
FROM ${BASEIMAGE}:${BASETAG} AS stage_deps

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

ENV \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

COPY aptDeps.txt /tmp/aptDeps.txt

# INSTALL APT DEPENDENCIES USING CACHE OF stage_apt
RUN \
    --mount=type=cache,target=/var/cache/apt,from=stage_apt,source=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,from=stage_apt,source=/var/lib/apt \
    --mount=type=cache,target=/etc/apt/sources.list.d,from=stage_apt,source=/etc/apt/sources.list.d \
	apt-get install --no-install-recommends -y $(cat /tmp/aptDeps.txt) \
    && rm -rf /tmp/*


# INSTALL PYTHON DEPENDENCIES
COPY pyDeps.txt /tmp/pyDeps.txt

RUN \
    pip install --upgrade pip \
    && pip install --upgrade $(cat /tmp/pyDeps.txt) \
    && rm -rf /tmp/*

WORKDIR /home/user/workspace

USER user

