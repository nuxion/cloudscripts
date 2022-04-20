#!/bin/bash 
if ! command -v dnsmasq &> /dev/null
then
	echo "dnsmasq not found"
	apt-get install dnsmasq -y
	echo "dnsmasq installed"
else
	echo "dnsmasq found"
fi
