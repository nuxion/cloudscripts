#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

GOPL_DOWNLOAD="https://github.com/hairyhenderson/gomplate/releases/download/${GOPL_VERSION}/gomplate_linux-amd64-slim"

install(){
	$CURL -Ls $GOPL_DOWNLOAD > /tmp/gomplate
	mv /tmp/gomplate $USR_LOCAL_BIN
	chmod +x $USR_LOCAL_BIN/gomplate
}


if ! command -v gomplate &> /dev/null
then
	echo -e "=> ${magenta}gomplate${clear} not found!"
    install
    status=$?
    if [ $status -eq 0 ]; then
	    echo -e "=> ${magenta}gomplate${clear} ${green}installed!${clear}"
    else
	    echo -e "[X] ${red}${pkg} installation failed!${clear}"
    fi

else
	echo -e "=> ${magenta}gomplate${clear} found!"
fi

