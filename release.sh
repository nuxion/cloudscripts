#!/bin/sh

VERSION="\"$(git describe --tags)\""

sed -i "/^VERSION/c\VERSION=${VERSION}" install.sh
sed -i "/^VERSION/c\VERSION=${VERSION}" scripts/cscli
echo "Versions changed to ${VERSION}"
