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
      jq \
      gnupg2 \
      ca-certificates \
      python3-minimal \
      python3-pip \
      pipx \
      python-is-python3 \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* && \
    printf "ubuntu ALL= NOPASSWD: ALL\\n" > /etc/sudoers.d/ubuntu

# Install some python utilities
RUN python3 -m pip config set global.break-system-packages true && \
    python3 -m pip install --no-cache-dir \
      bindep \
      && \
    PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install semver

# Install esmini devel packages
RUN --mount=type=bind,source=dependencies.txt,target=/tmp/esmini/dependencies.txt \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      $(bindep builder --brief --file /tmp/esmini/dependencies.txt) \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* 

ARG ESMINI_BUILD_PROTOBUF_VERSION=3.15.2
ENV ESMINI_BUILD_PROTOBUF_VERSION=${ESMINI_BUILD_PROTOBUF_VERSION}
COPY --chmod=755 scripts/protobuf-install.sh /usr/local/bin/protobuf-install.sh
RUN /usr/local/bin/protobuf-install.sh

ARG ESMINI_BUILD_OSI_VERSION=3.5.0
ENV ESMINI_BUILD_OSI_VERSION=${ESMINI_BUILD_OSI_VERSION}
COPY --chmod=755 scripts/osi-install.sh /usr/local/bin/osi-install.sh
RUN /usr/local/bin/osi-install.sh

ARG ESMINI_BUILD_OSG_VERSION=3.6.5
ENV ESMINI_BUILD_OSG_VERSION=${ESMINI_BUILD_OSG_VERSION}
COPY --chmod=755 scripts/osg-install.sh /usr/local/bin/osg-install.sh

ARG ESMINI_VERSION
ENV ESMINI_VERSION=${ESMINI_VERSION}

FROM ${ESMINI_IMAGE_NAME}:${ESMINI_VERSION}-builder AS esmini-devel
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

RUN --mount=type=bind,source=dependencies.txt,target=/tmp/esmini/dependencies.txt \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      $(bindep devel --brief --file /tmp/esmini/dependencies.txt) \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* 