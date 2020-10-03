#!/bin/sh

# Stop and remove all containers
docker ps -a -q | xargs --no-run-if-empty docker stop
docker ps -a -q | xargs --no-run-if-empty docker rm

# Remove untagged images
docker images | tail -n +2 | awk '$1 == "<none>" {print $3}' | xargs --no-run-if-empty docker rmi