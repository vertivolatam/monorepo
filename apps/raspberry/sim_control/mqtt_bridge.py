# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# All Rights Reserved.
#
# Thin MQTT bridge for the control panel. The panel runs as its own process
# (separate from the simulator), so it owns its own plain paho client:
#   * publishes control commands  -> vertivo/sim/greenhouse/{gh}/control
#   * subscribes to live values   <- vertivo/{user}/greenhouse/{gh}/sensor/#
# Live values are pushed to a callback so the server can fan them out to the
# browser over SSE.

import json
import logging
import threading

import paho.mqtt.client as mqtt

logger = logging.getLogger(__name__)


class MqttBridge:
    """Owns a paho client: publishes control commands, mirrors sensor values."""

    def __init__(self, host, port, user_id, greenhouse_id, on_sensor=None, keepalive=60):
        self.host = host
        self.port = port
        self.user_id = user_id
        self.greenhouse_id = greenhouse_id
        self.keepalive = keepalive
        # Callback(sensor_type:str, payload:dict) for each live sensor message.
        self._on_sensor = on_sensor
        self.connected = False

        self._client = mqtt.Client(client_id=f"sim-control-ui-{greenhouse_id}")
        self._client.on_connect = self._handle_connect
        self._client.on_message = self._handle_message
        self._lock = threading.Lock()

    # ------------------------------------------------------------------
    # Topics
    # ------------------------------------------------------------------
    def control_topic(self):
        return f"vertivo/sim/greenhouse/{self.greenhouse_id}/control"

    def sensor_topic_wildcard(self):
        return f"vertivo/{self.user_id}/greenhouse/{self.greenhouse_id}/sensor/#"

    # ------------------------------------------------------------------
    # Lifecycle
    # ------------------------------------------------------------------
    def connect(self):
        """Connect and start the network loop. Best-effort: never raises."""
        try:
            self._client.connect(self.host, self.port, self.keepalive)
            self._client.loop_start()
            return True
        except Exception as exc:  # pragma: no cover - network dependent
            logger.warning(f"MQTT connect failed ({self.host}:{self.port}): {exc}")
            return False

    def disconnect(self):
        try:
            self._client.loop_stop()
            self._client.disconnect()
        except Exception:  # pragma: no cover - defensive
            pass

    # ------------------------------------------------------------------
    # Publish / subscribe
    # ------------------------------------------------------------------
    def publish_control(self, command):
        """Publish a (pre-validated) control command dict to the control topic."""
        payload = json.dumps(command)
        with self._lock:
            result = self._client.publish(self.control_topic(), payload, qos=0)
        return result.rc == mqtt.MQTT_ERR_SUCCESS

    def _handle_connect(self, client, userdata, flags, rc):
        if rc == 0:
            self.connected = True
            client.subscribe(self.sensor_topic_wildcard(), qos=0)
            logger.info(f"sim-control: subscribed to {self.sensor_topic_wildcard()}")
        else:  # pragma: no cover - broker dependent
            logger.warning(f"sim-control: MQTT connect rc={rc}")

    def _handle_message(self, client, userdata, msg):
        sensor_type = msg.topic.rsplit("/", 1)[-1]
        try:
            payload = json.loads(msg.payload.decode("utf-8"))
        except (ValueError, UnicodeDecodeError):  # pragma: no cover - defensive
            return
        if self._on_sensor is not None:
            try:
                self._on_sensor(sensor_type, payload)
            except Exception as exc:  # pragma: no cover - defensive
                logger.warning(f"sim-control: on_sensor callback error: {exc}")
