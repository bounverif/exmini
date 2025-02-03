ESMINI_IMAGE_NAME ?= localhost/esmini
ESMINI_VERSION ?= latest
ESMINI_CURRENT_VERSION := $(if $(filter latest,$(ESMINI_VERSION)),$(shell curl -s https://api.github.com/repos/esmini/esmini/releases/latest | jq -r .tag_name),$(ESMINI_VERSION))
CONTAINER_BUILD_CONTEXT ?= .
CONTAINER_CACHE_TTL=24h

info:
	@echo "esmini version: ${ESMINI_VERSION}"
	@echo "esmini current version: ${ESMINI_CURRENT_VERSION}"

openscenegraph: 
	buildah build \
		-f esmini-builder/Dockerfile \
		--build-arg ESMINI_BUILD_OSG_VERSION=3.6.5 \
		--format oci \
		--layers=true \
		--target osg-builder \
		--tag ${ESMINI_IMAGE_NAME}:3.6.5-openscenegraph \
		--tag ${ESMINI_IMAGE_NAME}:latest-openscenegraph \
	${CONTAINER_BUILD_CONTEXT}

builder: 
	buildah build \
		-f esmini-builder/Dockerfile \
		--build-arg ESMINI_IMAGE_NAME=${ESMINI_IMAGE_NAME} \
		--build-arg ESMINI_VERSION=${ESMINI_CURRENT_VERSION} \
		--format oci \
		--layers=true \
		--cache-ttl=${CONTAINER_CACHE_TTL} \
		--target esmini-builder \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_VERSION}-builder \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_CURRENT_VERSION}-builder \
	${CONTAINER_BUILD_CONTEXT}

devel: builder
	buildah build \
		-f esmini-builder/Dockerfile \
		--build-arg ESMINI_IMAGE_NAME=${ESMINI_IMAGE_NAME} \
		--build-arg ESMINI_VERSION=${ESMINI_CURRENT_VERSION} \
		--format oci \
		--layers=true \
		--cache-ttl=${CONTAINER_CACHE_TTL} \
		--target esmini-devel \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_VERSION}-devel \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_CURRENT_VERSION}-devel \
	${CONTAINER_BUILD_CONTEXT}

runtime:
	buildah build \
		-f esmini-runtime/Dockerfile \
		--build-arg ESMINI_IMAGE_NAME=${ESMINI_IMAGE_NAME} \
		--build-arg ESMINI_VERSION=${ESMINI_CURRENT_VERSION} \
		--format oci \
		--layers=true \
		--cache-ttl=${CONTAINER_CACHE_TTL} \
		--target esmini-runtime \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_VERSION} \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_CURRENT_VERSION} \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_VERSION}-runtime \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_CURRENT_VERSION}-runtime \
	${CONTAINER_BUILD_CONTEXT}

video: headless
	buildah build \
		-f esmini-video/Dockerfile \
		--build-arg ESMINI_IMAGE_NAME=${ESMINI_IMAGE_NAME} \
		--build-arg ESMINI_VERSION=${ESMINI_CURRENT_VERSION} \
		--format oci \
		--layers=true \
		--cache-ttl=${CONTAINER_CACHE_TTL} \
		--target esmini-video \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_VERSION}-video \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_CURRENT_VERSION}-video \
	${CONTAINER_BUILD_CONTEXT}

xosc-scnearios-alks: 
	buildah build \
		-f xosc-scenarios-alks/Dockerfile \
		--format oci \
		--layers=true \
		--target xosc-scenarios-alks \
		--tag localhost/xosc-scenarios-alks:latest \
	${CONTAINER_BUILD_CONTEXT}
