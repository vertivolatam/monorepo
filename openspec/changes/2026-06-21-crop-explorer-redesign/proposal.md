# Crop Explorer redesign — instrumento compartido + tabs de la hoja + edición auditada

**Date:** 2026-06-21
**Owner:** Andrés (andres@dojocoding.io)
**Status:** Proposed — diseño aprobado vía brainstorm (visual companion)
**Domain:** `apps/raspberry/tools/crop_explorer/` (PySide6) sobre `crops.db` (SQLite)
**Tracking issue:** VRTV-96 (extiende la feature de crop catalog)

---

## Why (Problem)

La v1 del explorador (commit `d85cf32`) funciona pero su UX falla en lo que marcó el owner:
1. **Filtros torpes** — CheckableComboBox que parecen chips estáticos + botón suelto "Solo discrepancias".
2. **Setpoints como filas de texto planas** (QTextEdit) — no se ven como **rangos** (min/ideal/máx); la receta de nutrientes queda colapsada en una celda JSON.

Y dos decisiones de producto:
- La **tarjeta-instrumento** (valor + gauge de rango) debe ser el **lenguaje visual COMPARTIDO** entre el explorador y el **simulador** (VRTV-95).
- Las secciones del explorador deben **replicar los grupos de columnas color-codificados** del Modelo Fitotécnico.

## What (Decisions)

| # | Decisión | Razón |
|---|----------|-------|
| 1 | **Sidebar izquierdo**: búsqueda por nombre común (+familia/especie) + filtros reales (Aeropónico/Tipo/Perfil) + chip-toggle "⚠ solo discrepancias" + lista con estado. | Resuelve la crítica de filtros; navegación clara. |
| 2 | **Detalle** mapea los grupos de la hoja: Datos Botánicos (izq sticky) · Soluciones del Negocio + Constantes de Monitoreo (der-arriba sticky, 3 cols) · 4 tabs de fase (Veg/Repro/Madur/Nutricional). | Refleja la ontología del agrónomo; despliega lo que estaba colapsado. |
| 3 | **`InstrumentCard`** reutilizable (valor + gauge min/ideal/máx + provenance + color por estado). | Lenguaje visual único explorador ↔ simulador. |
| 4 | **Edición auditada**: `Perfil Asignado` y `Prioridad` como drop-downs + **Guardar** → escribe en `crops`/`setpoints` + inserta `setpoint_audit` (source=experiment, supersedes, is_active). | Permite corregir discrepancias/reasignar perfiles con rollback. |
| 5 | **Receta de nutrientes como árbol** expandible (JSON/YAML-like), no celda colapsada. | Legibilidad. |
| 6 | **Extraer datos nutricionales** (grupo verde de la hoja) a `crops.json`/`crops.db`. | La tab "Valor Nutricional" hoy no tiene datos. |

**In scope:** el rediseño UI (sidebar + detalle + InstrumentCard + tabs + árbol), la edición auditada de perfil/prioridad, y la extracción de datos nutricionales.

**Out of scope:** sync lab→backend→flota (track aparte); adopción de `InstrumentCard` en el simulador VRTV-95 (follow-up de esa rama; aquí se entrega el componente reutilizable); edición de setpoints numéricos individuales con audit (extensión futura).

## Open questions
1. ¿La tab Reproductiva/Maduración para cultivos de hoja muestra "No aplica" o se oculta?
2. ¿`InstrumentCard` se publica como módulo compartible importable por el simulador, o se duplica el patrón?

## References
- ADR: [`design.md`](./design.md) · Tasks: [`tasks.md`](./tasks.md)
- Fuente: `apps/raspberry/config/modelo-fitotecnico.xlsx` (hoja "Modelo Fitotécnico") → `crops.json` → `crops.db`.
- v1 del explorador: `apps/raspberry/tools/crop_explorer/` (commit `d85cf32`).
- Relacionado: `openspec/changes/2026-06-21-simulator-control-ui/` (comparte el InstrumentCard).
