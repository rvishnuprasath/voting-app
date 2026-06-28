#!/bin/bash

set -e

APP_NAME=$1
IMAGE_NAME=$2
IMAGE_TAG=$3

# Change to the repository root
cd "$BUILD_SOURCESDIRECTORY"

MANIFEST="k8s-specifications/${APP_NAME}-deployment.yaml"

echo "Updating image in ${MANIFEST}"
echo "New Image: webappaksacr.azurecr.io/${IMAGE_NAME}:${IMAGE_TAG}"

# Verify the manifest exists
if [ ! -f "$MANIFEST" ]; then
    echo "ERROR: Manifest file not found: $MANIFEST"
    exit 1
fi

# Update the image
sed -i "s|image:.*|image: webappaksacr.azurecr.io/${IMAGE_NAME}:${IMAGE_TAG}|g" "$MANIFEST"

# Configure Git
git config user.name "rvishnuprasath"
git config user.email "r.vishnuprasath1994@gmail.com"

# Switch from detached HEAD to main branch
git checkout -B main origin/main

# Stage the updated manifest
git add "$MANIFEST"

# Commit only if there are changes
if git diff --cached --quiet; then
    echo "No changes detected."
    exit 0
fi

# Commit changes
git commit -m "Update ${APP_NAME} image to ${IMAGE_TAG}"

# Push changes to GitHub
git push origin main

echo "Manifest updated and pushed successfully."
