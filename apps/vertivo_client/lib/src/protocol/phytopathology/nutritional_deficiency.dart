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

abstract class NutritionalDeficiency implements _i1.SerializableModel {
  NutritionalDeficiency._({
    this.id,
    required this.plantId,
    required this.greenhouseId,
    required this.nutrient,
    required this.severity,
    this.symptoms,
    required this.confidence,
    this.recommendedAction,
    required this.isResolved,
    this.resolvedAt,
    required this.detectedAt,
    required this.createdAt,
  });

  factory NutritionalDeficiency({
    int? id,
    required int plantId,
    required int greenhouseId,
    required String nutrient,
    required String severity,
    List<String>? symptoms,
    required double confidence,
    String? recommendedAction,
    required bool isResolved,
    DateTime? resolvedAt,
    required DateTime detectedAt,
    required DateTime createdAt,
  }) = _NutritionalDeficiencyImpl;

  factory NutritionalDeficiency.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NutritionalDeficiency(
      id: jsonSerialization['id'] as int?,
      plantId: jsonSerialization['plantId'] as int,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      nutrient: jsonSerialization['nutrient'] as String,
      severity: jsonSerialization['severity'] as String,
      symptoms: jsonSerialization['symptoms'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['symptoms'],
            ),
      confidence: (jsonSerialization['confidence'] as num).toDouble(),
      recommendedAction: jsonSerialization['recommendedAction'] as String?,
      isResolved: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isResolved'],
      ),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
      detectedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['detectedAt'],
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

  int plantId;

  int greenhouseId;

  String nutrient;

  String severity;

  List<String>? symptoms;

  double confidence;

  String? recommendedAction;

  bool isResolved;

  DateTime? resolvedAt;

  DateTime detectedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [NutritionalDeficiency]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NutritionalDeficiency copyWith({
    int? id,
    int? plantId,
    int? greenhouseId,
    String? nutrient,
    String? severity,
    List<String>? symptoms,
    double? confidence,
    String? recommendedAction,
    bool? isResolved,
    DateTime? resolvedAt,
    DateTime? detectedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NutritionalDeficiency',
      if (id != null) 'id': id,
      'plantId': plantId,
      'greenhouseId': greenhouseId,
      'nutrient': nutrient,
      'severity': severity,
      if (symptoms != null) 'symptoms': symptoms?.toJson(),
      'confidence': confidence,
      if (recommendedAction != null) 'recommendedAction': recommendedAction,
      'isResolved': isResolved,
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      'detectedAt': detectedAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NutritionalDeficiencyImpl extends NutritionalDeficiency {
  _NutritionalDeficiencyImpl({
    int? id,
    required int plantId,
    required int greenhouseId,
    required String nutrient,
    required String severity,
    List<String>? symptoms,
    required double confidence,
    String? recommendedAction,
    required bool isResolved,
    DateTime? resolvedAt,
    required DateTime detectedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         plantId: plantId,
         greenhouseId: greenhouseId,
         nutrient: nutrient,
         severity: severity,
         symptoms: symptoms,
         confidence: confidence,
         recommendedAction: recommendedAction,
         isResolved: isResolved,
         resolvedAt: resolvedAt,
         detectedAt: detectedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NutritionalDeficiency]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NutritionalDeficiency copyWith({
    Object? id = _Undefined,
    int? plantId,
    int? greenhouseId,
    String? nutrient,
    String? severity,
    Object? symptoms = _Undefined,
    double? confidence,
    Object? recommendedAction = _Undefined,
    bool? isResolved,
    Object? resolvedAt = _Undefined,
    DateTime? detectedAt,
    DateTime? createdAt,
  }) {
    return NutritionalDeficiency(
      id: id is int? ? id : this.id,
      plantId: plantId ?? this.plantId,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      nutrient: nutrient ?? this.nutrient,
      severity: severity ?? this.severity,
      symptoms: symptoms is List<String>?
          ? symptoms
          : this.symptoms?.map((e0) => e0).toList(),
      confidence: confidence ?? this.confidence,
      recommendedAction: recommendedAction is String?
          ? recommendedAction
          : this.recommendedAction,
      isResolved: isResolved ?? this.isResolved,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
      detectedAt: detectedAt ?? this.detectedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
