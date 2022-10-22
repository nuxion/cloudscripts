#!/bin/bash
# Standalone creation
RAND=`openssl rand -base64 32`
PASS=${1:-$RAND}
PG_USER=${2:-postgres}
sudo -u postgres psql -c "ALTER USER ${PG_USER} PASSWORD '${PASS}'" &> /dev/null
echo "${PASS}"
