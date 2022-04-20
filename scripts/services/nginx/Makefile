.EXPORT_ALL_VARIABLES:
# VERSION := $(shell git describe --tags)
# BUILD := $(shell git rev-parse --short HEAD)
# PROJECTNAME := $(shell basename "$(PWD)")
# VARFILE := ${VARFILE}

# LDFLAGS=-ldflags "-X=main.Version=$(VERSION) -X=main.Build=$(BUILD)"
# STDERR := /tmp/.$(PROJECTNAME)-stderr.txt
#
.PHONY: install
install:
	scripts/install.sh

.PHONY: validate
deploy:
	systemctl start nginx

