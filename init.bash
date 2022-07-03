#!/bin/bash

PROJECT=nap-devops-prod # will change to evermed-edh-nonprod
SECRET_NAME=gke-devops-oidc


#gcloud services --project ${PROJECT} enable secretmanager.googleapis.com

gcloud secrets --project ${PROJECT} create ${SECRET_NAME} \
    --replication-policy="automatic"
cat << EOF | gcloud secrets --project ${PROJECT} versions add ${SECRET_NAME} --data-file=-
{
    "GOOGLE_CLIENT_ID": "${GOOGLE_CLIENT_ID}",
    "GOOGLE_CLIENT_SECRET": "${GOOGLE_CLIENT_SECRET}"
}
EOF
