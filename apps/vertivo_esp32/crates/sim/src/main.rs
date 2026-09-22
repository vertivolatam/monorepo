//! Simulador host del edge: corre el orquestador con sensores mock y
//! emite una línea JSON por lectura (topic + payload), espejo de
//! `python3 -m src.main --orchestrator-mode indoor --simulate`.

use std::time::{Duration, SystemTime, UNIX_EPOCH};
use vertivo_app::{payload_json, topic, IndoorOrchestrator};
use vertivo_domain::Metric;

const DEVICE_ID: &str = "rust-sim-01";
const USER_ID: &str = "1";
const GREENHOUSE_ID: &str = "1";

/// Mock determinista por métrica (media del escenario `normal` Python).
fn mock_value(metric: Metric, tick: u64) -> f32 {
    let wobble = ((tick as f32 * 0.7).sin() * 0.02) + 1.0;
    let base = match metric {
        Metric::Temperature | Metric::NutrientTemperature => 21.5,
        Metric::Humidity => 58.0,
        Metric::Co2 => 660.0,
        Metric::Ph => 6.0,
        Metric::Ec => 1520.0,
        Metric::Tds => 1000.0,
        Metric::Do => 6.5,
        Metric::Orp => 405.0,
    };
    base * wobble
}

fn now_epoch() -> f64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap_or(Duration::ZERO)
        .as_secs_f64()
}

fn main() {
    let mut orch = IndoorOrchestrator::with_indoor_defaults();
    let mut tick: u64 = 0;
    loop {
        let readings = orch.read_all(|m| mock_value(m, tick));
        for r in &readings {
            let t = topic(USER_ID, GREENHOUSE_ID, r.metric);
            let p = payload_json(r, DEVICE_ID, now_epoch());
            println!("{t} {p}");
        }
        tick += 1;
        if std::env::args().any(|a| a == "--once") {
            break;
        }
        std::thread::sleep(Duration::from_secs(5));
    }
}
