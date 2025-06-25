#!/usr/bin/env bash

echo "☁️ Installing OpenShift CLI (oc)..."

curl --silent --show-error --fail --location "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz" | sudo tar --extract --gzip --directory /usr/local/bin oc kubectl
