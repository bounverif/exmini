ARG ESMINI_BASE_IMAGE=docker.io/library/ubuntu
ARG ESMINI_BASE_IMAGE_VERSION=24.04
ARG ESMINI_BUILD_PROTOBUF_VERSION=3.15.8
ARG ESMINI_BUILD_ASAM_OSI_VERSION=3.5.0

FROM ${ESMINI_BASE_IMAGE}:${ESMINI_BASE_IMAGE_VERSION} AS esmini-asam-osi
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
      build-essential \
      cmake \
      python3-minimal \
      python3-pip \
      pipx \
      python-is-python3 \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* && \
    printf "ubuntu ALL= NOPASSWD: ALL\\n" > /etc/sudoers.d/ubuntu

# Install some python utilities
RUN python3 -m pip config set global.break-system-packages true && \
    PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install semver

ARG ESMINI_BUILD_PROTOBUF_VERSION
ENV ESMINI_BUILD_PROTOBUF_VERSION=${ESMINI_BUILD_PROTOBUF_VERSION}
COPY --chmod=755 scripts/protobuf-install.sh /usr/local/bin/protobuf-install.sh
RUN /usr/local/bin/protobuf-install.sh

ARG ESMINI_BUILD_ASAM_OSI_VERSION
ENV ESMINI_BUILD_ASAM_OSI_VERSION=${ESMINI_BUILD_ASAM_OSI_VERSION}
COPY --chmod=755 scripts/asam-osi-install.sh /usr/local/bin/asam-osi-install.sh
RUN /usr/local/bin/asam-osi-install.sh
