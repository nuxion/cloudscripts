#!/bin/sh
set -e 

BRANCH=${1:-main}
GIT_REPO=https://github.com/nuxion/cloudscripts/

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

welcome(){
	echo
	echo "Running CloudScript installation"
	echo "refer to https://github.com/nuxion/cloudscripts/ for more information"
	echo
	echo "WARNING: This scripts need root rights for packages installations like git"
	echo
	echo "================================================================================"
	echo

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


	if [ !command_exists git]; then
 	       $sh_c "apt-get install git -y --no-installrecommends"
    	fi

    	git clone --branch $BRANCH --depth 1 $GIT_REPO
    	$sh_c "cp -R cloudscripts/ /opt"
	$sh_c "cp cloudscripts/scripts/cscli /usr/local/bin" 
}

do_install
