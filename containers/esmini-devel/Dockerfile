FROM bazalt-builder AS esmini-builder
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

RUN --mount=type=bind,source=./scripts/openscenegraph-source-install.sh,target=/container-build/scripts/openscenegraph-source-install.sh \
    . /container-build/openscenegraph-source-install.sh

RUN --mount=type=bind,source=./scripts/asam-osi-source-install.sh,target=/container-build/scripts/asam-osi-source-install.sh \
    . /container-build/asam-osi-source-install.sh

FROM esmini-builder AS esmini-devel
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

FROM bazalt-runtime AS esmini-runtime
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT
