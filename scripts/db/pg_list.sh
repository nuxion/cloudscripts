#!/bin/bash
# Standalone creation
DBNAME=${1:-adb}
DBUSER=${2:-defaultuser}
RAND=`openssl rand -base64 32`
DBUSER_PASS=${3:-$RAND}

run_psql(){
	sudo -u postgres psql -c "$@"
}
run_psql "\l"
