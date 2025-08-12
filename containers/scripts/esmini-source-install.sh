#!/bin/sh
#
# Example Usage:
# ESMINI_INSTALL_PREFIX=/tmp/install ESMINI_ASAM_OSI_VERSION=3.7.0 asam-osi-source-install.sh

set -ex

ESMINI_INSTALL_PREFIX=${ESMINI_INSTALL_PREFIX:-/opt/esmini}

ESMINI_SOURCE_DIR="/tmp/esmini"
ESMINI_BUILD_DIR="/tmp/build/esmini"

ESMINI_GIT_URL="https://github.com/esmini/esmini.git"
ESMINI_VERSION="${ESMINI_ASAM_OSI_VERSION:-2.50.0}"
ESMINI_VERSION_PREFIX="${ESMINI_VERSION_PREFIX:-v}"

if [ ! -d "${ESMINI_SOURCE_DIR}" ]; then
  git clone "${ESMINI_GIT_URL}" ${ESMINI_SOURCE_DIR} \
    --depth 1 \
    --branch "${ESMINI_VERSION_PREFIX}${ESMINI_VERSION}" \
    --recurse-submodules

  if [ -f "${SCRIPT_DIR}/asam-osi-${ESMINI_VERSION}.patch" ]; then
    echo "Found patch for Esmini version ${ESMINI_VERSION}."

    if patch -p1 -d "${ESMINI_SOURCE_DIR}" < "${SCRIPT_DIR}/esmini-${ESMINI_VERSION}.patch"; then
      echo "Applied patches for Esmini version ${ESMINI_VERSION}."
    else
      echo "Failed to apply patch for Esmini version ${ESMINI_VERSION}."
    fi
  fi
fi

cmake -S ${ESMINI_SOURCE_DIR} -B ${ESMINI_BUILD_DIR} \
  -DDOWNLOAD_EXTERNALS=OFF \
  -DUSE_SUMO="${ESMINI_BUILD_USE_SUMO}" \
  -DUSE_GTEST="${ESMINI_BUILD_USE_GTEST}" \
  -DUSE_IMPLOT="${ESMINI_BUILD_USE_IMPLOT}" \
  -DUSE_OSG="${ESMINI_BUILD_USE_OSG}" \
  -DUSE_OSI="${ESMINI_BUILD_USE_OSI}" \
  -DDYN_PROTOBUF=ON
cmake --build ${ESMINI_BUILD_DIR} --target install

# Cleanup
# rm -rf ${ESMINI_SOURCE_DIR} ${ESMINI_BUILD_DIR}
