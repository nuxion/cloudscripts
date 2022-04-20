#!/bin/bash
source ../shared/commands/gomplate.sh
source ../shared/commands/dig.sh
source ./scripts/dnsmasq.sh
source ../shared/metadata.sh

export GITEA_VERSION=1.16.5
gomplate -f templates/docker-compose.yml > rendered/docker_compose.yaml
mkdir -p /opt/services/gitea
mv rendered/docker_compose.yaml /opt/services/gitea
chown -R op:op /opt/services/gitea
cd /opt/services/gitea
docker-compose up -d gitea
