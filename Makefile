# Vertivo Monorepo - Automation Makefile
# ==========================================
#
# Naming Convention: env-recurso-verbo (same as altrupets)
# Examples:
#   make dev-minikube-deploy       # Create minikube cluster
#   make dev-emqx-deploy           # Deploy EMQX MQTT broker
#   make dev-backend-build         # Build backend image
#
# Quick Start:
#   make bootstrap-dev             # Full setup from scratch

TIMEOUT ?= 900000

.PHONY: help setup bootstrap-dev bootstrap-dev-clean \
        dev-minikube-deploy dev-minikube-clear dev-minikube-destroy \
        dev-postgres-deploy dev-postgres-destroy dev-postgres-logs dev-postgres-port-forward \
        dev-emqx-deploy dev-emqx-destroy dev-emqx-dashboard dev-emqx-status \
        dev-backend-build dev-backend-deploy dev-backend-start dev-backend-logs dev-backend-generate \
        dev-all-deploy dev-all-destroy dev-all-status dev-all-port-forward dev-all-port-forward-stop \
        dev-mqtt-forward dev-mqtt-test \
        dev-flutter-start dev-flutter-build \
        dev-argocd-deploy dev-argocd-status dev-argocd-password \
        dev-raspberry-install dev-raspberry-start dev-raspberry-test dev-raspberry-lint \
        dev-raspberry-emqx-sim dev-raspberry-i2c-sim dev-raspberry-i2c-sim-scenarios \
        bootstrap-raspberry dev-raspberry-balena-push dev-raspberry-balena-local \
        dev-raspberry-balena-preload dev-raspberry-balena-build dev-raspberry-balena-status \
        dev-docs-install dev-docs-serve dev-docs-build \
        dev-dashboard-install dev-dashboard-serve dev-dashboard-build

# ==========================================
# Variables
# ==========================================

ENV ?= dev
SCRIPTS_DIR = infrastructure/scripts
APPS_DIR = apps
NAMESPACE = vertivo-dev
VERSION ?= $(shell git describe --tags --always 2>/dev/null || echo "dev")
GIT_SHA ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")

BLUE := \033[36m
GREEN := \033[32m
YELLOW := \033[33m
RED := \033[31m
NC := \033[0m

# ==========================================
# Help
# ==========================================

help: ## Show this help message
	@echo ""
	@echo "$(BLUE)╔════════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║        Vertivo Monorepo - Commands (env-recurso-verbo)         ║$(NC)"
	@echo "$(BLUE)╚════════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(GREEN)Quick Start (Full GitOps Setup — one-liner):$(NC)"
	@echo "  make bootstrap-dev"
	@echo ""
	@echo "  $(YELLOW)Step by step (Manual):$(NC)"
	@echo "  1. make setup                    $(BLUE)# Check prerequisites$(NC)"
	@echo "  2. make dev-minikube-deploy      $(BLUE)# Create cluster (Podman + containerd)$(NC)"
	@echo "  3. make dev-postgres-deploy      $(BLUE)# Deploy PostgreSQL 16$(NC)"
	@echo "  4. make dev-emqx-deploy          $(BLUE)# Deploy EMQX MQTT broker$(NC)"
	@echo "  5. make dev-backend-generate     $(BLUE)# Serverpod generate (protocol + stubs)$(NC)"
	@echo "  6. make dev-backend-build        $(BLUE)# Build Serverpod image (Podman)$(NC)"
	@echo "  7. make dev-backend-deploy       $(BLUE)# Deploy backend to cluster$(NC)"
	@echo "  8. make dev-argocd-deploy        $(BLUE)# Install ArgoCD GitOps (optional)$(NC)"
	@echo "  9. make dev-all-port-forward     $(BLUE)# Expose all ports at once$(NC)"
	@echo " 10. make dev-dashboard-serve      $(BLUE)# Jaspr Dashboard at localhost:8080$(NC)"
	@echo ""
	@echo "  $(YELLOW)Nuclear rebuild (destroy + bootstrap):$(NC)"
	@echo "  make bootstrap-dev-clean"
	@echo ""
	@echo "$(GREEN)DEV - Minikube:$(NC)"
	@echo "  $(YELLOW)dev-minikube-deploy$(NC)         Create minikube cluster (Podman + containerd)"
	@echo "  $(YELLOW)dev-minikube-clear$(NC)          Clear stuck namespaces"
	@echo "  $(YELLOW)dev-minikube-destroy$(NC)        Delete minikube cluster"
	@echo ""
	@echo "$(GREEN)DEV - PostgreSQL:$(NC)"
	@echo "  $(YELLOW)dev-postgres-deploy$(NC)         Deploy PostgreSQL 16 + pgvector"
	@echo "  $(YELLOW)dev-postgres-destroy$(NC)        Remove PostgreSQL"
	@echo "  $(YELLOW)dev-postgres-logs$(NC)           Tail PostgreSQL logs"
	@echo "  $(YELLOW)dev-postgres-port-forward$(NC)   Port-forward 5432 (DBeaver access)"
	@echo ""
	@echo "$(GREEN)DEV - EMQX (MQTT Broker):$(NC)"
	@echo "  $(YELLOW)dev-emqx-deploy$(NC)             Deploy EMQX operator + cluster"
	@echo "  $(YELLOW)dev-emqx-destroy$(NC)            Remove EMQX"
	@echo "  $(YELLOW)dev-emqx-dashboard$(NC)          Port-forward dashboard (localhost:18083)"
	@echo "  $(YELLOW)dev-emqx-status$(NC)             Check EMQX cluster status"
	@echo "  $(YELLOW)dev-mqtt-forward$(NC)            Port-forward MQTT 1883 (Raspberry Pi access)"
	@echo "  $(YELLOW)dev-mqtt-test$(NC)               Test MQTT connectivity"
	@echo ""
	@echo "$(GREEN)DEV - Backend (Serverpod):$(NC)"
	@echo "  $(YELLOW)dev-backend-generate$(NC)        Serverpod generate (protocol + stubs)"
	@echo "  $(YELLOW)dev-backend-build$(NC)           Build backend image (Podman)"
	@echo "  $(YELLOW)dev-backend-deploy$(NC)          Deploy backend to cluster"
	@echo "  $(YELLOW)dev-backend-start$(NC)           Start backend locally (dev mode)"
	@echo "  $(YELLOW)dev-backend-logs$(NC)            Tail backend pod logs"
	@echo ""
	@echo "$(GREEN)DEV - All Services:$(NC)"
	@echo "  $(YELLOW)dev-all-deploy$(NC)              Deploy all (postgres + emqx + backend)"
	@echo "  $(YELLOW)dev-all-destroy$(NC)             Destroy all resources"
	@echo "  $(YELLOW)dev-all-status$(NC)              Show status of all pods/services"
	@echo "  $(YELLOW)dev-all-port-forward$(NC)        Expose all ports at once (background)"
	@echo "  $(YELLOW)dev-all-port-forward-stop$(NC)   Stop all background port-forwards"
	@echo ""
	@echo "$(GREEN)DEV - Raspberry Pi (Orquestador):$(NC)"
	@echo "  $(YELLOW)dev-raspberry-install$(NC)       Install Python dependencies"
	@echo "  $(YELLOW)dev-raspberry-start$(NC)         Start orchestrator (indoor mode)"
	@echo "  $(YELLOW)dev-raspberry-test$(NC)          Run pytest suite"
	@echo "  $(YELLOW)dev-raspberry-lint$(NC)          Lint Python code"
	@echo "  $(YELLOW)dev-raspberry-emqx-sim$(NC)      Simulate sensor data to EMQX (mosquitto_pub)"
	@echo "  $(YELLOW)dev-raspberry-i2c-sim$(NC)       Full pipeline simulation (no I2C needed)"
	@echo "  $(YELLOW)dev-raspberry-i2c-sim-scenarios$(NC) List simulation scenarios"
	@echo ""
	@echo "$(GREEN)DEV - Raspberry Pi Balena (Deployment):$(NC)"
	@echo "  $(YELLOW)bootstrap-raspberry$(NC)             Interactive wizard → fleet + deploy (step by step)"
	@echo "  $(YELLOW)dev-raspberry-balena-local$(NC)      Push to local device (LAN IP)"
	@echo "  $(YELLOW)dev-raspberry-balena-push$(NC)       Push to balenaCloud fleet (FLEET=myfleet)"
	@echo "  $(YELLOW)dev-raspberry-balena-build$(NC)      Build image locally (no push)"
	@echo "  $(YELLOW)dev-raspberry-balena-preload$(NC)    Preload release into SD card .img"
	@echo "  $(YELLOW)dev-raspberry-balena-status$(NC)     Show fleet devices and status"
	@echo ""
	@echo "$(GREEN)DEV - Flutter:$(NC)"
	@echo "  $(YELLOW)dev-flutter-start$(NC)           Run Flutter app in dev mode"
	@echo "  $(YELLOW)dev-flutter-build$(NC)           Build Flutter web for Serverpod"
	@echo ""
	@echo "$(GREEN)DEV - ArgoCD:$(NC)"
	@echo "  $(YELLOW)dev-argocd-deploy$(NC)           Install ArgoCD + apps"
	@echo "  $(YELLOW)dev-argocd-status$(NC)           Show ArgoCD applications"
	@echo "  $(YELLOW)dev-argocd-password$(NC)         Get ArgoCD admin password"
	@echo ""
	@echo "$(GREEN)DEV - Docs (Zensical):$(NC)"
	@echo "  $(YELLOW)dev-docs-install$(NC)            Install docs dependencies"
	@echo "  $(YELLOW)dev-docs-serve$(NC)              Serve docs locally (hot-reload)"
	@echo "  $(YELLOW)dev-docs-build$(NC)              Build static site"
	@echo ""
	@echo "$(GREEN)DEV - Dashboard (Jaspr + D3.js):$(NC)"
	@echo "  $(YELLOW)dev-dashboard-install$(NC)        Install Jaspr CLI + dependencies"
	@echo "  $(YELLOW)dev-dashboard-serve$(NC)          Serve dashboard at localhost:8080 (hot-reload)"
	@echo "  $(YELLOW)dev-dashboard-build$(NC)          Build static dashboard"
	@echo ""

# ==========================================
# Setup
# ==========================================

setup: ## Check prerequisites
	@echo "$(BLUE)Checking prerequisites...$(NC)"
	@chmod +x $(SCRIPTS_DIR)/*.sh 2>/dev/null || true
	@command -v podman >/dev/null 2>&1 && echo "$(GREEN)  podman$(NC)" || echo "$(RED)  podman not found$(NC)"
	@command -v minikube >/dev/null 2>&1 && echo "$(GREEN)  minikube$(NC)" || echo "$(RED)  minikube not found$(NC)"
	@command -v kubectl >/dev/null 2>&1 && echo "$(GREEN)  kubectl$(NC)" || echo "$(RED)  kubectl not found$(NC)"
	@command -v helm >/dev/null 2>&1 && echo "$(GREEN)  helm$(NC)" || echo "$(RED)  helm not found$(NC)"
	@command -v dart >/dev/null 2>&1 && echo "$(GREEN)  dart$(NC)" || echo "$(RED)  dart not found$(NC)"
	@command -v flutter >/dev/null 2>&1 && echo "$(GREEN)  flutter$(NC)" || echo "$(RED)  flutter not found$(NC)"
	@command -v pnpm >/dev/null 2>&1 && echo "$(GREEN)  pnpm$(NC)" || echo "$(RED)  pnpm not found$(NC)"
	@echo "$(GREEN)Setup check complete$(NC)"

# ==========================================
# DEV - Bootstrap
# ==========================================

bootstrap-dev: ## Full GitOps dev environment from scratch (one-liner)
	@echo ""
	@echo "$(BLUE)╔════════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║  Vertivo DEV Bootstrap — GitOps + EMQX + Serverpod + Dashboard ║$(NC)"
	@echo "$(BLUE)╚════════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(RED)Phase 0/7: Cleaning previous environment...$(NC)"
	@$(MAKE) dev-minikube-destroy 2>/dev/null || true
	@echo ""
	@echo "$(BLUE)Phase 1/7: Prerequisites check...$(NC)"
	@$(MAKE) setup
	@echo ""
	@echo "$(BLUE)Phase 2/7: Minikube cluster (Podman + containerd)...$(NC)"
	@$(MAKE) dev-minikube-deploy
	@echo ""
	@echo "$(BLUE)Phase 3/7: PostgreSQL 16 + pgvector...$(NC)"
	@$(MAKE) dev-postgres-deploy
	@echo ""
	@echo "$(BLUE)Phase 4/7: EMQX MQTT Broker (Operator + Cluster)...$(NC)"
	@$(MAKE) dev-emqx-deploy
	@echo ""
	@echo "$(BLUE)Phase 5/7: Serverpod backend (generate + build + deploy)...$(NC)"
	@$(MAKE) dev-backend-generate 2>/dev/null || echo "$(YELLOW)  Serverpod generate skipped (install serverpod_cli: dart pub global activate serverpod_cli)$(NC)"
	@$(MAKE) dev-backend-build
	@$(MAKE) dev-backend-deploy
	@echo ""
	@echo "$(BLUE)Phase 6/7: ArgoCD GitOps...$(NC)"
	@$(MAKE) dev-argocd-deploy 2>/dev/null || echo "$(YELLOW)  ArgoCD skipped (optional, deploy manually: make dev-argocd-deploy)$(NC)"
	@echo ""
	@echo "$(BLUE)Phase 7/7: Dashboard + Docs (Dart tooling)...$(NC)"
	@$(MAKE) dev-dashboard-install 2>/dev/null || echo "$(YELLOW)  Dashboard install skipped (install jaspr_cli: dart pub global activate jaspr_cli)$(NC)"
	@echo ""
	@echo "$(GREEN)╔════════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(GREEN)║  Vertivo DEV environment ready!                                ║$(NC)"
	@echo "$(GREEN)╠════════════════════════════════════════════════════════════════╣$(NC)"
	@echo "$(GREEN)║                                                                ║$(NC)"
	@echo "$(GREEN)║  Services deployed in vertivo-dev namespace:                   ║$(NC)"
	@echo "$(GREEN)║    PostgreSQL 16    — ClusterIP :5432                          ║$(NC)"
	@echo "$(GREEN)║    EMQX 5.x        — ClusterIP :1883 (MQTT), :18083 (UI)      ║$(NC)"
	@echo "$(GREEN)║    Serverpod        — ClusterIP :8080 (API), :8081 (Insights)  ║$(NC)"
	@echo "$(GREEN)║    ArgoCD           — argocd namespace                         ║$(NC)"
	@echo "$(GREEN)║                                                                ║$(NC)"
	@echo "$(GREEN)╚════════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(BLUE)Open services:$(NC)"
	@echo "  make dev-all-port-forward  $(YELLOW)# Expose all ports at once (background)$(NC)"
	@echo ""
	@echo "$(BLUE)Or one-by-one:$(NC)"
	@echo "  make dev-emqx-dashboard    $(YELLOW)# EMQX Dashboard   → localhost:18083 (admin/public)$(NC)"
	@echo "  make dev-mqtt-forward      $(YELLOW)# MQTT Broker       → localhost:1883  (Raspberry Pi)$(NC)"
	@echo "  make dev-postgres-port-forward $(YELLOW)# PostgreSQL    → localhost:5432  (DBeaver)$(NC)"
	@echo "  make dev-dashboard-serve   $(YELLOW)# Jaspr Dashboard   → localhost:8080  (D3.js)$(NC)"
	@echo "  make dev-flutter-start     $(YELLOW)# Flutter App       → mobile/desktop$(NC)"
	@echo ""
	@echo "$(BLUE)Monitor:$(NC)"
	@echo "  make dev-all-status        $(YELLOW)# Show all pods, services, EMQX status$(NC)"
	@echo "  make dev-argocd-password   $(YELLOW)# Get ArgoCD admin password$(NC)"
	@echo ""

bootstrap-dev-clean: ## Destroy + rebuild DEV from zero (nuclear option)
	@echo "$(RED)Nuclear clean: destroying everything and rebuilding...$(NC)"
	@$(MAKE) dev-all-destroy 2>/dev/null || true
	@$(MAKE) dev-minikube-destroy 2>/dev/null || true
	@$(MAKE) bootstrap-dev

# ==========================================
# DEV - Minikube
# ==========================================

images-pull: ## Pull all third-party container images required by minikube/k8s (run after `podman system prune`)
	podman pull gcr.io/k8s-minikube/kicbase:v0.0.50

dev-minikube-deploy: ## Create minikube cluster (Podman + containerd)
	@$(SCRIPTS_DIR)/start-minikube.sh

dev-minikube-clear: ## Clear stuck namespaces
	@echo "$(BLUE)Clearing stuck namespaces...$(NC)"
	@for ns in $$(kubectl get ns -o jsonpath='{.items[*].metadata.name}'); do \
		if kubectl get ns $$ns -o jsonpath='{.status.phase}' 2>/dev/null | grep -q "Terminating"; then \
			echo "$(YELLOW)Clearing finalizers: $$ns$(NC)"; \
			kubectl patch ns $$ns --type merge -p '{"metadata":{"finalizers":[]}}' 2>/dev/null || true; \
		fi; \
	done
	@echo "$(GREEN)Cleanup complete$(NC)"

dev-minikube-destroy: ## Delete minikube cluster
	@echo "$(RED)Deleting minikube cluster...$(NC)"
	@minikube delete
	@echo "$(GREEN)Minikube deleted$(NC)"

# ==========================================
# DEV - PostgreSQL
# ==========================================

dev-postgres-deploy: ## Deploy PostgreSQL 16 + pgvector
	@echo "$(BLUE)Deploying PostgreSQL...$(NC)"
	@kubectl create namespace $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -
	@kubectl apply -k k8s/overlays/dev/database
	@kubectl rollout status deployment/postgres -n $(NAMESPACE) --timeout=120s
	@echo "$(GREEN)PostgreSQL deployed$(NC)"

dev-postgres-destroy: ## Remove PostgreSQL
	@kubectl delete -k k8s/base/database -n $(NAMESPACE) --ignore-not-found=true
	@echo "$(GREEN)PostgreSQL removed$(NC)"

dev-postgres-logs: ## Tail PostgreSQL logs
	@kubectl logs -n $(NAMESPACE) -l app=postgres --tail=100 -f

dev-postgres-port-forward: ## Port-forward PostgreSQL to localhost:5432
	@pkill -f "kubectl port-forward.*postgres" 2>/dev/null || true
	@echo "$(BLUE)PostgreSQL at localhost:5432 (Ctrl+C to stop)$(NC)"
	@kubectl port-forward -n $(NAMESPACE) svc/postgres-service 5432:5432

# ==========================================
# DEV - EMQX (MQTT Broker)
# ==========================================

dev-emqx-deploy: ## Deploy EMQX operator + cluster
	@$(SCRIPTS_DIR)/setup-emqx-operator.sh

dev-emqx-destroy: ## Remove EMQX cluster
	@echo "$(RED)Removing EMQX...$(NC)"
	@kubectl delete emqx emqx -n $(NAMESPACE) --ignore-not-found=true
	@helm uninstall emqx-operator -n emqx-operator-system 2>/dev/null || true
	@kubectl delete namespace emqx-operator-system --ignore-not-found=true --wait=false
	@echo "$(GREEN)EMQX removed$(NC)"

dev-emqx-dashboard: ## Port-forward EMQX dashboard (localhost:18083, admin/public)
	@pkill -f "kubectl port-forward.*emqx-dashboard" 2>/dev/null || true
	@echo "$(BLUE)EMQX Dashboard at http://localhost:18083 (admin/public)$(NC)"
	@kubectl port-forward -n $(NAMESPACE) svc/emqx-dashboard 18083:18083

dev-emqx-status: ## Check EMQX cluster status
	@echo "$(BLUE)EMQX Cluster:$(NC)"
	@kubectl get emqx -n $(NAMESPACE) 2>/dev/null || echo "$(YELLOW)EMQX not deployed$(NC)"
	@echo ""
	@echo "$(BLUE)EMQX Pods:$(NC)"
	@kubectl get pods -n $(NAMESPACE) -l apps.emqx.io/managed-by=emqx-operator 2>/dev/null || echo "$(YELLOW)No EMQX pods$(NC)"
	@echo ""
	@echo "$(BLUE)EMQX Services:$(NC)"
	@kubectl get svc -n $(NAMESPACE) -l apps.emqx.io/managed-by=emqx-operator 2>/dev/null || echo "$(YELLOW)No EMQX services$(NC)"

dev-mqtt-forward: ## Port-forward MQTT 1883 for Raspberry Pi access
	@pkill -f "kubectl port-forward.*1883" 2>/dev/null || true
	@echo "$(BLUE)MQTT broker at localhost:1883$(NC)"
	@echo "$(YELLOW)Raspberry Pis can connect to $(shell hostname -I | awk '{print $$1}'):1883$(NC)"
	@kubectl port-forward -n $(NAMESPACE) svc/emqx-listeners 1883:1883

dev-mqtt-test: ## Test MQTT connectivity with mosquitto
	@echo "$(BLUE)Testing MQTT connectivity...$(NC)"
	@if command -v mosquitto_pub >/dev/null 2>&1; then \
		MINIKUBE_IP=$$(minikube ip); \
		mosquitto_pub -h $$MINIKUBE_IP -p 31883 -t "vertivo/test" -m '{"test": true}' && \
		echo "$(GREEN)MQTT connection successful$(NC)"; \
	else \
		echo "$(YELLOW)mosquitto-clients not installed. Install with: sudo apt install mosquitto-clients$(NC)"; \
		echo "$(BLUE)Alternative: use EMQX dashboard WebSocket client at localhost:18083$(NC)"; \
	fi

# ==========================================
# DEV - Backend (Serverpod)
# ==========================================

dev-backend-build: ## Build backend Podman image + load into minikube
	@$(SCRIPTS_DIR)/build-backend-image-minikube.sh

dev-backend-deploy: ## Deploy backend to minikube (kustomize overlay)
	@echo "$(BLUE)Deploying backend...$(NC)"
	@kubectl apply -k k8s/overlays/dev/backend --server-side
	@kubectl rollout status deployment/vertivo-backend -n $(NAMESPACE) --timeout=120s
	@echo "$(GREEN)Backend deployed$(NC)"

dev-backend-start: ## Start backend locally (dev mode with docker-compose DB)
	@echo "$(BLUE)Starting backend in dev mode...$(NC)"
	@cd apps/vertivo_server && docker compose up -d
	@cd apps/vertivo_server && dart bin/main.dart --apply-migrations

dev-backend-logs: ## Tail backend pod logs
	@kubectl logs -n $(NAMESPACE) -l app=vertivo-backend --tail=100 -f

dev-backend-generate: ## Run Serverpod generate (protocol + client stubs)
	@echo "$(BLUE)Generating Serverpod protocol...$(NC)"
	@cd apps/vertivo_server && dart pub get
	@cd apps/vertivo_server && dart pub global run serverpod_cli generate
	@echo "$(GREEN)Protocol generated$(NC)"

dev-backend-restart: ## Restart backend deployment
	@kubectl rollout restart deployment/vertivo-backend -n $(NAMESPACE)
	@kubectl rollout status deployment/vertivo-backend -n $(NAMESPACE) --timeout=120s
	@echo "$(GREEN)Backend restarted$(NC)"

# ==========================================
# DEV - All Services
# ==========================================

dev-all-deploy: ## Deploy all services (postgres + emqx + backend)
	@$(MAKE) dev-postgres-deploy
	@$(MAKE) dev-emqx-deploy
	@$(MAKE) dev-backend-build
	@$(MAKE) dev-backend-deploy

dev-all-destroy: ## Destroy all resources in vertivo-dev namespace
	@echo "$(RED)Destroying all vertivo-dev resources...$(NC)"
	@kubectl delete emqx emqx -n $(NAMESPACE) --ignore-not-found=true
	@kubectl delete -k k8s/overlays/dev --ignore-not-found=true 2>/dev/null || true
	@echo "$(GREEN)All resources destroyed$(NC)"

dev-all-port-forward: ## Expose all services at once (background port-forwards)
	@echo "$(BLUE)Starting all port-forwards (background)...$(NC)"
	@pkill -f "kubectl port-forward.*vertivo-dev" 2>/dev/null || true
	@kubectl port-forward -n $(NAMESPACE) svc/postgres-service 5432:5432 >/dev/null 2>&1 &
	@echo "  $(GREEN)PostgreSQL$(NC)     → localhost:5432"
	@kubectl port-forward -n $(NAMESPACE) svc/emqx-listeners 1883:1883 >/dev/null 2>&1 &
	@echo "  $(GREEN)MQTT Broker$(NC)    → localhost:1883"
	@kubectl port-forward -n $(NAMESPACE) svc/emqx-listeners 8083:8083 >/dev/null 2>&1 &
	@echo "  $(GREEN)MQTT WebSocket$(NC) → localhost:8083"
	@kubectl port-forward -n $(NAMESPACE) svc/emqx-dashboard 18083:18083 >/dev/null 2>&1 &
	@echo "  $(GREEN)EMQX Dashboard$(NC) → localhost:18083 (admin/public)"
	@echo ""
	@echo "$(GREEN)All ports forwarded. Stop with: make dev-all-port-forward-stop$(NC)"
	@echo "$(YELLOW)Raspberry Pis can connect to $(shell hostname -I | awk '{print $$1}'):1883$(NC)"

dev-all-port-forward-stop: ## Stop all background port-forwards
	@pkill -f "kubectl port-forward.*vertivo-dev" 2>/dev/null || true
	@pkill -f "kubectl port-forward.*emqx" 2>/dev/null || true
	@pkill -f "kubectl port-forward.*postgres" 2>/dev/null || true
	@echo "$(GREEN)All port-forwards stopped$(NC)"

dev-all-status: ## Show status of all pods and services
	@echo "$(BLUE)═══ Pods ═══$(NC)"
	@kubectl get pods -n $(NAMESPACE) -o wide 2>/dev/null || echo "$(YELLOW)Namespace not found$(NC)"
	@echo ""
	@echo "$(BLUE)═══ Services ═══$(NC)"
	@kubectl get svc -n $(NAMESPACE) 2>/dev/null || true
	@echo ""
	@echo "$(BLUE)═══ EMQX ═══$(NC)"
	@kubectl get emqx -n $(NAMESPACE) 2>/dev/null || echo "$(YELLOW)EMQX not deployed$(NC)"
	@echo ""
	@echo "$(BLUE)═══ PVCs ═══$(NC)"
	@kubectl get pvc -n $(NAMESPACE) 2>/dev/null || true

# ==========================================
# DEV - Raspberry Pi (Orquestador de Monitoreo)
# ==========================================

dev-raspberry-install: ## Install Python dependencies for Raspberry Pi orchestrator
	@echo "$(BLUE)Installing Raspberry Pi orchestrator dependencies...$(NC)"
	@cd apps/raspberry && ( [ -d .venv ] || python3 -m venv .venv ) && .venv/bin/pip install -r requirements.txt
	@echo "$(GREEN)Dependencies installed$(NC)"

dev-raspberry-start: ## Start orchestrator in indoor mode (connects to EMQX)
	@echo "$(BLUE)Starting Raspberry Pi orchestrator (indoor mode)...$(NC)"
	@cd apps/raspberry && .venv/bin/python3 -m src.main --orchestrator-mode indoor --debug

dev-raspberry-test: ## Run Raspberry Pi orchestrator tests
	@echo "$(BLUE)Running orchestrator tests...$(NC)"
	@cd apps/raspberry && .venv/bin/python3 -m pytest tests/ -v

dev-raspberry-lint: ## Lint Raspberry Pi orchestrator code
	@cd apps/raspberry && .venv/bin/python3 -m ruff check src/ tests/ 2>/dev/null || .venv/bin/python3 -m flake8 src/ tests/ 2>/dev/null || echo "$(YELLOW)Install ruff or flake8 for linting$(NC)"

dev-raspberry-emqx-sim: ## Simulate sensor data to EMQX via mosquitto_pub (quick test)
	@echo "$(BLUE)Simulating sensor data to EMQX...$(NC)"
	@MINIKUBE_IP=$$(minikube ip 2>/dev/null || echo "localhost"); \
	if command -v mosquitto_pub >/dev/null 2>&1; then \
		for sensor in temperature humidity co2 ph light soil_moisture; do \
			VALUE=$$(python3 -c "import random; print(round(random.uniform(15,35),1))"); \
			mosquitto_pub -h $$MINIKUBE_IP -p 31883 \
				-t "vertivo/1/greenhouse/1/sensor/$$sensor" \
				-m "{\"value\": $$VALUE, \"unit\": \"test\", \"sensorId\": \"sim-$$sensor\"}" && \
			echo "  $(GREEN)$$sensor$(NC) → $$VALUE"; \
		done; \
		echo "$(GREEN)Simulation complete$(NC)"; \
	else \
		echo "$(YELLOW)mosquitto-clients not installed. Install: sudo apt install mosquitto-clients$(NC)"; \
	fi

dev-raspberry-i2c-sim: ## Full pipeline simulation — simulated sensors → monitors → MQTT (no I2C needed)
	@echo "$(BLUE)Starting full pipeline simulation (no I2C hardware required)...$(NC)"
	@echo "$(YELLOW)Scenario: $${SCENARIO:-normal} | Interval: $${INTERVAL:-30}s$(NC)"
	@cd apps/raspberry && .venv/bin/python3 -m src.main \
		--orchestrator-mode indoor \
		--simulate \
		--scenario $${SCENARIO:-normal} \
		--sim-interval $${INTERVAL:-30} \
		--debug

dev-raspberry-i2c-sim-scenarios: ## List available simulation scenarios
	@cd apps/raspberry && .venv/bin/python3 -m src.main --orchestrator-mode indoor --list-scenarios

# ==========================================
# DEV - Raspberry Pi Balena (Deployment)
# ==========================================

FLEET ?= vertivo-rpi
DEVICE_IP ?= 10.0.0.1
DEVICE_TYPE ?= raspberrypi4-64

bootstrap-raspberry: ## Interactive wizard: collect client data → create fleet → deploy to Balena
	@chmod +x $(SCRIPTS_DIR)/bootstrap-raspberry.sh
	@$(SCRIPTS_DIR)/bootstrap-raspberry.sh

dev-raspberry-balena-push: ## Push to balenaCloud fleet (FLEET=myfleet)
	@echo "$(BLUE)Pushing to balenaCloud fleet '$(FLEET)'...$(NC)"
	@cd apps/raspberry && balena push $(FLEET) --source .

dev-raspberry-balena-local: ## Push to local balenaOS device (DEVICE_IP=10.0.0.1)
	@echo "$(BLUE)Pushing to local device at $(DEVICE_IP)...$(NC)"
	@cd apps/raspberry && balena push $(DEVICE_IP) --source .

dev-raspberry-balena-build: ## Build Balena image locally (no push)
	@echo "$(BLUE)Building Balena image for $(DEVICE_TYPE)...$(NC)"
	@cd apps/raspberry && balena build --deviceType $(DEVICE_TYPE) --arch aarch64

dev-raspberry-balena-preload: ## Preload release into SD card .img (IMG=path/to/balena.img)
	@chmod +x $(SCRIPTS_DIR)/bootstrap-raspberry.sh
	@$(SCRIPTS_DIR)/bootstrap-raspberry.sh --preload

dev-raspberry-balena-status: ## Show fleet devices and status
	@echo "$(BLUE)Fleet '$(FLEET)' status:$(NC)"
	@balena fleet $(FLEET) 2>/dev/null || echo "$(YELLOW)Fleet '$(FLEET)' not found. Set FLEET=<name>$(NC)"
	@echo ""
	@echo "$(BLUE)Devices:$(NC)"
	@balena devices --fleet $(FLEET) 2>/dev/null || echo "$(YELLOW)No devices or fleet not found$(NC)"

# ==========================================
# DEV - Flutter
# ==========================================

dev-flutter-start: ## Run Flutter app
	@cd apps/vertivo_flutter && flutter run

dev-flutter-build: ## Build Flutter web for Serverpod
	@cd apps/vertivo_flutter && flutter build web --base-href /app/ --wasm --output ../vertivo_server/web/app

# ==========================================
# DEV - ArgoCD
# ==========================================

dev-argocd-deploy: ## Install ArgoCD + vertivo apps
	@echo "$(BLUE)Installing ArgoCD...$(NC)"
	@kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
	@kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	@echo "$(BLUE)Waiting for ArgoCD...$(NC)"
	@kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=180s
	@kubectl apply -f k8s/argocd/projects/vertivo-dev-project.yaml
	@kubectl apply -f k8s/argocd/app-of-apps.yaml
	@echo "$(GREEN)ArgoCD deployed with vertivo apps$(NC)"

dev-argocd-status: ## Show ArgoCD applications
	@echo "$(BLUE)ArgoCD Applications:$(NC)"
	@kubectl get applications -n argocd 2>/dev/null || echo "$(YELLOW)ArgoCD not installed$(NC)"

dev-argocd-password: ## Get ArgoCD admin password
	@echo "$(BLUE)ArgoCD Admin Password:$(NC)"
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' 2>/dev/null | base64 -d && echo || echo "$(YELLOW)ArgoCD not installed$(NC)"

# ==========================================
# Turbo (Monorepo orchestration)
# ==========================================

build: ## Build all packages (turbo)
	@pnpm turbo build

lint: ## Lint all packages (turbo)
	@pnpm turbo lint

test: ## Test all packages (turbo)
	@pnpm turbo test

generate: ## Generate Serverpod protocol
	@cd apps/vertivo_server && dart pub global run serverpod_cli generate

migrate: ## Create Serverpod migration
	@cd apps/vertivo_server && dart pub global run serverpod_cli create-migration

# ==========================================
# DEV - Documentation (Zensical)
# ==========================================

dev-docs-install: ## Install docs dependencies (Zensical + MkDocs Material)
	@echo "$(BLUE)Installing docs dependencies...$(NC)"
	@cd docs && ( [ -d .venv ] || python3 -m venv .venv ) && .venv/bin/pip install -r requirements.txt
	@echo "$(GREEN)Docs dependencies installed$(NC)"

dev-docs-serve: ## Serve docs locally with hot-reload
	@echo "$(BLUE)Serving docs at http://localhost:8000 ...$(NC)"
	@cd docs && .venv/bin/zensical serve -f mkdocs.yml 2>/dev/null || .venv/bin/mkdocs serve -f mkdocs.yml

dev-docs-build: ## Build static docs site
	@echo "$(BLUE)Building docs...$(NC)"
	@cd docs && .venv/bin/zensical build -f mkdocs.yml 2>/dev/null || .venv/bin/mkdocs build -f mkdocs.yml
	@echo "$(GREEN)Docs built → docs/site/$(NC)"

# ==========================================
# Dashboard (Jaspr + D3.js)
# ==========================================

dev-dashboard-install: ## Install Jaspr CLI + dashboard dependencies
	@echo "$(BLUE)Installing Jaspr CLI...$(NC)"
	@dart pub global activate jaspr_cli
	@echo "$(BLUE)Installing dashboard dependencies...$(NC)"
	@cd apps/vertivo_dashboard && dart pub get
	@echo "$(GREEN)Dashboard ready. Run: make dev-dashboard-serve$(NC)"

dev-dashboard-serve: ## Serve dashboard at localhost:8080 with hot-reload
	@echo "$(BLUE)Serving dashboard at http://localhost:8080 ...$(NC)"
	@cd apps/vertivo_dashboard && jaspr serve

dev-dashboard-build: ## Build static dashboard for deployment
	@echo "$(BLUE)Building dashboard...$(NC)"
	@cd apps/vertivo_dashboard && jaspr build
	@echo "$(GREEN)Dashboard built → apps/vertivo_dashboard/build/$(NC)"

.DEFAULT_GOAL := help
