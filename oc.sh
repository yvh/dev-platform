#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

curl --silent --show-error --location "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz" | tar --extract --gzip --directory /usr/local/bin oc kubectl
