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

      final model = _mapCrop(crop, profile, now);
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
  /// `difficulty`, `waterRequirement`, `category`, `segments`. The EC and the
  /// nutrient recipe from the profile have **no home** on [CropModel] and are
  /// intentionally dropped here — see the seed report / follow-up issue.
  static CropModel _mapCrop(
    Map<String, dynamic> crop,
    Map<String, dynamic> profile,
    DateTime now,
  ) {
    final ph = (profile['ph'] as Map<String, dynamic>?) ?? const {};
    final temp = _dayRange(profile['ambient_temp_c']);
    final humidity = _dayRange(profile['relative_humidity_pct']);
    final photoperiod = _asDouble(profile['photoperiod_h']);

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
      waterRequirement: 'high', // aeroponic / nebuponía
      growthDurationDays: 0, // unknown in crops.json v1 — see follow-up
      difficulty: 'beginner',
      segments: const ['residential', 'commercial'],
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Crude category inference from botanical family. crops.json v1 has no
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

  static double? _asDouble(Object? value) {
    if (value is num) return value.toDouble();
    return null;
  }
}
