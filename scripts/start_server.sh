#!/bin/bash

cd /home/ubuntu/app

echo "Stopping old container"
docker stop employee-container || true
docker rm employee-container || true

echo "Pulling latest image"
docker pull $DOCKER_USERNAME/employee-app:latest

echo "Starting container"
docker run -d -p 8000:8000 --name employee-container $DOCKER_USERNAME/employee-app:latest