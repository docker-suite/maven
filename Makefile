DOCKER_IMAGE=dsuite/maven
DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))


build: build-3.5-jdk7 build-3.5-jdk8 build-3.6-jdk7 build-3.6-jdk8

test: test-3.5-jdk7 test-3.5-jdk8 test-3.6-jdk7 test-3.6-jdk8

push: push-3.5-jdk7 push-3.5-jdk8 push-3.6-jdk7 push-3.6-jdk8

build-3.5-jdk7:
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-3.5-jdk7 \
		--tag $(DOCKER_IMAGE):3.5-jdk7 \
		$(DIR)/Dockerfiles

build-3.5-jdk8:
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-3.5-jdk8 \
		--tag $(DOCKER_IMAGE):3.5-jdk8 \
		$(DIR)/Dockerfiles

build-3.6-jdk7:
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-3.6-jdk7 \
		--tag $(DOCKER_IMAGE):3.6-jdk7 \
		$(DIR)/Dockerfiles

build-3.6-jdk8:
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-3.6-jdk8 \
		--tag $(DOCKER_IMAGE):3.6-jdk8 \
		$(DIR)/Dockerfiles

	docker tag $(DOCKER_IMAGE):3.6-jdk8 $(DOCKER_IMAGE):latest

test-3.5-jdk7: build-3.5-jdk7
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):3.5-jdk7

test-3.5-jdk8: build-3.5-jdk8
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):3.5-jdk8

test-3.6-jdk7: build-3.6-jdk7
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):3.6-jdk7

test-3.6-jdk8: build-3.6-jdk8
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):3.6-jdk8

push-3.5-jdk7: build-3.5-jdk7
	@docker push $(DOCKER_IMAGE):3.5-jdk7

push-3.5-jdk8: build-3.5-jdk8
	@docker push $(DOCKER_IMAGE):3.5-jdk8

push-3.6-jdk7: build-3.6-jdk7
	@docker push $(DOCKER_IMAGE):3.6-jdk7
	@docker push $(DOCKER_IMAGE):latest

push-3.6-jdk8: build-3.6-jdk8
	@docker push $(DOCKER_IMAGE):3.6-jdk8

shell-3.5-jdk7: build-3.5-jdk7
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		-e TZ=Europe/Paris \
		$(DOCKER_IMAGE):3.5-jdk7 \
		bash

shell-3.5-jdk8: build-3.5-jdk8
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		$(DOCKER_IMAGE):3.5-jdk8 \
		bash

shell-3.6-jdk7: build-3.6-jdk7
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		$(DOCKER_IMAGE):3.6-jdk7 \
		bash

shell-3.6-jdk8: build-3.6-jdk8
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		$(DOCKER_IMAGE):3.6-jdk8 \
		bash

remove:
	@docker images | grep $(DOCKER_IMAGE) | tr -s ' ' | cut -d ' ' -f 2 | xargs -I {} docker rmi $(DOCKER_IMAGE):{}

