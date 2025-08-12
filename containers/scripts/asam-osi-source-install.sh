#!/bin/sh
#
# Example Usage:
# ESMINI_INSTALL_PREFIX=/tmp/install ESMINI_ASAM_OSI_VERSION=3.7.0 asam-osi-source-install.sh

set -ex

PROTOBUF_INSTALL_PREFIX=${PROTOBUF_INSTALL_PREFIX:-/opt/bazalt}
ESMINI_INSTALL_PREFIX=${ESMINI_INSTALL_PREFIX:-/usr/local}

ESMINI_OSI_SOURCE_DIR="/tmp/esmini/osi3"
ESMINI_OSI_BUILD_DIR=${ESMINI_OSI_SOURCE_DIR}/build

ESMINI_OSI_GIT_URL="https://github.com/OpenSimulationInterface/open-simulation-interface"
ESMINI_ASAM_OSI_VERSION=${ESMINI_ASAM_OSI_VERSION:-master}

if [ ! -d "${ESMINI_OSI_SOURCE_DIR}" ]; then
  git clone "${ESMINI_OSI_GIT_URL}" ${ESMINI_OSI_SOURCE_DIR} \
    --depth 1 \
    --branch "${ESMINI_ASAM_OSI_VERSION}" \
    --recurse-submodules

  if [ -f "${SCRIPT_DIR}/asam-osi-${ESMINI_ASAM_OSI_VERSION}.patch" ]; then
    echo "Found patch for ASAM OSI version ${ESMINI_ASAM_OSI_VERSION}."

    if patch -p1 -d "${ESMINI_OSI_SOURCE_DIR}" < "${SCRIPT_DIR}/asam-osi-${ESMINI_ASAM_OSI_VERSION}.patch"; then
      echo "Applied patches for ASAM OSI version ${ESMINI_ASAM_OSI_VERSION}."
    else
      echo "Failed to apply patch for ASAM OSI version ${ESMINI_ASAM_OSI_VERSION}."
    fi
  fi
fi

cmake \
  -S ${ESMINI_OSI_SOURCE_DIR} \
  -B ${ESMINI_OSI_BUILD_DIR} \
  -DBUILD_SHARED_LIBS="${ESMINI_OSI_BUILD_SHARED_LIBS}" \
  -DOSI_BUILD_FLATBUFFER=OFF \
  -DOSI_BUILD_DOCUMENTATION=OFF \
  -DOSI_INSTALL_LIB_DIR="${ESMINI_INSTALL_PREFIX}/lib" \
  -DOSI_INSTALL_INCLUDE_DIR="${ESMINI_INSTALL_PREFIX}/include" \
  -DCMAKE_PREFIX_PATH="${PROTOBUF_INSTALL_PREFIX};${CMAKE_PREFIX_PATH}" \
  -DCMAKE_INSTALL_PREFIX="${ESMINI_INSTALL_PREFIX}"
cmake --build ${ESMINI_OSI_BUILD_DIR} --target install

# Cleanup
rm -rf ${ESMINI_OSI_SOURCE_DIR} ${ESMINI_OSI_BUILD_DIR}
