#!/bin/bash
# Standalone creation
DBNAME=${1}
# BUCKET=${2}
LOCAL_DIR="/opt/backups"
TIMESTAMP=$(date +%F_%T | tr ':' '-')
TEMP_FILE=$(mktemp ${DBNAME}.XXXXX.tar)

if [ ! -d $LOCAL_DIR ];
then
	mkdir -p $LOCAL_DIR
fi

run_psql(){
	sudo -u postgres psql -U postgres -c "$@"
}

dump(){
	sudo -u postgres pg_dump -F t -w -U postgres $DBNAME > ${LOCAL_DIR}/${TEMP_FILE}
}

dump $DBNAME
gzip ${LOCAL_DIR}/${TEMP_FILE}
echo $LOCAL_DIR/$TEMP_FILE.gz
