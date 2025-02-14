ARG ESMINI_VERSION=latest
ARG ESMINI_BASE_IMAGE_NAME=docker.io/library/ubuntu
ARG ESMINI_BASE_IMAGE_VERSION=24.04
ARG ESMINI_BASE_IMAGE=${ESMINI_BASE_IMAGE_NAME}:${ESMINI_BASE_IMAGE_VERSION}
ARG ESMINI_IMAGE_NAME=localhost/esmini
ARG ESMINI_IMAGE_VERSION=${ESMINI_VERSION}
ARG ESMINI_BUILDER_IMAGE=${ESMINI_IMAGE_NAME}:${ESMINI_IMAGE_VERSION}-builder
ARG ESMINI_DEVEL_IMAGE=${ESMINI_IMAGE_NAME}:${ESMINI_IMAGE_VERSION}-devel

ARG ESMINI_BUILD_CACHE_IMAGE_NAME=ghcr.io/bounverif/esmini
ARG ESMINI_BUILD_OSG_VERSION=3.6.5
ARG ESMINI_BUILD_PROTOBUF_VERSION=3.15.8
ARG ESMINI_BUILD_ASAM_OSI_VERSION=3.5.0

FROM ${ESMINI_BUILD_CACHE_IMAGE_NAME}:${ESMINI_BUILD_OSG_VERSION}-openscenegraph AS esmini-openscenegraph
FROM ${ESMINI_BUILD_CACHE_IMAGE_NAME}:${ESMINI_BUILD_ASAM_OSI_VERSION}-${ESMINI_BUILD_PROTOBUF_VERSION}-asam-osi AS esmini-asam-osi

FROM ${ESMINI_BASE_IMAGE} AS esmini-builder
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

# Install predependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      sudo \
      curl \
      wget \
      git-core \
      jq \
      gnupg2 \
      ca-certificates \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* && \
    printf "ubuntu ALL= NOPASSWD: ALL\\n" > /etc/sudoers.d/ubuntu

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      python3-minimal \
      python3-pip \
      python-is-python3 \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* && \
    python3 -m pip config set global.break-system-packages true && \
    python3 -m pip install --no-cache-dir bindep

# Install esmini devel packages
RUN --mount=type=bind,source=dependencies.txt,target=/tmp/esmini/dependencies.txt \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      $(bindep builder --brief --file /tmp/esmini/dependencies.txt) \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* 

ARG ESMINI_BUILD_OSG_VERSION
ENV ESMINI_BUILD_OSG_VERSION=${ESMINI_BUILD_OSG_VERSION}
COPY --from=esmini-openscenegraph /usr/local /usr/local

ARG ESMINI_BUILD_PROTOBUF_VERSION
ARG ESMINI_BUILD_ASAM_OSI_VERSION
ENV ESMINI_BUILD_PROTOBUF_VERSION=${ESMINI_BUILD_PROTOBUF_VERSION}
ENV ESMINI_BUILD_ASAM_OSI_VERSION=${ESMINI_BUILD_ASAM_OSI_VERSION}
COPY --from=esmini-asam-osi /usr/local /usr/local

ARG ESMINI_VERSION
ENV ESMINI_VERSION=${ESMINI_VERSION}

FROM ${ESMINI_BUILDER_IMAGE} AS esmini-devel
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

RUN --mount=type=bind,source=dependencies.txt,target=/tmp/esmini/dependencies.txt \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      $(bindep devel --brief --file /tmp/esmini/dependencies.txt) \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* 
