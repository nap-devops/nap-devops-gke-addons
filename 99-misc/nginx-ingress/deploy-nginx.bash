#!/bin/bash

NS=ingress-nginx

echo "####"
echo "#### Deploying nginx config to [${NS}] ####"

kubectl create ns ${NS}

kubectl apply -f nginx-backend-cfg.yaml -n ${NS}
kubectl apply -f nginx-backend-cfg-restrict.yaml -n ${NS}

OUTPUT_FILE=nginx-ing-1.yaml
sed -i "s#<<VAR_NGINX_DOMAIN>>#${VAR_NGINX_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

OUTPUT_FILE=nginx-ing-2.yaml
sed -i "s#<<VAR_NGINX_DOMAIN>>#${VAR_NGINX_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

kubectl apply -f rendered-nginx-public.yaml -n ${NS}
kubectl apply -f rendered-nginx-restrict.yaml -n ${NS}

#=== Certificates ===
OUTPUT_FILE=certificate-edh.yaml
sed -i "s#<<VAR_NGINX_DOMAIN>>#${VAR_NGINX_DOMAIN}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}
