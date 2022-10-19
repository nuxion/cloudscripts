#!/bin/bash

docker run --rm -it \
	-v $PWD:/app \
	-p 127.0.0.1:9101:9100 \
	nuxion/cloudscripts-dev bash
