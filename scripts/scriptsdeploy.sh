#!/bin/bash

echo "Pulling latest Docker image"

docker stop employee-app || true
docker rm employee-app || true

docker pull $DOCKER_USERNAME/employee-app:latest

docker run -d -p 8000:8000 --name employee-app $DOCKER_USERNAME/employee-app:latest