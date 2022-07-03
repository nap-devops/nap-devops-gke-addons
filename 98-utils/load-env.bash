#!/bin/bash

if [ -z "$1" ]; then
    echo "Argument <env> is required!!!"
    exit 1
fi

ENV=$1

set -o allexport; source "${ROOT_PATH}/00-configs/env-common.cfg"; set +o allexport
set -o allexport; source "${ROOT_PATH}/00-configs/env.cfg"; set +o allexport
