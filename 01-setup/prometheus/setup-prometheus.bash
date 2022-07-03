#!/bin/bash

echo ""
echo "### Setting up Prometheus operator ###"

VERSION=${VAR_PROMETHEUS_VERSION}
GIT_URL=https://github.com/prometheus-operator/kube-prometheus.git
REPO_PATH=wip

rm -rf ${REPO_PATH}
mkdir -p ${REPO_PATH}
cd ${REPO_PATH}

git clone -b ${VERSION} ${GIT_URL}
cd kube-prometheus

PROMETHEUS_APPLY_MODE='replace'
CNT=$(kubectl get ns | grep monitoring | wc -l)
if [ "$CNT" = '0' ]; then
    PROMETHEUS_APPLY_MODE='create'
fi

kubectl ${PROMETHEUS_APPLY_MODE} -f manifests/setup
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
kubectl ${PROMETHEUS_APPLY_MODE} -f manifests/

kubectl patch daemonset node-exporter -n monitoring -p '{"spec":{"template": {"spec": {"hostNetwork": false}}}}'
