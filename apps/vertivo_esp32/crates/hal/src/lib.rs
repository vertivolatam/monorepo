//! Driver EZO sobre `embedded-hal` + bus-sharing con mutex.
//!
//! Protocolo Atlas Scientific (I2C): escribir comando ASCII (`R`), esperar el
//! tiempo de medición de la sonda, leer la respuesta (`1,<valor>` / `2,...`).
//! Espejo de `AtlasScientificSensor.read_data()` en Python.
//!
//! ## Bus-sharing
//!
//! Un solo bus, N dispositivos por dirección. Compartir con **mutex**
//! (`embedded_hal_bus::i2c::MutexDevice`):
//!
//! ```ignore
//! use embedded_hal_bus::i2c::MutexDevice;
//! use vertivo_hal::EzoDriver;
//! use vertivo_domain::Metric;
//!
//! // BUS: el I2c del target; M: el mutex del target
//! // (critical-section / esp-sync en ESP32, std::sync::Mutex en host).
//! let ph = EzoDriver::new(MutexDevice::new(&bus_mutex), Metric::Ph.i2c_address());
//! let ec = EzoDriver::new(MutexDevice::new(&bus_mutex), Metric::Ec.i2c_address());
//! ```
//!
//! `RefCellDevice` NO vale en ESP32 (single-thread sin preemption solamente).

#![no_std]

use embedded_hal::delay::DelayNs;
use embedded_hal::i2c::I2c;
use vertivo_domain::Metric;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum EzoError<E> {
    Bus(E),
    /// Respuesta sin byte de estado `1` (éxito) al frente.
    BadStatus(u8),
    /// El payload ASCII no parsea a `f32`.
    Parse,
    /// Respuesta vacía.
    Empty,
}

/// Driver genérico de un circuito EZO en una dirección I2C.
///
/// `BUS` suele ser un `MutexDevice` (ver ejemplo del módulo).
pub struct EzoDriver<BUS> {
    bus: BUS,
    address: u8,
}

impl<BUS> EzoDriver<BUS> {
    pub const fn new(bus: BUS, address: u8) -> Self {
        Self { bus, address }
    }

    pub const fn for_metric(bus: BUS, metric: Metric) -> Self {
        Self::new(bus, metric.i2c_address())
    }

    pub const fn address(&self) -> u8 {
        self.address
    }
}

impl<BUS, E> EzoDriver<BUS>
where
    BUS: I2c<Error = E>,
{
    /// Dispara una lectura (`R`) y retorna el valor parseado.
    ///
    /// `measure_delay_ms`: tiempo de medición de la sonda (pH ~900ms,
    /// RTD ~600ms, EC/DO ~600ms; ver datasheets EZO).
    /// `out` debe ser ≥32 bytes (máximo de respuesta EZO, terminada en NUL).
    /// En producción, leer byte a byte hasta NUL evita NACK-tail en algunos HAL.
    pub fn read(
        &mut self,
        delay: &mut impl DelayNs,
        measure_delay_ms: u32,
        out: &mut [u8],
    ) -> Result<f32, EzoError<E>> {
        self.bus.write(self.address, b"R").map_err(EzoError::Bus)?;
        delay.delay_ms(measure_delay_ms);
        let n = self.read_response(out)?;
        parse_ezo(&out[..n])
    }

    fn read_response(&mut self, out: &mut [u8]) -> Result<usize, EzoError<E>> {
        if out.is_empty() {
            return Err(EzoError::Empty);
        }
        // `I2c::read` llena el buffer completo o retorna error.
        self.bus.read(self.address, out).map_err(EzoError::Bus)?;
        // Primer byte: código de estado. 1 = éxito.
        if out[0] != b'1' {
            return Err(EzoError::BadStatus(out[0]));
        }
        Ok(out.len())
    }
}

/// Parsea `1,<valor>\0` → `f32` (sin `alloc`; `core` solamente).
pub fn parse_ezo<E>(buf: &[u8]) -> Result<f32, EzoError<E>> {
    if buf.len() < 3 || buf[0] != b'1' || buf[1] != b',' {
        return Err(EzoError::BadStatus(buf.first().copied().unwrap_or(0)));
    }
    let mut end = 2;
    while end < buf.len() && buf[end] != 0 {
        end += 1;
    }
    let s = core::str::from_utf8(&buf[2..end]).map_err(|_| EzoError::Parse)?;
    // Parseo decimal manual (sin std): [+/-]ddd[.ddd]
    let bytes = s.as_bytes();
    let mut i = 0;
    let neg = if bytes.first() == Some(&b'-') {
        i = 1;
        -1.0f32
    } else {
        1.0f32
    };
    let mut int: f32 = 0.0;
    while i < bytes.len() && bytes[i].is_ascii_digit() {
        int = int * 10.0 + (bytes[i] - b'0') as f32;
        i += 1;
    }
    let mut frac: f32 = 0.0;
    let mut div: f32 = 1.0;
    if bytes.get(i) == Some(&b'.') {
        i += 1;
        while i < bytes.len() && bytes[i].is_ascii_digit() {
            frac = frac * 10.0 + (bytes[i] - b'0') as f32;
            div *= 10.0;
            i += 1;
        }
    }
    if i != bytes.len() {
        return Err(EzoError::Parse);
    }
    Ok(neg * (int + frac / div))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_ok() {
        use core::convert::Infallible;
        assert_eq!(parse_ezo::<Infallible>(b"1,6.02\0").ok(), Some(6.02));
        assert_eq!(parse_ezo::<Infallible>(b"1,1500.5\0xxxx").ok(), Some(1500.5));
        assert_eq!(parse_ezo::<Infallible>(b"1,-3.25\0").ok(), Some(-3.25));
    }

    #[test]
    fn parse_rejects() {
        use core::convert::Infallible;
        assert!(parse_ezo::<Infallible>(b"2,6.02\0").is_err()); // still processing
        assert!(parse_ezo::<Infallible>(b"1,abc\0").is_err());
        assert!(parse_ezo::<Infallible>(b"").is_err());
    }
}
