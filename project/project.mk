build-app:
	@echo "+ $@"
	@docker build -t ${APP_NAME} -f ./${DOCKERFILE} .
	@docker tag ${APP_NAME} ${DOCKER_HUB_REPO}/${APP_NAME}:latest

push-app:
	@echo "+ $@"
	@docker push docker.io/${DOCKER_HUB_REPO}/${APP_NAME}:latest
