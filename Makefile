## Name of the image
DOCKER_IMAGE=dsuite/maven
DOCKER_IMAGE_CREATED=$(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
DOCKER_IMAGE_REVISION=$(shell git rev-parse --short HEAD)

## Current directory
DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

## Define the latest version
base_image = openjdk:16-alpine
maven_version = 3.8.2
image_name = 3.8-openjdk-16

## Config
.DEFAULT_GOAL := help
.PHONY: *

help: ## This help!
	@printf "\033[33mUsage:\033[0m\n  make [target] [arg=\"val\"...]\n\n\033[33mTargets:\033[0m\n"
	@grep -E '^[-a-zA-Z0-9_\.\/]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[32m%-15s\033[0m %s\n", $$1, $$2}'

build-all: ## Build all supported versions
	@$(MAKE) build	base=openjdk:7-alpine version=3.5.4 name=3.5-openjdk-7
	@$(MAKE) build	base=openjdk:7-alpine version=3.6.3 name=3.6-openjdk-7
	@$(MAKE) build	base=openjdk:7-alpine version=3.8.2 name=3.8-openjdk-7
	@$(MAKE) build	base=openjdk:8-alpine version=3.5.4 name=3.5-openjdk-8
	@$(MAKE) build	base=openjdk:8-alpine version=3.6.3 name=3.6-openjdk-8
	@$(MAKE) build	base=openjdk:8-alpine version=3.8.2 name=3.8-openjdk-8
	@$(MAKE) build	base=openjdk:16-alpine version=3.8.2 name=3.8-openjdk-16

test-all: ## Test all supported versions
	@$(MAKE) test v=3.5-openjdk-7
	@$(MAKE) test v=3.6-openjdk-7
	@$(MAKE) test v=3.8-openjdk-7
	@$(MAKE) test v=3.5-openjdk-8
	@$(MAKE) test v=3.6-openjdk-8
	@$(MAKE) test v=3.8-openjdk-8
	@$(MAKE) test v=3.8-openjdk-16

push-all: ## Push all supported versions
	@$(MAKE) push v=3.5-openjdk-7
	@$(MAKE) push v=3.6-openjdk-7
	@$(MAKE) push v=3.8-openjdk-7
	@$(MAKE) push v=3.5-openjdk-8
	@$(MAKE) push v=3.6-openjdk-8
	@$(MAKE) push v=3.8-openjdk-8
	@$(MAKE) push v=3.8-openjdk-16

build:
	$(eval base := $(or $(b),$(base),$(base_image)))
	$(eval version := $(or $(v),$(version),$(maven_version)))
	$(eval name := $(or $(n),$(name),$(image_name)))
	@docker run --rm \
		-e BASE_IMAGE=$(base) \
		-e MAVEN_VERSION=$(version) \
		-e DOCKER_IMAGE_CREATED=$(DOCKER_IMAGE_CREATED) \
		-e DOCKER_IMAGE_REVISION=$(DOCKER_IMAGE_REVISION) \
		-v $(DIR)/Dockerfiles:/data \
		dsuite/alpine-data \
		sh -c "templater Dockerfile.template > Dockerfile-$(name)"
	@docker build \
		--build-arg GH_TOKEN=${GH_TOKEN} \
		--file $(DIR)/Dockerfiles/Dockerfile-$(name) \
		--tag $(DOCKER_IMAGE):$(name) \
		$(DIR)/Dockerfiles
	@[ "$(version)" = "$(maven_version)" ] && docker tag $(DOCKER_IMAGE):$(name) $(DOCKER_IMAGE):latest || true

test:
	$(eval version := $(or $(v),$(latest)))
	@GOSS_FILES_PATH=$(DIR)/tests \
	GOSS_SLEEP=0.5 \
	 	dgoss run $(DOCKER_IMAGE):$(version) bash -c "sleep 60"

push:
	$(eval version := $(or $(v),$(latest)))
	@docker push $(DOCKER_IMAGE):$(version)
	@[ "$(version)" = "$(latest)" ] && docker push $(DOCKER_IMAGE):latest || true

shell: ## Run shell ( usage : make shell n=3.5-openjdk-7-alpine )
	$(eval name := $(or $(n),$(name),$(image_name)))
	@mkdir -p $(DIR)/.m2
	@docker run -it --rm \
		-e DEBUG_LEVEL=DEBUG \
		-v $(DIR)/.m2:/root/.m2 \
		-w /root/.m2 \
		$(DOCKER_IMAGE):$(name) \
		bash

remove: ## Remove all generated images
	@docker images | grep $(DOCKER_IMAGE) | tr -s ' ' | cut -d ' ' -f 2 | xargs -I {} docker rmi $(DOCKER_IMAGE):{} || true
	@docker images | grep $(DOCKER_IMAGE) | tr -s ' ' | cut -d ' ' -f 3 | xargs -I {} docker rmi {} || true

readme: ## Generate docker hub full description
	@docker run -t --rm \
		-e DOCKER_USERNAME=${DOCKER_USERNAME} \
		-e DOCKER_PASSWORD=${DOCKER_PASSWORD} \
		-e DOCKER_IMAGE=${DOCKER_IMAGE} \
		-v $(DIR):/data \
		dsuite/hub-updater
