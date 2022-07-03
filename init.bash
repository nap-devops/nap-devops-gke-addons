#!/bin/bash

PROJECT=evermed-edh-prod # will change to evermed-edh-nonprod
SA_NAME=gke-edh-prod-sm
SM_SA=${SA_NAME}@${PROJECT}.iam.gserviceaccount.com
SECRET_NAME=gke-edh-oidc
CORTEX_SECRET_NAME=cortex-basic-authen
LOKI_SECRET_NAME=loki-basic-authen


#gcloud services --project ${PROJECT} enable secretmanager.googleapis.com


LOKI_AUTH_USER=$(openssl rand -hex 8)
LOKI_AUTH_PASSWORD=$(openssl rand -hex 8)
gcloud secrets --project ${PROJECT} create ${LOKI_SECRET_NAME} \
    --replication-policy="automatic"
cat << EOF | gcloud secrets --project ${PROJECT} versions add ${LOKI_SECRET_NAME} --data-file=-
{
    "LOKI_AUTH_USER": "${LOKI_AUTH_USER}",
    "LOKI_AUTH_PASSWORD": "${LOKI_AUTH_PASSWORD}",
    "LOKI_AUTH_PASSWORD_HTPASSWD": "${LOKI_AUTH_USER}:$(openssl passwd -5 ${LOKI_AUTH_PASSWORD})"
}
EOF


CORTEX_AUTH_USER=$(openssl rand -hex 8)
CORTEX_AUTH_PASSWORD=$(openssl rand -hex 8)
gcloud secrets --project ${PROJECT} create ${CORTEX_SECRET_NAME} \
    --replication-policy="automatic"
cat << EOF | gcloud secrets --project ${PROJECT} versions add ${CORTEX_SECRET_NAME} --data-file=-
{
    "CORTEX_AUTH_USER": "${CORTEX_AUTH_USER}",
    "CORTEX_AUTH_PASSWORD": "${CORTEX_AUTH_PASSWORD}",
    "CORTEX_AUTH_PASSWORD_HTPASSWD": "${CORTEX_AUTH_USER}:$(openssl passwd -5 ${CORTEX_AUTH_PASSWORD})"
}
EOF

gcloud secrets --project ${PROJECT} create ${SECRET_NAME} \
    --replication-policy="automatic"
cat << EOF | gcloud secrets --project ${PROJECT} versions add ${SECRET_NAME} --data-file=-
{
    "GOOGLE_CLIENT_ID": "${GOOGLE_CLIENT_ID}",
    "GOOGLE_CLIENT_SECRET": "${GOOGLE_CLIENT_SECRET}"
}
EOF

#gcloud iam service-accounts create ${SA_NAME}

#gcloud projects add-iam-policy-binding ${PROJECT} \
#    --member="serviceAccount:${SM_SA}" \
#    --role="roles/secretmanager.admin"

#gcloud projects add-iam-policy-binding ${PROJECT} \
#    --member="serviceAccount:${SM_SA}" \
#    --role="roles/storage.objectAdmin"