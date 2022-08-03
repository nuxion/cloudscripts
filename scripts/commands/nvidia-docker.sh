#!/usr/bin/env bash
# docs
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html 
source $BASEDIR/commands/nvidia-driver.sh
source $BASEDIR/commands/docker.sh

IMG_VERIFICATION="nvidia/cuda:11.0.3-base-ubuntu18.04"

pkg="nvidia-docker2"

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

package_exists(){
	dpkg -l "$@" > /dev/null 2>&1
}

install(){
    # apt install -t bullseye-backports nvidia-driver firmware-misc-nonfree --yes
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    $CURL -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && $CURL -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

    apt-get update && \
        apt-get install -y nvidia-docker2 && \
        systemctl restart docker
}

verification(){
    docker run --rm --gpus all ${IMG_VERIFICATION} nvidia-smi &> /dev/null
}

clean(){
    docker image rmi ${IMG_VERIFICATION} &> /dev/null
}

if ! package_exists $pkg &> /dev/null
then
	echo -e "=> ${magenta}${pkg}${clear} not found!"
	echo -e "=> ${magenta}${pkg}${clear} installing... be patient it will take some minutes"
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
