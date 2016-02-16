#!/bin/sh

IMAGE_NAME=sjourdan/vault

echo "- Build Docker Image ${IMAGE_NAME}:"
docker build -t=${IMAGE_NAME} .
echo "- Preparing Test Environment"
bundle install --path vendor
echo "- Executing tests"
bundle exec rspec --color
