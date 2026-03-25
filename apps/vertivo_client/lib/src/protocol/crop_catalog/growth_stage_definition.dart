/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:vertivo_client/src/protocol/protocol.dart' as _i2;

abstract class GrowthStageDefinition implements _i1.SerializableModel {
  GrowthStageDefinition._({
    this.id,
    required this.cropModelId,
    required this.stageName,
    required this.stageOrder,
    required this.durationDaysMin,
    required this.durationDaysMax,
    this.description,
    this.careInstructions,
    this.expectedHeightMinCm,
    this.expectedHeightMaxCm,
    this.expectedLeafCountMin,
    this.expectedLeafCountMax,
    this.temperatureMinOverride,
    this.temperatureMaxOverride,
    this.humidityMinOverride,
    this.humidityMaxOverride,
    this.lightHoursMinOverride,
    this.lightHoursMaxOverride,
    this.wateringFrequencyDays,
    this.fertilizerType,
    this.keyIndicators,
    required this.createdAt,
  });

  factory GrowthStageDefinition({
    int? id,
    required int cropModelId,
    required String stageName,
    required int stageOrder,
    required int durationDaysMin,
    required int durationDaysMax,
    String? description,
    String? careInstructions,
    double? expectedHeightMinCm,
    double? expectedHeightMaxCm,
    int? expectedLeafCountMin,
    int? expectedLeafCountMax,
    double? temperatureMinOverride,
    double? temperatureMaxOverride,
    double? humidityMinOverride,
    double? humidityMaxOverride,
    double? lightHoursMinOverride,
    double? lightHoursMaxOverride,
    int? wateringFrequencyDays,
    String? fertilizerType,
    List<String>? keyIndicators,
    required DateTime createdAt,
  }) = _GrowthStageDefinitionImpl;

  factory GrowthStageDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return GrowthStageDefinition(
      id: jsonSerialization['id'] as int?,
      cropModelId: jsonSerialization['cropModelId'] as int,
      stageName: jsonSerialization['stageName'] as String,
      stageOrder: jsonSerialization['stageOrder'] as int,
      durationDaysMin: jsonSerialization['durationDaysMin'] as int,
      durationDaysMax: jsonSerialization['durationDaysMax'] as int,
      description: jsonSerialization['description'] as String?,
      careInstructions: jsonSerialization['careInstructions'] as String?,
      expectedHeightMinCm: (jsonSerialization['expectedHeightMinCm'] as num?)
          ?.toDouble(),
      expectedHeightMaxCm: (jsonSerialization['expectedHeightMaxCm'] as num?)
          ?.toDouble(),
      expectedLeafCountMin: jsonSerialization['expectedLeafCountMin'] as int?,
      expectedLeafCountMax: jsonSerialization['expectedLeafCountMax'] as int?,
      temperatureMinOverride:
          (jsonSerialization['temperatureMinOverride'] as num?)?.toDouble(),
      temperatureMaxOverride:
          (jsonSerialization['temperatureMaxOverride'] as num?)?.toDouble(),
      humidityMinOverride: (jsonSerialization['humidityMinOverride'] as num?)
          ?.toDouble(),
      humidityMaxOverride: (jsonSerialization['humidityMaxOverride'] as num?)
          ?.toDouble(),
      lightHoursMinOverride:
          (jsonSerialization['lightHoursMinOverride'] as num?)?.toDouble(),
      lightHoursMaxOverride:
          (jsonSerialization['lightHoursMaxOverride'] as num?)?.toDouble(),
      wateringFrequencyDays: jsonSerialization['wateringFrequencyDays'] as int?,
      fertilizerType: jsonSerialization['fertilizerType'] as String?,
      keyIndicators: jsonSerialization['keyIndicators'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['keyIndicators'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int cropModelId;

  String stageName;

  int stageOrder;

  int durationDaysMin;

  int durationDaysMax;

  String? description;

  String? careInstructions;

  double? expectedHeightMinCm;

  double? expectedHeightMaxCm;

  int? expectedLeafCountMin;

  int? expectedLeafCountMax;

  double? temperatureMinOverride;

  double? temperatureMaxOverride;

  double? humidityMinOverride;

  double? humidityMaxOverride;

  double? lightHoursMinOverride;

  double? lightHoursMaxOverride;

  int? wateringFrequencyDays;

  String? fertilizerType;

  List<String>? keyIndicators;

  DateTime createdAt;

  /// Returns a shallow copy of this [GrowthStageDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GrowthStageDefinition copyWith({
    int? id,
    int? cropModelId,
    String? stageName,
    int? stageOrder,
    int? durationDaysMin,
    int? durationDaysMax,
    String? description,
    String? careInstructions,
    double? expectedHeightMinCm,
    double? expectedHeightMaxCm,
    int? expectedLeafCountMin,
    int? expectedLeafCountMax,
    double? temperatureMinOverride,
    double? temperatureMaxOverride,
    double? humidityMinOverride,
    double? humidityMaxOverride,
    double? lightHoursMinOverride,
    double? lightHoursMaxOverride,
    int? wateringFrequencyDays,
    String? fertilizerType,
    List<String>? keyIndicators,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GrowthStageDefinition',
      if (id != null) 'id': id,
      'cropModelId': cropModelId,
      'stageName': stageName,
      'stageOrder': stageOrder,
      'durationDaysMin': durationDaysMin,
      'durationDaysMax': durationDaysMax,
      if (description != null) 'description': description,
      if (careInstructions != null) 'careInstructions': careInstructions,
      if (expectedHeightMinCm != null)
        'expectedHeightMinCm': expectedHeightMinCm,
      if (expectedHeightMaxCm != null)
        'expectedHeightMaxCm': expectedHeightMaxCm,
      if (expectedLeafCountMin != null)
        'expectedLeafCountMin': expectedLeafCountMin,
      if (expectedLeafCountMax != null)
        'expectedLeafCountMax': expectedLeafCountMax,
      if (temperatureMinOverride != null)
        'temperatureMinOverride': temperatureMinOverride,
      if (temperatureMaxOverride != null)
        'temperatureMaxOverride': temperatureMaxOverride,
      if (humidityMinOverride != null)
        'humidityMinOverride': humidityMinOverride,
      if (humidityMaxOverride != null)
        'humidityMaxOverride': humidityMaxOverride,
      if (lightHoursMinOverride != null)
        'lightHoursMinOverride': lightHoursMinOverride,
      if (lightHoursMaxOverride != null)
        'lightHoursMaxOverride': lightHoursMaxOverride,
      if (wateringFrequencyDays != null)
        'wateringFrequencyDays': wateringFrequencyDays,
      if (fertilizerType != null) 'fertilizerType': fertilizerType,
      if (keyIndicators != null) 'keyIndicators': keyIndicators?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GrowthStageDefinitionImpl extends GrowthStageDefinition {
  _GrowthStageDefinitionImpl({
    int? id,
    required int cropModelId,
    required String stageName,
    required int stageOrder,
    required int durationDaysMin,
    required int durationDaysMax,
    String? description,
    String? careInstructions,
    double? expectedHeightMinCm,
    double? expectedHeightMaxCm,
    int? expectedLeafCountMin,
    int? expectedLeafCountMax,
    double? temperatureMinOverride,
    double? temperatureMaxOverride,
    double? humidityMinOverride,
    double? humidityMaxOverride,
    double? lightHoursMinOverride,
    double? lightHoursMaxOverride,
    int? wateringFrequencyDays,
    String? fertilizerType,
    List<String>? keyIndicators,
    required DateTime createdAt,
  }) : super._(
         id: id,
         cropModelId: cropModelId,
         stageName: stageName,
         stageOrder: stageOrder,
         durationDaysMin: durationDaysMin,
         durationDaysMax: durationDaysMax,
         description: description,
         careInstructions: careInstructions,
         expectedHeightMinCm: expectedHeightMinCm,
         expectedHeightMaxCm: expectedHeightMaxCm,
         expectedLeafCountMin: expectedLeafCountMin,
         expectedLeafCountMax: expectedLeafCountMax,
         temperatureMinOverride: temperatureMinOverride,
         temperatureMaxOverride: temperatureMaxOverride,
         humidityMinOverride: humidityMinOverride,
         humidityMaxOverride: humidityMaxOverride,
         lightHoursMinOverride: lightHoursMinOverride,
         lightHoursMaxOverride: lightHoursMaxOverride,
         wateringFrequencyDays: wateringFrequencyDays,
         fertilizerType: fertilizerType,
         keyIndicators: keyIndicators,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [GrowthStageDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GrowthStageDefinition copyWith({
    Object? id = _Undefined,
    int? cropModelId,
    String? stageName,
    int? stageOrder,
    int? durationDaysMin,
    int? durationDaysMax,
    Object? description = _Undefined,
    Object? careInstructions = _Undefined,
    Object? expectedHeightMinCm = _Undefined,
    Object? expectedHeightMaxCm = _Undefined,
    Object? expectedLeafCountMin = _Undefined,
    Object? expectedLeafCountMax = _Undefined,
    Object? temperatureMinOverride = _Undefined,
    Object? temperatureMaxOverride = _Undefined,
    Object? humidityMinOverride = _Undefined,
    Object? humidityMaxOverride = _Undefined,
    Object? lightHoursMinOverride = _Undefined,
    Object? lightHoursMaxOverride = _Undefined,
    Object? wateringFrequencyDays = _Undefined,
    Object? fertilizerType = _Undefined,
    Object? keyIndicators = _Undefined,
    DateTime? createdAt,
  }) {
    return GrowthStageDefinition(
      id: id is int? ? id : this.id,
      cropModelId: cropModelId ?? this.cropModelId,
      stageName: stageName ?? this.stageName,
      stageOrder: stageOrder ?? this.stageOrder,
      durationDaysMin: durationDaysMin ?? this.durationDaysMin,
      durationDaysMax: durationDaysMax ?? this.durationDaysMax,
      description: description is String? ? description : this.description,
      careInstructions: careInstructions is String?
          ? careInstructions
          : this.careInstructions,
      expectedHeightMinCm: expectedHeightMinCm is double?
          ? expectedHeightMinCm
          : this.expectedHeightMinCm,
      expectedHeightMaxCm: expectedHeightMaxCm is double?
          ? expectedHeightMaxCm
          : this.expectedHeightMaxCm,
      expectedLeafCountMin: expectedLeafCountMin is int?
          ? expectedLeafCountMin
          : this.expectedLeafCountMin,
      expectedLeafCountMax: expectedLeafCountMax is int?
          ? expectedLeafCountMax
          : this.expectedLeafCountMax,
      temperatureMinOverride: temperatureMinOverride is double?
          ? temperatureMinOverride
          : this.temperatureMinOverride,
      temperatureMaxOverride: temperatureMaxOverride is double?
          ? temperatureMaxOverride
          : this.temperatureMaxOverride,
      humidityMinOverride: humidityMinOverride is double?
          ? humidityMinOverride
          : this.humidityMinOverride,
      humidityMaxOverride: humidityMaxOverride is double?
          ? humidityMaxOverride
          : this.humidityMaxOverride,
      lightHoursMinOverride: lightHoursMinOverride is double?
          ? lightHoursMinOverride
          : this.lightHoursMinOverride,
      lightHoursMaxOverride: lightHoursMaxOverride is double?
          ? lightHoursMaxOverride
          : this.lightHoursMaxOverride,
      wateringFrequencyDays: wateringFrequencyDays is int?
          ? wateringFrequencyDays
          : this.wateringFrequencyDays,
      fertilizerType: fertilizerType is String?
          ? fertilizerType
          : this.fertilizerType,
      keyIndicators: keyIndicators is List<String>?
          ? keyIndicators
          : this.keyIndicators?.map((e0) => e0).toList(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
