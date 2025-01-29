#!/bin/bash -e
OSG_VERSION="3.6.5"
FBXSDK_VERSION_MAJOR="${FBXSDK_VERSION_MAJOR:-2020}"
FBXSDK_VERSION_MINOR="${FBXSDK_VERSION_MINOR:-3}"
FBXSDK_VERSION_PATCH="${FBXSDK_VERSION_PATCH:-2}"
FBXSDK_VERSION="${FBXSDK_VERSION_MAJOR}${FBXSDK_VERSION_MINOR}${FBXSDK_VERSION_PATCH}"
FBXSDK_VERSION_DASHED="${FBXSDK_VERSION_MAJOR}-${FBXSDK_VERSION_MINOR}-${FBXSDK_VERSION_PATCH}"
FBXSDK_DOWNLOAD_URL="https://www.autodesk.com/content/dam/autodesk/www/adn/fbx/${FBXSDK_VERSION_DASHED}/fbx${FBXSDK_VERSION}_fbxsdk_linux.tar.gz"
mkdir -p /tmp/fbxsdk
mkdir -p /tmp/fbxsdk/install
curl -kL --user-agent "Mozilla/5.0" ${FBXSDK_DOWNLOAD_URL} | tar xzv -C /tmp/fbxsdk
yes yes | /tmp/fbxsdk/fbx${FBXSDK_VERSION}_fbxsdk_linux /tmp/fbxsdk/install
git clone --single-branch --depth 1 --branch OpenSceneGraph-${OSG_VERSION} https://github.com/OpenSceneGraph/OpenSceneGraph /tmp/osg
cd /tmp/osg
cmake . \
  -DFBX_INCLUDE_DIR="/tmp/fbxsdk/install/include" \
  -DFBX_LIBRARY="/tmp/fbxsdk/install/lib/gcc/x64/release/libfbxsdk.a" \
  -DFBX_LIBRARY_DEBUG="/tmp/fbxsdk/install/lib/gcc/x64/debug/libfbxsdk.a" \
  -DCMAKE_INSTALL_PREFIX="/usr/lib64"
cmake --build . --target install -j4
rm -rf /tmp/fbxsdk /tmp/osg