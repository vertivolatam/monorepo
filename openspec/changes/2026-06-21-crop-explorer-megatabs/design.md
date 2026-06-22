# ADR — Crop Explorer 3 mega-tabs + recetas perfil×fase + calculadora de lote

**Date:** 2026-06-21
**Status:** Proposed — diseño visual aprobado (mockup interactivo)
**PDR:** [`proposal.md`](./proposal.md)

## 1. IA — 3 mega-tabs

```
┌───────────────────────────────────────────────────────────────────────┐
│ 🌱 Catálogo de cultivos │ 🧪 Perfiles & Recetas │ 🧮 Calculadora de lote │
├───────────────────────────────────────────────────────────────────────┤
│ Tab 1: el explorador ACTUAL (sidebar pivot | detalle). Se le QUITA la    │
│        edición de receta del detalle (la receta es del perfil).          │
│ Tab 2: QListView perfiles | accordions de fase con editor de receta.     │
│ Tab 3: QListView envases  | accordions de receta con solver de lote.     │
└───────────────────────────────────────────────────────────────────────┘
```

`QTabWidget` raíz en `crop_explorer.py` (PySide6) / un router de 3 vistas en `vertivo_dashboard` (Jaspr). Patrón de consistencia: **QListView** para listas de selección (perfiles, envases), **accordions** para recetas/fases.

## 2. Tab "Perfiles & Recetas"

- **Izquierda:** `QListView` plano de los perfiles (sin grouping). Click → carga la derecha.
- **Derecha:** header (nombre perfil + "⚠ aplica a N cultivos") + **switch de base** (`Por 1000 ml de agua` / `Aforado a 1 L`, solo vista) + **accordions de fase** (Vegetativa morado, Reproductiva magenta, Maduración azul — colores de la hoja). Cada accordion = editor de receta de esa fase, o "sin receta — clic para agregar".
- **Editor de receta (3 columnas A/B/C):** cada columna = `Solución X — … · g / 1000 ml de agua`, un **mini-callout** ("stock concentrado aparte"), las sales con **stepper** `[− valor g +]`, y un badge **Volumen final ≈ X L** (calculado). Un callout grande de convención bajo el heading. Botón **"💾 Guardar <Fase> → N cultivos"**.

## 3. Convención de receta (CONFIRMADA con agrónomos)

**Almacenamiento canónico:** gramos de **sal SECA** por **1000 ml de AGUA** (NO aforado). Es la única base persistida (`nutrient_recipe_json` sigue siendo el formato; los valores son g/1000ml-agua).

**Volumen final de un stock** (la sal desplaza volumen):
```
V_final_unidad(ml) = 1000 + Σ_sal ( masa_g / densidad_g_por_ml )
```
Se muestra por solución (>1 L). Requiere **densidad por sal**.

**Switch "Aforado a 1 L" (solo vista):** reescala los gramos para que el volumen final sea 1 L exacto, misma concentración:
```
factor_aforo = 1000 / V_final_unidad(ml)
g_aforado    = g * factor_aforo      → V_final mostrado = 1,00 L
```
NO altera el dato guardado; es una transformación de display (`display_basis ∈ {water_1000ml, qs_1L}`).

**Open question (a confirmar con agrónomo):** si la hoja original quiso decir "por L de agua" (solvente) vs "aforado a L de solución" — el owner confirmó la primera; documentado aquí para trazabilidad.

## 4. Tab "Calculadora de lote" — solver inverso

- **Izquierda:** `QListView` del **catálogo de envases** (volumen final): Pichinga 18 L / 56 L, Tanque 5000/7500/10000/15000/22000/27000 L, Personalizado. Click → recalcula.
- **Derecha:** recetas como **accordions** (perfil×fase). El accordion abierto muestra, por solución, el **cálculo inverso** para el volumen final del envase.

**Solver** (dado V_final del envase, en ml):
```
unidades   = V_final / V_final_unidad(receta_solución)
agua_inicial_L = unidades * 1.0          (1 L de agua por unidad)
masa_sal_g(sal) = unidades * g_por_1000ml(sal)
→ completa exactamente V_final con el desplazamiento
botellas_1L = floor(V_final_L / volumen_botella_L)
```
Que el agua inicial varíe entre soluciones (la A desplaza más que la C) es correcto, no un bug.

## 5. Datos de referencia (de primera clase)

| Recurso | Forma | Uso |
|---|---|---|
| **Densidad por sal** | `salt_density(sal → g/ml)` — 9 sales conocidas (nitrato de calcio/potasio, MAP, sulfato de magnesio, Mn, Fe, B, Zn, Cu) | V_final + aforo + solver |
| **Catálogo de envases** | `container_catalog(modelo, capacidad_L, gal)` | QListView de la calculadora |

Van como datos versionados (config/JSON o tabla en `crops.db`), no hardcode. Densidades aproximadas iniciales en el mockup; el agrónomo puede ajustarlas (auditable).

## 6. Propagación perfil → N cultivos (auditada)

Guardar una receta en `Perfiles & Recetas` escribe la receta **del perfil** y **re-resuelve** los setpoints de TODOS los cultivos con ese `assigned_profile` (reusa `resolve_setpoints` / `_resync_setpoints` de `build_db`/`db.py`), dejando `setpoint_audit` por cultivo afectado. Confirmación previa "→ N cultivos". Rollback vía la auditoría existente.

> Hoy `nutrient_recipe_json` ya se resuelve per-cultivo desde el perfil; el cambio es que la EDICIÓN entra por el perfil (una vez) en vez de por cada cultivo.

## 7. Dual-target: PySide6 + vertivo_dashboard

El mockup (`mockups/interactive-megatabs.html`) es el **contrato visual compartido**:
- **crop_explorer (PySide6):** `QTabWidget` + `QListView` + accordions (`QToolBox` o accordions custom) + `Stepper` (ya existe) + el solver en Python.
- **vertivo_dashboard (Jaspr web):** las MISMAS 3 vistas en componentes Jaspr, contra el backend Serverpod (K8s). La receta perfil×fase, el solver y los datos de referencia viven en el backend (`cropCatalog`/nuevo endpoint), consumidos por ambos. El HTML/JS del mockup es portable casi 1:1 a Jaspr.

El **solver y la convención** se implementan una vez (idealmente backend Dart + espejo Python para la herramienta local) para no divergir.

## 8. Errores / edge cases
- Sal con densidad faltante → V_final no calculable: mostrar "—" + warning, no romper.
- Receta-stub (sin sales): accordion "sin receta — clic para agregar" parte del esqueleto A/B/C estándar.
- Volumen de envase personalizado: input validado >0.
- Guardar perfil sin cultivos asociados (N=0): permitido, sin propagación.

## 9. Testing
- **Unit (pura):** `V_final_unidad`, `factor_aforo`, solver inverso (agua/sal/botellas) — casos conocidos (Pichinga 18 L sobre la receta de fruto-vegetativa).
- **DB:** propagación perfil→N cultivos deja audit en cada cultivo; rollback.
- **Widget/SSR smoke:** los 3 tabs montan; switch re-renderiza; selección de envase recalcula.
- **Paridad:** el mismo set de casos del solver corre en Python y Dart (mismos resultados).

## References
- PDR: [`proposal.md`](./proposal.md) · Tasks: [`tasks.md`](./tasks.md) · Mockup: [`mockups/interactive-megatabs.html`](./mockups/interactive-megatabs.html)
- Relacionado: `2026-06-21-crop-variants` (VRTV-100) — cuando exista el modelo de variantes, la receta colgará de la variante×fase (este spec usa `perfil×fase`).
