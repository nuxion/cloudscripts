#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

CURLCMD=/usr/bin/curl -s
export AWS_META="http://169.254.169.254/latest/meta-data/"
export GCE_META="http://metadata.google.internal/computeMetadata/v1/"

meta_gce()
{
    # set project attributes
    # https://cloud.google.com/compute/docs/metadata/setting-custom-metadata#set-projectwide

    # default metadata values
    # https://cloud.google.com/compute/docs/metadata/default-metadata-values

    export CLOUD_PROJECTID=`$CURL $GCE_META/project/project-id -H "Metadata-Flavor: Google"`
    export CLOUD_IPV4_PRIV=`$CURL $GCE_META/instance/network-interfaces/0/ip -H "Metadata-Flavor: Google"`
    export CLOUD_ZONE=`$CURL $GCE_META/instance/zone -H "Metadata-Flavor: Google"| awk -F "/" '{print $NF}'`
    export CLOUD_PROJECTID=`$CURLCMD $URL/project/project-id -H "Metadata-Flavor: Google"`

    export CLOUD_DNS_DOMAIN=`$CURLCMD $URL/project/attributes/dnsdomain -H "Metadata-Flavor: Google"`
    # echo ProjectID: $project_id
    # echo Zone: $zone
    # echo IP: $private_ip
    # echo $HOSTNAME
}

if "${CLOUD_PROVIDER}" == "gce"
then
    meta_gce
fi
