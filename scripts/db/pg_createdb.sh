#!/bin/bash
# Standalone creation
DBNAME=${1:-adb}
DBUSER=${2:-defaultuser}
RAND=`openssl rand -base64 32`
DBUSER_PASS=${3:-$RAND}

run_psql(){
	sudo -u postgres psql -U postgres -c "$@"
}
# Standalone creation
run_psql "CREATE DATABASE ${DBNAME} WITH ENCODING 'UTF8'"
run_psql "create user ${DBUSER} with encrypted password '${DBUSER_PASS}'"
run_psql "grant all privileges on database ${DBNAME} to ${DBUSER};"

echo $DBUSER_PASS
