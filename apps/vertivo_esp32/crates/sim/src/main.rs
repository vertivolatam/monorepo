//! Simulador host del edge con MQTT real + dispatcher de control.
//!
//! Espejo de `src/simulation/simulator.py` (Python):
//! - publica las 9 métricas en `vertivo/{user}/greenhouse/{gh}/sensor/*`
//!   con payload `{value, unit, sensorId, timestamp}` cada N segundos;
//! - obedece el contrato de control de `sim_control/control_schema.py`
//!   en `vertivo/sim/greenhouse/{gh}/control`
//!   (`set_target`, `inject_anomaly`, `enable`, `calibrate`,
//!   `kill_all`, `set_interval`).
//!
//! El panel web (`sim_control`, puerto 8090) muestra estos datos y sus
//! botones comandan este binario sin cambios en el panel.
//!
//! Env: `VERTIVO_MQTT_ENDPOINT` (default `localhost`), `VERTIVO_MQTT_PORT`
//! (default `1883`), `VERTIVO_USER_ID`/`VERTIVO_GREENHOUSE_ID` (default `1`),
//! `VERTIVO_DEVICE_ID` (default `rust-sim-01`), `VERTIVO_INTERVAL_S` (default 5).

use rumqttc::{Client, Event, MqttOptions, Packet, QoS};
use std::collections::HashMap;
use std::time::{Duration, SystemTime, UNIX_EPOCH};
use vertivo_app::{payload_json, topic, IndoorOrchestrator};
use vertivo_domain::Metric;

/// Estado mutable por métrica (lo que el panel comanda).
#[derive(Debug)]
struct SensorState {
    /// Media objetivo (`set_target`); `None` = base del escenario normal.
    target: Option<f32>,
    /// Offset inyectado (`inject_anomaly`); decae un 20 % por ciclo.
    anomaly: f32,
    enabled: bool,
}

impl SensorState {
    fn fresh() -> Self {
        Self {
            target: None,
            anomaly: 0.0,
            enabled: true,
        }
    }
}

fn scenario_base(metric: Metric) -> f32 {
    match metric {
        Metric::Temperature | Metric::NutrientTemperature => 21.5,
        Metric::Humidity => 58.0,
        Metric::Co2 => 660.0,
        Metric::Ph => 6.0,
        Metric::Ec => 1520.0,
        Metric::Tds => 1000.0,
        Metric::Do => 6.5,
        Metric::Orp => 405.0,
    }
}

/// Nombres cortos del panel (`control_schema.SENSORS`) → `Metric`.
fn panel_sensor(name: &str) -> Option<Metric> {
    Some(match name {
        "temperature" => Metric::Temperature,
        "humidity" => Metric::Humidity,
        "co2" => Metric::Co2,
        "ph" => Metric::Ph,
        "ec" => Metric::Ec,
        "tds" => Metric::Tds,
        "do" => Metric::Do,
        "orp" => Metric::Orp,
        _ => return None,
    })
}

fn now_epoch() -> f64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap_or(Duration::ZERO)
        .as_secs_f64()
}

fn env(key: &str, default: &str) -> String {
    std::env::var(key).unwrap_or_else(|_| default.to_string())
}

/// Aplica un comando de control. Espejo de `Simulator._dispatch`.
/// Retorna mensaje de log (nunca falla: lo malformado se ignora).
fn dispatch(cmd: &serde_json::Value, state: &mut HashMap<&'static str, SensorState>) -> String {
    let action = cmd.get("action").and_then(|a| a.as_str()).unwrap_or("");
    match action {
        "kill_all" => {
            for s in state.values_mut() {
                s.enabled = false;
            }
            "control: kill_all — publishing halted".to_string()
        }
        "set_interval" => match cmd.get("seconds").and_then(|s| s.as_f64()) {
            Some(secs) if secs > 0.0 => format!("control: set_interval — {secs}s"),
            _ => "control: set_interval inválido, ignorado".to_string(),
        },
        "set_target" | "inject_anomaly" | "enable" | "calibrate" => {
            let sensor = cmd.get("sensor").and_then(|s| s.as_str()).unwrap_or("");
            let Some(metric) = panel_sensor(sensor) else {
                return format!("control: sensor desconocido '{sensor}', ignorado");
            };
            // Clave estable por métrica para el mapa de estado.
            let key = metric.as_topic();
            let st = state.entry(key).or_insert_with(SensorState::fresh);
            match action {
                "set_target" => match cmd.get("value").and_then(|v| v.as_f64()) {
                    Some(v) => {
                        st.target = Some(v as f32);
                        format!("control: {sensor} target -> {v}")
                    }
                    None => format!("control: set_target sin 'value', ignorado"),
                },
                "inject_anomaly" => match cmd.get("magnitude").and_then(|v| v.as_f64()) {
                    Some(mag) => {
                        st.anomaly += mag as f32;
                        format!("control: {sensor} anomaly +{mag}")
                    }
                    None => format!("control: inject_anomaly sin 'magnitude', ignorado"),
                },
                "enable" => {
                    let on = cmd.get("on").and_then(|v| v.as_bool()).unwrap_or(true);
                    st.enabled = on;
                    format!("control: {sensor} enabled={on}")
                }
                _ => format!("control: {sensor} calibrate ok (mock)"),
            }
        }
        _ => format!("control: acción desconocida '{action}', ignorada"),
    }
}

fn main() {
    let endpoint = env("VERTIVO_MQTT_ENDPOINT", "localhost");
    let port: u16 = env("VERTIVO_MQTT_PORT", "1883").parse().unwrap_or(1883);
    let user = env("VERTIVO_USER_ID", "1");
    let greenhouse = env("VERTIVO_GREENHOUSE_ID", "1");
    let device = env("VERTIVO_DEVICE_ID", "rust-sim-01");
    let mut interval_s: u64 = env("VERTIVO_INTERVAL_S", "5").parse().unwrap_or(5);

    let control_topic = format!("vertivo/sim/greenhouse/{greenhouse}/control");

    let mut mqttoptions = MqttOptions::new(format!("{device}-ctrl"), &endpoint, port);
    mqttoptions.set_keep_alive(Duration::from_secs(30));

    let (client, mut connection) = Client::new(mqttoptions, 16);
    client
        .subscribe(&control_topic, QoS::AtMostOnce)
        .expect("subscribe control");

    // Hilo de red: drena eventos y reenvía comandos por canal.
    let (tx, rx) = std::sync::mpsc::channel::<String>();
    std::thread::spawn(move || {
        for event in connection.iter() {
            match event {
                Ok(Event::Incoming(Packet::Publish(p))) => {
                    if let Ok(payload) = String::from_utf8(p.payload.to_vec()) {
                        let _ = tx.send(payload);
                    }
                }
                Ok(_) => {}
                Err(e) => {
                    eprintln!("mqtt net: {e:?}");
                    break;
                }
            }
        }
    });

    let mut orch = IndoorOrchestrator::with_indoor_defaults();
    let mut state: HashMap<&'static str, SensorState> = HashMap::new();
    let mut tick: u64 = 0;

    println!("rust-sim {device}: publicando en {endpoint}:{port} (gh {greenhouse})");
    loop {
        // 1. Comandos pendientes del panel.
        while let Ok(raw) = rx.try_recv() {
            match serde_json::from_str::<serde_json::Value>(&raw) {
                Ok(cmd) => {
                    let msg = dispatch(&cmd, &mut state);
                    println!("{msg}");
                    if cmd.get("action").and_then(|a| a.as_str()) == Some("set_interval") {
                        if let Some(s) = cmd.get("seconds").and_then(|v| v.as_f64()) {
                            if s > 0.0 {
                                interval_s = s as u64;
                            }
                        }
                    }
                }
                Err(_) => println!("control: JSON inválido, ignorado"),
            }
        }

        // 2. Lectura + publish por métrica (solo habilitados).
        let readings = orch.read_all(|m| {
            let st = state.entry(m.as_topic()).or_insert_with(SensorState::fresh);
            let base = st.target.unwrap_or_else(|| scenario_base(m));
            let wobble = ((tick as f32 * 0.7).sin() * 0.02) + 1.0;
            let v = base * wobble + st.anomaly;
            st.anomaly *= 0.8;
            v
        });
        for r in &readings {
            let key = r.metric.as_topic();
            if !state
                .get(key)
                .map(|s| s.enabled)
                .unwrap_or(true)
            {
                continue;
            }
            let t = topic(&user, &greenhouse, r.metric);
            let p = payload_json(r, &device, now_epoch());
            if let Err(e) = client.publish(t, QoS::AtMostOnce, false, p.to_string()) {
                eprintln!("publish: {e:?}");
            }
        }

        tick += 1;
        if std::env::args().any(|a| a == "--once") {
            break;
        }
        std::thread::sleep(Duration::from_secs(interval_s.max(1)));
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn st() -> HashMap<&'static str, SensorState> {
        HashMap::new()
    }

    #[test]
    fn dispatch_set_target_and_enable() {
        let mut s = st();
        let cmd = serde_json::json!({"sensor": "ph", "action": "set_target", "value": 7.0});
        assert!(dispatch(&cmd, &mut s).contains("target"));
        assert_eq!(s["ph"].target, Some(7.0));

        let cmd = serde_json::json!({"sensor": "ph", "action": "enable", "on": false});
        dispatch(&cmd, &mut s);
        assert!(!s["ph"].enabled);
    }

    #[test]
    fn dispatch_globals_and_garbage() {
        let mut s = st();
        assert!(dispatch(&serde_json::json!({"action": "kill_all"}), &mut s).contains("kill_all"));
        assert!(dispatch(&serde_json::json!({"action": "nope"}), &mut s).contains("desconocida"));
        assert!(dispatch(&serde_json::json!({"sensor": "x", "action": "enable"}), &mut s)
            .contains("desconocido"));
        // set_interval válido no toca estado pero se acepta
        assert!(dispatch(&serde_json::json!({"action": "set_interval", "seconds": 5}), &mut s)
            .contains("set_interval"));
    }
}
