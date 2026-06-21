# Canonical Flutter app — retire `apps/mobile` stub, make `vertivo_flutter` the single source

**Date:** 2026-06-21
**Owner:** Andrés (andres@dojocoding.io)
**Status:** Proposed — surfaced while designing the pH monitoring vertical slice
**Domain:** `vertivo_flutter` (vertivolatam) + repo docs hygiene
**Tracking issue:** _to be created (`area:mobile` / `area:docs`)_

---

## Why (Problem)

The monorepo has **two competing homes for "the Flutter app"**, and the docs point at the
wrong one:

- `apps/mobile/` (package `vertivo_mobile`) is an **empty templated stub**: only
  `package.json` + three `.gitkeep` files. No `pubspec.yaml`, no Dart, never developed.
  It was copied from the altrupets monorepo template.
- `apps/vertivo_flutter/` is **the real app**: Serverpod client (`vertivo_client`),
  `main.dart`, screens, and full platform folders (`android/ios/linux/web/windows`). It is
  the app the Makefile actually runs (`dev-flutter-start`, `dev-flutter-build`).
- `docs/STRUCTURE.md` documents `apps/mobile/lib/` as the mobile app and describes a layout
  (`apps/backend` NestJS, `widgetbook`) that is **the altrupets template, not Vertivo's
  reality** (no mention of `raspberry`, `vertivo_server` Serverpod, `vertivo_client`,
  `vertivo_dashboard`, EMQX/MQTT). The reference doc is actively misleading.

No code depends on `apps/mobile` (no imports, no build). The only references are: the pnpm
workspace glob `apps/*` (harmless empty package), and `docs/STRUCTURE.md` (stale).

## What (Decisions)

| # | Decision | Rationale |
|---|----------|-----------|
| 1 | **`vertivo_flutter` is the canonical Flutter app** (mobile + desktop + web), driven by the existing Serverpod client. | It is the only real, runnable app; the Makefile already targets it. |
| 2 | **Retire `apps/mobile`** (`git rm -r apps/mobile`); regenerate `pnpm-lock.yaml`. | Dead scaffolding; eliminates the "two mobile homes" ambiguity. |
| 3 | **Mobile architecture stack = Clean Architecture (by feature) + Atomic Design (`shared/ui`) + Riverpod.** | Preserves the one genuinely useful part of `STRUCTURE.md` as a real decision, now bound to `vertivo_flutter`. Matches the pH-slice design (Riverpod polling). |
| 4 | **Rewrite `docs/STRUCTURE.md`** to reflect Vertivo's real apps (`raspberry`, `vertivo_server`, `vertivo_client`, `vertivo_dashboard`, `vertivo_flutter`, `widgetbook`), or supersede it. | Reference docs must describe reality, not a copied template. |

**In scope (this change):** recording the decision; the `apps/mobile` deletion; the
`STRUCTURE.md` correction; pnpm-lock regeneration.

**Out of scope:** building any UI (that is the pH-slice spec); renaming `vertivo_flutter`;
restructuring `vertivo_flutter/lib` into the Clean Arch layout (a later change, applied as
features are built).

## Open questions for the owner

1. Keep `docs/STRUCTURE.md` rewritten, or fold it into the root `README.md` and delete it?
2. Should `vertivo_flutter/lib` be migrated to the Clean Arch + Atomic layout now, or
   incrementally as the pH slice and later screens are built? (Recommendation: incremental.)
3. Is `apps/widgetbook` still intended as the widget catalog for `vertivo_flutter`?

## References

- ADR: [`design.md`](./design.md) · Tasks: [`tasks.md`](./tasks.md)
- Related spec: `docs/superpowers/specs/2026-06-21-vertivo-ph-monitoring-slice-design.md`
  (this decision absorbs that spec's "retire `apps/mobile`" out-of-scope item).
