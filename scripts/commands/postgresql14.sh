#!/usr/bin/env bash
# docs
#  https://computingforgeeks.com/how-to-install-postgresql-14-on-debian/
URL="http://apt.postgresql.org/pub/repos/apt"

pkg="postgresql-14"

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

package_exists() {
    dpkg -s "$@"
}

install(){
    echo "deb ${URL} $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
    $CURL -fsSL -o /tmp/psql.asc https://www.postgresql.org/media/keys/ACCC4CF8.asc
    cat /tmp/psql.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/psql.gpg
    apt-get update
    apt-get install ${pkg} --yes --no-install-recommends
    # systemctl postgresql
}

verification(){
    package_exists postgresql-14
}

clean(){
    rm /tmp/psql.asc
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
