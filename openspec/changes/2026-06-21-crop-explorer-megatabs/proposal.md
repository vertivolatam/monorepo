# Crop Explorer → 3 mega-tabs + editor de recetas por perfil×fase + calculadora de lote

**Date:** 2026-06-21
**Owner:** Andrés (andres@dojocoding.io)
**Status:** Proposed — diseño visual APROBADO vía brainstorm con visual companion (mockup interactivo adjunto)
**Domain:** `apps/raspberry/tools/crop_explorer/` (PySide6) **y** `apps/vertivo_dashboard/` (Jaspr web) — diseño dual-target
**Tracking issue:** VRTV (crear) — extiende crop_explorer (VRTV-96) y se relaciona con crop-variants (VRTV-100)

---

## Why (Problema)

El crop_explorer actual (un solo panel: sidebar pivot | detalle de cultivo) tiene dos errores de modelo que el owner detectó:

1. **La receta de nutrientes NO es del cultivo — es del PERFIL × FASE.** La hoja "Recetas Soluciones Nutritivas" del Modelo Fitotécnico define recetas por *columna de perfil*, no por cultivo. Todos los cultivos con el mismo perfil comparten la misma receta. El editor per-cultivo actual (escribe `nutrient_recipe_json` en los setpoints de UN cultivo) **diverge ese cultivo de sus hermanos** — semántica equivocada.
2. **Falta el flujo de producción real del laboratorio:** preparar lotes de cada solución (A/B/C) en envases de volumen final estándar (pichingas/tanques) y envasar en botellas de 1 L, escalando la receta con el desplazamiento de volumen.

Además: el mismo editor de recetas debe servir en **vertivo_dashboard** (la versión web conectada al backend K8s donde se valida la flota), no solo en la herramienta local PySide6.

## What (Decisiones — todas validadas en el mockup interactivo)

| # | Decisión | Razón |
|---|----------|-------|
| 1 | **3 mega-tabs:** `Catálogo de cultivos` (el explorador actual, SIN edición de receta) · `Perfiles & Recetas` · `Calculadora de lote`. | Separa *overrides por-cultivo* de *defaults por-perfil* de *producción*. |
| 2 | **Tab Perfiles & Recetas:** sidebar `QListView` plano de perfiles (sin grouping) \| derecha: **accordions de fase** (Vegetativa/Reproductiva/Maduración, color de la hoja) con editor de receta. | El perfil×fase es dueño de la receta; los datos hoy solo tienen Vegetativa → accordions colapsables comunican el hueco. |
| 3 | **Editor de receta = 3 columnas (Solución A/B/C)**, label de sal grande arriba + **stepper `[− valor g +]`** debajo. Sin botón "agregar sal" (set de sales fijo conocido). | Replica la estructura de la hoja; steppers consistentes con el monitoreo. |
| 4 | **Convención de cálculo (confirmada con agrónomos): el dato se guarda SIEMPRE como "g de sal SECA por 1000 ml de AGUA" (sin aforar).** La sal desplaza volumen → el volumen final de cada stock es >1 L, **calculado** y mostrado por solución. | Es lo que el operador pesa en balanza; evita reinterpretar valores registrados. |
| 5 | **Switch de base (solo vista):** `Por 1000 ml de agua` ⟷ `Aforado a 1 L`. "Aforado" reescala los gramos a 1 L exacto (misma concentración) — NO cambia el dato guardado. | Permite leer la receta en cualquier base sin ambigüedad de almacenamiento. |
| 6 | **Callouts de warning (estilo Notion):** uno grande de convención bajo el heading de fase + 3 mini-callouts "stock concentrado aparte, no mezclar A/B/C directo". | El calcio precipita con fosfatos/sulfatos; la UI debe advertirlo. |
| 7 | **Guardar es por-fase y PROPAGA al perfil → todos los cultivos** que lo tengan (re-resuelve sus setpoints), con confirmación "→ N cultivos", auditado. | La receta vive en el perfil; editar afecta a todos sus cultivos. |
| 8 | **Tab Calculadora de lote:** sidebar `QListView` de **envases estándar** (catálogo: Pichinga 18/56 L, Tanque 5000…27000 L, Personalizado) = volumen FINAL \| derecha: recetas como **accordions** (perfil×fase). | Selección consistente (QListView para listas, accordions para recetas). |
| 9 | **Solver inverso de lote:** dado el volumen final del envase + la receta + densidad por sal, calcula **hacia atrás** el agua inicial + gramos de cada sal para completar ese volumen con el desplazamiento, y cuántas botellas de 1 L salen. | El flujo real: elegís el envase, la app te dice qué pesar y agregar. |
| 10 | **Datos de referencia de primera clase:** tabla de **densidad por sal** (9 sales) + **catálogo de envases** (modelo/capacidad). | El cálculo de volumen y el QListView se alimentan de datos, no de código. |

**In scope:** el rediseño a 3 mega-tabs; el editor de receta perfil×fase con accordions + steppers + convención + switch de base + callouts; la propagación auditada perfil→N cultivos; la calculadora de lote (solver inverso) con catálogo de envases; las densidades por sal; y la **paridad en vertivo_dashboard** (misma IA/editor en Jaspr web contra el backend).

**Out of scope:** el modelo crop-variants completo (VRTV-100, track aparte — aquí la receta sigue colgando del `perfil`); edición de constantes de monitoreo a nivel de perfil (futuro); el cálculo de dilución working-solution (1:N) a partir de los stocks (extensión futura).

## Mockup (contrato visual)

El diseño aprobado está en [`mockups/interactive-megatabs.html`](./mockups/interactive-megatabs.html) — preview interactivo (tabs, accordions, QListViews, switch de base y **calculadora con cálculo real en JS**). Es el contrato visual para ambas implementaciones (PySide6 y Jaspr).

## References
- ADR: [`design.md`](./design.md) · Tasks: [`tasks.md`](./tasks.md)
- Base: crop_explorer redesign (VRTV-96) · Relacionado: crop-variants (VRTV-100, `2026-06-21-crop-variants`).
- Fuente de recetas: hoja "Recetas Soluciones Nutritivas" de `apps/raspberry/config/modelo-fitotecnico.xlsx`.
- Catálogo de envases: La Casa del Tanque (Pichinga Industrial, Tanque Industrial Ecotank).
