#!/bin/bash

VERSION=$1

sed -i "/[[:space:]]VERSION/c\    VERSION=${VERSION}" install.sh
sed -i "/^VERSION/c\VERSION=${VERSION}" scripts/cscli
echo "Versions changed to ${VERSION}"
# git tag -a ${VERSION}
