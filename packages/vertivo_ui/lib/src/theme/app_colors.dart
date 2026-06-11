import 'package:flutter/material.dart';
import 'token_service.dart';
import 'design_token_model.dart';

/// Light theme color system — driven by style-dictionary/tokens.json
class AppColors {
  static DesignTokenModel get _tokens => TokenService.instance.tokens;

  // Brand Colors (Light)
  static Color get primary => _tokens.brand.primary;
  static Color get secondary => _tokens.brand.secondary;
  static Color get accent => _tokens.brand.accent;
  static Color get warning => _tokens.brand.warning;
  static Color get error => _tokens.brand.error;

  // Mapped from Tonal Palettes (Light)
  static Color get primaryContainer => _tokens.palette.primary[90]!;
  static Color get onPrimary => _tokens.palette.primary[100]!;
  static Color get onPrimaryContainer => _tokens.palette.primary[10]!;

  static Color get secondaryContainer => _tokens.palette.secondary[90]!;
  static Color get onSecondary => _tokens.palette.secondary[100]!;
  static Color get onSecondaryContainer => _tokens.palette.secondary[10]!;

  static Color get tertiary => _tokens.brand.accent;
  static Color get tertiaryContainer => _tokens.palette.accent[90]!;
  static Color get onTertiary => _tokens.palette.accent[100]!;
  static Color get onTertiaryContainer => _tokens.palette.accent[10]!;

  static Color get errorContainer => _tokens.palette.error[90]!;
  static Color get onError => _tokens.palette.error[100]!;
  static Color get onErrorContainer => _tokens.palette.error[10]!;

  // Success Colors
  static Color get success =>
      _tokens.palette.success[40] ?? const Color(0xFF5E7E29);
  static Color get successContainer =>
      _tokens.palette.success[90] ?? const Color(0xFFC8E89A);
  static Color get onSuccess =>
      _tokens.palette.success[100] ?? const Color(0xFFFFFFFF);
  static Color get onSuccessContainer =>
      _tokens.palette.success[10] ?? const Color(0xFF0F1A00);

  // Warning Colors
  static Color get warningContainer =>
      _tokens.palette.warning[90] ?? const Color(0xFFFFDCAA);
  static Color get onWarning =>
      _tokens.palette.warning[100] ?? const Color(0xFFFFFFFF);
  static Color get onWarningContainer =>
      _tokens.palette.warning[10] ?? const Color(0xFF2E1500);

  // Surface & Background (Using Neutral palette)
  static Color get background =>
      _tokens.palette.neutral[98] ?? _tokens.palette.primary[99]!;
  static Color get onBackground =>
      _tokens.palette.neutral[10] ?? _tokens.palette.primary[10]!;
  static Color get surface =>
      _tokens.palette.neutral[98] ?? _tokens.palette.primary[99]!;
  static Color get onSurface =>
      _tokens.palette.neutral[10] ?? _tokens.palette.primary[10]!;

  static Color get surfaceContainerHighest =>
      _tokens.palette.neutral[90] ?? _tokens.palette.primary[90]!;
  static Color get surfaceContainer =>
      _tokens.palette.neutral[94] ??
      _tokens.palette.primary[94] ??
      _tokens.palette.primary[90]!;

  static Color get outline =>
      _tokens.palette.neutralVariant[50] ?? _tokens.palette.primary[50]!;
  static Color get outlineVariant =>
      _tokens.palette.neutralVariant[80] ?? _tokens.palette.primary[80]!;

  // Inverse Colors
  static Color get inverseSurface =>
      _tokens.palette.neutral[20] ?? _tokens.palette.primary[20]!;
  static Color get inverseOnSurface =>
      _tokens.palette.neutral[95] ?? _tokens.palette.primary[95]!;
  static Color get inversePrimary => _tokens.palette.primary[80]!;

  // Shadow & Scrim
  static Color get shadow =>
      _tokens.palette.neutral[0] ?? const Color(0xFF000000);
  static Color get scrim =>
      _tokens.palette.neutral[0] ?? const Color(0xFF000000);
}

/// Dark theme color system — driven by style-dictionary/tokens.json
class AppColorsDark {
  static DesignTokenModel get _tokens => TokenService.instance.tokens;

  // Primary (Dark)
  static Color get primary => _tokens.palette.primary[80]!;
  static Color get primaryContainer => _tokens.palette.primary[30]!;
  static Color get onPrimary => _tokens.palette.primary[20]!;
  static Color get onPrimaryContainer => _tokens.palette.primary[90]!;

  // Secondary (Dark)
  static Color get secondary => _tokens.brand.secondary;
  static Color get secondaryContainer => _tokens.palette.secondary[30]!;
  static Color get onSecondary => _tokens.palette.secondary[20]!;
  static Color get onSecondaryContainer => _tokens.palette.secondary[90]!;

  // Tertiary/Accent (Dark)
  static Color get tertiary => _tokens.palette.accent[80]!;
  static Color get tertiaryContainer => _tokens.palette.accent[30]!;
  static Color get onTertiary => _tokens.palette.accent[20]!;
  static Color get onTertiaryContainer => _tokens.palette.accent[90]!;

  // Error (Dark)
  static Color get error => _tokens.brand.error;
  static Color get errorContainer => _tokens.palette.error[30]!;
  static Color get onError => _tokens.palette.error[100]!;
  static Color get onErrorContainer => _tokens.palette.error[90]!;

  // Success (Dark)
  static Color get success => _tokens.palette.success[40]!;
  static Color get successContainer => _tokens.palette.success[30]!;
  static Color get onSuccess => _tokens.palette.success[100]!;
  static Color get onSuccessContainer => _tokens.palette.success[90]!;

  // Warning (Dark)
  static Color get warning => _tokens.palette.warning[80]!;
  static Color get warningContainer => _tokens.palette.warning[30]!;
  static Color get onWarning => _tokens.palette.warning[100]!;
  static Color get onWarningContainer => _tokens.palette.warning[90]!;

  // Surface & Background (Dark)
  static Color get background =>
      _tokens.palette.neutral[6] ??
      _tokens.palette.primary[6] ??
      const Color(0xFF141419);
  static Color get onBackground =>
      _tokens.palette.neutral[90] ?? _tokens.palette.primary[90]!;
  static Color get surface =>
      _tokens.palette.neutral[6] ??
      _tokens.palette.primary[6] ??
      const Color(0xFF141419);
  static Color get onSurface =>
      _tokens.palette.neutral[90] ?? _tokens.palette.primary[90]!;

  static Color get surfaceContainerHighest =>
      _tokens.palette.neutral[22] ??
      _tokens.palette.primary[22] ??
      _tokens.palette.primary[20]!;
  static Color get surfaceContainer =>
      _tokens.palette.neutral[12] ??
      _tokens.palette.primary[12] ??
      _tokens.palette.primary[10]!;

  static Color get outline =>
      _tokens.palette.neutralVariant[60] ?? _tokens.palette.primary[60]!;
  static Color get outlineVariant =>
      _tokens.palette.neutralVariant[30] ?? _tokens.palette.primary[30]!;

  // Inverse Colors
  static Color get inverseSurface =>
      _tokens.palette.neutral[90] ?? _tokens.palette.primary[90]!;
  static Color get inverseOnSurface =>
      _tokens.palette.neutral[20] ?? _tokens.palette.primary[20]!;
  static Color get inversePrimary => _tokens.brand.primary;

  // Shadow & Scrim
  static Color get shadow =>
      _tokens.palette.neutral[0] ?? const Color(0xFF000000);
  static Color get scrim =>
      _tokens.palette.neutral[0] ?? const Color(0xFF000000);
}
