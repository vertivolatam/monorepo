#!/usr/bin/env bash
# ============================================================
# Vertivo — Raspberry Pi Bootstrap (Balena Deployment)
# ============================================================
#
# Interactive wizard that collects client data and deploys the
# monitoring orchestrator to a Raspberry Pi fleet via Balena.
#
# Supports:
#   - balenaCloud (managed)
#   - open-balena (self-hosted)
#   - Local mode (push directly to device IP)
#
# Usage:
#   ./bootstrap-raspberry.sh              # Interactive wizard
#   ./bootstrap-raspberry.sh --local-push # Push to local device
#   ./bootstrap-raspberry.sh --preload    # Preload SD card image
# ============================================================

set -euo pipefail

BLUE='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
RASPBERRY_DIR="${REPO_ROOT}/apps/raspberry"

# ── Helpers ──────────────────────────────────────────────────

info()  { echo -e "${BLUE}  $*${NC}"; }
ok()    { echo -e "${GREEN}  $*${NC}"; }
warn()  { echo -e "${YELLOW}  $*${NC}"; }
err()   { echo -e "${RED}  $*${NC}" >&2; }

ask() {
    local prompt="$1" default="${2:-}" var_name="$3"
    if [[ -n "$default" ]]; then
        echo -en "${BOLD}  ${prompt}${NC} [${default}]: "
    else
        echo -en "${BOLD}  ${prompt}${NC}: "
    fi
    read -r input
    eval "${var_name}=\"${input:-$default}\""
}

ask_choice() {
    local prompt="$1" var_name="$2"
    shift 2
    local options=("$@")
    echo -e "\n${BOLD}  ${prompt}${NC}"
    for i in "${!options[@]}"; do
        echo -e "    $((i+1))) ${options[$i]}"
    done
    echo -en "  Choice [1]: "
    read -r choice
    choice="${choice:-1}"
    if [[ "$choice" -ge 1 && "$choice" -le "${#options[@]}" ]]; then
        eval "${var_name}=\"${options[$((choice-1))]}\""
    else
        eval "${var_name}=\"${options[0]}\""
    fi
}

banner() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   Vertivo — Raspberry Pi Deployment Wizard (Balena)          ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ── Prerequisites ────────────────────────────────────────────

check_prerequisites() {
    echo -e "\n${BLUE}Step 0/6: Checking prerequisites...${NC}\n"

    local missing=0

    if command -v balena >/dev/null 2>&1; then
        ok "balena CLI  $(balena version 2>/dev/null || echo '(installed)')"
    else
        err "balena CLI not found"
        warn "Install: https://github.com/balena-io/balena-cli/blob/master/INSTALL-LINUX.md"
        warn "  curl -sL https://raw.githubusercontent.com/balena-io/balena-cli/master/scripts/linux-installer.sh | bash"
        missing=1
    fi

    if command -v docker >/dev/null 2>&1; then
        ok "Docker      $(docker --version 2>/dev/null | head -1)"
    elif command -v podman >/dev/null 2>&1; then
        ok "Podman      $(podman --version 2>/dev/null) (Docker-compatible)"
    else
        err "Docker or Podman not found"
        missing=1
    fi

    if [[ ! -f "${RASPBERRY_DIR}/Dockerfile.template" ]]; then
        err "Dockerfile.template not found in apps/raspberry/"
        missing=1
    else
        ok "Dockerfile.template found"
    fi

    if [[ ! -f "${RASPBERRY_DIR}/requirements.txt" ]]; then
        err "requirements.txt not found in apps/raspberry/"
        missing=1
    else
        ok "requirements.txt found"
    fi

    if [[ "$missing" -eq 1 ]]; then
        echo ""
        err "Missing prerequisites. Fix the above issues and retry."
        exit 1
    fi

    echo ""
    ok "All prerequisites met"
}

# ── Step 1: Client info ─────────────────────────────────────

collect_client_info() {
    echo -e "\n${BLUE}Step 1/6: Client Information${NC}\n"
    info "This data identifies the deployment in MQTT topics and Balena fleet."
    echo ""

    ask "Client / Organization name" "vertivo" CLIENT_NAME
    ask "User ID (for MQTT topics: vertivo/{user_id}/...)" "1" USER_ID
    ask "Greenhouse ID" "1" GREENHOUSE_ID
    ask "Device name (human-friendly label)" "${CLIENT_NAME,,}-rpi-01" DEVICE_NAME

    echo ""
    ok "Client: ${CLIENT_NAME} | User: ${USER_ID} | Greenhouse: ${GREENHOUSE_ID}"
}

# ── Step 2: Orchestrator mode ───────────────────────────────

collect_orchestrator_mode() {
    echo -e "\n${BLUE}Step 2/6: Orchestrator Mode${NC}\n"
    info "Select the monitoring profile for this device."

    ask_choice "Orchestrator mode:" ORCH_MODE \
        "indoor"        \
        "outdoor"       \
        "soil"          \
        "environmental"

    echo ""
    ok "Mode: ${ORCH_MODE}"
}

# ── Step 3: MQTT / EMQX connection ──────────────────────────

collect_mqtt_config() {
    echo -e "\n${BLUE}Step 3/6: MQTT Connection (EMQX)${NC}\n"
    info "Where does the Raspberry Pi send sensor data?"
    echo ""

    ask "MQTT broker endpoint (IP or hostname)" "localhost" MQTT_ENDPOINT
    ask "MQTT broker port" "1883" MQTT_PORT
    ask "Enable debug logging? (true/false)" "false" DEBUG_MODE

    echo ""
    ok "MQTT: ${MQTT_ENDPOINT}:${MQTT_PORT} | Debug: ${DEBUG_MODE}"
}

# ── Step 4: Balena deployment target ────────────────────────

collect_balena_target() {
    echo -e "\n${BLUE}Step 4/6: Deployment Target${NC}\n"

    ask_choice "Balena deployment mode:" DEPLOY_MODE \
        "balenaCloud (managed — balena.io)"      \
        "open-balena (self-hosted)"              \
        "Local push (device IP on LAN)"

    case "$DEPLOY_MODE" in
        "balenaCloud"*)
            DEPLOY_TYPE="cloud"
            info "Using balenaCloud. Make sure you are logged in (balena login)."
            echo ""
            ask "Fleet name (will be created if missing)" "vertivo-${CLIENT_NAME,,}" FLEET_NAME
            ;;
        "open-balena"*)
            DEPLOY_TYPE="openbalena"
            echo ""
            ask "open-balena API endpoint (e.g. openbalena.mycompany.com)" "" OB_ENDPOINT
            ask "Fleet name" "vertivo-${CLIENT_NAME,,}" FLEET_NAME
            ;;
        "Local push"*)
            DEPLOY_TYPE="local"
            echo ""
            ask "Device IP address on LAN" "10.0.0.1" DEVICE_IP
            ;;
    esac

    if [[ "$DEPLOY_TYPE" != "local" ]]; then
        ask_choice "Raspberry Pi model:" DEVICE_TYPE \
            "raspberrypi4-64"  \
            "raspberrypi5"     \
            "raspberrypi3-64"  \
            "raspberrypi3"
        echo ""
        ok "Device type: ${DEVICE_TYPE}"
    fi

    echo ""
    ok "Deploy mode: ${DEPLOY_TYPE}"
}

# ── Step 5: Summary & confirm ───────────────────────────────

confirm_deployment() {
    echo -e "\n${BLUE}Step 5/6: Deployment Summary${NC}\n"

    echo -e "  ${BOLD}Client:${NC}          ${CLIENT_NAME}"
    echo -e "  ${BOLD}User ID:${NC}         ${USER_ID}"
    echo -e "  ${BOLD}Greenhouse ID:${NC}   ${GREENHOUSE_ID}"
    echo -e "  ${BOLD}Device name:${NC}     ${DEVICE_NAME}"
    echo -e "  ${BOLD}Mode:${NC}            ${ORCH_MODE}"
    echo -e "  ${BOLD}MQTT endpoint:${NC}   ${MQTT_ENDPOINT}:${MQTT_PORT}"
    echo -e "  ${BOLD}Debug:${NC}           ${DEBUG_MODE}"
    echo -e "  ${BOLD}Deploy target:${NC}   ${DEPLOY_TYPE}"

    case "$DEPLOY_TYPE" in
        cloud)
            echo -e "  ${BOLD}Fleet:${NC}           ${FLEET_NAME}"
            echo -e "  ${BOLD}Device type:${NC}     ${DEVICE_TYPE}"
            ;;
        openbalena)
            echo -e "  ${BOLD}open-balena:${NC}     ${OB_ENDPOINT}"
            echo -e "  ${BOLD}Fleet:${NC}           ${FLEET_NAME}"
            echo -e "  ${BOLD}Device type:${NC}     ${DEVICE_TYPE}"
            ;;
        local)
            echo -e "  ${BOLD}Device IP:${NC}       ${DEVICE_IP}"
            ;;
    esac

    echo ""
    echo -en "  ${BOLD}Proceed with deployment? [Y/n]:${NC} "
    read -r confirm
    if [[ "${confirm,,}" == "n" ]]; then
        warn "Deployment cancelled."
        exit 0
    fi
}

# ── Step 6: Deploy ──────────────────────────────────────────

deploy() {
    echo -e "\n${BLUE}Step 6/6: Deploying...${NC}\n"

    cd "${RASPBERRY_DIR}"

    case "$DEPLOY_TYPE" in
        cloud)
            deploy_cloud
            ;;
        openbalena)
            deploy_openbalena
            ;;
        local)
            deploy_local
            ;;
    esac
}

deploy_cloud() {
    # Ensure logged in
    if ! balena whoami >/dev/null 2>&1; then
        info "Not logged in to balenaCloud. Opening login..."
        balena login
    fi

    # Create fleet if it doesn't exist
    if ! balena fleet "${FLEET_NAME}" >/dev/null 2>&1; then
        info "Creating fleet: ${FLEET_NAME} (${DEVICE_TYPE})..."
        balena fleet create "${FLEET_NAME}" --type "${DEVICE_TYPE}" || true
    else
        ok "Fleet '${FLEET_NAME}' already exists"
    fi

    # Set fleet environment variables
    info "Setting fleet environment variables..."
    balena env set VERTIVO_ORCHESTRATOR_MODE "${ORCH_MODE}"    --fleet "${FLEET_NAME}"
    balena env set VERTIVO_USER_ID           "${USER_ID}"      --fleet "${FLEET_NAME}"
    balena env set VERTIVO_GREENHOUSE_ID     "${GREENHOUSE_ID}" --fleet "${FLEET_NAME}"
    balena env set VERTIVO_MQTT_ENDPOINT     "${MQTT_ENDPOINT}" --fleet "${FLEET_NAME}"
    balena env set VERTIVO_MQTT_PORT         "${MQTT_PORT}"     --fleet "${FLEET_NAME}"
    balena env set VERTIVO_DEBUG             "${DEBUG_MODE}"    --fleet "${FLEET_NAME}"

    # Deploy
    info "Building and pushing to balenaCloud fleet '${FLEET_NAME}'..."
    balena push "${FLEET_NAME}" --source .

    echo ""
    ok "Deployed to balenaCloud fleet '${FLEET_NAME}'!"
    echo ""
    info "Next steps:"
    info "  1. Flash a balenaOS image to an SD card:  balena os download ${DEVICE_TYPE} -o vertivo-os.img"
    info "  2. Configure the image:                   balena os configure vertivo-os.img --fleet ${FLEET_NAME}"
    info "  3. Flash to SD card:                      balena os initialize vertivo-os.img --type ${DEVICE_TYPE} --drive /dev/sdX"
    info "  4. Or provision interactively:             balena device init --fleet ${FLEET_NAME}"
    info "  5. Monitor in dashboard:                   https://dashboard.balena-cloud.com"
}

deploy_openbalena() {
    # Login to open-balena
    info "Logging in to open-balena at ${OB_ENDPOINT}..."
    balena login --server "${OB_ENDPOINT}" || {
        err "Failed to login to open-balena. Check your endpoint and credentials."
        exit 1
    }

    # Create fleet if it doesn't exist
    if ! balena fleet "${FLEET_NAME}" >/dev/null 2>&1; then
        info "Creating fleet: ${FLEET_NAME} (${DEVICE_TYPE})..."
        balena fleet create "${FLEET_NAME}" --type "${DEVICE_TYPE}" || true
    else
        ok "Fleet '${FLEET_NAME}' already exists"
    fi

    # Set fleet environment variables
    info "Setting fleet environment variables..."
    balena env set VERTIVO_ORCHESTRATOR_MODE "${ORCH_MODE}"    --fleet "${FLEET_NAME}"
    balena env set VERTIVO_USER_ID           "${USER_ID}"      --fleet "${FLEET_NAME}"
    balena env set VERTIVO_GREENHOUSE_ID     "${GREENHOUSE_ID}" --fleet "${FLEET_NAME}"
    balena env set VERTIVO_MQTT_ENDPOINT     "${MQTT_ENDPOINT}" --fleet "${FLEET_NAME}"
    balena env set VERTIVO_MQTT_PORT         "${MQTT_PORT}"     --fleet "${FLEET_NAME}"
    balena env set VERTIVO_DEBUG             "${DEBUG_MODE}"    --fleet "${FLEET_NAME}"

    # Deploy using --noparent-check for open-balena
    info "Building and deploying to open-balena fleet '${FLEET_NAME}'..."
    balena deploy --noparent-check "${FLEET_NAME}" --source .

    echo ""
    ok "Deployed to open-balena fleet '${FLEET_NAME}'!"
    echo ""
    info "Next steps:"
    info "  1. Download balenaOS for your device type from the open-balena dashboard"
    info "  2. Configure: balena os configure <image> --fleet ${FLEET_NAME}"
    info "  3. Flash the SD card and boot the device"
}

deploy_local() {
    info "Pushing to local device at ${DEVICE_IP}..."
    info "Make sure the device is in local mode (balena device local-mode <uuid> --enable)"

    balena push "${DEVICE_IP}" \
        --source . \
        --env "VERTIVO_ORCHESTRATOR_MODE=${ORCH_MODE}" \
        --env "VERTIVO_USER_ID=${USER_ID}" \
        --env "VERTIVO_GREENHOUSE_ID=${GREENHOUSE_ID}" \
        --env "VERTIVO_MQTT_ENDPOINT=${MQTT_ENDPOINT}" \
        --env "VERTIVO_MQTT_PORT=${MQTT_PORT}" \
        --env "VERTIVO_DEBUG=${DEBUG_MODE}"

    echo ""
    ok "Pushed to local device at ${DEVICE_IP}!"
    info "The device will rebuild and restart the container automatically."
}

# ── Preload SD card image ───────────────────────────────────

preload_image() {
    echo -e "\n${BLUE}Preload Mode — Burn release into SD card image${NC}\n"
    info "This injects the latest release into an .img file so the device"
    info "boots ready without downloading over the network."
    echo ""

    ask "Path to balenaOS .img file" "" IMG_PATH
    ask "Fleet name" "" FLEET_NAME

    if [[ ! -f "$IMG_PATH" ]]; then
        err "Image file not found: ${IMG_PATH}"
        exit 1
    fi

    info "Preloading fleet '${FLEET_NAME}' into ${IMG_PATH}..."
    balena preload "${IMG_PATH}" --fleet "${FLEET_NAME}"

    echo ""
    ok "Image preloaded! Flash it to an SD card and boot."
}

# ── Main ─────────────────────────────────────────────────────

main() {
    banner

    # Handle flags
    case "${1:-}" in
        --local-push)
            check_prerequisites
            collect_client_info
            collect_orchestrator_mode
            collect_mqtt_config
            DEPLOY_TYPE="local"
            ask "Device IP address on LAN" "10.0.0.1" DEVICE_IP
            confirm_deployment
            deploy
            exit 0
            ;;
        --preload)
            check_prerequisites
            preload_image
            exit 0
            ;;
    esac

    # Full interactive wizard
    check_prerequisites
    collect_client_info
    collect_orchestrator_mode
    collect_mqtt_config
    collect_balena_target
    confirm_deployment
    deploy
}

main "$@"
