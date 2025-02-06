#!/bin/sh -e
#
# Example Usage: 
# ESMINI_BUILD_INSTALL_PREFIX=~/pb ESMINI_BUILD_ASAM_OSI_VERSION=3.15.2 protobuf-install.sh

ESMINI_INSTALL_PREFIX=${ESMINI_INSTALL_PREFIX:-/usr/local}
ESMINI_BUILD_INSTALL_PREFIX=${ESMINI_BUILD_INSTALL_PREFIX:-${ESMINI_INSTALL_PREFIX}}
ESMINI_BUILD_OSI_SOURCE_DIR="/tmp/osi3"
ESMINI_BUILD_OSI_BUILD_DIR=${ESMINI_BUILD_OSI_SOURCE_DIR}/build

ESMINI_BUILD_OSI_SOURCE_REPOSITORY_URL="https://github.com/OpenSimulationInterface/open-simulation-interface"
ESMINI_BUILD_ASAM_OSI_VERSION=${ESMINI_BUILD_ASAM_OSI_VERSION:-3.7.0}

git clone "${ESMINI_BUILD_OSI_SOURCE_REPOSITORY_URL}" ${ESMINI_BUILD_OSI_SOURCE_DIR} \
  --depth 1 \
  --branch "v${ESMINI_BUILD_ASAM_OSI_VERSION}" \
  --recurse-submodules

if dpkg --compare-versions "${ESMINI_BUILD_ASAM_OSI_VERSION}" "lt" "3.8"; then
mkdir -p ${ESMINI_BUILD_OSI_SOURCE_DIR}/patch
cat >${ESMINI_BUILD_OSI_SOURCE_DIR}/patch/asam-osi-cmake.patch <<'EOF'
diff --git a/open_simulation_interface-config.cmake.in b/open_simulation_interface-config.cmake.in
index 615ec5c..a285246 100644
--- a/open_simulation_interface-config.cmake.in
+++ b/open_simulation_interface-config.cmake.in
@@ -6,5 +6,5 @@ find_dependency(Protobuf)
 if(NOT TARGET @PROJECT_NAME@ AND NOT @PROJECT_NAME@_BINARY_DIR)
   set_and_check(OPEN_SIMULATION_INTERFACE_INCLUDE_DIRS "@PACKAGE_OSI_INSTALL_INCLUDE_DIR@")
   set(OPEN_SIMULATION_INTERFACE_LIBRARIES "@PROJECT_NAME@")
-  include("${CMAKE_CURRENT_LIST_DIR}/open_simulation_interface_targets.cmake")
+  include("${CMAKE_CURRENT_LIST_DIR}/open_simulation_interface-targets.cmake")
 endif()
EOF
git -C ${ESMINI_BUILD_OSI_SOURCE_DIR} apply --whitespace=fix patch/asam-osi-cmake.patch
fi

cmake \
  -S ${ESMINI_BUILD_OSI_SOURCE_DIR} \
  -B ${ESMINI_BUILD_OSI_BUILD_DIR} \
  -DBUILD_SHARED_LIBS="${ESMINI_BUILD_OSI_BUILD_SHARED_LIBS}" \
  -DOSI_BUILD_FLATBUFFER=OFF \
  -DOSI_BUILD_DOCUMENTATION=OFF \
  -DOSI_INSTALL_LIB_DIR="${ESMINI_BUILD_INSTALL_PREFIX}\lib" \
  -DOSI_INSTALL_INCLUDE_DIR="${ESMINI_BUILD_INSTALL_PREFIX}\include" \
  -DCMAKE_INSTALL_PREFIX="${ESMINI_BUILD_INSTALL_PREFIX}"
  
mkdir -p "${ESMINI_BUILD_INSTALL_PREFIX}"
cmake --build ${ESMINI_BUILD_OSI_BUILD_DIR} --target install

# Cleanup
rm -rf ${ESMINI_BUILD_OSI_SOURCE_DIR} ${ESMINI_BUILD_OSI_BUILD_DIR}