# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# All Rights Reserved.
#
# Phase 5 — server E2E: POST /control validates and publishes the correct
# JSON command to MQTT (paho bridge mocked). Invalid commands -> 4xx, no publish.

import os
import sys

import pytest
from fastapi.testclient import TestClient

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..")))

from sim_control.server import create_app  # noqa: E402


class FakeBridge:
    """Stand-in for MqttBridge: records published commands instead of using MQTT."""

    host = "localhost"
    port = 1883
    user_id = "1"
    greenhouse_id = "1"
    connected = True

    def __init__(self):
        self.published = []

    def publish_control(self, command):
        self.published.append(command)
        return True

    def control_topic(self):
        return f"vertivo/sim/greenhouse/{self.greenhouse_id}/control"


@pytest.fixture
def bridge():
    return FakeBridge()


@pytest.fixture
def client(bridge):
    app = create_app(bridge=bridge)
    return TestClient(app)


class TestControlEndpoint:
    def test_valid_set_target_publishes(self, client, bridge):
        resp = client.post("/control", json={"sensor": "ph", "action": "set_target", "value": 6.6})
        assert resp.status_code == 200
        assert resp.json()["published"] is True
        assert bridge.published == [{"sensor": "ph", "action": "set_target", "value": 6.6}]

    def test_kill_all_publishes(self, client, bridge):
        resp = client.post("/control", json={"action": "kill_all"})
        assert resp.status_code == 200
        assert bridge.published == [{"action": "kill_all"}]

    def test_inject_anomaly_publishes_offset(self, client, bridge):
        resp = client.post(
            "/control", json={"sensor": "orp", "action": "inject_anomaly", "magnitude": 120.0}
        )
        assert resp.status_code == 200
        assert bridge.published[0] == {
            "sensor": "orp",
            "action": "inject_anomaly",
            "magnitude": 120.0,
        }

    def test_ph_calibrate_publishes_point(self, client, bridge):
        resp = client.post(
            "/control",
            json={"sensor": "ph", "action": "calibrate", "point": "mid", "value": 7.0},
        )
        assert resp.status_code == 200
        assert bridge.published[0] == {
            "sensor": "ph",
            "action": "calibrate",
            "point": "mid",
            "value": 7.0,
        }

    def test_invalid_command_rejected_no_publish(self, client, bridge):
        resp = client.post("/control", json={"sensor": "banana", "action": "set_target", "value": 1})
        assert resp.status_code == 422
        assert bridge.published == []

    def test_missing_action_rejected(self, client, bridge):
        resp = client.post("/control", json={"sensor": "ph"})
        assert resp.status_code == 422
        assert bridge.published == []

    def test_set_interval_published(self, client, bridge):
        resp = client.post("/control", json={"action": "set_interval", "seconds": 5})
        assert resp.status_code == 200
        assert bridge.published[0] == {"action": "set_interval", "seconds": 5}


class TestConfigEndpoint:
    def test_config_reports_topic_identifiers(self, client):
        resp = client.get("/config")
        assert resp.status_code == 200
        body = resp.json()
        assert body["greenhouse_id"] == "1"
        assert body["connected"] is True
        # Security: /config must not leak user_id to (localhost) callers.
        assert "user_id" not in body

    def test_control_rejects_non_json_content_type(self, client):
        # CSRF mitigation: only application/json is accepted.
        resp = client.post(
            "/control",
            content=b'{"action":"kill_all"}',
            headers={"content-type": "text/plain"},
        )
        assert resp.status_code == 415


class TestStaticRoutes:
    def test_index_served(self, client):
        resp = client.get("/")
        assert resp.status_code == 200
        assert "html" in resp.headers["content-type"].lower()
