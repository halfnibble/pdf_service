#!/bin/bash

#Exist on first error:
set -e

# Login to docker
docker login

# Build AMD64 and ARM64 and push to docker hub
docker buildx build --platform linux/amd64,linux/arm64 -t nostalgio/pdf_service --push .

# Local build
# docker buildx build --platform linux/arm64 --load -t pdf_service .
