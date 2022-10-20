define USAGE
CloudScripts utils

Commands:
	setup     Install dependencies, dev included
	lock      Generate requirements.txt
	test      Run tests
	lint      Run linting tests
	run       Run docker image with --rm flag but mounted dirs.
	release   Publish docker image based on some variables
	docker    Build the docker image
	tag    	  Make a git tab using poetry information

endef

export USAGE
.EXPORT_ALL_VARIABLES:
GIT_TAG := $(shell git describe --tags)

PROJECTNAME := $(shell basename "$(PWD)")
PACKAGE_DIR = $(shell basename "$(PWD)")
DOCKERID = $(shell echo "nuxion")
VERSION="0.1.0"

.PHONY: dev
dev:
	./utils/devenv.sh

.PHONY: docker-dev
docker-dev:
	docker build -t ${DOCKERID}/${PACKAGE_DIR}-dev -f Dockerfile.dev .

.PHONY: release
release:
	  ./release.sh 

last:
	git describe --tags

