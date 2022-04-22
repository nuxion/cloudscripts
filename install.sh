#!/bin/sh
set -e

BRANCH=${1:-main}
GIT_REPO="https://github.com/nuxion/cloudscripts/"
PROVIDER="undetected"
VERSION="0.1.0-RC"
INSTALLDIR="/opt/cloudscripts"

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

welcome(){
	echo "=> Running CloudScript installation"
	echo "   refer to https://github.com/nuxion/cloudscripts/ for more information"
	echo
	echo "   WARNING: This scripts need root rights for working with directories in /opt"
	echo
}

final(){
    echo "[OK] cscli installed on /usr/local/bin :)" 
}

is_aws()
{
    curl -s "http://169.254.169.254/latest/meta-data/" -o /dev/null
    status=$?
    if [ "$status" -eq 0 ];then
       echo "aws"
    fi
}

is_gce()
{
    curl -s "http://metadata.google.internal/computeMetadata/v1/instance" -H "Metadata-Flavor: Google" -o /dev/null
    status=$?
    if [ "$status" -eq 0 ];then
       echo "gce"
    fi
}

detect_cloud_provider(){
    PROVIDER=$( is_gce )
    echo $PROVIDER
    if [ $PROVIDER != "gce" ]; then
        PROVIDER=$( is_aws )
        echo "=> WARNING: Some scripts could not work in AMAZON AWS provider"
        if [ $PROVIDER != "aws" ]; then
            echo "=> WARNING: nor GCE nor AWS cloud env found"
        fi
    fi
    echo "=> Provider identified as ${PROVIDER}"
}

do_install(){
    	user="$(id -un 2>/dev/null || true)"

	sh_c='sh -c'
	if [ "$user" != 'root' ]; then
		if command_exists sudo; then
			sh_c='sudo -E sh -c'
		elif command_exists su; then
			sh_c='su -c'
		else
			cat >&2 <<-'EOF'
			Error: this installer needs the ability to run commands as root.
			We are unable to find either "sudo" or "su" available to make this happen.
			EOF
			exit 1
		fi
	fi

	# if ! command_exists git
	# then
 	#       $sh_c "apt-get install git -y --no-install-recommends"
    # 	fi
    # git clone --branch $BRANCH --depth 1 $GIT_REPO
    detect_cloud_provider
    URL="https://github.com/nuxion/cloudscripts/archive/refs/tags/${VERSION}.tar.gz"
    curl -sL ${URL} -o /tmp/${VERSION}.tgz
    echo "=> Downloading releases files from ${URL}" 
    if [ $? -ne 0 ]; then
        echo "[X] Downloaded failed"
    fi
    echo "=> Extracting files into /tmp/${VERSION}" 
    tar xfz "/tmp/${VERSION}.tgz" 
    sed -i "s/changeme/${PROVIDER}/g" /tmp/cloudscripts-${VERSION}/scripts/cscli
    if [ -d "${INSTALLDIR}-${VERSION}" ];then
       echo "[X] a ${INSTALLDIR}-${VERSION} found, delete it first or modify the installation script"
       exit 1
    fi
    $sh_c "mv cloudscripts-${VERSION} ${INSTALLDIR}-${VERSION}"
    $sh_c "cp ${INSTALLDIR}-${VERSION}/scripts/cscli /usr/local/bin"
    echo "=> Script files moved to ${INSTALLDIR}-${VERSION}" 
}
welcome
do_install
final
