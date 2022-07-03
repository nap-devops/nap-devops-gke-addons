#!/bin/bash

NS=argocd

echo "####"
echo "#### Deploying argocd to [${NS}] ####"

kubectl create ns ${NS}

#######################
OUTPUT_FILE=rendered-argocd.yaml
sed -i "s#<<VAR_NGINX_DOMAIN>>#${VAR_NGINX_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

OUTPUT_FILE=argocd-ing.yaml
sed -i "s#<<VAR_NGINX_DOMAIN>>#${VAR_NGINX_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

OUTPUT_FILE=google-oidc-secret.yaml
sed -i "s#<<VAR_PROMETHEUS_SECRET_NAME>>#${VAR_PROMETHEUS_SECRET_NAME}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

#ssh-keygen -t ed25519
SSH_KEY_BASE64=$(cat ${HOME}/.ssh/id_ed25519 | base64 -w0)

OUTPUT_FILE=github-ssh-secret.yaml
sed -i "s#<<SSH_KEY_BASE64>>#${SSH_KEY_BASE64}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

OUTPUT_FILE=local-cluster-secret.yaml
sed -i "s#<<VAR_ENVIRONMENT>>#${VAR_ENVIRONMENT}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

#### ArgoCD Application ####
OUTPUT_FILE=bootstrap-app.yaml
sed -i "s#<<VAR_ENVIRONMENT>>#${VAR_ENVIRONMENT}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}
