# Crop Explorer redesign — Architecture

**Issue:** VRTV-96
**Status:** Decision 2026-06-21 (brainstorm aprobado vía visual companion)
**PDR:** [`proposal.md`](./proposal.md)

## TL;DR

Refactor del explorador PySide6 a **sidebar (búsqueda+filtros+lista) | detalle**. El detalle mapea
los grupos color-codificados de la hoja: **Datos Botánicos** (izq sticky), **Soluciones del Negocio**
(editable: perfil/prioridad + Guardar→audit) + **Constantes de Monitoreo** (der-arriba sticky, 3 cols),
y **4 tabs de fase** (Vegetativa/Reproductiva/Maduración/Valor Nutricional) con un grid de
**`InstrumentCard`** (valor + gauge de rango + provenance) y la receta de nutrientes como **árbol**.
`crops.db` (SQLite) es la fuente de verdad; editar escribe `setpoint_audit`.

## 1. Layout

```
┌─────────────────┬───────────────────────────────────────────────┐
│ SIDEBAR         │ DETALLE                                        │
│ 🔍 buscar       │ ┌──────────────┬────────────────────────────┐ │
│   nombre común  │ │ Datos        │ Soluciones del Negocio      │ │  ← sticky, 3 cols
│ filtros ▾:      │ │ Botánicos    │  Perfil ▾ · Prioridad ▾     │ │
│  Aeropónico     │ │ (sticky izq) │  [Guardar]                  │ │
│  Tipo (harvest) │ │              │ Constantes de Monitoreo     │ │
│  Perfil         │ │              ├────────────────────────────┤ │
│ ⚠ chip discrep. │ │              │ [4 tabs] Veg│Repro│Madur│Nut │ │  ← tabs
│ ─────           │ │              │  grid InstrumentCard +      │ │
│ lista (107) con │ │              │  árbol de receta            │ │
│  🟢/⚪/🟠 + tipo  │ └──────────────┴────────────────────────────┘ │
└─────────────────┴───────────────────────────────────────────────┘
```

## 2. Sidebar
- Búsqueda en vivo por nombre común (matchea también familia/especie).
- Filtros multi-select consistentes: Aeropónico, Tipo (`sheet_harvest_type`), Perfil. "⚠ solo discrepancias" = chip-toggle (no botón suelto).
- Lista: punto de estado (🟢 aeropónico · ⚪ no-aero · 🟠 discrepancia sheet/profile) + nombre + tipo; contador "N de 107 · M ⚠"; click → carga detalle.

## 3. Detalle
- **Izquierda sticky (naranja):** Datos Botánicos (familia, especie, parte comestible, origen, uso).
- **Der-arriba sticky, 3 cols:** Soluciones del Negocio (Apto; **`Perfil Asignado` y `Prioridad` drop-downs editables + Guardar**) + Constantes de Monitoreo (espectro, fotoperiodo).
- **Der-abajo, 4 tabs (colores de la hoja):** Fase Vegetativa (morado) · Reproductiva (magenta) · Maduración (azul) · Valor Nutricional (verde). Cada tab de fase = grid de `InstrumentCard` + árbol de receta. Fase sin datos → "No aplica".

## 4. `InstrumentCard` (componente compartido)
Widget reutilizable (explorador ↔ simulador): valor operativo grande coloreado por estado
(🟢 en rango / 🟡 advertencia / 🔴 fuera; el simulador añade 🟡 sin-calibrar) + **gauge** (banda
saludable, marca del ideal, marcador del valor) + min/ideal/máx + **provenance** (🟦 sheet / 🟨 researched,
confianza/cita en tooltip, de `setpoint_audit is_active=1`) + unidad. En el explorador es solo-lectura;
el simulador le añade controles (target/anomalía/on-off/calibración) sobre el mismo núcleo visual.

## 5. Edición auditada
Editar `Perfil Asignado`/`Prioridad` + Guardar → actualiza `crops` (y `setpoints` resueltos si cambió
el perfil) + inserta `setpoint_audit` (`source='experiment'`, `changed_at/by`, `supersedes_id`, viejo
`is_active=0`). Flujo de corrección/experimentación auditada (arregla las 5 discrepancias, reasigna perfiles, rollback).

## 6. Datos nuevos (nutrición)
Extraer de la hoja (grupo verde) por 100g: energía, carbohidratos/azúcares/fibra, grasa, proteína, agua,
vitaminas (A, β-caroteno, B1-B9, colina, C, E, K), minerales (Ca, Fe, Mg, Mn, P, K, Na, Zn). Añadir a
`crops.json` (provenance `sheet`) → tabla `nutrition` en `crops.db`. Fases Reproductiva/Maduración: mostrar
los investigados que existan (fruto/raíz) y "sin datos" donde no.

## 7. Componentes (archivos)
| Archivo | Responsabilidad |
|---------|-----------------|
| `build_db.py` | extender: extraer nutrición → tabla `nutrition`. |
| `widgets/instrument_card.py` | **nuevo** `InstrumentCard` (+ función pura `range_status`). |
| `widgets/sidebar.py` | **nuevo** búsqueda + filtros + lista. |
| `widgets/detail_view.py` | **nuevo** layout izq/der + tabs + árbol + edición Guardar. |
| `db.py` | acceso a crops.db + **escritura auditada** (`save_classification`). |
| `crop_explorer.py` | refactor: compone sidebar+detail; quita QTextEdit + filtros viejos. |

## 8. Errores
- Cultivo `profile:null` (43 no-aeropónicos) → tabs muestran "sin perfil"; Botánicos/Negocio igual.
- Guardar con error SQL → toast de error, sin corromper estado.
- Fase/receta sin datos → "No aplica"/oculto, no card vacía.

## 9. Testing
- **Unit:** extracción de nutrición (conteos + un cultivo con valores); `save_classification` (nuevo audit con supersedes, viejo is_active=0, setpoints sincronizado); `range_status` (in/out/sin-cal).
- **Widget (pytest-qt o smoke):** `InstrumentCard` color/gauge correctos.
- **Manual:** `make dev-crop-explorer` → buscar, filtrar, abrir cultivo, cambiar perfil + Guardar + verificar `setpoint_audit`.

## References
- PDR: [`proposal.md`](./proposal.md) · Tasks: [`tasks.md`](./tasks.md)
