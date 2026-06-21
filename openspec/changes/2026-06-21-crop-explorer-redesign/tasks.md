# Crop Explorer redesign — Tasks

> Plan por fases, TDD donde hay lógica pura. PySide6 en `apps/raspberry/tools/crop_explorer/`.
> Toolchain: `apps/raspberry/.venv` (auto-instala PySide6/openpyxl). Tests: `.venv/bin/python -m pytest`.
> `crops.db` es fuente de verdad (seed-once) — no la borres salvo `--reseed`.

## Phase 0 — Extraer datos nutricionales (build_db.py)
- [ ] En `build_db.py`: mapear las columnas del grupo verde de la hoja ("Nutritional value per 100g": energía, carbohidratos/azúcares/fibra, grasa, proteína, agua, vitaminas A/β-caroteno/B1-B9/colina/C/E/K, minerales Ca/Fe/Mg/Mn/P/K/Na/Zn). Añadir índices de columna (1-indexed) como las existentes (`COL_*`).
- [ ] Añadir a `crops.json` por cultivo un bloque `nutrition_per_100g` (con provenance `source:"sheet"`), generado por un script de extracción (o extender el pipeline existente). Bump `meta.version`.
- [ ] Nueva tabla `nutrition` en el schema (`CREATE TABLE IF NOT EXISTS nutrition (crop_id, nutrient, value_num, unit, source)`) + índice `(crop_id)`. Poblarla en `build()`.
- [ ] Test: tras build, un cultivo conocido (ej. Albahaca/espinaca) tiene filas en `nutrition`; conteo > 0.

## Phase 1 — InstrumentCard (componente compartido) — TDD
- [ ] `widgets/__init__.py` + `widgets/instrument_card.py`. Función pura `range_status(value, lo, hi, ideal=None, warn_band=...) -> "ok"|"warn"|"alert"` (misma semántica que el slice de pH).
- [ ] Test de `range_status`: in-range→ok, borde→warn, fuera→alert; sin rango (lo/hi None) → "ok"/"n/a" definido.
- [ ] `InstrumentCard(QWidget)`: props (label, value, unit, lo/ideal/hi, source, confidence, citation). Pinta valor coloreado por `range_status` + gauge (banda + ideal + marcador) + min/ideal/máx + badge provenance 🟦/🟨 (tooltip con cita/confianza). Solo-lectura.
- [ ] Smoke (pytest-qt si está, o instanciar sin `exec`): la card construye y reporta el color esperado para in/out-of-range.

## Phase 2 — Escritura auditada (db.py) — TDD
- [ ] `db.py`: clase/funciones de acceso a `crops.db`. `save_classification(crop_id, *, profile=None, priority=None, changed_by="explorer")`: actualiza `crops`; si cambió `assigned_profile`, re-resuelve y actualiza `setpoints`; inserta un `setpoint_audit` (field=`assigned_profile`/`priority`, value_text, `source='experiment'`, `supersedes_id`=audit activo previo, `is_active=1`) y pone el previo `is_active=0`.
- [ ] Test (DB temporal sembrada): cambiar el perfil de un cultivo → existe un nuevo `setpoint_audit` con `source='experiment'` y `supersedes_id`; el previo `is_active=0`; `crops.assigned_profile` actualizado; idempotencia razonable.
- [ ] Test: cambiar prioridad sin cambiar perfil → audit de `priority`, `setpoints` intactos.

## Phase 3 — Sidebar (widgets/sidebar.py)
- [ ] `Sidebar(QWidget)`: `QLineEdit` de búsqueda (filtra por name_es/family/species en vivo); 3 `QComboBox`/multi-select (Aeropónico, Tipo=`sheet_harvest_type`, Perfil); chip-toggle "⚠ solo discrepancias"; `QListView`/lista con punto de estado (🟢/⚪/🟠) + nombre + tipo; contador. Emite señal `cropSelected(crop_id)` al click.
- [ ] Discrepancia = `PROFILE_TO_SHEET_TYPE[assigned_profile] != sheet_harvest_type` (reusar la lógica de build_db).
- [ ] Smoke: construir el sidebar con la DB real, verificar que filtra (term → subconjunto) y que el chip de discrepancias deja 5.

## Phase 4 — DetailView (widgets/detail_view.py)
- [ ] `DetailView(QWidget)` con `setCrop(crop_id)`: panel izq sticky (Datos Botánicos) + der-arriba sticky 3-col (Soluciones del Negocio con `QComboBox` Perfil + `QComboBox` Prioridad + botón Guardar; Constantes de Monitoreo) + der-abajo `QTabWidget` (Veg/Repro/Madur/Nutricional).
- [ ] Tabs de fase: grid de `InstrumentCard` (de los `setpoints` activos del cultivo, leídos vía `db.py`) + árbol de receta (`QTreeWidget` desde `nutrient_recipe_json`). Tab Nutricional: tabla desde `nutrition`. Fase sin datos → label "No aplica".
- [ ] Guardar → `db.save_classification(...)` + toast ("✓ guardado — auditoría") + refresca la card/estado y emite señal para que el sidebar re-evalúe discrepancias.

## Phase 5 — Refactor crop_explorer.py
- [ ] `crop_explorer.py`: `QMainWindow` con `QSplitter`/grid `Sidebar | DetailView`. Conectar `cropSelected` → `DetailView.setCrop`. **Eliminar** el viejo `QTextEdit` plano, los CheckableComboBox del header y el botón "Solo discrepancias".
- [ ] Conservar el auto-ensure de PySide6 y el arranque seed-if-empty de la DB.
- [ ] `dart`/ruff: `ruff check` limpio sobre `crop_explorer/`.

## Phase 6 — Verificar
- [ ] `make dev-crop-explorer` levanta sin errores; buscar por nombre, filtrar, abrir un cultivo, cambiar perfil + Guardar.
- [ ] Verificar en SQLite el nuevo registro de `setpoint_audit` (source=experiment) y que la discrepancia desaparece tras corregir.
- [ ] Tests verdes (`pytest tests/`), ruff limpio.

## Done when
- [ ] Sidebar con búsqueda + filtros reales + chip discrepancias; detalle con Botánicos/Negocio editable/Monitoreo + 4 tabs de `InstrumentCard` + árbol de receta.
- [ ] Guardar perfil/prioridad escribe audit (rollback posible).
- [ ] Datos nutricionales extraídos y visibles en su tab.
- [ ] `openspec/README.md` lista este change.
