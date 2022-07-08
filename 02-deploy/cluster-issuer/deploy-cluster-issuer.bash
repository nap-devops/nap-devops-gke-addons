#!/bin/bash

NS=cert-manager
KEY_FILE=sa.json
SECRET=gcp-cloud-dns-account-key
SA=${VAR_EXT_SECRET_SA}

echo "####"
echo "#### Deploying cluseter-issuer to [${NS}] ####"

# Service Account secret
if [ -f "${KEY_FILE}" ]; then
    echo "File ${KEY_FILE} already exists. So, do nothing!!!"
else 
    gcloud iam service-accounts keys create ${KEY_FILE} --iam-account=${SA}
fi
kubectl delete secret ${SECRET} -n ${NS}

kubectl create secret generic ${SECRET} \
--from-file=service-account.json=${KEY_FILE} \
-n ${NS}

# Cluster Issuer
OUTPUT_FILE=cluster-issuer.yaml
sed -i "s#<<VAR_CLOUD_DNS_PROJECT>>#${VAR_CLOUD_DNS_PROJECT}#g" ${OUTPUT_FILE}
sed -i "s#<<VAR_LETENCRYPT_SERVER>>#${VAR_LETENCRYPT_SERVER}#g" ${OUTPUT_FILE}
sed -i "s#<<VAR_CLOUD_DNS_INFRA_PROJECT>>#${VAR_CLOUD_DNS_INFRA_PROJECT}#g" ${OUTPUT_FILE}
kubectl apply -f ${OUTPUT_FILE} -n ${NS}
