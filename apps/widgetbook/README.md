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

## Package UI compartido: packages/vertivo_ui

El tema, los design tokens y `ResultDisplay` viven en `packages/vertivo_ui`
(`lib/src/{theme,molecules}/`); `apps/vertivo_flutter` los re-exporta para
compatibilidad. A medida que se construyan las pantallas T0 (ver
`srd/gap-audit.md`), cada widget nuevo debe:

1. Vivir en `packages/vertivo_ui/lib/src/{atoms,molecules,organisms}/`
   y exportarse desde `vertivo_ui.dart`.
2. Nacer con su story en `lib/use_cases/<nivel>/<widget>_use_case.dart`.
