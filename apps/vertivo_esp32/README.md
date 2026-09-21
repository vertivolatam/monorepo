# vertivo_esp32 — Edge Rust (ESP32) · scaffold clean architecture

Port del orquestador Python (`apps/raspberry`) a Rust sobre `embedded-hal`.

## Capas

```text
crates/domain  # entidades puras, no_std: Metric, Bounds, SensorReading, Monitor
crates/hal     # driver EZO sobre embedded_hal::i2c::I2c + bus-sharing con MutexDevice
crates/app     # IndoorOrchestrator (caso de uso): ciclo leer → payload → topic
crates/sim     # binario host (std): corre el orquestador con sensores mock, imprime JSON
```

## Bus-sharing (diseño)

Un solo bus I2C, N EZO por dirección. En Rust se comparte con **mutex**:

- `embedded_hal_bus::i2c::MutexDevice<'_, BUS>` — correcto en ESP32
  (multicore/interrupciones). Requiere un `Mutex` del target
  (`critical-section`, `esp-sync`, o `std::sync::Mutex` en host/sim).
- `RefCellDevice` solo vale en single-thread sin preemption — NO usar en ESP32.

Cada EZO tiene dirección única (`domain::Metric::i2c_address`, espejo de
`apps/raspberry/src/hardware/sensors/atlas_scientific/i2c_addresses.csv`).
Lecturas secuenciales: escribir `R`, esperar el tiempo de medición de la sonda,
leer respuesta ASCII y parsear a `f32`.

## Aislamiento (Interlink i3)

pH/ORP/EC/DO van en slots aislados (sondas conductivas en la misma solución);
HUM/CO2/RTD no lo requieren. Ver `docs/content/docs/iot/sensors.md`.

## Contratos (SSOT en docs)

- Payload: `{value, unit, sensorId, timestamp}` —
  `docs/content/docs/architecture/data-flow.md` (sección Contrato de payload MQTT).
- Topics: `vertivo/{user}/greenhouse/{gh}/sensor/{metric}`, ritmo ~5s.

## Verificar en host

```sh
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
cargo test --workspace   # 7 tests (domain: bounds+direcciones, hal: parser EZO, app: contrato)
cargo run -p vertivo-sim -- --once   # emite 9 líneas topic + JSON del contrato
```

Toolchain: `rustup` minimal en `~/.cargo` + `zig cc` como linker
(`apps/vertivo_esp32/.cargo/config.toml`), porque la máquina no tiene GCC.

## Llevar a ESP32 (pendiente, no en este scaffold)

1. `espup` / `espflash`, target `xtensa-esp32s3-none-elf` (o el MCU elegido).
2. `esp-hal` provee `I2c` + `Delay`; envolver el bus en el `Mutex` del target.
3. MQTT con `rust-mqtt`/`minimq` + `serde-json-core` (sin `std`); hoy `app`
   usa `serde_json` (std) a propósito para validar el contrato en host.
