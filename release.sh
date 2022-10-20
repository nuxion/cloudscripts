#!/bin/sh
ensure_var()
{
    if [[ -z "${!1:-}" ]];
    then
        echo "${1} is unset"
        exit 1
    else
        echo "${1} is ${!1}"
    fi
}


ensure_var VERSION
sed -i "/[[:space:]]VERSION/c\    VERSION=${VERSION}" install.sh
sed -i "/^VERSION/c\VERSION=${VERSION}" scripts/cscli
echo "Versions changed to ${VERSION}"
# git tag -a ${VERSION}
