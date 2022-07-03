#!/bin/bash

#usage : operate.bash <setup|deploy> [<component>]
export KUBECONFIG=$(pwd)/kubeconfig

if [ -z "$1" ]; then
    echo "Argument <setup|deploy> is required!!!"
    echo "You can run : <setup|deploy> [<component>]"
    exit 1
fi

if [ -z "${KUBECONFIG}" ]; then
    echo "Need environment variable KUBECONFIG to be populated first!!!"
    exit 1
fi

ACTION=$1
COMPONENT=$2

if [ -z "$COMPONENT" ]; then
    COMPONENT='all'
fi

export ROOT_PATH=$(pwd); . ./98-utils/load-env.bash 'no-need-now'

kubectl get nodes

CWD=$(pwd)

if [ "$ACTION" = 'setup' ]; then
    if [[ $COMPONENT =~ ^(prometheus|all)$ ]]; 
    then
        cd 01-setup/prometheus; ./setup-prometheus.bash; cd ${CWD}
    fi

    if [[ $COMPONENT =~ ^(cert-manager|all)$ ]]; 
    then
        cd 01-setup/cert-manager; ./deploy-cert-manager.bash; cd ${CWD}
    fi
fi

if [ "$ACTION" = 'deploy' ]; then
    if [[ $COMPONENT =~ ^(k8s-external-secrets|all)$ ]]; 
    then
        cd 02-deploy/k8s-external-secrets; ./deploy-k8s-external-secrets.bash; cd ${CWD}
    fi

    if [[ $COMPONENT =~ ^(cluster-issuer|all)$ ]]; 
    then
        cd 02-deploy/cluster-issuer; ./deploy-cluster-issuer.bash; cd ${CWD}
    fi

    if [[ $COMPONENT =~ ^(prometheus|all)$ ]]; 
    then
        cd 02-deploy/prometheus; ./deploy-prometheus-config.bash; cd ${CWD}
    fi 

    # Moved this to last
#    if [[ $COMPONENT =~ ^(argocd|all)$ ]]; 
#    then
#        cd 02-deploy/argocd; ./deploy-argocd.bash; cd ${CWD}
#    fi
fi