#!/bin/bash
# Build Serverpod backend image with Podman and load into Minikube
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SERVER_DIR="$PROJECT_ROOT/apps/vertivo_server"
BUILD_ID="$(date +%Y%m%d-%H%M%S)"
IMAGE_TAG="localhost/vertivo-backend:${BUILD_ID}"
IMAGE_TAG_DEV="localhost/vertivo-backend:dev"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Building backend image: ${IMAGE_TAG}${NC}"

for cmd in podman minikube; do
    if ! command -v $cmd >/dev/null 2>&1; then
        echo -e "${RED}$cmd is not installed${NC}"
        exit 1
    fi
done

if ! minikube status >/dev/null 2>&1; then
    echo -e "${RED}minikube is not running. Start it first: make dev-minikube-deploy${NC}"
    exit 1
fi

if [ ! -d "$SERVER_DIR" ]; then
    echo -e "${RED}Server directory not found: $SERVER_DIR${NC}"
    exit 1
fi

# Build from workspace root so Dart workspace resolution works
cd "$PROJECT_ROOT"

if ! podman build -t "${IMAGE_TAG}" -f "$SERVER_DIR/Dockerfile" "$SERVER_DIR" 2>&1; then
    echo -e "${RED}Failed to build backend image${NC}"
    exit 1
fi

podman tag "${IMAGE_TAG}" "${IMAGE_TAG_DEV}"

echo -e "${BLUE}Loading image into minikube...${NC}"
if ! podman save "${IMAGE_TAG_DEV}" | minikube image load -; then
    echo -e "${RED}Failed to load image into minikube${NC}"
    exit 1
fi

echo -e "${GREEN}Image built (${BUILD_ID}) and loaded: ${IMAGE_TAG_DEV}${NC}"
