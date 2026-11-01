//! Dominio puro Vertivo (`no_std`): entidades del edge.
//!
//! Espejo de:
//! - `apps/raspberry/src/hardware/sensors/atlas_scientific/i2c_addresses.csv`
//! - `apps/raspberry/src/monitors/atlas_scientific/*_monitor.py` (bounds + read)
//! - `apps/raspberry/src/orchestrators/agronomic/indoor_urban_vertical_farming/orchestrator.py`

#![no_std]

/// Métrica del invernadero. El topic MQTT es `.../sensor/{as_topic()}` y la
/// unidad del payload es `unit()`. Contratos en
/// `docs/content/docs/architecture/data-flow.md`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Metric {
    Temperature,
    Humidity,
    Co2,
    NutrientTemperature,
    Ph,
    Ec,
    Tds,
    Do,
    Orp,
}

impl Metric {
    /// Dirección I2C por defecto del EZO (ver `i2c_addresses.csv`).
    /// TDS deriva de EC: comparte dirección `0x64`, no tiene circuito propio.
    pub const fn i2c_address(self) -> u8 {
        match self {
            Metric::Temperature => 0x66, // EZO-RTD (nota docs: tabla usa 0x69 para CO2)
            Metric::Humidity => 0x6F,    // EZO-HUM
            Metric::Co2 => 0x69,         // EZO-CO2 (csv legacy dice 0x67; firmware actual 0x69)
            Metric::NutrientTemperature => 0x66, // EZO-RTD
            Metric::Ph => 0x63,          // EZO-pH (slot aislado)
            Metric::Ec => 0x64,          // EZO-EC (slot aislado)
            Metric::Tds => 0x64,         // derivado de EC
            Metric::Do => 0x61,          // EZO-DO (slot aislado)
            Metric::Orp => 0x62,         // EZO-ORP (slot aislado)
        }
    }

    pub const fn as_topic(self) -> &'static str {
        match self {
            Metric::Temperature => "temperature",
            Metric::Humidity => "humidity",
            Metric::Co2 => "co2",
            Metric::NutrientTemperature => "nutrient_temperature",
            Metric::Ph => "ph",
            Metric::Ec => "ec",
            Metric::Tds => "tds",
            Metric::Do => "do",
            Metric::Orp => "orp",
        }
    }

    pub const fn unit(self) -> &'static str {
        match self {
            Metric::Temperature | Metric::NutrientTemperature => "C",
            Metric::Humidity => "%",
            Metric::Co2 => "ppm",
            Metric::Ph => "pH",
            Metric::Ec => "uS/cm",
            Metric::Tds | Metric::Do => "mg/L",
            Metric::Orp => "mV",
        }
    }

    /// `true` si la sonda debe ir en slot aislado del Interlink
    /// (sondas conductivas compartiendo la misma solución).
    pub const fn needs_isolation(self) -> bool {
        matches!(self, Metric::Ph | Metric::Ec | Metric::Do | Metric::Orp)
    }

    pub const ALL: [Metric; 9] = [
        Metric::Temperature,
        Metric::Humidity,
        Metric::Co2,
        Metric::NutrientTemperature,
        Metric::Ph,
        Metric::Ec,
        Metric::Tds,
        Metric::Do,
        Metric::Orp,
    ];
}

/// Cotas inferior/superior de una métrica (constructor del orquestador Python).
#[derive(Debug, Clone, Copy)]
pub struct Bounds {
    pub lower: f32,
    pub upper: f32,
}

impl Bounds {
    pub const fn new(lower: f32, upper: f32) -> Self {
        Self { lower, upper }
    }
}

/// Lectura validada de un monitor. Equivale a `monitor.current_*` en Python.
#[derive(Debug, Clone, Copy)]
pub struct SensorReading {
    pub metric: Metric,
    pub value: f32,
    pub in_range: bool,
}

/// Monitor con cotas. Espejo de `*_monitor.py`: `read_*` actualiza y retorna.
#[derive(Debug)]
pub struct Monitor {
    pub metric: Metric,
    pub bounds: Bounds,
    pub current: f32,
}

impl Monitor {
    pub const fn new(metric: Metric, bounds: Bounds) -> Self {
        Self {
            metric,
            bounds,
            current: 0.0,
        }
    }

    /// Registra una lectura y retorna si está dentro de cotas.
    pub fn observe(&mut self, value: f32) -> SensorReading {
        self.current = value;
        SensorReading {
            metric: self.metric,
            value,
            in_range: value >= self.bounds.lower && value <= self.bounds.upper,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn observe_flags_out_of_range() {
        let mut m = Monitor::new(Metric::Ph, Bounds::new(5.5, 6.5));
        assert!(m.observe(6.0).in_range);
        assert!(!m.observe(7.2).in_range);
        assert_eq!(m.current, 7.2);
    }

    #[test]
    fn addresses_match_csv() {
        assert_eq!(Metric::Ph.i2c_address(), 0x63);
        assert_eq!(Metric::Ec.i2c_address(), 0x64);
        assert_eq!(Metric::Do.i2c_address(), 0x61);
        assert_eq!(Metric::Orp.i2c_address(), 0x62);
        assert_eq!(Metric::NutrientTemperature.i2c_address(), 0x66);
        assert_eq!(Metric::Humidity.i2c_address(), 0x6F);
    }
}
