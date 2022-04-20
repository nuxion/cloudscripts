#!/bin/bash

# docs
# https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html#package-manager

pkg=""
nvidia_repo="deb https://developer.download.nvidia.com/compute/cuda/repos/${OS_RELEASE}/x86_64/ /"
nvidia_keys="https://developer.download.nvidia.com/compute/cuda/repos/${OS_RELEASE}/x86_64/7fa2af80.pub"

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

install(){
    # apt install -t bullseye-backports nvidia-driver firmware-misc-nonfree --yes
    sed -i '/^\([^#].*main\)/s/main/& contrib non-free/' /etc/apt/sources.list
    apt-key adv --fetch-keys ${nvidia_keys}  && \
        add-apt-repository ${nvidia_repo} && \
	    add-apt-repository contrib && \
	    apt-get update && \
	    apt-get -y install cuda
}

if ! command_exists add-apt-repository
then
	apt-get install software-properties-common --yes
	apt-get update
fi


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
