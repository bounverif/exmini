ESMINI_IMAGE_NAME ?= localhost/esmini
ESMINI_VERSION ?= latest
ESMINI_CURRENT_VERSION := $(if $(filter latest,$(ESMINI_VERSION)),$(shell curl -s https://api.github.com/repos/esmini/esmini/releases/latest | jq -r .tag_name),$(ESMINI_VERSION))
CONTAINER_BUILD_CONTEXT ?= .

info:
	@echo "esmini version: ${ESMINI_VERSION}"
	@echo "esmini current version: ${ESMINI_CURRENT_VERSION}"

builder:
	buildah build \
		-f esmini-devel/Dockerfile \
		--build-arg ESMINI_IMAGE_NAME=${ESMINI_IMAGE_NAME} \
		--build-arg ESMINI_VERSION=${ESMINI_CURRENT_VERSION} \
		--format oci \
		--layers=true \
		--target esmini-builder \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_VERSION}-builder \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_CURRENT_VERSION}-builder \
	${CONTAINER_BUILD_CONTEXT}

devel: builder
	buildah build \
		-f esmini-devel/Dockerfile \
		--build-arg ESMINI_IMAGE_NAME=${ESMINI_IMAGE_NAME} \
		--build-arg ESMINI_VERSION=${ESMINI_CURRENT_VERSION} \
		--format oci \
		--layers=true \
		--target esmini-devel \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_VERSION}-devel \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_CURRENT_VERSION}-devel \
	${CONTAINER_BUILD_CONTEXT}

runtime:
	buildah build \
		-f esmini-devel/Dockerfile \
		--build-arg ESMINI_IMAGE_NAME=${ESMINI_IMAGE_NAME} \
		--build-arg ESMINI_VERSION=${ESMINI_CURRENT_VERSION} \
		--format oci \
		--layers=true \
		--target esmini-runtime \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_VERSION} \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_CURRENT_VERSION} \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_VERSION}-runtime \
		--tag ${ESMINI_IMAGE_NAME}:${ESMINI_CURRENT_VERSION}-runtime \
	${CONTAINER_BUILD_CONTEXT}

xosc-scnearios-alks:
	buildah build \
		-f xosc-scenarios-alks/Dockerfile \
		--format oci \
		--layers=true \
		--target xosc-scenarios-alks \
		--tag localhost/xosc-scenarios-alks:latest \
	${CONTAINER_BUILD_CONTEXT}
