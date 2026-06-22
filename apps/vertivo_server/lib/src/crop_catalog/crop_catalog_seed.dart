// Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
// Cédula Jurídica 3-102-815230
// San Francisco, Heredia, Heredia, Republic of Costa Rica
// All Rights Reserved.
//
// This file is part of the Licensed Work under the Business Source License (BSL).
// You may obtain a copy of the License at ./LICENSE.md
// You may not use this file except in compliance with the License.

import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Seeds the `crop_models` table from the canonical `config/crops.json`
/// artifact (VRTV-96).
///
/// `config/crops.json` is a synced copy of the canonical
/// `apps/raspberry/config/crops.json`. It keeps the agronomic setpoints
/// (pH / EC / temps / humidity / photoperiod / nutrient recipe) in *profiles*
/// referenced by each crop via its `profile` key; this seeder resolves that
/// indirection before mapping onto [CropModel].
///
/// The seed is **idempotent**: a crop is matched by its `species` (the latin
/// binomial) and skipped if already present, so it is safe to run on every
/// boot.
class CropCatalogSeeder {
  static const String defaultPath = 'config/crops.json';

  /// Reads [path], resolves each crop's profile, and inserts any crops that
  /// are not yet present. Returns the number of crops inserted.
  static Future<int> seed(
    Session session, {
    String path = defaultPath,
  }) async {
    final file = File(Uri(path: path).toFilePath());
    if (!file.existsSync()) {
      session.log(
        '[CropCatalogSeeder] crops.json not found at $path; skipping seed.',
        level: LogLevel.warning,
      );
      return 0;
    }

    final data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    final profiles = (data['profiles'] as Map<String, dynamic>? ?? {});
    final crops = (data['crops'] as List<dynamic>? ?? []);

    final now = DateTime.now();
    var inserted = 0;

    for (final raw in crops) {
      final crop = raw as Map<String, dynamic>;
      final species = crop['species'] as String?;
      final commonName = crop['name_es'] as String?;
      if (species == null || commonName == null) {
        session.log(
          '[CropCatalogSeeder] skipping crop without species/name_es: $crop',
          level: LogLevel.warning,
        );
        continue;
      }

      // Idempotency: skip if a crop with this latin binomial already exists.
      final existing = await CropModel.db.findFirstRow(
        session,
        where: (t) => t.species.equals(species),
      );
      if (existing != null) {
        continue;
      }

      final profileName = crop['profile'] as String?;
      final profile =
          (profiles[profileName] as Map<String, dynamic>?) ?? const {};
      // Only record the profile key when it actually resolved to a profile;
      // crops with `profile: null` (non-aeroponic) keep profileKey null.
      final profileKey = profile.isEmpty ? null : profileName;

      final model = _mapCrop(crop, profile, profileKey, now);
      await CropModel.db.insertRow(session, model);
      inserted++;
    }

    session.log('[CropCatalogSeeder] inserted $inserted crop(s).');
    return inserted;
  }

  /// Maps a crops.json crop entry + its resolved profile onto a [CropModel].
  ///
  /// Fields the model supports but crops.json does not yet carry are filled
  /// with documented defaults (see VRTV-96 follow-up): `growthDurationDays`,
  /// `difficulty`, `waterRequirement`, `category`, `segments`.
  ///
  /// The full agronomic setpoints from the resolved profile (pH ideal, EC in
  /// dS/m, night temperatures, ORP, PPFD, photoperiod, light spectrum) and the
  /// nutrient recipe (serialized as a JSON string in `nutrientRecipeJson`) are
  /// now persisted on [CropModel]. Crops with no aeroponic profile
  /// (`profile: null`) leave every one of those new fields `null` — no defaults
  /// are invented.
  static CropModel _mapCrop(
    Map<String, dynamic> crop,
    Map<String, dynamic> profile,
    String? profileKey,
    DateTime now,
  ) {
    final ph = (profile['ph'] as Map<String, dynamic>?) ?? const {};
    final ec = (profile['ec_dS_m'] as Map<String, dynamic>?) ?? const {};
    final orp = (profile['orp_mv'] as Map<String, dynamic>?) ?? const {};
    final ppfd =
        (profile['ppfd_umol_m2_s'] as Map<String, dynamic>?) ?? const {};
    final temp = _dayRange(profile['ambient_temp_c']);
    final nightTemp = _nightRange(profile['ambient_temp_c']);
    final humidity = _dayRange(profile['relative_humidity_pct']);
    final photoperiod = _photoperiodHours(profile['photoperiod_h']);
    final spectrum = _wrappedValue(profile['light_spectrum']);
    final recipeJson = _recipeJson(profile['nutrient_recipe_g_per_1000ml']);

    return CropModel(
      species: crop['species'] as String,
      commonName: crop['name_es'] as String,
      scientificName: crop['species'] as String?,
      family: crop['family'] as String?,
      category: _categoryFor(crop),
      idealTemperatureMin: temp.$1 ?? 15.0,
      idealTemperatureMax: temp.$2 ?? 33.0,
      idealHumidityMin: humidity.$1 ?? 50.0,
      idealHumidityMax: humidity.$2 ?? 100.0,
      idealLightHoursMin: photoperiod ?? 12.0,
      idealLightHoursMax: photoperiod ?? 18.0,
      idealPhMin: _asDouble(ph['min']) ?? 6.0,
      idealPhMax: _asDouble(ph['max']) ?? 7.0,
      idealPhIdeal: _asDouble(ph['ideal']),
      idealEcMinDsM: _asDouble(ec['min']),
      idealEcMaxDsM: _asDouble(ec['max']),
      idealNightTemperatureMin: nightTemp.$1,
      idealNightTemperatureMax: nightTemp.$2,
      idealOrpMinMv: _asDouble(orp['min']),
      idealOrpMaxMv: _asDouble(orp['max']),
      ppfdMin: _asDouble(ppfd['min']),
      ppfdMax: _asDouble(ppfd['max']),
      photoperiodHours: photoperiod,
      lightSpectrum: spectrum,
      ediblePart: crop['edible_part'] as String?,
      priority: _asInt(crop['priority']),
      aeroponicSuitable: crop['aeroponic'] as bool?,
      profileKey: profileKey,
      nutrientRecipeJson: recipeJson,
      waterRequirement: 'high', // aeroponic / nebuponía
      growthDurationDays: 0, // unknown in crops.json v2 — see follow-up VRTV-97
      difficulty: 'beginner',
      segments: const ['residential', 'commercial'],
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Crude category inference from botanical family. crops.json v2 has no
  /// explicit category; aromatic families map to `herb`, the rest to
  /// `vegetable`.
  static String _categoryFor(Map<String, dynamic> crop) {
    const herbFamilies = {'Lamiaceae', 'Apiaceae'};
    final family = crop['family'] as String?;
    if (family != null && herbFamilies.contains(family)) {
      return 'herb';
    }
    return 'vegetable';
  }

  /// Extracts a (min, max) tuple from a profile field shaped like
  /// `{ "day": { "min": .., "max": .. }, "night": {...} }`, preferring `day`.
  static (double?, double?) _dayRange(Object? field) {
    if (field is! Map<String, dynamic>) return (null, null);
    final day = field['day'];
    if (day is! Map<String, dynamic>) return (null, null);
    return (_asDouble(day['min']), _asDouble(day['max']));
  }

  /// Extracts a (min, max) tuple from the `night` sub-range of a field shaped
  /// like `{ "day": {...}, "night": { "min": .., "max": .. } }`.
  static (double?, double?) _nightRange(Object? field) {
    if (field is! Map<String, dynamic>) return (null, null);
    final night = field['night'];
    if (night is! Map<String, dynamic>) return (null, null);
    return (_asDouble(night['min']), _asDouble(night['max']));
  }

  /// Extracts the photoperiod in hours from the v2 `photoperiod_h` field.
  ///
  /// In crops.json v2 it is wrapped as `{ "value": 18, "source": "sheet" }`
  /// (it was a flat int in v1). Accepts both shapes for resilience.
  static double? _photoperiodHours(Object? field) {
    if (field is num) return field.toDouble();
    if (field is Map<String, dynamic>) return _asDouble(field['value']);
    return null;
  }

  /// Unwraps a v2 provenance-wrapped string field shaped like
  /// `{ "value": "FSMUV", "source": "sheet" }`, tolerating a bare string.
  static String? _wrappedValue(Object? field) {
    if (field is String) return field;
    if (field is Map<String, dynamic>) {
      final value = field['value'];
      return value is String ? value : null;
    }
    return null;
  }

  /// Serializes the profile's `nutrient_recipe_g_per_1000ml` map to a JSON
  /// string for storage in `nutrientRecipeJson`. Drops the `source` provenance
  /// key (metadata, not part of the recipe). Returns null when absent.
  static String? _recipeJson(Object? field) {
    if (field is! Map<String, dynamic>) return null;
    final recipe = Map<String, dynamic>.of(field)..remove('source');
    if (recipe.isEmpty) return null;
    return jsonEncode(recipe);
  }

  static double? _asDouble(Object? value) {
    if (value is num) return value.toDouble();
    return null;
  }

  static int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return null;
  }
}
