MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(MAKEFILE_DIR)/project/project.mk

# DockerHub Repo address
DOCKER_HUB_REPO = umairedu

# project directory
DOCKERFILE = project/Dockerfile

# project app name
APP_NAME = flask_demo

help:
	@echo "From this makefile, you can control all your cluster operations and docker tasks"

.DEFAULT_GOAL := help

.PHONY: default list

list:
	docker ps -all
	docker images
	docker network ls

clean:
	docker system prune -f
	docker ps -all
	docker images

build: build-app push-app

push: push-app

up:
	vagrant up

destroy:
	vagrant destroy

halt:
	vagrant halt

suspend:
	vagrant suspende

resume:
	vagrant resume

app_update: build-app push-app
	vagrant ssh master -c "kubectl rollout restart deployment flask; kubectl get pods"
