#Dockerfile vars

#vars
TAG=v1.4.79
IMAGENAME=docker-lighttpd
IMAGEFULLNAME=avhost/${IMAGENAME}
BUILDDATE=$(shell date -u +%Y%m%d)
BRANCH=${TAG}
LASTCOMMIT=$(shell git log -1 --pretty=short | tail -n 1 | tr -d " " | tr -d "UPDATE:")

help:
	    @echo "Makefile arguments:"
	    @echo ""
	    @echo "Makefile commands:"
	    @echo "build"
			@echo "publish-latest"
			@echo "publish-tag"

.DEFAULT_GOAL := all

sboom:
	syft dir:. > sbom.txt
	syft dir:. -o json > sbom.json

seccheck:
	grype --add-cpes-if-none .

imagecheck:
	grype --add-cpes-if-none ${IMAGEFULLNAME}:latest > cve-report.md

build:
	@echo ">>>> Build docker image"
	@docker build --build-arg TAG=${TAG} --build-arg BUILDDATE=${BUILDDATE} -t ${IMAGEFULLNAME}:latest .

push:
	@echo ">>>> Publish docker image: " ${BRANCH}
	@docker buildx create --use --name buildkit
	@docker buildx build  --sbom=true --provenance=true  --platform linux/arm64,linux/amd64 --push -t ${IMAGEFULLNAME}:${BRANCH} .
	@docker buildx build  --sbom=true --provenance=true  --platform linux/arm64,linux/amd64 --push -t ${IMAGEFULLNAME}:latest .
	@docker buildx rm buildkit

all: build seccheck imagecheck sboom
