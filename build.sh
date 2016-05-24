#!/bin/bash
set -e

IMAGE_NAME=sjourdan/vault

echo "- Build Docker Image ${IMAGE_NAME}:"
docker build -t=${IMAGE_NAME} .
