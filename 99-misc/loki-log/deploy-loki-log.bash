#!/bin/bash

NS=loki-log

echo "####"
echo "#### Deploying Loki-Stack to [${NS}] ####"

kubectl create ns ${NS}

OUTPUT_FILE=google-oidc-secret.yaml
sed -i "s#<<VAR_PROMETHEUS_SECRET_PROJECT>>#${VAR_PROMETHEUS_SECRET_PROJECT}#g" ${OUTPUT_FILE}
sed -i "s#<<VAR_PROMETHEUS_SECRET_NAME>>#${VAR_PROMETHEUS_SECRET_NAME}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

OUTPUT_FILE=rendered-loki-stack.yaml
sed -i "s#<<VAR_NGINX_DOMAIN>>#${VAR_NGINX_DOMAIN}#g" ${OUTPUT_FILE}
sed -i "s#<<VAR_CLUSTER_NAME>>#${VAR_CLUSTER_NAME}#g" ${OUTPUT_FILE}
sed -i "s#<<VAR_PROMETHEUS_SECRET_PROJECT>>#${VAR_PROMETHEUS_SECRET_PROJECT}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

OUTPUT_FILE=grafana-loki-ing.yaml
sed -i "s#<<VAR_NGINX_DOMAIN>>#${VAR_NGINX_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}
