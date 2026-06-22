# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# All Rights Reserved.
#
# Control command validation. Mirrors the simulator's dispatcher contract
# (src/simulation/simulator.py::_dispatch) so the web panel only ever
# publishes well-formed commands. Invalid commands are rejected with a
# ValueError carrying a human-readable reason; the server turns that into
# a 4xx response instead of silently publishing a no-op.

SENSORS = (
    "ph",
    "ec",
    "do",
    "orp",
    "tds",
    "co2",
    "humidity",
    "temperature",
)

# Actions that operate on a single sensor (require a valid "sensor").
PER_SENSOR_ACTIONS = ("set_target", "inject_anomaly", "enable", "calibrate")
# Actions that are greenhouse-global (ignore "sensor").
GLOBAL_ACTIONS = ("kill_all", "set_interval")

# pH calibration points (faithful multi-point procedure).
PH_POINTS = ("low", "mid", "high")


class ValidationError(ValueError):
    """Raised when a control command does not satisfy the dispatcher contract."""


def validate_command(command):
    """Validate and normalise a control command dict.

    Returns the cleaned command dict ready to publish as JSON. Raises
    ValidationError with a descriptive message when the command is malformed.

    The contract intentionally matches the simulator dispatcher: ``action`` is
    always required; per-sensor actions require a known ``sensor``; global
    actions ignore ``sensor``.
    """
    if not isinstance(command, dict):
        raise ValidationError("command must be a JSON object")

    action = command.get("action")
    if not action or not isinstance(action, str):
        raise ValidationError("missing or invalid 'action'")

    if action in GLOBAL_ACTIONS:
        return _validate_global(action, command)

    if action in PER_SENSOR_ACTIONS:
        return _validate_per_sensor(action, command)

    raise ValidationError(f"unknown action '{action}'")


def _validate_global(action, command):
    if action == "kill_all":
        return {"action": "kill_all"}

    # set_interval
    seconds = command.get("seconds")
    if not isinstance(seconds, (int, float)) or isinstance(seconds, bool) or seconds <= 0:
        raise ValidationError("set_interval requires positive numeric 'seconds'")
    return {"action": "set_interval", "seconds": seconds}


def _validate_per_sensor(action, command):
    sensor = command.get("sensor")
    if sensor not in SENSORS:
        raise ValidationError(f"unknown sensor '{sensor}'")

    if action == "set_target":
        value = _require_number(command, "value")
        return {"sensor": sensor, "action": "set_target", "value": value}

    if action == "inject_anomaly":
        magnitude = _require_number(command, "magnitude")
        return {"sensor": sensor, "action": "inject_anomaly", "magnitude": magnitude}

    if action == "enable":
        on = command.get("on", True)
        if not isinstance(on, bool):
            raise ValidationError("enable requires boolean 'on'")
        return {"sensor": sensor, "action": "enable", "on": on}

    # calibrate
    return _validate_calibrate(sensor, command)


def _validate_calibrate(sensor, command):
    point = command.get("point")
    # pH calibration is multi-point; EC/DO/ORP are single-action (no args).
    if point is not None:
        if sensor != "ph":
            raise ValidationError(f"sensor '{sensor}' does not support point calibration")
        if point not in PH_POINTS:
            raise ValidationError(f"invalid pH calibration point '{point}'")
        out = {"sensor": sensor, "action": "calibrate", "point": point}
        if "value" in command and command["value"] is not None:
            out["value"] = _require_number(command, "value")
        return out
    return {"sensor": sensor, "action": "calibrate"}


def _require_number(command, key):
    value = command.get(key)
    if not isinstance(value, (int, float)) or isinstance(value, bool):
        raise ValidationError(f"'{key}' must be a number")
    return float(value)
