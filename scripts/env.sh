#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

export MAIN_CONFIG=${CS_CONFIG:-"./config.yaml"}

# so environments
export DEBIAN_VERSION=debian11
export DEBIAN_FRONTEND=noninteractive
export OS_RELEASE=$(. /etc/os-release;echo $ID$VERSION_ID | sed -e 's/\.//g')
export OP_USER="op"
export OP_GROUP="op"

# commands versions
export GOPL_VERSION="v3.10.0"
