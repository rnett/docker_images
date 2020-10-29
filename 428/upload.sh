#!/usr/bin/env bash

export PROJECT_ID=$(gcloud config list project --format "value(core.project)")
export IMAGE_REPO_NAME=428-container
export IMAGE_TAG=$(date +%Y%m%d_%H%M%S)
export IMAGE_URI=gcr.io/$PROJECT_ID/$IMAGE_REPO_NAME:$IMAGE_TAG

# local build (really slow upload)
# docker build -f Dockerfile -t $IMAGE_URI --build-arg CACHEBUST=$(date +%s) ./
# docker push $IMAGE_URI

gcloud builds submit --tag $IMAGE_URI --substitutions=GITHUB_TOKEN="$GITHUB_TOKEN"