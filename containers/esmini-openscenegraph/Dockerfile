ARG ESMINI_BASE_IMAGE=docker.io/library/ubuntu
ARG ESMINI_BASE_IMAGE_VERSION=24.04

FROM ${ESMINI_BASE_IMAGE}:${ESMINI_BASE_IMAGE_VERSION} AS esmini-openscenegraph-builder
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

ARG ESMINI_BUILD_OSG_VERSION=latest

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      sudo \
      curl \
      git \
      jq \
      gnupg2 \
      ca-certificates \
      build-essential \
      cmake \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* && \
    printf "ubuntu ALL= NOPASSWD: ALL\\n" > /etc/sudoers.d/ubuntu

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      libgl1-mesa-dev \
      libxml2-dev \
      libjpeg-dev \
      libpng-dev \
      libtiff-dev \
      libfontconfig-dev \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

ARG ESMINI_BUILD_OSG_VERSION=latest
ARG ESMINI_BUILD_OSG_WITH_FBX=OFF
ARG ESMINI_BUILD_OSG_BUILD_SHARED_LIBS=OFF
ARG ESMINI_BUILD_OSG_BUILD_APPLICATIONS=OFF

ENV ESMINI_BUILD_OSG_VERSION=${ESMINI_BUILD_OSG_VERSION}
ENV ESMINI_BUILD_OSG_WITH_FBX=${ESMINI_BUILD_OSG_WITH_FBX}
ENV ESMINI_BUILD_OSG_BUILD_SHARED_LIBS=${ESMINI_BUILD_OSG_BUILD_SHARED_LIBS}
ENV ESMINI_BUILD_OSG_BUILD_APPLICATIONS=${ESMINI_BUILD_OSG_BUILD_APPLICATIONS}

COPY --chmod=755 scripts/osg-install.sh /usr/local/bin/osg-install.sh
RUN /usr/local/bin/osg-install.sh

FROM ${ESMINI_BASE_IMAGE}:${ESMINI_BASE_IMAGE_VERSION} AS esmini-openscenegraph
COPY --from=esmini-openscenegraph-builder /usr/local/ /usr/local/