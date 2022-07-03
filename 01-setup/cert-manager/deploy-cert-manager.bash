#!/bin/bash

NS=cert-manager

echo "####"
echo "#### Deploying cert-manager to [${NS}] ####"

kubectl create ns ${NS}

kubectl apply -f rendered-cert-manager.yaml -n ${NS}
