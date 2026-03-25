import 'package:flutter/material.dart';

class DesignTokenModel {
  DesignTokenModel({
    required this.brand,
    required this.palette,
    required this.typography,
    required this.motion,
  });

  factory DesignTokenModel.fromJson(Map<String, dynamic> json) {
    final color = json['color'] as Map<String, dynamic>;
    final brandJson = color['brand'] as Map<String, dynamic>;
    final paletteJson = color['palette'] as Map<String, dynamic>;
    final typographyJson = json['typography'] as Map<String, dynamic>;
    final motionJson = json['motion'] as Map<String, dynamic>;

    return DesignTokenModel(
      brand: BrandColors.fromJson(brandJson),
      palette: ColorPalette.fromJson(paletteJson),
      typography: TypographyTokens.fromJson(typographyJson),
      motion: MotionTokens.fromJson(motionJson),
    );
  }

  final BrandColors brand;
  final ColorPalette palette;
  final TypographyTokens typography;
  final MotionTokens motion;
}

class BrandColors {
  BrandColors({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.warning,
    required this.error,
  });

  factory BrandColors.fromJson(Map<String, dynamic> json) {
    return BrandColors(
      primary: _parseHex(json['primary']['value'] as String),
      secondary: _parseHex(json['secondary']['value'] as String),
      accent: _parseHex(json['accent']['value'] as String),
      warning: _parseHex(json['warning']['value'] as String),
      error: _parseHex(json['error']['value'] as String),
    );
  }

  final Color primary;
  final Color secondary;
  final Color accent;
  final Color warning;
  final Color error;
}

class ColorPalette {
  ColorPalette({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.warning,
    required this.error,
    required this.success,
    required this.neutral,
    required this.neutralVariant,
  });

  factory ColorPalette.fromJson(Map<String, dynamic> json) {
    return ColorPalette(
      primary: _parseTonalPalette(json['primary'] as Map<String, dynamic>),
      secondary: _parseTonalPalette(json['secondary'] as Map<String, dynamic>),
      accent: _parseTonalPalette(json['accent'] as Map<String, dynamic>),
      warning: _parseTonalPalette(json['warning'] as Map<String, dynamic>),
      error: _parseTonalPalette(json['error'] as Map<String, dynamic>),
      success: _parseTonalPalette(
        (json['success'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
      neutral: _parseTonalPalette(
        (json['neutral'] ?? json['primary']) as Map<String, dynamic>,
      ),
      neutralVariant: _parseTonalPalette(
        (json['neutralVariant'] ?? json['primary']) as Map<String, dynamic>,
      ),
    );
  }

  static Map<int, Color> _parseTonalPalette(Map<String, dynamic> json) {
    final Map<int, Color> palette = {};
    json.forEach((key, value) {
      final tone = int.tryParse(key);
      if (tone != null) {
        final toneData = value as Map<String, dynamic>;
        palette[tone] = _parseHex(toneData['value'] as String);
      }
    });
    return palette;
  }

  final Map<int, Color> primary;
  final Map<int, Color> secondary;
  final Map<int, Color> accent;
  final Map<int, Color> warning;
  final Map<int, Color> error;
  final Map<int, Color> success;
  final Map<int, Color> neutral;
  final Map<int, Color> neutralVariant;
}

class TypographyTokens {
  TypographyTokens({
    required this.primaryFamily,
    required this.headerFamily,
    required this.tertiaryFamily,
  });

  factory TypographyTokens.fromJson(Map<String, dynamic> json) {
    final family = json['family'] as Map<String, dynamic>;
    return TypographyTokens(
      primaryFamily: family['primary']['value'] as String,
      headerFamily: family['header']['value'] as String,
      tertiaryFamily:
          (family['tertiary'] ?? family['primary'])['value'] as String,
    );
  }

  final String primaryFamily;
  final String headerFamily;
  final String tertiaryFamily;
}

class MotionTokens {
  MotionTokens({required this.short, required this.medium, required this.long});

  factory MotionTokens.fromJson(Map<String, dynamic> json) {
    final duration = json['duration'] as Map<String, dynamic>;
    return MotionTokens(
      short: duration['short']['value'] as int,
      medium: duration['medium']['value'] as int,
      long: duration['long']['value'] as int,
    );
  }

  final int short;
  final int medium;
  final int long;
}

Color _parseHex(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) hex = 'FF$hex';
  return Color(int.parse(hex, radix: 16));
}
