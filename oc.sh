#!/usr/bin/env bash

set -ex

curl -fsSL "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz" -o /tmp/openshift-client-linux.tar.gz
sudo tar --extract --directory /usr/local/bin --file /tmp/openshift-client-linux.tar.gz oc kubectl
rm -rf /tmp/openshift-client-linux.tar.gz
