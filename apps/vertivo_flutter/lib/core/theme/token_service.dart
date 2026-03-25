import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'design_token_model.dart';

class TokenService {
  TokenService._internal();

  static final TokenService _instance = TokenService._internal();
  static TokenService get instance => _instance;

  DesignTokenModel? _tokens;
  bool isExternal = false;

  DesignTokenModel get tokens {
    if (_tokens == null) {
      throw Exception(
        'TokenService must be initialized before accessing tokens',
      );
    }
    return _tokens!;
  }

  static Future<void> initialize() async {
    try {
      String response;
      try {
        // First try local path (standard for Vertivo app)
        response = await rootBundle.loadString(
          'assets/style_dictionary/tokens.json',
        );
        instance.isExternal = false;
      } catch (_) {
        // Fallback to package-prefixed path (needed for Widgetbook/external apps)
        response = await rootBundle.loadString(
          'packages/vertivo_flutter/assets/style_dictionary/tokens.json',
        );
        instance.isExternal = true;
      }

      final Map<String, dynamic> data =
          json.decode(response) as Map<String, dynamic>;
      instance._tokens = DesignTokenModel.fromJson(data);
    } catch (e) {
      debugPrint('Error loading design tokens: $e');
      rethrow;
    }
  }
}
