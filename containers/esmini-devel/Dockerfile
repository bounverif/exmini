ARG ESMINI_VERSION=latest
ARG ESMINI_IMAGE_NAME=localhost/esmini
ARG ESMINI_IMAGE_VERSION=${ESMINI_VERSION}
ARG ESMINI_BASE_BUILDER_IMAGE=bazalt-builder
ARG ESMINI_BASE_RUNTIME_IMAGE=bazalt-runtime
ARG ESMINI_BUILDER_IMAGE=esmini-builder
ARG ESMINI_DEVEL_IMAGE=esmini-devel

ARG ESMINI_SOURCE_DIR=/tmp/esmini
ARG ESMINI_BUILD_DIR=/tmp/esmini/build

FROM ghcr.io/bounverif/bazalt:latest-builder AS esmini-builder
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

RUN --mount=type=bind,source=./scripts/openscenegraph-source-install.sh,target=/build/scripts/openscenegraph-source-install.sh \
    bash /build/scripts/openscenegraph-source-install.sh

RUN --mount=type=bind,source=./scripts/asam-osi-source-install.sh,target=/build/scripts/asam-osi-source-install.sh \
    bash /build/scripts/asam-osi-source-install.sh

FROM ${ESMINI_BUILDER_IMAGE} AS esmini-devel
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

FROM ${ESMINI_BUILDER_IMAGE} AS esmini-prebuilt
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

RUN --mount=type=bind,source=./scripts/esmini-source-install.sh,target=/build/scripts/esmini-source-install.sh \
    bash /build/scripts/esmini-source-install.sh

FROM ghcr.io/bounverif/bazalt:latest-runtime AS esmini-runtime
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT
