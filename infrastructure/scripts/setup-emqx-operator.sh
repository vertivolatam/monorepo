#!/bin/bash
# Install EMQX Operator and deploy EMQX cluster in vertivo-dev namespace
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${BLUE}Installing EMQX Operator...${NC}"

# Add EMQX Helm repo
helm repo add emqx https://repos.emqx.io/charts 2>/dev/null || true
helm repo update

# Install operator (creates CRDs)
helm upgrade --install emqx-operator emqx/emqx-operator \
    --namespace emqx-operator-system \
    --create-namespace \
    --wait

echo -e "${GREEN}EMQX Operator installed${NC}"

# Wait for operator to be ready
echo -e "${BLUE}Waiting for EMQX Operator to be ready...${NC}"
kubectl wait --for=condition=ready pod \
    -l control-plane=controller-manager \
    -n emqx-operator-system \
    --timeout=120s

# Ensure namespace exists
kubectl create namespace vertivo-dev --dry-run=client -o yaml | kubectl apply -f -

# Apply EMQX cluster CRD
echo -e "${BLUE}Deploying EMQX cluster...${NC}"
kubectl apply -f "$PROJECT_ROOT/k8s/base/mqtt/emqx-cluster.yaml" -n vertivo-dev

# Wait for EMQX to be running
echo -e "${BLUE}Waiting for EMQX to start (this may take 1-2 minutes)...${NC}"
for i in $(seq 1 60); do
    STATUS=$(kubectl get emqx emqx -n vertivo-dev -o jsonpath='{.status.conditions[?(@.type=="Running")].status}' 2>/dev/null || echo "")
    if [ "$STATUS" = "True" ]; then
        echo -e "${GREEN}EMQX cluster is running${NC}"
        break
    fi
    if [ "$i" -eq 60 ]; then
        echo -e "${YELLOW}EMQX still starting, check with: kubectl get emqx -n vertivo-dev${NC}"
    fi
    sleep 5
done

echo ""
echo -e "${GREEN}EMQX deployed in vertivo-dev namespace${NC}"
echo -e "${BLUE}Dashboard: kubectl port-forward svc/emqx-dashboard 18083:18083 -n vertivo-dev${NC}"
echo -e "${BLUE}           http://localhost:18083 (admin/public)${NC}"
echo -e "${BLUE}MQTT:      emqx-listeners.vertivo-dev.svc.cluster.local:1883${NC}"
