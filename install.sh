#!/bin/sh
set -e
STRATEGY=${1:-tar}
BRANCH=${2:-main}
VERSION="0.2.0"
GIT_REPO="https://github.com/nuxion/cloudscripts/"
TAR_REPO="https://github.com/nuxion/cloudscripts/archive/refs/tags/${VERSION}.tar.gz"
PROVIDER="undetected"
INSTALLDIR="/opt/cloudscripts"

# METADATA services by provider
AWS_META="http://169.254.169.254/latest/meta-data/"
GCE_META="http://metadata.google.internal/computeMetadata/v1/"


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
    curl -s "${AWS_META}" -o /dev/null
    status=$?
    if [ "$status" -eq 0 ];then
       echo "aws"
    fi
}

is_gce()
{
    curl -s "${GCE_META}instance" -H "Metadata-Flavor: Google" -o /dev/null
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

check_folder(){
    folder=$1
    if [ -d "${folder}" ];then
       echo "[X] a ${folder} found, delete it first or modify the installation script"
       exit 1
    fi

}

git_install(){
    echo $INSTALLDIR
    check_folder $INSTALLDIR
    if ! command_exists git
    then
        echo "=> Installing git"
    	$sh_c "apt-get install git -y --no-install-recommends > /dev/null 2>&1"
    fi
    git clone --quiet --branch $BRANCH --depth 1 $GIT_REPO
    echo "=> Cloning cloudscripts from ${GIT_REPO}"
    $sh_c "cp -R cloudscripts/ /opt"
    echo "=> Script files moved to /opt/cloudscripts"
    $sh_c "cp cloudscripts/scripts/cscli /usr/local/bin"
}


tar_install(){
    check_folder "${INSTALLDIR}-${VERSION}"
    curl -sL ${TAR_REPO} -o /tmp/${VERSION}.tgz
    echo "=> Downloading releases files from ${TAR_REPO}"
    if [ $? -ne 0 ]; then
        echo "[X] Downloaded failed"
    fi
    echo "=> Extracting files into /tmp/${VERSION}"
    tar xfz "/tmp/${VERSION}.tgz" -C /tmp
    sed -i "s/changeme/${PROVIDER}/g" /tmp/cloudscripts-${VERSION}/scripts/cscli
    $sh_c "mv /tmp/cloudscripts-${VERSION} ${INSTALLDIR}-${VERSION}"
    $sh_c "cp ${INSTALLDIR}-${VERSION}/scripts/cscli /usr/local/bin"
    echo "=> Script files moved to ${INSTALLDIR}-${VERSION}"
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
	detect_cloud_provider
    if [ "${STRATEGY}" = 'tar' ]; then
        tar_install
    else
        git_install
    fi

}
welcome
do_install
final
