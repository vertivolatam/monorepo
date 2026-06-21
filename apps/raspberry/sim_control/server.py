# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# All Rights Reserved.
#
# FastAPI control panel (Phase 3-5). Serves the instrument grid + wiring view,
# validates control commands and publishes them to MQTT, and mirrors live
# sensor values back to the browser over Server-Sent Events.

import asyncio
import json
import logging
import os
import queue
import threading
from contextlib import asynccontextmanager

from fastapi import FastAPI, Request
from fastapi.responses import FileResponse, JSONResponse, StreamingResponse

from sim_control.control_schema import ValidationError, validate_command
from sim_control.mqtt_bridge import MqttBridge

logger = logging.getLogger(__name__)

HERE = os.path.dirname(os.path.abspath(__file__))
INDEX_HTML = os.path.join(HERE, "index.html")
TOPOLOGY_YAML = os.path.join(HERE, "topology.yaml")


def load_mqtt_config():
    """Read host/port + user/greenhouse from config/current/mqtt_dev.json.

    Falls back to localhost:1883 / user "1" / greenhouse "1" so the panel can
    still boot (degraded) if the config is missing.
    """
    cfg_path = os.path.join(
        HERE, "..", "config", "current", "mqtt_dev.json"
    )
    defaults = {"host": "localhost", "port": 1883, "user_id": "1", "greenhouse_id": "1"}
    try:
        with open(cfg_path, "r", encoding="utf-8") as fh:
            raw = json.load(fh)
    except (OSError, ValueError) as exc:
        logger.warning(f"sim-control: could not read mqtt_dev.json ({exc}); using defaults")
        return defaults

    conn = raw.get("mqtt_connection", {})
    return {
        "host": conn.get("endpoint", defaults["host"]),
        "port": int(conn.get("port", defaults["port"])),
        "user_id": str(raw.get("user_id", defaults["user_id"])),
        "greenhouse_id": str(raw.get("greenhouse_id", defaults["greenhouse_id"])),
    }


class SensorHub:
    """Fan-out of live sensor values to any number of SSE subscribers.

    Each browser connection registers a thread-safe queue; the MQTT callback
    (running on the paho network thread) pushes JSON events into every queue.
    Keeps the latest value per sensor so a freshly-connected browser is
    immediately populated.
    """

    def __init__(self):
        self._subscribers = []
        self._latest = {}
        self._lock = threading.Lock()

    def publish(self, sensor_type, payload):
        event = json.dumps({"sensor": sensor_type, "payload": payload})
        with self._lock:
            self._latest[sensor_type] = payload
            subs = list(self._subscribers)
        for q in subs:
            try:
                q.put_nowait(event)
            except queue.Full:  # pragma: no cover - slow client
                pass

    def subscribe(self):
        q = queue.Queue(maxsize=100)
        with self._lock:
            self._subscribers.append(q)
            snapshot = dict(self._latest)
        # Seed the new subscriber with the latest known value of each sensor.
        for sensor_type, payload in snapshot.items():
            q.put_nowait(json.dumps({"sensor": sensor_type, "payload": payload}))
        return q

    def unsubscribe(self, q):
        with self._lock:
            if q in self._subscribers:
                self._subscribers.remove(q)


def create_app(bridge=None, hub=None):
    """Build the FastAPI app.

    bridge/hub can be injected for testing; in production they are created from
    config and wired together on startup.
    """
    owns_bridge = bridge is None
    cfg = load_mqtt_config() if owns_bridge else {
        "host": getattr(bridge, "host", "localhost"),
        "port": getattr(bridge, "port", 1883),
        "user_id": getattr(bridge, "user_id", "1"),
        "greenhouse_id": getattr(bridge, "greenhouse_id", "1"),
    }

    @asynccontextmanager
    async def lifespan(app):
        if owns_bridge:
            b = MqttBridge(
                host=cfg["host"],
                port=cfg["port"],
                user_id=cfg["user_id"],
                greenhouse_id=cfg["greenhouse_id"],
                on_sensor=app.state.hub.publish,
            )
            b.connect()
            app.state.bridge = b
        try:
            yield
        finally:
            if owns_bridge and app.state.bridge is not None:
                app.state.bridge.disconnect()

    app = FastAPI(title="Vertivo Simulator Control", lifespan=lifespan)
    app.state.hub = hub or SensorHub()
    app.state.bridge = bridge
    app.state.config = cfg

    @app.get("/")
    def index():
        return FileResponse(INDEX_HTML)

    @app.get("/topology.yaml")
    def topology():
        return FileResponse(TOPOLOGY_YAML, media_type="text/yaml")

    @app.get("/config")
    def config():
        # Dev/QA panel bound to localhost (Makefile: --host 127.0.0.1). Only
        # expose what the panel renders; never leak user_id to callers.
        cfg = dict(app.state.config)
        return {
            "host": cfg.get("host"),
            "port": cfg.get("port"),
            "greenhouse_id": cfg.get("greenhouse_id"),
            "connected": bool(getattr(app.state.bridge, "connected", False)),
        }

    @app.post("/control")
    async def control(request: Request):
        # CSRF mitigation: a cross-origin simple form/POST can't set this
        # content-type without a CORS preflight it can't satisfy.
        ctype = request.headers.get("content-type", "").split(";")[0].strip()
        if ctype != "application/json":
            return JSONResponse(
                {"error": "content-type must be application/json"}, status_code=415
            )
        try:
            body = await request.json()
        except (ValueError, json.JSONDecodeError):
            return JSONResponse({"error": "invalid JSON body"}, status_code=400)

        try:
            command = validate_command(body)
        except ValidationError as exc:
            return JSONResponse({"error": str(exc)}, status_code=422)

        bridge = app.state.bridge
        if bridge is None:
            return JSONResponse({"error": "MQTT bridge not ready"}, status_code=503)

        ok = bridge.publish_control(command)
        return JSONResponse({"published": bool(ok), "command": command})

    @app.get("/events")
    async def events(request: Request):
        hub_ref = app.state.hub
        q = hub_ref.subscribe()

        async def event_stream():
            try:
                while True:
                    if await request.is_disconnected():
                        break
                    try:
                        event = q.get(timeout=1.0)
                        yield f"data: {event}\n\n"
                    except queue.Empty:
                        # Heartbeat keeps the connection (and proxies) alive.
                        yield ": ping\n\n"
                    await asyncio.sleep(0)
            finally:
                hub_ref.unsubscribe(q)

        return StreamingResponse(event_stream(), media_type="text/event-stream")

    return app


app = create_app()
