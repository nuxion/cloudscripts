#!/bin/bash

VERSION=$1

if [[ -z "${VERSION}" ]]; then
    echo "usage: ./release.sh <version>    (e.g. ./release.sh 0.7.1)"
    exit 1
fi

sed -i "/[[:space:]]VERSION/c\    VERSION=${VERSION}" install.sh
sed -i "/^VERSION/c\VERSION=${VERSION}" scripts/cscli
sed -i "s#| VERSION=[0-9][0-9A-Za-z.-]* sh#| VERSION=${VERSION} sh#" README.md
echo "Versions changed to ${VERSION}"
# git tag -a ${VERSION}
