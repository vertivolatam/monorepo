#!/bin/bash
#
# bootstrap-dev.sh — Full GitOps DEV environment from scratch (one-liner)
#
# Wraps the existing `make dev-*` phases with the shared logging library
# (lib/common.sh): emoji log levels, step headers, and full tee'd logging to
# logs/bootstrap/bootstrap-dev-<timestamp>.log. Deployment logic is unchanged —
# this only adds structured logging around the real phases.
#
# Phases (vertivolatam):
#   minikube → postgres → emqx → serverpod (generate/build/deploy)
#            → argocd → dashboard
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

cd "$PROJECT_ROOT"

# ============================================
# Logging setup
# ============================================
LOG_DIR="logs/bootstrap"
ensure_dir "$LOG_DIR"
LOG_FILE="$LOG_DIR/bootstrap-dev-$(get_timestamp).log"

# Redirect all stdout + stderr through tee so everything lands in the console
# AND in $LOG_FILE (preserving order). Done once, here, for the whole run.
exec > >(tee -a "$LOG_FILE") 2>&1

# ============================================
# Bootstrap
# ============================================
TOTAL_STEPS=8

log_header "Vertivo DEV Bootstrap — GitOps + EMQX + Serverpod + Dashboard"
log_info "Logging to: $LOG_FILE"

log_step 1 "$TOTAL_STEPS" "Cleaning previous environment..."
make dev-minikube-destroy 2>/dev/null || true

log_step 2 "$TOTAL_STEPS" "Prerequisites check..."
make setup

log_step 3 "$TOTAL_STEPS" "Minikube cluster (Podman + containerd)..."
make dev-minikube-deploy

log_step 4 "$TOTAL_STEPS" "PostgreSQL 16 + pgvector..."
make dev-postgres-deploy

log_step 5 "$TOTAL_STEPS" "EMQX MQTT Broker (Operator + Cluster)..."
make dev-emqx-deploy

log_step 6 "$TOTAL_STEPS" "Serverpod backend (generate + build + deploy)..."
make dev-backend-generate 2>/dev/null || log_warn "Serverpod generate skipped (install serverpod_cli: dart pub global activate serverpod_cli)"
make dev-backend-build
make dev-backend-deploy

log_step 7 "$TOTAL_STEPS" "ArgoCD GitOps..."
make dev-argocd-deploy 2>/dev/null || log_warn "ArgoCD skipped (optional, deploy manually: make dev-argocd-deploy)"

log_step 8 "$TOTAL_STEPS" "Dashboard + Docs (Dart tooling)..."
make dev-dashboard-install 2>/dev/null || log_warn "Dashboard install skipped (install jaspr_cli: dart pub global activate jaspr_cli)"

log_header "Vertivo DEV environment ready!"
log_info "Services deployed in vertivo-dev namespace:"
log_info "  PostgreSQL 16  — ClusterIP :5432"
log_info "  EMQX 5.x       — ClusterIP :1883 (MQTT), :18083 (UI)"
log_info "  Serverpod      — ClusterIP :8080 (API), :8081 (Insights)"
log_info "  ArgoCD         — argocd namespace"
echo ""
log_info "Open services:"
log_info "  make dev-all-port-forward       # Expose all ports at once (background)"
log_info "  make dev-emqx-dashboard         # EMQX Dashboard → localhost:18083 (admin/public)"
log_info "  make dev-mqtt-forward           # MQTT Broker    → localhost:1883 (Raspberry Pi)"
log_info "  make dev-postgres-port-forward  # PostgreSQL     → localhost:5432 (DBeaver)"
log_info "  make dev-dashboard-serve        # Jaspr Dashboard → localhost:8080 (D3.js)"
log_info "  make dev-flutter-start          # Flutter App    → mobile/desktop"
echo ""
log_info "Monitor:"
log_info "  make dev-all-status             # Show all pods, services, EMQX status"
log_info "  make dev-argocd-password        # Get ArgoCD admin password"
echo ""

log_success "Bootstrap complete — full log saved to $LOG_FILE"
