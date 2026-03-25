---
title: Design System
description: Design system con Widgetbook, tokens.json, paleta de colores y Material 3.
---

# Design System

Vertivo cuenta con un design system documentado mediante **Widgetbook**, que permite visualizar y probar todos los componentes de UI de forma aislada. Los tokens de diseno se definen en un archivo JSON centralizado procesado por **Style Dictionary**.

## Widgetbook

Widgetbook es una herramienta de catalogacion de widgets para Flutter (equivalente a Storybook para web). Cada componente reutilizable tiene una entrada donde se prueban variantes, estados y temas.

```bash
# Levantar Widgetbook en desarrollo
cd apps/widgetbook
flutter run -d chrome
```

## Design Tokens (tokens.json)

Los tokens de diseno (colores, tipografia, espaciado, bordes, motion) se definen en `style-dictionary/tokens.json`. Style Dictionary los transforma a:

- **Dart constants** para Flutter
- **CSS variables** para Jaspr/dashboard
- **YAML** para documentacion

```
style-dictionary/
  tokens.json         # Fuente unica de verdad
  build/
    dart/             # Constantes Dart generadas
    css/              # Variables CSS generadas
```

## Paleta de Colores

Basada en la identidad de marca Vertivo:

| Token | Color | Uso |
|-------|-------|-----|
| **Primary** | `#772583` (Purple) | Acciones principales, header, CTA |
| **Secondary** | `#CEDC00` (Lime) | Acentos, badges, exito |
| **Accent** | `#5E7E29` (Olive Green) | Elementos de naturaleza, agricultura |
| **Surface** | `#FFFFFF` / `#1A1A2E` | Fondos light/dark |
| **Error** | `#F4493A` | Alertas, errores |

## Tipografia

| Token | Fuente | Uso |
|-------|--------|-----|
| **text** | Poppins | Cuerpo de texto, UI general |
| **display** | Lemon Milk | Headings, branding |
| **code** | Roboto Mono | Codigo, datos de sensores |

## Material 3

La app Flutter usa **Material 3** con `ColorScheme.fromSeed()` basado en los tokens de marca. El tema soporta light y dark mode automaticamente.

```dart
// Generacion del tema desde tokens
final colorScheme = ColorScheme.fromSeed(
  seedColor: VertivoColors.primary, // #772583
  brightness: Brightness.light,
);
```

## Principio Rosa Test

!!! warning "Accesibilidad"
    Todos los componentes del design system deben pasar el **Rosa Test**: si Rosa (63 anos, tech baja, WhatsApp-only) no puede usarlo, el componente necesita revision. Esto implica:

    - Letras grandes y legibles
    - Contraste suficiente (WCAG AA minimo)
    - Lenguaje simple en espanol
    - Touch targets de al menos 48px
    - Feedback visual claro en cada interaccion
