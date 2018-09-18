#!/bin/bash

set -x

export SERVICE_NAME='pilipa-inside-nginx'
export IMAGE_NAME='nginx/yujianbo:latest'

docker service rm pilipa-inside-nginx

sleep 2

docker service create \
    --name "$SERVICE_NAME" \
    --network my-network \
    --replicas 1 \
    --publish "mode=host,published=80,target=80" \
    --publish "mode=host,published=443,target=443" \
"$IMAGE_NAME"
