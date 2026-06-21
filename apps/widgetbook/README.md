# vertivo_widgetbook

Catálogo de widgets de Vertivo con [Widgetbook](https://pub.dev/packages/widgetbook),
con la misma taxonomía Atomic Design que el widgetbook canónico de altrupets:

```
lib/
  main.dart                  # Widgetbook app + tab Showcase del design system
  use_cases/
    atoms/                   # (vacío — ver Gap abajo)
    molecules/               # ResultDisplay
    organisms/               # (vacío — ver Gap abajo)
  showcase/
    design_system_showcase.dart  # colores y tipografía desde tokens.json
```

## Correr

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome
```

> Nota: este paquete se resuelve FUERA del pub workspace raíz a propósito —
> `widgetbook_generator` requiere `analyzer >=8.2.0` y `vertivo_dashboard`
> (jaspr_lints) fija `analyzer ^7.0.0`, lo que hace imposible la resolución
> conjunta. Depende de `vertivo_flutter` por path igualmente.

## Gap: Vertivo aún no tiene package UI compartido

Hoy `apps/vertivo_flutter` solo tiene 2 screens (scaffold de Serverpod) y el
sistema de tokens/tema (`lib/core/theme/`). El único widget reutilizable es
`ResultDisplay` (extraído a `lib/core/widgets/molecules/`). A medida que se
construyan las pantallas T0 (ver `srd/gap-audit.md`), cada widget nuevo debe:

1. Vivir en `apps/vertivo_flutter/lib/core/widgets/{atoms,molecules,organisms}/`.
2. Nacer con su story en `lib/use_cases/<nivel>/<widget>_use_case.dart`.
