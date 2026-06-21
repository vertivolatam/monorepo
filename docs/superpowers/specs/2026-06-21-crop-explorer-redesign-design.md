# Diseño: Rediseño del Crop Explorer (instrumento compartido + tabs de la hoja + edición auditada)

- **Fecha:** 2026-06-21
- **Estado:** Aprobado para planificación
- **Rama:** `feat/VRTV-96-crop-catalog-config`
- **App:** `apps/raspberry/tools/crop_explorer/` (PySide6/Qt) sobre `crops.db` (SQLite)

## 1. Contexto y problema

La v1 del explorador (commit `d85cf32`) funciona pero la UX falla en dos cosas que el owner marcó:
1. **Filtros torpes** — CheckableComboBox que parecen chips estáticos + un botón suelto "Solo discrepancias".
2. **Setpoints como filas de texto planas** (QTextEdit) — no se ven como **rangos** (min/ideal/máx), y la receta de nutrientes queda colapsada en una celda JSON.

Además surgieron dos decisiones de producto:
- La **tarjeta-instrumento** (valor grande + gauge de rango) debe ser el **lenguaje visual COMPARTIDO** entre el explorador y el **simulador** (VRTV-95).
- Las secciones del explorador deben **replicar los grupos de columnas color-codificados** del Modelo Fitotécnico (la hoja del agrónomo).

## 2. Fuente de verdad (recordatorio del modelo)

`crops.db` (SQLite) es la **fuente de verdad por-device** durante la experimentación de laboratorio (seed-once desde `crops.json`, con `setpoint_audit` para rollback). El explorador **lee y escribe** esa DB. (La promoción a PostgreSQL/flota es un track aparte.)

## 3. Layout

```
┌─────────────────┬───────────────────────────────────────────────┐
│ SIDEBAR         │ DETALLE                                        │
│ 🔍 buscar       │ ┌──────────────┬────────────────────────────┐ │
│   (nombre común,│ │ Datos        │ Soluciones del Negocio      │ │  ← sticky top, 3 cols
│   familia,      │ │ Botánicos    │  Perfil Asignado ▾          │ │
│   especie)      │ │ (sticky izq, │  Prioridad ▾   [Guardar]    │ │
│ filtros ▾:      │ │  naranja)    │ Constantes de Monitoreo (am)│ │
│  Aeropónico     │ │              ├────────────────────────────┤ │
│  Tipo (harvest) │ │              │ [4 tabs]  Veg│Repro│Madur│Nut│ │  ← tabs
│  Perfil         │ │              │  tarjetas-instrumento +      │ │
│ ⚠ chip discrep. │ │              │  árbol de receta de nutrientes│ │
│ ───────────     │ │              │                            │ │
│ lista (107):    │ └──────────────┴────────────────────────────┘ │
│  🟢 Albahaca Hoja│                                                │
│  🟠 Tacaco  Raíz │                                                │
└─────────────────┴───────────────────────────────────────────────┘
```

### 3.1 Sidebar (izquierda) — resuelve la crítica #1
- **Búsqueda en vivo** por nombre común (ES); además matchea familia/especie.
- **Filtros reales** (multi-select consistentes): Aeropónico (Sí/No), Tipo de cultivo (`sheet_harvest_type`: Hoja/Fruto/Raíz/Semillas), Perfil asignado.
- **"⚠ solo discrepancias" = chip-toggle** entre los filtros (NO un botón suelto).
- **Lista** de cultivos: punto de estado (🟢 aeropónico · ⚪ no-aero · 🟠 discrepancia sheet/profile) + nombre + tipo. Click → carga el detalle. Contador "N de 107 · M ⚠".

### 3.2 Detalle (derecha) — mapeo de las secciones de la hoja
- **Izquierda sticky (naranja):** **Datos Botánicos** — familia, especie, parte comestible, origen, uso.
- **Derecha-arriba sticky, 3 columnas:**
  - **Soluciones del Negocio (gris):** Apto Aeroponía; **`Perfil Asignado` (drop-down, valores en español)** y **`Prioridad` (drop-down)** EDITABLES + botón **Guardar**.
  - **Constantes de Monitoreo (amarillo):** Espectro de Luz, Fotoperiodo.
- **Derecha-abajo, 4 tabs (color de la hoja):**
  - **Fase Vegetativa (morado)** · **Fase Reproductiva (magenta)** · **Fase de Maduración (azul)** · **Valor Nutricional (verde)**.
  - Cada tab de fase muestra un **grid de tarjetas-instrumento** + el **árbol de receta de nutrientes**.
  - Para cultivos que no tienen una fase (p.ej. hoja → no hay reproductiva/maduración), la tab muestra **"No aplica"**; donde hay datos investigados parciales (tomate/fresa), se muestran con su provenance.

## 4. La tarjeta-instrumento (componente compartido)

Widget reutilizable (`InstrumentCard`) — el MISMO en explorador y simulador:
- **Valor operativo** grande, coloreado por estado (🟢 en rango / 🟡 advertencia / 🔴 fuera o anomalía / 🟡 sin-calibrar en el simulador).
- **Gauge de rango**: barra con banda saludable, marca del ideal, marcador del valor.
- **Min / ideal / máx** debajo.
- **Provenance**: 🟦 sheet / 🟨 researched (+ confianza/cita en tooltip), leído de `setpoint_audit (is_active=1)`.
- Unidad en el label (pH, EC dS/m, °C, %, mV, µmol…).

> En el **explorador** la card es de solo-lectura (muestra el setpoint del cultivo). En el **simulador** la card añade controles (target/anomalía/on-off/calibración). El núcleo visual (valor + gauge + estado) es idéntico. La adopción en el simulador (VRTV-95) es un follow-up de esa rama; aquí se entrega el componente y su uso en el explorador.

## 5. Edición con auditoría (Guardar)

Editar `Perfil Asignado` o `Prioridad` + **Guardar**:
- Actualiza `crops` (y los `setpoints` resueltos si cambió el perfil).
- Inserta un registro en **`setpoint_audit`** con `source='experiment'`, `changed_at`, `changed_by`, `supersedes_id` apuntando al previo, y desactiva el anterior (`is_active=0`).
- Esto es el flujo de **corrección/experimentación auditada** — permite arreglar las 5 discrepancias (Tacaco, brotes, semillas) y reasignar perfiles directamente, con rollback.

## 6. Datos nuevos a extraer

- **Valor Nutricional (tab verde):** hoy NO está en `crops.json`/`crops.db`. Extraer de la hoja "Modelo Fitotécnico" (grupo verde) los campos por 100g: energía, carbohidratos/azúcares/fibra, grasa, proteína, agua, vitaminas (A, β-caroteno, B1-B9, colina, C, E, K) y minerales (Ca, Fe, Mg, Mn, P, K, Na, Zn). Añadir a `crops.json` (con provenance `sheet`) → re-seed de la tabla `crops`/una tabla `nutrition`.
- **Fases Reproductiva/Maduración:** la hoja las tenía vacías; se muestran los valores investigados que sí existen (fruto/raíz) y "sin datos" donde no.

## 7. Componentes (archivos)

| Archivo | Responsabilidad |
|---------|-----------------|
| `apps/raspberry/tools/crop_explorer/build_db.py` | seed-once crops.json (+ xlsx harvest_type + **nutrición**) → crops.db. Modificar para extraer nutrición. |
| `apps/raspberry/tools/crop_explorer/widgets/instrument_card.py` | **nuevo** — `InstrumentCard` (valor + gauge + provenance). Compartible. |
| `apps/raspberry/tools/crop_explorer/widgets/sidebar.py` | **nuevo** — búsqueda + filtros + lista. |
| `apps/raspberry/tools/crop_explorer/widgets/detail_view.py` | **nuevo** — layout izq/der + tabs + árbol de receta + edición Guardar. |
| `apps/raspberry/tools/crop_explorer/crop_explorer.py` | refactor: arma sidebar + detail; quita el QTextEdit plano y los filtros viejos. |
| `apps/raspberry/tools/crop_explorer/db.py` | (si conviene extraer) acceso a crops.db + escritura auditada. |

## 8. Errores / edge cases

- Cultivo sin perfil (`profile:null`, los 43 no-aeropónicos) → tabs de fase muestran "sin perfil / no aeropónico"; el detalle muestra Botánicos + Negocio igual.
- Guardar con DB de solo-lectura o error SQL → toast de error, no corrompe estado.
- Fase sin datos → "No aplica" / "sin datos", no card vacía.
- Receta ausente → el árbol no se muestra (no nodo vacío).

## 9. Testing

- **Unit (sin GUI):** `build_db.py` extrae nutrición (conteos, un cultivo con valores nutricionales); la escritura auditada (cambiar perfil → nuevo `setpoint_audit` con supersedes, viejo `is_active=0`, `setpoints` sincronizado); resolución de `sheet_harvest_type` y detección de discrepancias.
- **Widget (pytest-qt si está, o smoke):** `InstrumentCard` renderiza valor+rango+color correcto para in-range / out-of-range / sin-calibrar.
- **Manual:** `make dev-crop-explorer` → buscar por nombre, filtrar, abrir un cultivo, cambiar perfil + Guardar + verificar el registro de audit en `setpoint_audit`.

## 10. Fuera de alcance

- Sync lab→backend→flota (track aparte).
- Adopción de `InstrumentCard` en el simulador VRTV-95 (follow-up de esa rama; aquí se entrega el componente reutilizable).
- Edición de setpoints numéricos individuales (esta iteración edita perfil/prioridad; editar cada setpoint con audit es una extensión futura).
