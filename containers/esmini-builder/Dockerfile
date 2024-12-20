ARG ESMINI_BASE_IMAGE=docker.io/library/ubuntu
ARG ESMINI_BASE_IMAGE_VERSION=24.04
ARG ESMINI_IMAGE_NAME=localhost/esmini
ARG ESMINI_VERSION=latest

FROM ${ESMINI_BASE_IMAGE}:${ESMINI_BASE_IMAGE_VERSION} AS esmini-builder
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

# Install predependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      doas \
      curl \
      wget \
      git \
      gnupg2 \
      ca-certificates \
      python3-minimal \
      python3-pip \
      python-is-python3 \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* && \
    echo "permit nopass ubuntu as root" >> /etc/doas.conf

RUN python3 -m pip config set global.break-system-packages true && \
    python3 -m pip install --no-cache-dir bindep

ARG ESMINI_VERSION
ENV ESMINI_VERSION=${ESMINI_VERSION}

# Install esmini devel packages
COPY dependencies.txt /etc/esmini/dependencies.txt
RUN apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      $(bindep devel --brief --file /etc/esmini/dependencies.txt) \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* 
