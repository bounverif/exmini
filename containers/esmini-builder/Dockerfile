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
      sudo \
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
    printf "ubuntu ALL= NOPASSWD: ALL\\n" > /etc/sudoers.d/ubuntu

RUN python3 -m pip config set global.break-system-packages true && \
    python3 -m pip install --no-cache-dir bindep

# Install esmini devel packages
RUN --mount=type=bind,source=dependencies.txt,target=/tmp/esmini/dependencies.txt \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      $(bindep builder --brief --file /tmp/esmini/dependencies.txt) \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* 

COPY --chmod=755 scripts/build_osgdb_fbx.sh /usr/bin/build-osgdb-fbx

ARG ESMINI_VERSION
ENV ESMINI_VERSION=${ESMINI_VERSION}

FROM ${ESMINI_IMAGE_NAME}:${ESMINI_VERSION}-builder AS esmini-devel
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

# Build OpenSceneGraph from source with FBX support
RUN --mount=type=bind,source=scripts,target=/tmp/scripts \
    ./build-osgdb-fbx.sh

RUN --mount=type=bind,source=dependencies.txt,target=/tmp/esmini/dependencies.txt \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      $(bindep devel --brief --file /tmp/esmini/dependencies.txt) \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* 