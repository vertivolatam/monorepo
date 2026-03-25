#!/bin/bash
# Start Minikube with Podman driver + containerd for Vertivo dev cluster
set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Checking minikube...${NC}"
if ! command -v minikube >/dev/null 2>&1; then
    echo -e "${RED}minikube not installed${NC}"
    exit 1
fi

echo -e "${BLUE}Cleaning minikube locks...${NC}"
rm -f /tmp/minikube-locks/* 2>/dev/null || true

echo -e "${BLUE}Starting minikube (Podman + containerd)...${NC}"
minikube start \
    --driver=podman \
    --container-runtime=containerd \
    --cpus=6 \
    --memory=8192 \
    --disk-size=30g \
    --addons=default-storageclass,storage-provisioner

minikube config set WantUpdateNotification false

echo -e "${BLUE}Creating vertivo-dev namespace...${NC}"
kubectl create namespace vertivo-dev --dry-run=client -o yaml | kubectl apply -f -

echo -e "${GREEN}Minikube started (vertivo-dev namespace ready)${NC}"
