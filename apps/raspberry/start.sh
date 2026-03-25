#!/bin/bash
# Vertivo Raspberry Pi — Entrypoint
# Reads Balena env vars and generates MQTT config before starting the orchestrator.

set -e

CONFIG_DIR="/app/config/current"
MQTT_CONFIG="${CONFIG_DIR}/mqtt_dev.json"

mkdir -p "${CONFIG_DIR}"

# Generate MQTT config from environment variables
cat > "${MQTT_CONFIG}" <<EOF
{
    "mqtt_client_type": "paho",
    "mqtt_connection": {
        "endpoint": "${VERTIVO_MQTT_ENDPOINT:-localhost}",
        "port": ${VERTIVO_MQTT_PORT:-1883},
        "keepalive": 60,
        "client_id_prefix": "vertivo-rpi-${BALENA_DEVICE_NAME_AT_INIT:-unknown}"
    },
    "mqtt_topics": {
        "telemetry": "vertivo/${VERTIVO_USER_ID:-1}/greenhouse/${VERTIVO_GREENHOUSE_ID:-1}/telemetry",
        "status": "vertivo/${VERTIVO_USER_ID:-1}/greenhouse/${VERTIVO_GREENHOUSE_ID:-1}/status",
        "commands": "vertivo/${VERTIVO_USER_ID:-1}/greenhouse/${VERTIVO_GREENHOUSE_ID:-1}/command/#",
        "environmental": {
            "temperature": "vertivo/${VERTIVO_USER_ID:-1}/greenhouse/${VERTIVO_GREENHOUSE_ID:-1}/sensor/temperature",
            "humidity": "vertivo/${VERTIVO_USER_ID:-1}/greenhouse/${VERTIVO_GREENHOUSE_ID:-1}/sensor/humidity",
            "co2": "vertivo/${VERTIVO_USER_ID:-1}/greenhouse/${VERTIVO_GREENHOUSE_ID:-1}/sensor/co2",
            "air_quality": "vertivo/${VERTIVO_USER_ID:-1}/greenhouse/${VERTIVO_GREENHOUSE_ID:-1}/sensor/air_quality",
            "gases": "vertivo/${VERTIVO_USER_ID:-1}/greenhouse/${VERTIVO_GREENHOUSE_ID:-1}/sensor/gases",
            "particulate_matter": "vertivo/${VERTIVO_USER_ID:-1}/greenhouse/${VERTIVO_GREENHOUSE_ID:-1}/sensor/particulate_matter"
        },
        "nutrient_solution": {
            "temperature": "vertivo/${VERTIVO_USER_ID:-1}/greenhouse/${VERTIVO_GREENHOUSE_ID:-1}/sensor/nutrient_temperature",
            "ph": "vertivo/${VERTIVO_USER_ID:-1}/greenhouse/${VERTIVO_GREENHOUSE_ID:-1}/sensor/ph",
            "ec": "vertivo/${VERTIVO_USER_ID:-1}/greenhouse/${VERTIVO_GREENHOUSE_ID:-1}/sensor/ec",
            "tds": "vertivo/${VERTIVO_USER_ID:-1}/greenhouse/${VERTIVO_GREENHOUSE_ID:-1}/sensor/tds",
            "do": "vertivo/${VERTIVO_USER_ID:-1}/greenhouse/${VERTIVO_GREENHOUSE_ID:-1}/sensor/do",
            "orp": "vertivo/${VERTIVO_USER_ID:-1}/greenhouse/${VERTIVO_GREENHOUSE_ID:-1}/sensor/orp"
        }
    },
    "mqtt_publish_interval": 30,
    "user_id": "${VERTIVO_USER_ID:-1}",
    "greenhouse_id": "${VERTIVO_GREENHOUSE_ID:-1}"
}
EOF

echo "=== Vertivo Monitoring Orchestrator ==="
echo "  Device:      ${BALENA_DEVICE_NAME_AT_INIT:-local}"
echo "  Mode:        ${VERTIVO_ORCHESTRATOR_MODE:-indoor}"
echo "  User ID:     ${VERTIVO_USER_ID:-1}"
echo "  Greenhouse:  ${VERTIVO_GREENHOUSE_ID:-1}"
echo "  MQTT:        ${VERTIVO_MQTT_ENDPOINT:-localhost}:${VERTIVO_MQTT_PORT:-1883}"
echo "========================================"

DEBUG_FLAG=""
if [ "${VERTIVO_DEBUG}" = "true" ]; then
    DEBUG_FLAG="--debug"
fi

exec python3 -m src.main \
    --orchestrator-mode "${VERTIVO_ORCHESTRATOR_MODE:-indoor}" \
    ${DEBUG_FLAG}
