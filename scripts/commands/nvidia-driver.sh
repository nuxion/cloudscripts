#!/bin/bash

# docs
# https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html#package-manager

pkg="cuda"
# nvidia_repo="deb https://developer.download.nvidia.com/compute/cuda/repos/${OS_RELEASE}/x86_64/ /"
# nvidia_keys="https://developer.download.nvidia.com/compute/cuda/repos/${OS_RELEASE}/x86_64/7fa2af80.pub"
nvidia_repo="https://developer.download.nvidia.com/compute/cuda/11.6.2/local_installers/cuda-repo-debian11-11-6-local_11.6.2-510.47.03-1_amd64.deb"
nvidia_key="/var/cuda-repo-debian11-11-6-local/7fa2af80.pub"

	

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

package_exists(){
	dpkg -l "$@" > /dev/null 2>&1
}

add_contrib(){
	if ! grep contrib non-free /etc/apt/sources.list 2>&1
	then
    		sed -i '/^\([^#].*main\)/s/main/& contrib non-free/' /etc/apt/sources.list
	fi
}

install(){
    # apt install -t bullseye-backports nvidia-driver firmware-misc-nonfree --yes
    echo OS release: ${OS_RELEASE}
    # add_contrib
    $CURL -L $nvidia_repo -o /tmp/cuda.deb
    apt-key add $nvidia_key
    add-apt-repository contrib
    apt-get update
    apt-get -y install cuda
}

if ! command_exists add-apt-repository
then
	apt-get install software-properties-common --yes
	apt-get update
fi


if ! package_exists $pkg &> /dev/null
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
