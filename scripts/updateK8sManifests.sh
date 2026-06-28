#!/bin/bash

set -e

APP_NAME=$1
IMAGE_NAME=$2
IMAGE_TAG=$3

MANIFEST="k8s-specifications/${APP_NAME}-deployment.yaml"

echo "Updating image in ${MANIFEST}"
echo "New Image: webappaksacr.azurecr.io/${IMAGE_NAME}:${IMAGE_TAG}"

# Replace image line
sed -i "s|image:.*|image: webappaksacr.azurecr.io/${IMAGE_NAME}:${IMAGE_TAG}|g" "$MANIFEST"

# Configure Git
git config user.name "rvishnuprasath"
git config user.email "r.vishnuprasath1994@gmail.com"

# Commit changes
git add "$MANIFEST"

if git diff --cached --quiet; then
    echo "No changes detected."
    exit 0
fi

git commit -m "Update ${APP_NAME} image to ${IMAGE_TAG}"

git push origin main
