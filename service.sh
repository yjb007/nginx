#!/bin/bash

set -ex

export SERVICE_NAME='pilipa-inside-nginx'
export IMAGE_NAME='nginx/yujianbo:latest'
export RUNNING=`docker service ls |grep $SERVICE_NAME`

if [ "$RUNNING" != "" ];then
    echo "Updating an existing service '$SERVICE_NAME'"
    DATE=$(TZ="Asia/Shanghai" date +"%Y%m%d-%H%M%S")
    docker service update \
        --force \
        --image "$IMAGE_NAME" \
        --container-label-add "deploy=$DATE" \
        --update-parallelism 1 \
        --update-delay 5s \
        --update-monitor 30s \
    "$SERVICE_NAME"
else
    echo "Create a new service '$SERVICE_NAME'"
    docker service create \
        --name "$SERVICE_NAME" \
        --network my-network \
        --replicas 1 \
        --publish "mode=host,published=80,target=80" \
        --publish "mode=host,published=443,target=443" \
    "$IMAGE_NAME"
fi
