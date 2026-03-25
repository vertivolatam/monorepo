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

abstract class HarvestPrediction implements _i1.SerializableModel {
  HarvestPrediction._({
    this.id,
    required this.greenhouseId,
    this.plantId,
    required this.cropSpecies,
    required this.predictedYieldKg,
    required this.yieldConfidence,
    required this.qualityGrade,
    required this.harvestWindowStart,
    required this.harvestWindowEnd,
    required this.daysToHarvest,
    required this.scenarioType,
    this.actualYieldKg,
    this.actualQualityGrade,
    this.actualHarvestDate,
    this.modelVersion,
    this.notes,
    required this.createdAt,
  });

  factory HarvestPrediction({
    int? id,
    required int greenhouseId,
    int? plantId,
    required String cropSpecies,
    required double predictedYieldKg,
    required double yieldConfidence,
    required String qualityGrade,
    required DateTime harvestWindowStart,
    required DateTime harvestWindowEnd,
    required int daysToHarvest,
    required String scenarioType,
    double? actualYieldKg,
    String? actualQualityGrade,
    DateTime? actualHarvestDate,
    String? modelVersion,
    String? notes,
    required DateTime createdAt,
  }) = _HarvestPredictionImpl;

  factory HarvestPrediction.fromJson(Map<String, dynamic> jsonSerialization) {
    return HarvestPrediction(
      id: jsonSerialization['id'] as int?,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      plantId: jsonSerialization['plantId'] as int?,
      cropSpecies: jsonSerialization['cropSpecies'] as String,
      predictedYieldKg: (jsonSerialization['predictedYieldKg'] as num)
          .toDouble(),
      yieldConfidence: (jsonSerialization['yieldConfidence'] as num).toDouble(),
      qualityGrade: jsonSerialization['qualityGrade'] as String,
      harvestWindowStart: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['harvestWindowStart'],
      ),
      harvestWindowEnd: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['harvestWindowEnd'],
      ),
      daysToHarvest: jsonSerialization['daysToHarvest'] as int,
      scenarioType: jsonSerialization['scenarioType'] as String,
      actualYieldKg: (jsonSerialization['actualYieldKg'] as num?)?.toDouble(),
      actualQualityGrade: jsonSerialization['actualQualityGrade'] as String?,
      actualHarvestDate: jsonSerialization['actualHarvestDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['actualHarvestDate'],
            ),
      modelVersion: jsonSerialization['modelVersion'] as String?,
      notes: jsonSerialization['notes'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int greenhouseId;

  int? plantId;

  String cropSpecies;

  double predictedYieldKg;

  double yieldConfidence;

  String qualityGrade;

  DateTime harvestWindowStart;

  DateTime harvestWindowEnd;

  int daysToHarvest;

  String scenarioType;

  double? actualYieldKg;

  String? actualQualityGrade;

  DateTime? actualHarvestDate;

  String? modelVersion;

  String? notes;

  DateTime createdAt;

  /// Returns a shallow copy of this [HarvestPrediction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HarvestPrediction copyWith({
    int? id,
    int? greenhouseId,
    int? plantId,
    String? cropSpecies,
    double? predictedYieldKg,
    double? yieldConfidence,
    String? qualityGrade,
    DateTime? harvestWindowStart,
    DateTime? harvestWindowEnd,
    int? daysToHarvest,
    String? scenarioType,
    double? actualYieldKg,
    String? actualQualityGrade,
    DateTime? actualHarvestDate,
    String? modelVersion,
    String? notes,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HarvestPrediction',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      if (plantId != null) 'plantId': plantId,
      'cropSpecies': cropSpecies,
      'predictedYieldKg': predictedYieldKg,
      'yieldConfidence': yieldConfidence,
      'qualityGrade': qualityGrade,
      'harvestWindowStart': harvestWindowStart.toJson(),
      'harvestWindowEnd': harvestWindowEnd.toJson(),
      'daysToHarvest': daysToHarvest,
      'scenarioType': scenarioType,
      if (actualYieldKg != null) 'actualYieldKg': actualYieldKg,
      if (actualQualityGrade != null) 'actualQualityGrade': actualQualityGrade,
      if (actualHarvestDate != null)
        'actualHarvestDate': actualHarvestDate?.toJson(),
      if (modelVersion != null) 'modelVersion': modelVersion,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HarvestPredictionImpl extends HarvestPrediction {
  _HarvestPredictionImpl({
    int? id,
    required int greenhouseId,
    int? plantId,
    required String cropSpecies,
    required double predictedYieldKg,
    required double yieldConfidence,
    required String qualityGrade,
    required DateTime harvestWindowStart,
    required DateTime harvestWindowEnd,
    required int daysToHarvest,
    required String scenarioType,
    double? actualYieldKg,
    String? actualQualityGrade,
    DateTime? actualHarvestDate,
    String? modelVersion,
    String? notes,
    required DateTime createdAt,
  }) : super._(
         id: id,
         greenhouseId: greenhouseId,
         plantId: plantId,
         cropSpecies: cropSpecies,
         predictedYieldKg: predictedYieldKg,
         yieldConfidence: yieldConfidence,
         qualityGrade: qualityGrade,
         harvestWindowStart: harvestWindowStart,
         harvestWindowEnd: harvestWindowEnd,
         daysToHarvest: daysToHarvest,
         scenarioType: scenarioType,
         actualYieldKg: actualYieldKg,
         actualQualityGrade: actualQualityGrade,
         actualHarvestDate: actualHarvestDate,
         modelVersion: modelVersion,
         notes: notes,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [HarvestPrediction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HarvestPrediction copyWith({
    Object? id = _Undefined,
    int? greenhouseId,
    Object? plantId = _Undefined,
    String? cropSpecies,
    double? predictedYieldKg,
    double? yieldConfidence,
    String? qualityGrade,
    DateTime? harvestWindowStart,
    DateTime? harvestWindowEnd,
    int? daysToHarvest,
    String? scenarioType,
    Object? actualYieldKg = _Undefined,
    Object? actualQualityGrade = _Undefined,
    Object? actualHarvestDate = _Undefined,
    Object? modelVersion = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
  }) {
    return HarvestPrediction(
      id: id is int? ? id : this.id,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      plantId: plantId is int? ? plantId : this.plantId,
      cropSpecies: cropSpecies ?? this.cropSpecies,
      predictedYieldKg: predictedYieldKg ?? this.predictedYieldKg,
      yieldConfidence: yieldConfidence ?? this.yieldConfidence,
      qualityGrade: qualityGrade ?? this.qualityGrade,
      harvestWindowStart: harvestWindowStart ?? this.harvestWindowStart,
      harvestWindowEnd: harvestWindowEnd ?? this.harvestWindowEnd,
      daysToHarvest: daysToHarvest ?? this.daysToHarvest,
      scenarioType: scenarioType ?? this.scenarioType,
      actualYieldKg: actualYieldKg is double?
          ? actualYieldKg
          : this.actualYieldKg,
      actualQualityGrade: actualQualityGrade is String?
          ? actualQualityGrade
          : this.actualQualityGrade,
      actualHarvestDate: actualHarvestDate is DateTime?
          ? actualHarvestDate
          : this.actualHarvestDate,
      modelVersion: modelVersion is String? ? modelVersion : this.modelVersion,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
