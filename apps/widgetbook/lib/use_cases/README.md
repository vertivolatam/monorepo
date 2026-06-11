# Use cases — taxonomía Atomic Design

Los stories se organizan en `atoms/`, `molecules/` y `organisms/`, igual que en el
widgetbook canónico de altrupets (`apps/widgetbook/lib/use_cases/`).

## Estado actual

- `molecules/` — `ResultDisplay` (único widget reutilizable extraíble de
  `apps/vertivo_flutter` hoy; las screens dependen del `client` global de Serverpod).
- `atoms/` y `organisms/` — vacíos: **Vertivo aún no tiene package UI compartido ni
  widgets atómicos propios**. Cuando se extraigan widgets de las pantallas T0
  (ver `srd/gap-audit.md`), cada uno debe nacer con su story aquí.

## Convención

Un archivo por widget: `<widget>_use_case.dart`, anotado con
`@widgetbook.UseCase(name: ..., type: ...)` y knobs para sus props.
Regenerar el catálogo con:

```sh
dart run build_runner build --delete-conflicting-outputs
```
