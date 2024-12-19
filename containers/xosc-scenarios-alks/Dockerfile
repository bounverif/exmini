FROM docker.io/library/debian:12 AS xosc-scenarios-alks-cloner
ARG TARGETARCH TARGETOS TARGETPLATFORM TARGETVARIANT

ARG XOSC_SCENARIOS_ALKS_VERSION=master
ARG XOSC_SCENARIOS_ALKS_REPO_URL=https://github.com/openMSL/sl-3-1-osc-alks-scenarios.git

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,id=${TARGETPLATFORM}/var/cache/apt \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    apt-get install -qy --no-install-recommends \
        git \
        ca-certificates \
        && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

RUN git clone --branch=${XOSC_SCENARIOS_ALKS_VERSION} ${XOSC_SCENARIOS_ALKS_REPO_URL} /repository

FROM docker.io/library/busybox:latest AS xosc-scenarios-alks

VOLUME [ "/opt/xosc/scenarios" ]

COPY --from=xosc-scenarios-alks-cloner /repository/LICENSE /LICENSE
COPY --from=xosc-scenarios-alks-cloner /repository/logical_scenarios/concrete_scenarios /opt/xosc/scenarios/
