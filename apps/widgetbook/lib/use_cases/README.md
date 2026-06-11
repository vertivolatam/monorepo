# Use cases — taxonomía Atomic Design

Los stories se organizan en `atoms/`, `molecules/` y `organisms/`, igual que en el
widgetbook canónico de altrupets (`apps/widgetbook/lib/use_cases/`).

## Estado actual

- `molecules/` — `ResultDisplay` (vive en `packages/vertivo_ui`; las screens de
  la app dependen del `client` global de Serverpod y no son catalogables).
- `atoms/` y `organisms/` — vacíos: los próximos widgets deben nacer en
  `packages/vertivo_ui` con su story aquí.

## Convención

Un archivo por widget: `<widget>_use_case.dart`, anotado con
`@widgetbook.UseCase(name: ..., type: ...)` y knobs para sus props.
Regenerar el catálogo con:

```sh
dart run build_runner build --delete-conflicting-outputs
```
