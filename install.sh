#!/bin/bash

MOUNTPOINT=${1:-/tmp/data}

docker-compose -f docker-compose-storage.yml up -d
docker volume create -d local-persist -o mountpoint=${MOUNTPOINT} --name=teamspeak-database-data
docker-compose up -d
