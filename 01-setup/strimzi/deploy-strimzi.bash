#!/bin/bash

# Note : We found the issue when installed with Helm

NS=strimzi
VERSION=0.32.0

echo "####"
echo "#### Setting Kafka Operator into [${NS}] ####"

kubectl create ns ${NS}

kubectl apply -n ${NS} \
-f https://github.com/strimzi/strimzi-kafka-operator/releases/download/${VERSION}/strimzi-crds-${VERSION}.yaml

kubectl apply -f rendered-strimzi.yaml -n ${NS}
