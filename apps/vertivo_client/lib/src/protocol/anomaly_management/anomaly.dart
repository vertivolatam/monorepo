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

abstract class Anomaly implements _i1.SerializableModel {
  Anomaly._({
    this.id,
    required this.greenhouseId,
    this.plantId,
    this.trayId,
    required this.anomalyType,
    required this.severity,
    required this.detectionMethod,
    this.measurementType,
    this.expectedValue,
    this.actualValue,
    this.deviationPercent,
    required this.description,
    required this.isResolved,
    this.resolvedAt,
    this.resolvedBy,
    this.resolutionNotes,
    this.sourceEntityType,
    this.sourceEntityId,
    required this.createdAt,
  });

  factory Anomaly({
    int? id,
    required int greenhouseId,
    int? plantId,
    int? trayId,
    required String anomalyType,
    required String severity,
    required String detectionMethod,
    String? measurementType,
    double? expectedValue,
    double? actualValue,
    double? deviationPercent,
    required String description,
    required bool isResolved,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNotes,
    String? sourceEntityType,
    int? sourceEntityId,
    required DateTime createdAt,
  }) = _AnomalyImpl;

  factory Anomaly.fromJson(Map<String, dynamic> jsonSerialization) {
    return Anomaly(
      id: jsonSerialization['id'] as int?,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      plantId: jsonSerialization['plantId'] as int?,
      trayId: jsonSerialization['trayId'] as int?,
      anomalyType: jsonSerialization['anomalyType'] as String,
      severity: jsonSerialization['severity'] as String,
      detectionMethod: jsonSerialization['detectionMethod'] as String,
      measurementType: jsonSerialization['measurementType'] as String?,
      expectedValue: (jsonSerialization['expectedValue'] as num?)?.toDouble(),
      actualValue: (jsonSerialization['actualValue'] as num?)?.toDouble(),
      deviationPercent: (jsonSerialization['deviationPercent'] as num?)
          ?.toDouble(),
      description: jsonSerialization['description'] as String,
      isResolved: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isResolved'],
      ),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
      resolvedBy: jsonSerialization['resolvedBy'] as String?,
      resolutionNotes: jsonSerialization['resolutionNotes'] as String?,
      sourceEntityType: jsonSerialization['sourceEntityType'] as String?,
      sourceEntityId: jsonSerialization['sourceEntityId'] as int?,
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

  int? trayId;

  String anomalyType;

  String severity;

  String detectionMethod;

  String? measurementType;

  double? expectedValue;

  double? actualValue;

  double? deviationPercent;

  String description;

  bool isResolved;

  DateTime? resolvedAt;

  String? resolvedBy;

  String? resolutionNotes;

  String? sourceEntityType;

  int? sourceEntityId;

  DateTime createdAt;

  /// Returns a shallow copy of this [Anomaly]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Anomaly copyWith({
    int? id,
    int? greenhouseId,
    int? plantId,
    int? trayId,
    String? anomalyType,
    String? severity,
    String? detectionMethod,
    String? measurementType,
    double? expectedValue,
    double? actualValue,
    double? deviationPercent,
    String? description,
    bool? isResolved,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNotes,
    String? sourceEntityType,
    int? sourceEntityId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Anomaly',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      if (plantId != null) 'plantId': plantId,
      if (trayId != null) 'trayId': trayId,
      'anomalyType': anomalyType,
      'severity': severity,
      'detectionMethod': detectionMethod,
      if (measurementType != null) 'measurementType': measurementType,
      if (expectedValue != null) 'expectedValue': expectedValue,
      if (actualValue != null) 'actualValue': actualValue,
      if (deviationPercent != null) 'deviationPercent': deviationPercent,
      'description': description,
      'isResolved': isResolved,
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      if (resolvedBy != null) 'resolvedBy': resolvedBy,
      if (resolutionNotes != null) 'resolutionNotes': resolutionNotes,
      if (sourceEntityType != null) 'sourceEntityType': sourceEntityType,
      if (sourceEntityId != null) 'sourceEntityId': sourceEntityId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnomalyImpl extends Anomaly {
  _AnomalyImpl({
    int? id,
    required int greenhouseId,
    int? plantId,
    int? trayId,
    required String anomalyType,
    required String severity,
    required String detectionMethod,
    String? measurementType,
    double? expectedValue,
    double? actualValue,
    double? deviationPercent,
    required String description,
    required bool isResolved,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNotes,
    String? sourceEntityType,
    int? sourceEntityId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         greenhouseId: greenhouseId,
         plantId: plantId,
         trayId: trayId,
         anomalyType: anomalyType,
         severity: severity,
         detectionMethod: detectionMethod,
         measurementType: measurementType,
         expectedValue: expectedValue,
         actualValue: actualValue,
         deviationPercent: deviationPercent,
         description: description,
         isResolved: isResolved,
         resolvedAt: resolvedAt,
         resolvedBy: resolvedBy,
         resolutionNotes: resolutionNotes,
         sourceEntityType: sourceEntityType,
         sourceEntityId: sourceEntityId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Anomaly]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Anomaly copyWith({
    Object? id = _Undefined,
    int? greenhouseId,
    Object? plantId = _Undefined,
    Object? trayId = _Undefined,
    String? anomalyType,
    String? severity,
    String? detectionMethod,
    Object? measurementType = _Undefined,
    Object? expectedValue = _Undefined,
    Object? actualValue = _Undefined,
    Object? deviationPercent = _Undefined,
    String? description,
    bool? isResolved,
    Object? resolvedAt = _Undefined,
    Object? resolvedBy = _Undefined,
    Object? resolutionNotes = _Undefined,
    Object? sourceEntityType = _Undefined,
    Object? sourceEntityId = _Undefined,
    DateTime? createdAt,
  }) {
    return Anomaly(
      id: id is int? ? id : this.id,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      plantId: plantId is int? ? plantId : this.plantId,
      trayId: trayId is int? ? trayId : this.trayId,
      anomalyType: anomalyType ?? this.anomalyType,
      severity: severity ?? this.severity,
      detectionMethod: detectionMethod ?? this.detectionMethod,
      measurementType: measurementType is String?
          ? measurementType
          : this.measurementType,
      expectedValue: expectedValue is double?
          ? expectedValue
          : this.expectedValue,
      actualValue: actualValue is double? ? actualValue : this.actualValue,
      deviationPercent: deviationPercent is double?
          ? deviationPercent
          : this.deviationPercent,
      description: description ?? this.description,
      isResolved: isResolved ?? this.isResolved,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
      resolvedBy: resolvedBy is String? ? resolvedBy : this.resolvedBy,
      resolutionNotes: resolutionNotes is String?
          ? resolutionNotes
          : this.resolutionNotes,
      sourceEntityType: sourceEntityType is String?
          ? sourceEntityType
          : this.sourceEntityType,
      sourceEntityId: sourceEntityId is int?
          ? sourceEntityId
          : this.sourceEntityId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
