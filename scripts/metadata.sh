#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# set project attributes
# https://cloud.google.com/compute/docs/metadata/setting-custom-metadata#set-projectwide

# default metadata values
# https://cloud.google.com/compute/docs/metadata/default-metadata-values
CURLCMD=/usr/bin/curl -s
URL="http://metadata.google.internal/computeMetadata/v1/"
export PROJECT_ID=`$CURLCMD $URL/project/project-id -H "Metadata-Flavor: Google"`
export DNS_DOMAIN=`$CURLCMD $URL/project/attributes/dnsdomain -H "Metadata-Flavor: Google"`
export ZONE=`$CURLCMD $URL/instance/zone -H "Metadata-Flavor: Google"| awk -F "/" '{print $NF}'`
# export PRIVATE_IP=`curl $URL/instance/network-interfaces/0/ip -H "Metadata-Flavor: Google"`

echo ProjectID: $project_id
echo Zone: $zone
echo IP: $private_ip
echo $HOSTNAME
