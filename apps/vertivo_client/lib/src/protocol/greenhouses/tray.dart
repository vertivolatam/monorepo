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

abstract class Tray implements _i1.SerializableModel {
  Tray._({
    this.id,
    required this.greenhouseId,
    required this.position,
    this.label,
    this.cropType,
    this.plantingDate,
    this.expectedHarvestDate,
    required this.status,
    required this.plantCount,
    this.healthScore,
    this.soilPh,
    this.soilMoisture,
    this.soilFertility,
    this.lastIrrigatedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tray({
    int? id,
    required int greenhouseId,
    required int position,
    String? label,
    String? cropType,
    DateTime? plantingDate,
    DateTime? expectedHarvestDate,
    required String status,
    required int plantCount,
    double? healthScore,
    double? soilPh,
    double? soilMoisture,
    String? soilFertility,
    DateTime? lastIrrigatedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TrayImpl;

  factory Tray.fromJson(Map<String, dynamic> jsonSerialization) {
    return Tray(
      id: jsonSerialization['id'] as int?,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      position: jsonSerialization['position'] as int,
      label: jsonSerialization['label'] as String?,
      cropType: jsonSerialization['cropType'] as String?,
      plantingDate: jsonSerialization['plantingDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['plantingDate'],
            ),
      expectedHarvestDate: jsonSerialization['expectedHarvestDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['expectedHarvestDate'],
            ),
      status: jsonSerialization['status'] as String,
      plantCount: jsonSerialization['plantCount'] as int,
      healthScore: (jsonSerialization['healthScore'] as num?)?.toDouble(),
      soilPh: (jsonSerialization['soilPh'] as num?)?.toDouble(),
      soilMoisture: (jsonSerialization['soilMoisture'] as num?)?.toDouble(),
      soilFertility: jsonSerialization['soilFertility'] as String?,
      lastIrrigatedAt: jsonSerialization['lastIrrigatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastIrrigatedAt'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int greenhouseId;

  int position;

  String? label;

  String? cropType;

  DateTime? plantingDate;

  DateTime? expectedHarvestDate;

  String status;

  int plantCount;

  double? healthScore;

  double? soilPh;

  double? soilMoisture;

  String? soilFertility;

  DateTime? lastIrrigatedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Tray]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Tray copyWith({
    int? id,
    int? greenhouseId,
    int? position,
    String? label,
    String? cropType,
    DateTime? plantingDate,
    DateTime? expectedHarvestDate,
    String? status,
    int? plantCount,
    double? healthScore,
    double? soilPh,
    double? soilMoisture,
    String? soilFertility,
    DateTime? lastIrrigatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Tray',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      'position': position,
      if (label != null) 'label': label,
      if (cropType != null) 'cropType': cropType,
      if (plantingDate != null) 'plantingDate': plantingDate?.toJson(),
      if (expectedHarvestDate != null)
        'expectedHarvestDate': expectedHarvestDate?.toJson(),
      'status': status,
      'plantCount': plantCount,
      if (healthScore != null) 'healthScore': healthScore,
      if (soilPh != null) 'soilPh': soilPh,
      if (soilMoisture != null) 'soilMoisture': soilMoisture,
      if (soilFertility != null) 'soilFertility': soilFertility,
      if (lastIrrigatedAt != null) 'lastIrrigatedAt': lastIrrigatedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TrayImpl extends Tray {
  _TrayImpl({
    int? id,
    required int greenhouseId,
    required int position,
    String? label,
    String? cropType,
    DateTime? plantingDate,
    DateTime? expectedHarvestDate,
    required String status,
    required int plantCount,
    double? healthScore,
    double? soilPh,
    double? soilMoisture,
    String? soilFertility,
    DateTime? lastIrrigatedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         greenhouseId: greenhouseId,
         position: position,
         label: label,
         cropType: cropType,
         plantingDate: plantingDate,
         expectedHarvestDate: expectedHarvestDate,
         status: status,
         plantCount: plantCount,
         healthScore: healthScore,
         soilPh: soilPh,
         soilMoisture: soilMoisture,
         soilFertility: soilFertility,
         lastIrrigatedAt: lastIrrigatedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Tray]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Tray copyWith({
    Object? id = _Undefined,
    int? greenhouseId,
    int? position,
    Object? label = _Undefined,
    Object? cropType = _Undefined,
    Object? plantingDate = _Undefined,
    Object? expectedHarvestDate = _Undefined,
    String? status,
    int? plantCount,
    Object? healthScore = _Undefined,
    Object? soilPh = _Undefined,
    Object? soilMoisture = _Undefined,
    Object? soilFertility = _Undefined,
    Object? lastIrrigatedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tray(
      id: id is int? ? id : this.id,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      position: position ?? this.position,
      label: label is String? ? label : this.label,
      cropType: cropType is String? ? cropType : this.cropType,
      plantingDate: plantingDate is DateTime?
          ? plantingDate
          : this.plantingDate,
      expectedHarvestDate: expectedHarvestDate is DateTime?
          ? expectedHarvestDate
          : this.expectedHarvestDate,
      status: status ?? this.status,
      plantCount: plantCount ?? this.plantCount,
      healthScore: healthScore is double? ? healthScore : this.healthScore,
      soilPh: soilPh is double? ? soilPh : this.soilPh,
      soilMoisture: soilMoisture is double? ? soilMoisture : this.soilMoisture,
      soilFertility: soilFertility is String?
          ? soilFertility
          : this.soilFertility,
      lastIrrigatedAt: lastIrrigatedAt is DateTime?
          ? lastIrrigatedAt
          : this.lastIrrigatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
