#!/bin/bash
source ../shared/commands/gomplate.sh
source ../shared/commands/dig.sh
source ./scripts/dnsmasq.sh
source ../shared/metadata.sh

gomplate -d config=./config.yaml -f templates/dnsmasq.conf > rendered/dnsmasq.conf
mv rendered/dnsmasq.conf /etc/dnsmasq.conf
systemctl restart dnsmasq
dig @localhost $HOSTNAME
