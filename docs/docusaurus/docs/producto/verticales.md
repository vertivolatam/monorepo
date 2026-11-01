---
title: Verticales de Negocio
description: 3 verticales — Farm Automation, Product-as-a-Service, Urban-Farming-as-a-Service.
---

# Verticales de Negocio

Vertivo opera en 3 verticales que cubren diferentes segmentos socioeconomicos y modelos de ingreso.

## Farm Automation (Vertical Principal)

**Modelo**: Venta de micro-invernadero + SaaS monitoreo + Marketplace de insumos

| Componente | Detalle |
|-----------|---------|
| **Hardware** | Vertivo Home ([precio redactado]), Vertivo Pro ([precio redactado]), Vertivo Scale ([precio redactado]) |
| **SaaS** | Basic ([ver pricing]), Pro ([ver pricing]), Commercial ([ver pricing]), Industrial ([ver pricing]) |
| **Marketplace** | Caja Vertivo ([ver pricing] suscripcion) + on-demand |
| **Target** | Familias medio-alto, restaurantes, agroindustria |
| **Retention** | Triple lock-in: hardware + software + insumos |

### Fuentes de Ingreso

```mermaid
graph LR
    HW[Hardware\nOne-time\n[precio redactado]-[precio redactado]] --> MRR[MRR Total]
    SAAS[SaaS\nRecurrente\n$29-[ver pricing]] --> MRR
    CAJA[Caja Vertivo\nSuscripcion\n[ver pricing]] --> MRR
    OD[On-demand\nTransaccional\nVariable] --> MRR
    DATA[Data API\nContratos anuales\n$2,500+/mo] --> MRR
```

### Revenue Mix (Target 18 meses)

| Stream | MRR | % |
|--------|-----|---|
| SaaS Monitoring | [redactado] | 43% |
| Marketplace (Caja + on-demand) | [redactado] | 36% |
| Hardware | [redactado] | 14% |
| Data & B2B | [redactado] | 7% |
| **Total** | **[redactado]** | **100%** |

## Product-as-a-Service (Fase 2)

**Modelo**: Alquiler del micro-invernadero + SaaS + Insumos

- **Target**: Familias de poder adquisitivo medio, locales comerciales, personas sin capacidad de compra
- **Pricing**: Suscripcion mensual que incluye hardware, mantenimiento, SaaS y reposicion de insumos
- **Ventaja**: Elimina la barrera de entrada del costo del hardware ([precio redactado])
- **Estado**: VRTV-28 (T3 — post [MRR target])

## Urban-Farming-as-a-Service (Fase 3)

**Modelo**: Suscripcion de alimentos organicos cultivados por Vertivo

- **Target**: Familias de bajo poder adquisitivo, comedores escolares, instituciones sin espacio
- **Pricing**: Suscripcion de alimentos sin necesidad de poseer hardware
- **Ventaja**: Vertivo opera las granjas urbanas y entrega los alimentos a domicilio
- **Estado**: VRTV-29 (T3 — post [MRR target])

## Socios Clave

| Socio | Producto/Servicio | Importancia |
|-------|-------------------|-------------|
| Atlas Scientific | Sensores EZO I2C | Critica |
| Raspberry Pi Foundation | SBC robot agronomo | Critica |
| OnvoPay / Tilopay | Pagos CR + PA | Critica |
| Wompi | Pagos CO | Critica |
| EMQX | MQTT Broker (open source) | Alta |
| Balena | Deployment + OTA updates RPi | Alta |
| Proveedores de semillas | Semillas organicas certificadas | Alta |
| Fabricante LEDs horticultura | Full spectrum LED panels | Alta |
| Logistica last-mile | Envios Caja Vertivo | Alta |

---

> Fuente: [`srd/business-model-canvas.md`](https://github.com/vertivolatam/monorepo/blob/main/srd/business-model-canvas.md) — Secciones 3, 6, 10
