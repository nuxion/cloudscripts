#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

pkg="docker"

install(){
    apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y
    $CURL -sSL https://get.docker.com/ | sh
    apt-get install docker-compose
}

if ! command -v $pkg &> /dev/null
then
	echo -e "=> ${magenta}${pkg}${clear} not found!"
    install
    status=$?
    if [ $status -eq 0 ]; then
	    echo -e "=> ${magenta}${pkg}${clear} ${green}installed!${clear}"
    else
	    echo -e "[X] ${red}${pkg} installation failed!${clear}"
    fi
else
	echo -e "=> ${magenta}${pkg}${clear} found!"
fi