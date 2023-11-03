#!/usr/bin/env bash

set -ex

curl --silent --show-error --location "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz" | sudo tar --extract --gzip --directory /usr/local/bin oc kubectl
