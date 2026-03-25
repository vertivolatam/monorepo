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

abstract class QualityPrediction implements _i1.SerializableModel {
  QualityPrediction._({
    this.id,
    required this.harvestPredictionId,
    this.plantId,
    required this.greenhouseId,
    this.vitaminAScore,
    this.vitaminCScore,
    this.vitaminKScore,
    this.ironScore,
    this.calciumScore,
    this.potassiumScore,
    required this.overallNutritionalScore,
    this.appearanceColorScore,
    this.appearanceSizeScore,
    this.appearanceUniformityScore,
    required this.overallAppearanceScore,
    this.shelfLifeDays,
    this.modelVersion,
    required this.createdAt,
  });

  factory QualityPrediction({
    int? id,
    required int harvestPredictionId,
    int? plantId,
    required int greenhouseId,
    double? vitaminAScore,
    double? vitaminCScore,
    double? vitaminKScore,
    double? ironScore,
    double? calciumScore,
    double? potassiumScore,
    required double overallNutritionalScore,
    double? appearanceColorScore,
    double? appearanceSizeScore,
    double? appearanceUniformityScore,
    required double overallAppearanceScore,
    int? shelfLifeDays,
    String? modelVersion,
    required DateTime createdAt,
  }) = _QualityPredictionImpl;

  factory QualityPrediction.fromJson(Map<String, dynamic> jsonSerialization) {
    return QualityPrediction(
      id: jsonSerialization['id'] as int?,
      harvestPredictionId: jsonSerialization['harvestPredictionId'] as int,
      plantId: jsonSerialization['plantId'] as int?,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      vitaminAScore: (jsonSerialization['vitaminAScore'] as num?)?.toDouble(),
      vitaminCScore: (jsonSerialization['vitaminCScore'] as num?)?.toDouble(),
      vitaminKScore: (jsonSerialization['vitaminKScore'] as num?)?.toDouble(),
      ironScore: (jsonSerialization['ironScore'] as num?)?.toDouble(),
      calciumScore: (jsonSerialization['calciumScore'] as num?)?.toDouble(),
      potassiumScore: (jsonSerialization['potassiumScore'] as num?)?.toDouble(),
      overallNutritionalScore:
          (jsonSerialization['overallNutritionalScore'] as num).toDouble(),
      appearanceColorScore: (jsonSerialization['appearanceColorScore'] as num?)
          ?.toDouble(),
      appearanceSizeScore: (jsonSerialization['appearanceSizeScore'] as num?)
          ?.toDouble(),
      appearanceUniformityScore:
          (jsonSerialization['appearanceUniformityScore'] as num?)?.toDouble(),
      overallAppearanceScore:
          (jsonSerialization['overallAppearanceScore'] as num).toDouble(),
      shelfLifeDays: jsonSerialization['shelfLifeDays'] as int?,
      modelVersion: jsonSerialization['modelVersion'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int harvestPredictionId;

  int? plantId;

  int greenhouseId;

  double? vitaminAScore;

  double? vitaminCScore;

  double? vitaminKScore;

  double? ironScore;

  double? calciumScore;

  double? potassiumScore;

  double overallNutritionalScore;

  double? appearanceColorScore;

  double? appearanceSizeScore;

  double? appearanceUniformityScore;

  double overallAppearanceScore;

  int? shelfLifeDays;

  String? modelVersion;

  DateTime createdAt;

  /// Returns a shallow copy of this [QualityPrediction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  QualityPrediction copyWith({
    int? id,
    int? harvestPredictionId,
    int? plantId,
    int? greenhouseId,
    double? vitaminAScore,
    double? vitaminCScore,
    double? vitaminKScore,
    double? ironScore,
    double? calciumScore,
    double? potassiumScore,
    double? overallNutritionalScore,
    double? appearanceColorScore,
    double? appearanceSizeScore,
    double? appearanceUniformityScore,
    double? overallAppearanceScore,
    int? shelfLifeDays,
    String? modelVersion,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QualityPrediction',
      if (id != null) 'id': id,
      'harvestPredictionId': harvestPredictionId,
      if (plantId != null) 'plantId': plantId,
      'greenhouseId': greenhouseId,
      if (vitaminAScore != null) 'vitaminAScore': vitaminAScore,
      if (vitaminCScore != null) 'vitaminCScore': vitaminCScore,
      if (vitaminKScore != null) 'vitaminKScore': vitaminKScore,
      if (ironScore != null) 'ironScore': ironScore,
      if (calciumScore != null) 'calciumScore': calciumScore,
      if (potassiumScore != null) 'potassiumScore': potassiumScore,
      'overallNutritionalScore': overallNutritionalScore,
      if (appearanceColorScore != null)
        'appearanceColorScore': appearanceColorScore,
      if (appearanceSizeScore != null)
        'appearanceSizeScore': appearanceSizeScore,
      if (appearanceUniformityScore != null)
        'appearanceUniformityScore': appearanceUniformityScore,
      'overallAppearanceScore': overallAppearanceScore,
      if (shelfLifeDays != null) 'shelfLifeDays': shelfLifeDays,
      if (modelVersion != null) 'modelVersion': modelVersion,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QualityPredictionImpl extends QualityPrediction {
  _QualityPredictionImpl({
    int? id,
    required int harvestPredictionId,
    int? plantId,
    required int greenhouseId,
    double? vitaminAScore,
    double? vitaminCScore,
    double? vitaminKScore,
    double? ironScore,
    double? calciumScore,
    double? potassiumScore,
    required double overallNutritionalScore,
    double? appearanceColorScore,
    double? appearanceSizeScore,
    double? appearanceUniformityScore,
    required double overallAppearanceScore,
    int? shelfLifeDays,
    String? modelVersion,
    required DateTime createdAt,
  }) : super._(
         id: id,
         harvestPredictionId: harvestPredictionId,
         plantId: plantId,
         greenhouseId: greenhouseId,
         vitaminAScore: vitaminAScore,
         vitaminCScore: vitaminCScore,
         vitaminKScore: vitaminKScore,
         ironScore: ironScore,
         calciumScore: calciumScore,
         potassiumScore: potassiumScore,
         overallNutritionalScore: overallNutritionalScore,
         appearanceColorScore: appearanceColorScore,
         appearanceSizeScore: appearanceSizeScore,
         appearanceUniformityScore: appearanceUniformityScore,
         overallAppearanceScore: overallAppearanceScore,
         shelfLifeDays: shelfLifeDays,
         modelVersion: modelVersion,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [QualityPrediction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  QualityPrediction copyWith({
    Object? id = _Undefined,
    int? harvestPredictionId,
    Object? plantId = _Undefined,
    int? greenhouseId,
    Object? vitaminAScore = _Undefined,
    Object? vitaminCScore = _Undefined,
    Object? vitaminKScore = _Undefined,
    Object? ironScore = _Undefined,
    Object? calciumScore = _Undefined,
    Object? potassiumScore = _Undefined,
    double? overallNutritionalScore,
    Object? appearanceColorScore = _Undefined,
    Object? appearanceSizeScore = _Undefined,
    Object? appearanceUniformityScore = _Undefined,
    double? overallAppearanceScore,
    Object? shelfLifeDays = _Undefined,
    Object? modelVersion = _Undefined,
    DateTime? createdAt,
  }) {
    return QualityPrediction(
      id: id is int? ? id : this.id,
      harvestPredictionId: harvestPredictionId ?? this.harvestPredictionId,
      plantId: plantId is int? ? plantId : this.plantId,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      vitaminAScore: vitaminAScore is double?
          ? vitaminAScore
          : this.vitaminAScore,
      vitaminCScore: vitaminCScore is double?
          ? vitaminCScore
          : this.vitaminCScore,
      vitaminKScore: vitaminKScore is double?
          ? vitaminKScore
          : this.vitaminKScore,
      ironScore: ironScore is double? ? ironScore : this.ironScore,
      calciumScore: calciumScore is double? ? calciumScore : this.calciumScore,
      potassiumScore: potassiumScore is double?
          ? potassiumScore
          : this.potassiumScore,
      overallNutritionalScore:
          overallNutritionalScore ?? this.overallNutritionalScore,
      appearanceColorScore: appearanceColorScore is double?
          ? appearanceColorScore
          : this.appearanceColorScore,
      appearanceSizeScore: appearanceSizeScore is double?
          ? appearanceSizeScore
          : this.appearanceSizeScore,
      appearanceUniformityScore: appearanceUniformityScore is double?
          ? appearanceUniformityScore
          : this.appearanceUniformityScore,
      overallAppearanceScore:
          overallAppearanceScore ?? this.overallAppearanceScore,
      shelfLifeDays: shelfLifeDays is int? ? shelfLifeDays : this.shelfLifeDays,
      modelVersion: modelVersion is String? ? modelVersion : this.modelVersion,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
