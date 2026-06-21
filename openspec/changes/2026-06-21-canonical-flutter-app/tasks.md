# Canonical Flutter app — Tasks

> Decision recorded 2026-06-21. Low-risk cleanup; no app code is built here.

## Phase 0 — Retire the stub
- [x] `git rm -r apps/mobile` (package `vertivo_mobile`: only `package.json` + `.gitkeep`s).
- [x] Regenerate `pnpm-lock.yaml` via `pnpm install --lockfile-only` (real pnpm 10.30.3 lives in nvm: `~/.nvm/versions/node/v22.22.2/bin/pnpm`, not on the default PATH). Besides dropping `apps/mobile`, it also added the previously-missing `apps/raspberry` and `apps/vertivo_dashboard` workspace members — the committed lock was stale.
- [x] Verified nothing else references it: only `pnpm-lock.yaml` (fixed) and `docs/STRUCTURE.md` (fixed); the `AGENTS.md`/`srd/`/`latam-payments.md` hits point at `altrupets-monorepo/apps/mobile` (other repo) and stay.

## Phase 1 — Fix the reference docs
- [x] Rewrote `docs/STRUCTURE.md` to reflect Vertivo's real apps: `raspberry`, `vertivo_server` (Serverpod), `vertivo_client`, `vertivo_dashboard` (Jaspr + D3), `vertivo_flutter` (canonical), `widgetbook`.
- [x] Bound the Clean Arch + Atomic + Riverpod layout to `apps/vertivo_flutter/lib/` (not `apps/mobile/`).
- [ ] Decide per open-question #1: keep `STRUCTURE.md` or fold into `README.md`. (Kept as reference doc for now.)

## Phase 2 — (Deferred) layout migration
- [ ] As features are built, author them under `lib/features/<feature>/{domain,data,presentation}` + `lib/shared/ui/{atoms,…}`. Starts with the pH `MonitorPhScreen` (see pH-slice spec). No big-bang refactor.

## Done when
- [ ] `apps/mobile` no longer exists; `pnpm-lock.yaml` regenerated; CI/`pnpm install` green.
- [ ] `docs/STRUCTURE.md` (or `README.md`) describes reality and points to `vertivo_flutter`.
- [ ] `openspec/README.md` Active Changes table includes this change.
