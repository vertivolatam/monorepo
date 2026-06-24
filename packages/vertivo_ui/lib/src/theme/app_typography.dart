import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'token_service.dart';

/// Tipografia del Design System de Vertivo
/// M3 Expressive type scale — Inter font family
class AppTypography {
  static String get headerFontFamily =>
      TokenService.instance.tokens.typography.headerFamily;
  static String get bodyFontFamily =>
      TokenService.instance.tokens.typography.primaryFamily;
  static String get uiFontFamily =>
      TokenService.instance.tokens.typography.tertiaryFamily;

  static TextTheme textTheme({bool isDark = false}) {
    final baseColor = isDark
        ? const Color(0xFFE6E1E8) // neutral-90
        : const Color(0xFF1C1A1E); // neutral-10

    final baseStyle = TextStyle(color: baseColor);

    return TextTheme(
      displayLarge: _getStyle(
        headerFontFamily,
        baseStyle.copyWith(
          fontSize: _getFontSize('displayLarge'),
          fontWeight: _getFontWeight('displayLarge'),
          height: _getLineHeight('displayLarge'),
          letterSpacing: -0.25,
        ),
      ),
      displayMedium: _getStyle(
        headerFontFamily,
        baseStyle.copyWith(
          fontSize: _getFontSize('displayMedium'),
          fontWeight: _getFontWeight('displayMedium'),
          height: _getLineHeight('displayMedium'),
        ),
      ),
      displaySmall: _getStyle(
        headerFontFamily,
        baseStyle.copyWith(
          fontSize: _getFontSize('displaySmall'),
          fontWeight: _getFontWeight('displaySmall'),
          height: _getLineHeight('displaySmall'),
        ),
      ),
      headlineLarge: _getStyle(
        headerFontFamily,
        baseStyle.copyWith(
          fontSize: _getFontSize('headlineLarge'),
          fontWeight: _getFontWeight('headlineLarge'),
          height: _getLineHeight('headlineLarge'),
        ),
      ),
      headlineMedium: _getStyle(
        headerFontFamily,
        baseStyle.copyWith(
          fontSize: _getFontSize('headlineMedium'),
          fontWeight: _getFontWeight('headlineMedium'),
          height: _getLineHeight('headlineMedium'),
        ),
      ),
      headlineSmall: _getStyle(
        headerFontFamily,
        baseStyle.copyWith(
          fontSize: _getFontSize('headlineSmall'),
          fontWeight: _getFontWeight('headlineSmall'),
          height: _getLineHeight('headlineSmall'),
        ),
      ),
      titleLarge: _getStyle(
        bodyFontFamily,
        baseStyle.copyWith(
          fontSize: _getFontSize('titleLarge'),
          fontWeight: _getFontWeight('titleLarge'),
          height: _getLineHeight('titleLarge'),
        ),
      ),
      titleMedium: _getStyle(
        bodyFontFamily,
        baseStyle.copyWith(
          fontSize: _getFontSize('titleMedium'),
          fontWeight: _getFontWeight('titleMedium'),
          height: _getLineHeight('titleMedium'),
          letterSpacing: 0.15,
        ),
      ),
      titleSmall: _getStyle(
        bodyFontFamily,
        baseStyle.copyWith(
          fontSize: _getFontSize('titleSmall'),
          fontWeight: _getFontWeight('titleSmall'),
          height: _getLineHeight('titleSmall'),
          letterSpacing: 0.1,
        ),
      ),
      bodyLarge: _getStyle(
        bodyFontFamily,
        baseStyle.copyWith(
          fontSize: _getFontSize('bodyLarge'),
          fontWeight: _getFontWeight('bodyLarge'),
          height: _getLineHeight('bodyLarge'),
          letterSpacing: 0.5,
        ),
      ),
      bodyMedium: _getStyle(
        bodyFontFamily,
        baseStyle.copyWith(
          fontSize: _getFontSize('bodyMedium'),
          fontWeight: _getFontWeight('bodyMedium'),
          height: _getLineHeight('bodyMedium'),
          letterSpacing: 0.25,
        ),
      ),
      bodySmall: _getStyle(
        bodyFontFamily,
        baseStyle.copyWith(
          fontSize: _getFontSize('bodySmall'),
          fontWeight: _getFontWeight('bodySmall'),
          height: _getLineHeight('bodySmall'),
          letterSpacing: 0.4,
        ),
      ),
      labelLarge: _getStyle(
        bodyFontFamily,
        baseStyle.copyWith(
          fontSize: _getFontSize('labelLarge'),
          fontWeight: _getFontWeight('labelLarge'),
          height: _getLineHeight('labelLarge'),
          letterSpacing: 0.1,
        ),
      ),
      labelMedium: _getStyle(
        bodyFontFamily,
        baseStyle.copyWith(
          fontSize: _getFontSize('labelMedium'),
          fontWeight: _getFontWeight('labelMedium'),
          height: _getLineHeight('labelMedium'),
          letterSpacing: 0.5,
        ),
      ),
      labelSmall: _getStyle(
        bodyFontFamily,
        baseStyle.copyWith(
          fontSize: _getFontSize('labelSmall'),
          fontWeight: _getFontWeight('labelSmall'),
          height: _getLineHeight('labelSmall'),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static TextStyle _getStyle(String fontFamily, TextStyle textStyle) {
    // Inter is available via Google Fonts
    return GoogleFonts.getFont(fontFamily, textStyle: textStyle);
  }

  static double _getFontSize(String style) {
    return switch (style) {
      'displayLarge'  => 57,
      'displayMedium' => 45,
      'displaySmall'  => 36,
      'headlineLarge' => 32,
      'headlineMedium' => 28,
      'headlineSmall' => 24,
      'titleLarge'    => 22,
      'titleMedium'   => 16,
      'titleSmall'    => 14,
      'bodyLarge'     => 16,
      'bodyMedium'    => 14,
      'bodySmall'     => 12,
      'labelLarge'    => 14,
      'labelMedium'   => 12,
      'labelSmall'    => 11,
      _ => 14,
    };
  }

  static FontWeight _getFontWeight(String style) {
    return switch (style) {
      'titleMedium' || 'titleSmall' ||
      'labelLarge' || 'labelMedium' || 'labelSmall' => FontWeight.w500,
      'headlineLarge' || 'headlineMedium' ||
      'headlineSmall' => FontWeight.w600,
      _ => FontWeight.w400,
    };
  }

  static double _getLineHeight(String style) {
    return switch (style) {
      'displayLarge'  => 1.12,
      'displayMedium' => 1.16,
      'displaySmall'  => 1.22,
      'headlineLarge' => 1.25,
      'headlineMedium' => 1.29,
      'headlineSmall' => 1.33,
      'titleLarge'    => 1.27,
      'titleMedium'   => 1.50,
      'titleSmall'    => 1.43,
      'bodyLarge'     => 1.50,
      'bodyMedium'    => 1.43,
      'bodySmall'     => 1.33,
      'labelLarge'    => 1.43,
      'labelMedium'   => 1.33,
      'labelSmall'    => 1.45,
      _ => 1.4,
    };
  }
}
