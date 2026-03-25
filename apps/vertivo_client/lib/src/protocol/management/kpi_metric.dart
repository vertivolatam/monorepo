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

abstract class KpiMetric implements _i1.SerializableModel {
  KpiMetric._({
    this.id,
    required this.userId,
    this.greenhouseId,
    required this.metricType,
    required this.value,
    this.unit,
    required this.periodStart,
    required this.periodEnd,
    required this.periodType,
    this.previousValue,
    this.changePercent,
    this.targetValue,
    this.segment,
    this.notes,
    required this.createdAt,
  });

  factory KpiMetric({
    int? id,
    required String userId,
    int? greenhouseId,
    required String metricType,
    required double value,
    String? unit,
    required DateTime periodStart,
    required DateTime periodEnd,
    required String periodType,
    double? previousValue,
    double? changePercent,
    double? targetValue,
    String? segment,
    String? notes,
    required DateTime createdAt,
  }) = _KpiMetricImpl;

  factory KpiMetric.fromJson(Map<String, dynamic> jsonSerialization) {
    return KpiMetric(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      greenhouseId: jsonSerialization['greenhouseId'] as int?,
      metricType: jsonSerialization['metricType'] as String,
      value: (jsonSerialization['value'] as num).toDouble(),
      unit: jsonSerialization['unit'] as String?,
      periodStart: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['periodStart'],
      ),
      periodEnd: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['periodEnd'],
      ),
      periodType: jsonSerialization['periodType'] as String,
      previousValue: (jsonSerialization['previousValue'] as num?)?.toDouble(),
      changePercent: (jsonSerialization['changePercent'] as num?)?.toDouble(),
      targetValue: (jsonSerialization['targetValue'] as num?)?.toDouble(),
      segment: jsonSerialization['segment'] as String?,
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

  String userId;

  int? greenhouseId;

  String metricType;

  double value;

  String? unit;

  DateTime periodStart;

  DateTime periodEnd;

  String periodType;

  double? previousValue;

  double? changePercent;

  double? targetValue;

  String? segment;

  String? notes;

  DateTime createdAt;

  /// Returns a shallow copy of this [KpiMetric]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  KpiMetric copyWith({
    int? id,
    String? userId,
    int? greenhouseId,
    String? metricType,
    double? value,
    String? unit,
    DateTime? periodStart,
    DateTime? periodEnd,
    String? periodType,
    double? previousValue,
    double? changePercent,
    double? targetValue,
    String? segment,
    String? notes,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'KpiMetric',
      if (id != null) 'id': id,
      'userId': userId,
      if (greenhouseId != null) 'greenhouseId': greenhouseId,
      'metricType': metricType,
      'value': value,
      if (unit != null) 'unit': unit,
      'periodStart': periodStart.toJson(),
      'periodEnd': periodEnd.toJson(),
      'periodType': periodType,
      if (previousValue != null) 'previousValue': previousValue,
      if (changePercent != null) 'changePercent': changePercent,
      if (targetValue != null) 'targetValue': targetValue,
      if (segment != null) 'segment': segment,
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

class _KpiMetricImpl extends KpiMetric {
  _KpiMetricImpl({
    int? id,
    required String userId,
    int? greenhouseId,
    required String metricType,
    required double value,
    String? unit,
    required DateTime periodStart,
    required DateTime periodEnd,
    required String periodType,
    double? previousValue,
    double? changePercent,
    double? targetValue,
    String? segment,
    String? notes,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         greenhouseId: greenhouseId,
         metricType: metricType,
         value: value,
         unit: unit,
         periodStart: periodStart,
         periodEnd: periodEnd,
         periodType: periodType,
         previousValue: previousValue,
         changePercent: changePercent,
         targetValue: targetValue,
         segment: segment,
         notes: notes,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [KpiMetric]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  KpiMetric copyWith({
    Object? id = _Undefined,
    String? userId,
    Object? greenhouseId = _Undefined,
    String? metricType,
    double? value,
    Object? unit = _Undefined,
    DateTime? periodStart,
    DateTime? periodEnd,
    String? periodType,
    Object? previousValue = _Undefined,
    Object? changePercent = _Undefined,
    Object? targetValue = _Undefined,
    Object? segment = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
  }) {
    return KpiMetric(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      greenhouseId: greenhouseId is int? ? greenhouseId : this.greenhouseId,
      metricType: metricType ?? this.metricType,
      value: value ?? this.value,
      unit: unit is String? ? unit : this.unit,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      periodType: periodType ?? this.periodType,
      previousValue: previousValue is double?
          ? previousValue
          : this.previousValue,
      changePercent: changePercent is double?
          ? changePercent
          : this.changePercent,
      targetValue: targetValue is double? ? targetValue : this.targetValue,
      segment: segment is String? ? segment : this.segment,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
