#!/bin/bash

NS=external-secrets
SA=${VAR_EXT_SECRET_SA}
KEY_FILE=sm.json
SECRET=gcp-secret-manager

echo "####"
echo "#### Deploying k8s-external-secret to [${NS}] ####"

kubectl create ns ${NS}
kubectl apply -f rendered-k8s-external-secrets.yaml -n ${NS}

OUTPUT_FILE=cluster-secret-store.yaml
sed -i "s#<<VAR_PROMETHEUS_SECRET_PROJECT>>#${VAR_PROMETHEUS_SECRET_PROJECT}#g" ${OUTPUT_FILE}
sed -i "s#<<NS>>#${NS}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}

if [ -f "${KEY_FILE}" ]; then
    echo "File ${KEY_FILE} already exists. So, do nothing!!!"
else 
    gcloud iam service-accounts keys create ${KEY_FILE} --iam-account=${SA} 
fi

kubectl delete secret ${SECRET} -n ${NS}

kubectl create secret generic ${SECRET} \
--from-file=gcp-creds.json=${KEY_FILE} \
-n ${NS}
