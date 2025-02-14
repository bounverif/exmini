ARG ESMINI_VERSION=latest
ARG ESMINI_BASE_IMAGE_NAME=docker.io/library/ubuntu
ARG ESMINI_BASE_IMAGE_VERSION=24.04
ARG ESMINI_BASE_IMAGE=${ESMINI_BASE_IMAGE_NAME}:${ESMINI_BASE_IMAGE_VERSION}
ARG ESMINI_IMAGE_NAME=localhost/esmini
ARG ESMINI_IMAGE_VERSION=${ESMINI_VERSION}
ARG ESMINI_BUILDER_IMAGE=${ESMINI_IMAGE_NAME}:${ESMINI_IMAGE_VERSION}-builder

ARG ESMINI_SOURCE_DIR=/tmp/esmini
ARG ESMINI_BUILD_DIR=/tmp/esmini/build

FROM ${ESMINI_BUILDER_IMAGE} AS esmini-prebuilt
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

ARG ESMINI_SOURCE_DIR
ARG ESMINI_BUILD_DIR

ARG ESMINI_BUILD_USE_SUMO=0
ARG ESMINI_BUILD_USE_GTEST=0
ARG ESMINI_BUILD_USE_IMPLOT=0
ARG ESMINI_BUILD_USE_OSG=1
ARG ESMINI_BUILD_USE_OSI=1
ARG ESMINI_BUILD_DYN_PROTOBUF=0

RUN git clone https://github.com/esmini/esmini.git "${ESMINI_SOURCE_DIR}" && \
    cd "${ESMINI_SOURCE_DIR}" && \
    if [ "${ESMINI_VERSION}" = "latest" ]; then \
      git checkout $(git describe --tags `git rev-list --tags --max-count=1`); \
    else \
      git checkout ${ESMINI_VERSION}; \
    fi && \
    mkdir -p /etc/esmini && \
    printf "%s\\n" "$(git tag --points-at HEAD)" >> /etc/esmini/VERSION

# TODO: Install system dependencies from the cloned repository

RUN cmake -S ${ESMINI_SOURCE_DIR} -B ${ESMINI_BUILD_DIR} \
      -DUSE_SUMO=${ESMINI_BUILD_USE_SUMO} \
      -DUSE_GTEST=${ESMINI_BUILD_USE_GTEST} \
      -DUSE_IMPLOT=${ESMINI_BUILD_USE_IMPLOT} \
      -DUSE_OSG=${ESMINI_BUILD_USE_OSG} \
      -DUSE_OSI=${ESMINI_BUILD_USE_OSI} \
      -DDYN_PROTOBUF=${ESMINI_BUILD_DYN_PROTOBUF} \
      && \
    cmake --build ${ESMINI_BUILD_DIR} --target install

FROM ${ESMINI_BASE_IMAGE} AS esmini-runtime
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

ARG ESMINI_SOURCE_DIR
ARG ESMINI_BUILD_DIR

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
      doas \
      tini \
      && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/* && \
    echo "permit nopass ubuntu as root" >> /etc/doas.conf

COPY --from=esmini-prebuilt ${ESMINI_SOURCE_DIR}/bin /usr/local/bin
COPY --from=esmini-prebuilt ${ESMINI_SOURCE_DIR}/resources /usr/local/share/esmini/resources

COPY --chmod=755 esmini-runtime/esmini.sh /usr/local/bin/esmini.sh

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/esmini.sh"]

# VOLUME ["/var/esmini/scenarios", "/var/esmini/data"]
