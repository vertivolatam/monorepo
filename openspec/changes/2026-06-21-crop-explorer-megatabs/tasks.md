# Crop Explorer mega-tabs — Tasks

> Plan por fases, TDD en la lógica pura (cálculo de volumen, aforo, solver). PySide6 en
> `apps/raspberry/tools/crop_explorer/`; paridad Jaspr en `apps/vertivo_dashboard/`.
> Contrato visual: `mockups/interactive-megatabs.html`. `crops.db` es fuente de verdad local.

## Phase 0 — Datos de referencia
- [ ] `config/salt_densities.json` (o tabla en build_db): 9 sales → densidad g/ml (valores iniciales del design; provenance `researched`, ajustables). Loader en el catálogo.
- [ ] `config/container_catalog.json`: modelo, capacidad_L, gal (Pichinga 18/56 L, Tanque 5000…27000 L). Loader.
- [ ] Test: ambos cargan; densidad faltante → None sin romper.

## Phase 1 — Lógica pura (TDD, compartible)
- [ ] `recipe_math.py`: `unit_final_ml(salts, densities)`, `aforo_factor(...)`, `scale_to_volume(recipe, V_final_ml, densities) -> {agua_L, masas_g, botellas}`.
- [ ] Tests: V_final de fruto-vegetativa A/B/C; aforo → 1,00 L; solver Pichinga 18 L (agua/sal/botellas) contra valores esperados; densidad faltante → "—".

## Phase 2 — DB: receta por perfil + propagación auditada
- [ ] `db.save_profile_recipe(profile_key, phase, recipe_json, changed_by)`: persiste la receta del PERFIL y re-resuelve `setpoints` de TODOS los cultivos con ese `assigned_profile`, dejando `setpoint_audit` por cultivo (reusa `_resync_setpoints`).
- [ ] `db.crops_using_profile(profile_key) -> [crop_id]` (para el "→ N cultivos" + la propagación).
- [ ] Tests (DB temporal): editar receta de un perfil → audit en los N cultivos; rollback; N=0 no rompe.

## Phase 3 — Tab "Perfiles & Recetas" (PySide6)
- [ ] `widgets/profiles_view.py`: `QListView` de perfiles | derecha con switch de base + accordions de fase.
- [ ] Editor de receta 3 columnas A/B/C: steppers `[− g +]`, mini-callouts por solución, callout de convención, badge de volumen final (de Phase 1), botón "Guardar <Fase> → N".
- [ ] Switch base re-renderiza (water/aforo). Guardar → `save_profile_recipe` + confirmación + toast.
- [ ] Smoke: monta, switch funciona, guardar propaga.

## Phase 4 — Tab "Calculadora de lote" (PySide6)
- [ ] `widgets/batch_view.py`: `QListView` de envases (catálogo) | accordions de receta (perfil×fase). Selección de envase → `scale_to_volume` → 3 solución cards (agua/sales/volumen/botellas).
- [ ] Selector de botella (default 1 L). Envase personalizado (input validado).
- [ ] Smoke: cambiar de envase recalcula; accordion abre/cierra.

## Phase 5 — Reestructura crop_explorer a 3 mega-tabs
- [ ] `crop_explorer.py`: `QTabWidget` raíz [Catálogo | Perfiles & Recetas | Calculadora]. Tab 1 = el detalle ACTUAL pero SIN edición de receta (la receta se ve read-only; se edita en Tab 2).
- [ ] Quitar `_edit_recipe`/`_recipe_sidebar` editable del detalle de cultivo (queda read-only).
- [ ] Conservar dark mode, tokens, seed-if-empty.

## Phase 6 — Paridad vertivo_dashboard (Jaspr web)
- [ ] Endpoint backend para receta-por-perfil×fase + solver (o exponer `cropCatalog` extendido) — consumido por ambos targets.
- [ ] Componentes Jaspr de los 3 tabs (port del mockup `interactive-megatabs.html`), contra el backend K8s.
- [ ] El solver/convención: una sola implementación canónica (backend Dart) + espejo Python para la tool local; test de paridad (mismos resultados).

## Phase 7 — Verificar
- [ ] `make dev-crop-explorer`: los 3 tabs, editar receta de un perfil → ver audit en N cultivos; calcular lote para Pichinga 18 L y un Tanque.
- [ ] Tests verdes (pytest + paridad), ruff limpio.

## Done when
- [ ] 3 mega-tabs funcionando; receta editable por perfil×fase con propagación auditada a N cultivos.
- [ ] Calculadora de lote: solver inverso por envase del catálogo, con densidades por sal.
- [ ] Switch de base (water/aforo) solo-vista; dato guardado siempre "por 1000 ml de agua".
- [ ] Paridad de diseño/solver con vertivo_dashboard; mockup commiteado.
- [ ] `openspec/README.md` lista este change.
