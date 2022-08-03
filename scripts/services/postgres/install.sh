#!/bin/bash
source $BASEDIR/commands/docker.sh
source $BASEDIR/commands/gomplate.sh
service_name="${postgres}"
version="14.2-alpine"
service_path="/opt/services/${service_name}_${version}"

deploy(){
    export POSTGRES_VERSION="${version}"
    export POSTGRES_ADDRESS=$CLOUD_IPV4_PRIV
    #export POSTGRES_PORT=5432
    gomplate -d config="${MAIN_CONFIG}" -f templates/docker-compose.yaml > rendered/docker-compose.yaml
    mkdir -p "${service_path}_${version}"
    mkdir -p "${service_path}_${version}/scripts"
    mv rendered/docker-compose "${service_path}_${version}/docker-compose.yaml"
    cp files/createpsql "${service_path}_${version}/scripts/"
    cp files/sqldump "${service_path}_${version}/scripts/"
}

up(){
   cd "${service_path}_${version}"
   docker-compose up -d
}
