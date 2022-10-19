#!/usr/bin/env bash
# docs
# https://prometheus.io/docs/guides/node-exporter/
VERSION="1.4.0"
URL="https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz"

pkg="node_exporter"

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

package_exists() {
    dpkg -s "$@"
}

install(){
    echo Downloading form $URL
    curl -sSL --output /tmp/node.tar.gz $URL
    tar xvfz /tmp/node.tar.gz -C /opt
    chmod +x  /opt/node_exporter-${VERSION}.linux-amd64/node_exporter
    ln -s /opt/node_exporter-${VERSION}.linux-amd64/node_exporter /usr/local/bin/node_exporter
}

verification(){
    command_exists $pkg
}

clean(){
    rm /tmp/node.tar.gz
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
