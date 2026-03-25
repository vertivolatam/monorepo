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

abstract class EnvironmentalReading implements _i1.SerializableModel {
  EnvironmentalReading._({
    this.id,
    required this.greenhouseId,
    required this.measurementType,
    required this.value,
    required this.unit,
    this.source,
    required this.isAnomaly,
    required this.createdAt,
  });

  factory EnvironmentalReading({
    int? id,
    required int greenhouseId,
    required String measurementType,
    required double value,
    required String unit,
    String? source,
    required bool isAnomaly,
    required DateTime createdAt,
  }) = _EnvironmentalReadingImpl;

  factory EnvironmentalReading.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EnvironmentalReading(
      id: jsonSerialization['id'] as int?,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      measurementType: jsonSerialization['measurementType'] as String,
      value: (jsonSerialization['value'] as num).toDouble(),
      unit: jsonSerialization['unit'] as String,
      source: jsonSerialization['source'] as String?,
      isAnomaly: _i1.BoolJsonExtension.fromJson(jsonSerialization['isAnomaly']),
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

  String measurementType;

  double value;

  String unit;

  String? source;

  bool isAnomaly;

  DateTime createdAt;

  /// Returns a shallow copy of this [EnvironmentalReading]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EnvironmentalReading copyWith({
    int? id,
    int? greenhouseId,
    String? measurementType,
    double? value,
    String? unit,
    String? source,
    bool? isAnomaly,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EnvironmentalReading',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      'measurementType': measurementType,
      'value': value,
      'unit': unit,
      if (source != null) 'source': source,
      'isAnomaly': isAnomaly,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnvironmentalReadingImpl extends EnvironmentalReading {
  _EnvironmentalReadingImpl({
    int? id,
    required int greenhouseId,
    required String measurementType,
    required double value,
    required String unit,
    String? source,
    required bool isAnomaly,
    required DateTime createdAt,
  }) : super._(
         id: id,
         greenhouseId: greenhouseId,
         measurementType: measurementType,
         value: value,
         unit: unit,
         source: source,
         isAnomaly: isAnomaly,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [EnvironmentalReading]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EnvironmentalReading copyWith({
    Object? id = _Undefined,
    int? greenhouseId,
    String? measurementType,
    double? value,
    String? unit,
    Object? source = _Undefined,
    bool? isAnomaly,
    DateTime? createdAt,
  }) {
    return EnvironmentalReading(
      id: id is int? ? id : this.id,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      measurementType: measurementType ?? this.measurementType,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      source: source is String? ? source : this.source,
      isAnomaly: isAnomaly ?? this.isAnomaly,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
