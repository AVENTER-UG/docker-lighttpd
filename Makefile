#Dockerfile vars

#vars
TAG=v1.4.79
IMAGENAME=docker-lighttpd
IMAGEFULLNAME=avhost/${IMAGENAME}
BUILDDATE=$(shell date -u +%Y%m%d)

help:
	    @echo "Makefile arguments:"
	    @echo ""
	    @echo "Makefile commands:"
	    @echo "build"
			@echo "publish-latest"
			@echo "publish-tag"

.DEFAULT_GOAL := all

build:
	@echo ">>>> Build docker image"
	@docker buildx build --build-arg TAG=${TAG} --build-arg BUILDDATE=${BUILDDATE} -t ${IMAGEFULLNAME}:${TAG} .

push:
	@echo ">>>> Publish docker image: " ${TAG}_${BUILDDATE}
	docker buildx build --push --build-arg TAG=${TAG} --build-arg BUILDDATE=${BUILDDATE} -t ${IMAGEFULLNAME}:latest .
	docker buildx build --push --build-arg TAG=${TAG} --build-arg BUILDDATE=${BUILDDATE} -t ${IMAGEFULLNAME}:${TAG} .
	docker buildx build --push --build-arg TAG=${TAG} --build-arg BUILDDATE=${BUILDDATE} -t ${IMAGEFULLNAME}:${TAG}_${BUILDDATE} .


all: build
