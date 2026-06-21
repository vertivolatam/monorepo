# Canonical Flutter app — Architecture

**Issue:** _to be created_ (`area:mobile` / `area:docs`)
**Status:** Decision 2026-06-21
**PDR:** [`proposal.md`](./proposal.md)

## TL;DR

One Flutter app, `vertivo_flutter`, is the single client for all platforms (mobile,
desktop, web) and consumes the Serverpod backend via the generated `vertivo_client`. The
empty `apps/mobile` stub is deleted. The mobile architecture is **Clean Architecture
(by feature) + Atomic Design (shared UI) + Riverpod** — the one durable idea rescued from
the stale `STRUCTURE.md`, now bound to the real app.

## 1. Why one app, not two

`vertivo_flutter` already ships every platform target (`android/`, `ios/`, `linux/`,
`web/`, `windows/`) and the Serverpod auth + connectivity wiring in `main.dart`. A separate
`apps/mobile` would duplicate the Serverpod client, theme, and auth for no benefit. Flutter
is inherently multi-platform from one codebase, so "mobile vs desktop" is a *run target*
(`flutter run -d linux` vs `-d android`), not a separate project. The pH-slice design
already adds `dev-flutter-desktop` / `dev-flutter-mobile` targets on this premise.

## 2. Architecture stack (bound to `vertivo_flutter/lib`)

| Layer | Home | Depends on |
|-------|------|------------|
| `domain/` | `lib/features/<feature>/domain/` — entities, use cases, repo interfaces | nothing (innermost) |
| `data/` | `lib/features/<feature>/data/` — datasources, models, repo impl (wraps `vertivo_client`) | `domain/` |
| `presentation/` | `lib/features/<feature>/presentation/` — pages, Riverpod providers, widgets | `domain/` |
| shared UI | `lib/shared/ui/{atoms,molecules,organisms,templates}/` (Atomic Design) | — |

Dependencies point inward (presentation/data → domain, never the reverse). State management
is **Riverpod** (compile-safe providers; matches the pH-slice polling provider). `Air
Framework` is noted as an option for enterprise scale but not adopted now (YAGNI).

## 3. Migration posture (incremental, not big-bang)

`vertivo_flutter/lib` today is flat (`main.dart`, `screens/`, `core/theme/`). We do **not**
rewrite it wholesale. New features (starting with the pH `MonitorPhScreen`) are authored in
the Clean Arch + Atomic layout; existing `screens/` migrate opportunistically. This avoids a
risky mass refactor and keeps the pH slice unblocked.

## 4. Docs correction

`docs/STRUCTURE.md` is rewritten to describe Vertivo's actual app set and the
`vertivo_flutter` layout above, or folded into `README.md`. The directory **tree** stays as
plain reference docs; the **architectural decision** lives here in OpenSpec. The two genres
are kept separate by design — reference describes, OpenSpec decides.

## 5. Risks

- **pnpm-lock drift** after deleting `apps/mobile` → regenerate (`pnpm install`) and commit
  the lockfile in the same change.
- **Hidden references** to `apps/mobile` → audited: only `pnpm-lock.yaml` (glob) and
  `docs/STRUCTURE.md`. The hits in `AGENTS.md` / `srd/` / `latam-payments.md` point at
  `altrupets-monorepo/apps/mobile` (a different repo) and are left untouched.

## References

- PDR: [`proposal.md`](./proposal.md) · Tasks: [`tasks.md`](./tasks.md)
- pH slice: `docs/superpowers/specs/2026-06-21-vertivo-ph-monitoring-slice-design.md`
