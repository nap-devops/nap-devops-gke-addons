#!/bin/bash

NS=monitoring

echo "####"
echo "#### Deploying prometheus config to [${NS}] ####"

OUTPUT_FILE=google-oidc-secret.yaml
sed -i "s#<<VAR_PROMETHEUS_SECRET_PROJECT>>#${VAR_PROMETHEUS_SECRET_PROJECT}#g" ${OUTPUT_FILE}
sed -i "s#<<VAR_PROMETHEUS_SECRET_NAME>>#${VAR_PROMETHEUS_SECRET_NAME}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

kubectl apply -f rendered-prometheus-config.yaml

#Use for debugging only
OUTPUT_FILE=prometheus-ing.yaml
sed -i "s#<<VAR_NGINX_DOMAIN>>#${VAR_NGINX_DOMAIN}#g" ${OUTPUT_FILE}
#kubectl apply -f ${OUTPUT_FILE} -n ${NS}

OUTPUT_FILE=rendered-grafana-k8s.yaml
sed -i "s#<<VAR_NGINX_DOMAIN>>#${VAR_NGINX_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

OUTPUT_FILE=grafana-k8s-ing.yaml
sed -i "s#<<VAR_NGINX_DOMAIN>>#${VAR_NGINX_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

OUTPUT_FILE=prometheus-ing.yaml
sed -i "s#<<VAR_NGINX_DOMAIN>>#${VAR_NGINX_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

#Set prometheus to monitore in its own namespace
kubectl label ns monitoring --overwrite monitoring=true
kubectl patch prometheus k8s -n monitoring --type merge --patch "$(cat prometheus-patch.yaml)"
