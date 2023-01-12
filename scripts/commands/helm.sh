#!/usr/bin/env bash
# docs
#  https://helm.sh/docs/intro/install/
URL="https://baltocdn.com/helm/stable/debian/"

pkg="helm"

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

package_exists() {
    dpkg -s "$@"
}

install(){
    $CURL https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null
    apt-get install apt-transport-https --yes
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] ${URL} all main" > /etc/apt/sources.list.d/helm.list
    apt-get update
    apt-get install ${pkg} --yes --no-install-recommends
    # systemctl postgresql
}

verification(){
    package_exists $pkg
}

clean(){
    echo "Nothing to clean"
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
