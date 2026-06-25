---
description: "Maneja issues VRTV hasta un PR Ready-for-Review APPROVED >= umbral (bifrost last-resort + CodeRabbit). No para hasta que todos esten verdes."
argument-hint: "<VRTV-XXXX [VRTV-YYYY ...]> [--confidence 4.5]"
---

# Ready To Review (Mergeable) — Vertivo

`$ARGUMENTS`

Maneja uno o mas issues VRTV hasta un PR **APPROVED y mergeable** cada uno, contra
`develop` (GitFlow), y no para hasta que cada PR este verde.

## Parse arguments
- Issue IDs: cada token `VRTV-XXXX` en `$ARGUMENTS` (un PR por issue).
- Umbral: `--confidence X.X` si esta presente, si no **4.5**. `--confidence` es el
  relajador: nunca subir por encima de lo que pidio el caller.

## Higiene Linear (por issue) — vía API GraphQL de vertivolatam
> El Linear MCP de la sesion esta en OTRO workspace (no VRTV). Usar el helper
> `scripts/linear/vrtv.sh` (GraphQL directo; la key nunca se imprime).

**On start (antes de implementar cada issue):**
1. `scripts/linear/vrtv.sh ensure VRTV-XXX` — setea project/assignee(lapc506)/priority si faltan.
2. `scripts/linear/vrtv.sh set-state VRTV-XXX "In Progress"` — flip + read-back. Si imprime
   `PENDING-MANUAL`, anotarlo para el reporte final (no asumir exito).

## Run the pipeline
Invoca **`make-no-mistakes:implement`** con los issue IDs parseados. Ese skill es dueño de:
- un worktree + una branch por issue (aislamiento),
- el loop de reviewers del repo (CodeRabbit primario),
- **HITL en push / PR / merge** (nunca auto-push, auto-open ni auto-merge sin la aprobacion
  por-accion que el repo exige).

## Per-PR contract
Cuando el skill abre cada PR:
1. **Ready for Review**, nunca Draft — salvo cambios cross-cutting (el repo los abre Draft;
   no correr el reviewer sobre un Draft).
2. Base = **`develop`**.
3. **Append el PR#** a `.claude/.implement-prs`. Crear el archivo si falta; su **primera linea
   es el umbral** (escribirla una vez, antes del primer PR#). Es el estado del Stop hook.

## Reviewer loop (primario -> last-resort bifrost)
- **Primario:** dejar que CodeRabbit (via el loop de `implement`) revise y resolver sus findings.
- **Last-resort bifrost (una vez, al final):** cuando el PR este casi-limpio (o si CodeRabbit
  esta rate-limited/caido/sin veredicto), correr **`bifrost-review pr <n> --post`** (NIM key via
  Infisical/env; `GITHUB_TOKEN` para postear) para obtener el APPROVE con `Confidence: X/5`.
  Correrlo **una sola vez** sobre un PR ya atendido minimiza el gasto NIM (~400k tokens/review,
  rate-limit a nivel de cuenta).
- **Si Confidence < umbral:** leer los findings, arreglar, push, re-correr `bifrost-review pr <n>
  --post`, iterar. No bajar la vara.

## Exit condition (el punto)
No estas listo hasta que *cada* PR en `.claude/.implement-prs` sea:
- no-Draft, **y**
- tenga una review **APPROVED** cuyo body traiga **`Confidence: X/5` con X >= umbral**.

Cuando un PR alcanza el umbral, flip su issue a **"In Review"**:
`scripts/linear/vrtv.sh set-state VRTV-XXX "In Review"` (read-back; **nunca "Done"** — es HITL del PO).

El Stop hook `stop-prs-green.sh` enforce esto: bloquea el fin de sesion mientras
`.claude/.implement-prs` liste algun PR draft, sin-review-APPROVED, o < umbral.

## On success
1. Borrar `.claude/.implement-prs` (el hook tambien lo limpia cuando todo esta verde).
2. Reportar una tabla, una fila por issue: **Issue -> PR -> Confidence -> Linear state**
   (marcando cada flip como **applied** o **PENDING-MANUAL**), y al final la lista
   "manual Linear flips pending" (`issue -> target state`) para lo que no aplico.
