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

abstract class TreatmentRecommendation implements _i1.SerializableModel {
  TreatmentRecommendation._({
    this.id,
    this.diseaseDetectionId,
    this.pestIdentificationId,
    required this.plantId,
    required this.treatmentType,
    required this.description,
    this.ingredients,
    this.applicationMethod,
    this.frequencyDays,
    this.durationDays,
    this.estimatedCost,
    required this.segmentTarget,
    required this.priority,
    required this.isApplied,
    this.appliedAt,
    this.effectivenessScore,
    required this.createdAt,
  });

  factory TreatmentRecommendation({
    int? id,
    int? diseaseDetectionId,
    int? pestIdentificationId,
    required int plantId,
    required String treatmentType,
    required String description,
    List<String>? ingredients,
    String? applicationMethod,
    int? frequencyDays,
    int? durationDays,
    double? estimatedCost,
    required String segmentTarget,
    required String priority,
    required bool isApplied,
    DateTime? appliedAt,
    double? effectivenessScore,
    required DateTime createdAt,
  }) = _TreatmentRecommendationImpl;

  factory TreatmentRecommendation.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TreatmentRecommendation(
      id: jsonSerialization['id'] as int?,
      diseaseDetectionId: jsonSerialization['diseaseDetectionId'] as int?,
      pestIdentificationId: jsonSerialization['pestIdentificationId'] as int?,
      plantId: jsonSerialization['plantId'] as int,
      treatmentType: jsonSerialization['treatmentType'] as String,
      description: jsonSerialization['description'] as String,
      ingredients: jsonSerialization['ingredients'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['ingredients'],
            ),
      applicationMethod: jsonSerialization['applicationMethod'] as String?,
      frequencyDays: jsonSerialization['frequencyDays'] as int?,
      durationDays: jsonSerialization['durationDays'] as int?,
      estimatedCost: (jsonSerialization['estimatedCost'] as num?)?.toDouble(),
      segmentTarget: jsonSerialization['segmentTarget'] as String,
      priority: jsonSerialization['priority'] as String,
      isApplied: _i1.BoolJsonExtension.fromJson(jsonSerialization['isApplied']),
      appliedAt: jsonSerialization['appliedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['appliedAt']),
      effectivenessScore: (jsonSerialization['effectivenessScore'] as num?)
          ?.toDouble(),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? diseaseDetectionId;

  int? pestIdentificationId;

  int plantId;

  String treatmentType;

  String description;

  List<String>? ingredients;

  String? applicationMethod;

  int? frequencyDays;

  int? durationDays;

  double? estimatedCost;

  String segmentTarget;

  String priority;

  bool isApplied;

  DateTime? appliedAt;

  double? effectivenessScore;

  DateTime createdAt;

  /// Returns a shallow copy of this [TreatmentRecommendation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TreatmentRecommendation copyWith({
    int? id,
    int? diseaseDetectionId,
    int? pestIdentificationId,
    int? plantId,
    String? treatmentType,
    String? description,
    List<String>? ingredients,
    String? applicationMethod,
    int? frequencyDays,
    int? durationDays,
    double? estimatedCost,
    String? segmentTarget,
    String? priority,
    bool? isApplied,
    DateTime? appliedAt,
    double? effectivenessScore,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TreatmentRecommendation',
      if (id != null) 'id': id,
      if (diseaseDetectionId != null) 'diseaseDetectionId': diseaseDetectionId,
      if (pestIdentificationId != null)
        'pestIdentificationId': pestIdentificationId,
      'plantId': plantId,
      'treatmentType': treatmentType,
      'description': description,
      if (ingredients != null) 'ingredients': ingredients?.toJson(),
      if (applicationMethod != null) 'applicationMethod': applicationMethod,
      if (frequencyDays != null) 'frequencyDays': frequencyDays,
      if (durationDays != null) 'durationDays': durationDays,
      if (estimatedCost != null) 'estimatedCost': estimatedCost,
      'segmentTarget': segmentTarget,
      'priority': priority,
      'isApplied': isApplied,
      if (appliedAt != null) 'appliedAt': appliedAt?.toJson(),
      if (effectivenessScore != null) 'effectivenessScore': effectivenessScore,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TreatmentRecommendationImpl extends TreatmentRecommendation {
  _TreatmentRecommendationImpl({
    int? id,
    int? diseaseDetectionId,
    int? pestIdentificationId,
    required int plantId,
    required String treatmentType,
    required String description,
    List<String>? ingredients,
    String? applicationMethod,
    int? frequencyDays,
    int? durationDays,
    double? estimatedCost,
    required String segmentTarget,
    required String priority,
    required bool isApplied,
    DateTime? appliedAt,
    double? effectivenessScore,
    required DateTime createdAt,
  }) : super._(
         id: id,
         diseaseDetectionId: diseaseDetectionId,
         pestIdentificationId: pestIdentificationId,
         plantId: plantId,
         treatmentType: treatmentType,
         description: description,
         ingredients: ingredients,
         applicationMethod: applicationMethod,
         frequencyDays: frequencyDays,
         durationDays: durationDays,
         estimatedCost: estimatedCost,
         segmentTarget: segmentTarget,
         priority: priority,
         isApplied: isApplied,
         appliedAt: appliedAt,
         effectivenessScore: effectivenessScore,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TreatmentRecommendation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TreatmentRecommendation copyWith({
    Object? id = _Undefined,
    Object? diseaseDetectionId = _Undefined,
    Object? pestIdentificationId = _Undefined,
    int? plantId,
    String? treatmentType,
    String? description,
    Object? ingredients = _Undefined,
    Object? applicationMethod = _Undefined,
    Object? frequencyDays = _Undefined,
    Object? durationDays = _Undefined,
    Object? estimatedCost = _Undefined,
    String? segmentTarget,
    String? priority,
    bool? isApplied,
    Object? appliedAt = _Undefined,
    Object? effectivenessScore = _Undefined,
    DateTime? createdAt,
  }) {
    return TreatmentRecommendation(
      id: id is int? ? id : this.id,
      diseaseDetectionId: diseaseDetectionId is int?
          ? diseaseDetectionId
          : this.diseaseDetectionId,
      pestIdentificationId: pestIdentificationId is int?
          ? pestIdentificationId
          : this.pestIdentificationId,
      plantId: plantId ?? this.plantId,
      treatmentType: treatmentType ?? this.treatmentType,
      description: description ?? this.description,
      ingredients: ingredients is List<String>?
          ? ingredients
          : this.ingredients?.map((e0) => e0).toList(),
      applicationMethod: applicationMethod is String?
          ? applicationMethod
          : this.applicationMethod,
      frequencyDays: frequencyDays is int? ? frequencyDays : this.frequencyDays,
      durationDays: durationDays is int? ? durationDays : this.durationDays,
      estimatedCost: estimatedCost is double?
          ? estimatedCost
          : this.estimatedCost,
      segmentTarget: segmentTarget ?? this.segmentTarget,
      priority: priority ?? this.priority,
      isApplied: isApplied ?? this.isApplied,
      appliedAt: appliedAt is DateTime? ? appliedAt : this.appliedAt,
      effectivenessScore: effectivenessScore is double?
          ? effectivenessScore
          : this.effectivenessScore,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
