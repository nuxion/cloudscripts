#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


install_command()
{
    pkg=$1
    source "${COMMANDS}/${pkg}.sh"
}

deploy_service(){
    srv=$1
    source "${SERVICES}/${srv}/deploy.sh"
}

export f install_service
export -f install_command
