#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
# docs
# The installation procces of nvidia docker and nvidia driver is very tricky
# it has a matrix of conditions that should match to be succesfully, for instance
# until 2022 january, nvidia-docker doesnt work in debian 11 because cgroups
# driver version, hardware card, cloud provider, S.O. and version S.O.,
# all of it should be taked in consideration as a matrix support. 

pkg="cuda"
pkg_test="nvidia-smi"
	

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

package_exists(){
	dpkg -l "$@" > /dev/null 2>&1
}

add_apt()
{
    if ! command_exists add-apt-repository
    then
        apt-get install software-properties-common --yes
        apt-get update
    fi
}

verification(){
    nvidia-smi 2>&1
}

install_gce(){
    # https://cloud.google.com/compute/docs/gpus/install-drivers-gpu
    python3 $BASEDIR/ext/gce/install_gpu_driver.py
}

install_agnostic(){
    # https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html#package-manager
    # apt install -t bullseye-backports nvidia-driver firmware-misc-nonfree --yes
    echo OS release: ${OS_RELEASE}
    # add_contrib
    add_apt
    nvidia_repo="https://developer.download.nvidia.com/compute/cuda/11.6.2/local_installers/cuda-repo-debian11-11-6-local_11.6.2-510.47.03-1_amd64.deb"
    nvidia_key="/var/cuda-repo-debian11-11-6-local/7fa2af80.pub"
    $CURL -L $nvidia_repo -o /tmp/cuda.deb
    apt-key add $nvidia_key
    add-apt-repository contrib
    apt-get update
    apt-get -y install cuda
}

detect_card(){
    lspci | grep NVIDIA &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo -e "${red}WARNING: NVIDIA card not found, the installation could fail${clear}"
    fi
}


if ! package_exists "$pkg_test" &> /dev/null
then
	echo -e "=> ${magenta}${pkg}${clear} not found!"

    detect_card

    if [ "$CLOUD_PROVIDER" = "gce" ]; then
        install_gce
        status=$?
    else
        install
        status=$?
    fi
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
