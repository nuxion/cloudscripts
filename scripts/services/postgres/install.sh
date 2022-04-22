#!/bin/bash
source $BASEDIR/commands/docker.sh
source $BASEDIR/commands/gomplate.sh
service_name="${postgres}"

deploy(){
    export POSTGRES_VERSION=${1:-latest}
    export POSTGRES_ADDRESS=$CLOUD_IPV4_PRIV
    export POSTGRES_PORT=5432
    service_path="/opt/services/${service_name}_${POSTGRES_VERSION}"
    gomplate -d config=./config.yaml -f templates/docker-compose.yaml > rendered/docker-compose.yaml
    mkdir -p "${service_path}"
    mkdir -p "${service_path}/scripts"
    mv rendered/docker-compose "${service_path}/docker-compose.yaml"
    cp files/createpsql "${service_path}/scripts/"
    cp files/sqldump "${service_path}/scripts/"
    cd "${service_path}"
    docker-compose up -d
}

gomplate -d config=./config.yaml -f templates/dnsmasq.conf > rendered/dnsmasq.conf
mv rendered/dnsmasq.conf /etc/dnsmasq.conf
systemctl restart dnsmasq
dig @localhost $HOSTNAME
