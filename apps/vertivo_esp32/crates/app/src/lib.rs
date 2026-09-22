//! Caso de uso: orquestador indoor + contrato MQTT.
//!
//! Espejo de `IndoorUrbanVerticalFarmingOrchestrator` + `_sensor_payload`
//! (`apps/raspberry/.../indoor_urban_vertical_farming/orchestrator.py`,
//! `src/networking/mqtt.py`). Contrato SSOT en
//! `docs/content/docs/architecture/data-flow.md`.
//!
//! Nota `std`: este crate usa `serde_json` (std) para validar el contrato en
//! host. El port `no_std` a ESP32 usará `serde-json-core` + `heapless`.

use serde::Serialize;
use vertivo_domain::{Bounds, Metric, Monitor, SensorReading};

/// Payload MQTT. Debe serializar EXACTO al contrato:
/// `{"value","unit","sensorId","timestamp"}`.
#[derive(Debug, Serialize)]
pub struct Payload<'a> {
    pub value: f32,
    pub unit: &'a str,
    #[serde(rename = "sensorId")]
    pub sensor_id: String,
    pub timestamp: f64,
}

/// Arma el topic `vertivo/{user}/greenhouse/{gh}/sensor/{metric}`.
pub fn topic(user_id: &str, greenhouse_id: &str, metric: Metric) -> String {
    format!(
        "vertivo/{user_id}/greenhouse/{greenhouse_id}/sensor/{metric}",
        metric = metric.as_topic()
    )
}

/// `sensorId` = `<device_id>/<metric>` (verificado en el broker).
pub fn sensor_id(device_id: &str, metric: Metric) -> String {
    format!("{device_id}/{metric}", metric = metric.as_topic())
}

/// Orquestador indoor: 9 monitores con cotas + ciclo de lectura.
///
/// El transporte (I2C real vs mock) se inyecta por closure, igual que el
/// `input_EZO_*Sensor` del simulador Python: el caso de uso no conoce el bus.
pub struct IndoorOrchestrator {
    pub co2: Monitor,
    pub humidity: Monitor,
    pub temperature: Monitor,
    pub nutrient_temperature: Monitor,
    pub ph: Monitor,
    pub ec: Monitor,
    pub tds: Monitor,
    pub dissolved_oxygen: Monitor,
    pub orp: Monitor,
}

impl IndoorOrchestrator {
    /// Cotas por defecto del modo indoor (`config/defaults/indoor.json`).
    pub fn with_indoor_defaults() -> Self {
        Self {
            co2: Monitor::new(Metric::Co2, Bounds::new(400.0, 1000.0)),
            humidity: Monitor::new(Metric::Humidity, Bounds::new(40.0, 80.0)),
            // EDGE TEST: temperature duplica el RTD (sin sensor de aire dedicado).
            temperature: Monitor::new(Metric::Temperature, Bounds::new(18.0, 24.0)),
            nutrient_temperature: Monitor::new(
                Metric::NutrientTemperature,
                Bounds::new(18.0, 24.0),
            ),
            ph: Monitor::new(Metric::Ph, Bounds::new(5.5, 6.5)),
            ec: Monitor::new(Metric::Ec, Bounds::new(1000.0, 2000.0)),
            tds: Monitor::new(Metric::Tds, Bounds::new(500.0, 1500.0)),
            dissolved_oxygen: Monitor::new(Metric::Do, Bounds::new(5.0, 8.0)),
            orp: Monitor::new(Metric::Orp, Bounds::new(300.0, 500.0)),
        }
    }

    /// Un ciclo: lee cada sensor vía `read(metric)` y observa en su monitor.
    /// Retorna las 9 lecturas (incluye `temperature` duplicado del RTD).
    pub fn read_all(&mut self, mut read: impl FnMut(Metric) -> f32) -> [SensorReading; 9] {
        // `temperature` comparte el RTD con `nutrient_temperature`.
        let rtd = read(Metric::NutrientTemperature);
        let t = self.temperature.observe(rtd);
        [
            t,
            self.humidity.observe(read(Metric::Humidity)),
            self.co2.observe(read(Metric::Co2)),
            self.nutrient_temperature.observe(rtd),
            self.ph.observe(read(Metric::Ph)),
            self.ec.observe(read(Metric::Ec)),
            self.tds.observe(read(Metric::Tds)),
            self.dissolved_oxygen.observe(read(Metric::Do)),
            self.orp.observe(read(Metric::Orp)),
        ]
    }
}

/// Serializa una lectura al JSON del contrato (verificado contra el broker).
pub fn payload_json(reading: &SensorReading, device_id: &str, timestamp: f64) -> serde_json::Value {
    serde_json::json!({
        "value": reading.value,
        "unit": reading.metric.unit(),
        "sensorId": sensor_id(device_id, reading.metric),
        "timestamp": timestamp,
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn contract_shape() {
        let r = SensorReading {
            metric: Metric::NutrientTemperature,
            value: 22.59,
            in_range: true,
        };
        let v = payload_json(&r, "rpi-01", 1789964162.4);
        assert!((v["value"].as_f64().unwrap() - 22.59).abs() < 1e-4); // f32
        assert_eq!(v["unit"], "C");
        assert_eq!(v["sensorId"], "rpi-01/nutrient_temperature");
        assert!(v.get("timestamp").is_some());
        assert_eq!(v.as_object().unwrap().len(), 4);
    }

    #[test]
    fn topic_shape() {
        assert_eq!(topic("1", "1", Metric::Ph), "vertivo/1/greenhouse/1/sensor/ph");
        assert_eq!(
            topic("1", "1", Metric::NutrientTemperature),
            "vertivo/1/greenhouse/1/sensor/nutrient_temperature"
        );
    }

    #[test]
    fn read_all_returns_nine_with_rtd_dup() {
        let mut o = IndoorOrchestrator::with_indoor_defaults();
        let rs = o.read_all(|_| 20.0);
        assert_eq!(rs.len(), 9);
        assert_eq!(rs[0].metric, Metric::Temperature);
        assert_eq!(rs[0].value, rs[3].value); // duplicado del RTD
    }
}
