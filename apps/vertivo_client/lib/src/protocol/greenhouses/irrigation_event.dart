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

abstract class IrrigationEvent implements _i1.SerializableModel {
  IrrigationEvent._({
    this.id,
    required this.greenhouseId,
    this.trayId,
    required this.irrigationType,
    required this.durationMinutes,
    this.waterVolumeLiters,
    this.nutrientMix,
    required this.triggeredBy,
    required this.createdAt,
  });

  factory IrrigationEvent({
    int? id,
    required int greenhouseId,
    int? trayId,
    required String irrigationType,
    required double durationMinutes,
    double? waterVolumeLiters,
    String? nutrientMix,
    required String triggeredBy,
    required DateTime createdAt,
  }) = _IrrigationEventImpl;

  factory IrrigationEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return IrrigationEvent(
      id: jsonSerialization['id'] as int?,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      trayId: jsonSerialization['trayId'] as int?,
      irrigationType: jsonSerialization['irrigationType'] as String,
      durationMinutes: (jsonSerialization['durationMinutes'] as num).toDouble(),
      waterVolumeLiters: (jsonSerialization['waterVolumeLiters'] as num?)
          ?.toDouble(),
      nutrientMix: jsonSerialization['nutrientMix'] as String?,
      triggeredBy: jsonSerialization['triggeredBy'] as String,
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

  int? trayId;

  String irrigationType;

  double durationMinutes;

  double? waterVolumeLiters;

  String? nutrientMix;

  String triggeredBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [IrrigationEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IrrigationEvent copyWith({
    int? id,
    int? greenhouseId,
    int? trayId,
    String? irrigationType,
    double? durationMinutes,
    double? waterVolumeLiters,
    String? nutrientMix,
    String? triggeredBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IrrigationEvent',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      if (trayId != null) 'trayId': trayId,
      'irrigationType': irrigationType,
      'durationMinutes': durationMinutes,
      if (waterVolumeLiters != null) 'waterVolumeLiters': waterVolumeLiters,
      if (nutrientMix != null) 'nutrientMix': nutrientMix,
      'triggeredBy': triggeredBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IrrigationEventImpl extends IrrigationEvent {
  _IrrigationEventImpl({
    int? id,
    required int greenhouseId,
    int? trayId,
    required String irrigationType,
    required double durationMinutes,
    double? waterVolumeLiters,
    String? nutrientMix,
    required String triggeredBy,
    required DateTime createdAt,
  }) : super._(
         id: id,
         greenhouseId: greenhouseId,
         trayId: trayId,
         irrigationType: irrigationType,
         durationMinutes: durationMinutes,
         waterVolumeLiters: waterVolumeLiters,
         nutrientMix: nutrientMix,
         triggeredBy: triggeredBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [IrrigationEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IrrigationEvent copyWith({
    Object? id = _Undefined,
    int? greenhouseId,
    Object? trayId = _Undefined,
    String? irrigationType,
    double? durationMinutes,
    Object? waterVolumeLiters = _Undefined,
    Object? nutrientMix = _Undefined,
    String? triggeredBy,
    DateTime? createdAt,
  }) {
    return IrrigationEvent(
      id: id is int? ? id : this.id,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      trayId: trayId is int? ? trayId : this.trayId,
      irrigationType: irrigationType ?? this.irrigationType,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      waterVolumeLiters: waterVolumeLiters is double?
          ? waterVolumeLiters
          : this.waterVolumeLiters,
      nutrientMix: nutrientMix is String? ? nutrientMix : this.nutrientMix,
      triggeredBy: triggeredBy ?? this.triggeredBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
