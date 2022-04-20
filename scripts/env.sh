#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


if [[ -z "${CS_BASEDIR}" ]]; then
    # export BASEDIR=$(dirname "$0")
    export BASEDIR=$(dirname "$(readlink -f $0)")
else
    export BASEDIR="${CD_BASEDIR}"
fi
export PARENTDIR="$(dirname "$BASEDIR")"
echo "BASEDIR set as ${BASEDIR}"
echo "PARENTDIR set as ${PARENTDIR}"

export CURL=/usr/bin/curl
export COMMANDS="${BASEDIR}/commands"
export USR_LOCAL_BIN="/usr/local/bin"

source $BASEDIR/colors.sh

# PACKAGE VERSIONS
export GOPL_VERSION="v3.10.0"
