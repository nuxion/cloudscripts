#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

pkg="git"

install(){
    apt-get install git -y --no-install-recommends
}

verification(){
    # docker ps &> /dev/null
	command -v "${pkg}" > /dev/null 2>&1
}

if ! command -v $pkg &> /dev/null
then
	echo -e "=> ${magenta}${pkg}${clear} not found!"
    install
    status=$?
    verification
    verif_status=$?
    if [ "$status" -eq 0 ] && [ "$verif_status" -eq 0 ]; then
	    echo -e "=> ${magenta}${pkg}${clear} ${green}installed!${clear}"
    else
	    echo -e "[X] ${red}${pkg} installation failed!${clear}"
        exit -1
    fi
else
	echo -e "=> ${magenta}${pkg}${clear} found!"
fi
