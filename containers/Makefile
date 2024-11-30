ESMINI_IMAGE_NAME ?= ghcr.io/bounverif/esmini
ESMINI_VERSION ?= latest
ESMINI_CURRENT_VERSION := $(if $(filter latest,$(ESMINI_VERSION)),$(shell curl -s https://api.github.com/repos/esmini/esmini/releases/latest | jq -r .tag_name),$(ESMINI_VERSION))
CONTEXT ?= .
CONTAINER_CACHE_TTL=24h

info:
	@echo "esmini version: ${ESMINI_VERSION}"
	@echo "esmini current version: ${ESMINI_CURRENT_VERSION}"

version:
	${ESMINI_VERSION}=latest

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
	${CONTEXT}

headless: 
	buildah build \
		-f esmini-headless/Dockerfile \
		--build-arg ESMINI_IMAGE_NAME=${ESMINI_IMAGE_NAME} \
		--build-arg ESMINI_VERSION=${ESMINI_CURRENT_VERSION} \
		--format oci \
		--layers=true \
		--cache-ttl=${CONTAINER_CACHE_TTL} \
		--target esmini-headless \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_VERSION}-headless \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_CURRENT_VERSION}-headless \
	${CONTEXT}

video: headless
	buildah build \
		-f esmini-video/Dockerfile \
		--build-arg ESMINI_IMAGE_NAME=${ESMINI_IMAGE_NAME} \
		--build-arg ESMINI_VERSION=${ESMINI_CURRENT_VERSION} \
		--format oci \
		--cache-ttl=${CONTAINER_CACHE_TTL} \
		--target esmini-video \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_VERSION}-video \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_CURRENT_VERSION}-video \
	${CONTEXT}