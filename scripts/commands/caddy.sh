#!/usr/bin/env bash
# docs
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html 
source $BASEDIR/commands/nvidia-driver.sh
source $BASEDIR/commands/docker.sh

URL="https://caddyserver.com/api/download?os=linux&arch=amd64&idempotency=371179942471"

pkg="caddy"

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

install(){
    # apt install -t bullseye-backports nvidia-driver firmware-misc-nonfree --yes
    $CURL -Ls $URL > /tmp/caddy
    mv /tmp/caddy $USR_LOCAL_BIN
    chmod +x $USR_LOCAL_BIN/caddy
}

verification(){
    caddy version
}

clean(){
    rm $USR_LOCAL_BIN/caddy
}

if ! command_exists $pkg &> /dev/null
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
    fi
    echo -e "=> Cleaning"
    clean
else
	echo -e "=> ${magenta}${pkg}${clear} found!"
fi
