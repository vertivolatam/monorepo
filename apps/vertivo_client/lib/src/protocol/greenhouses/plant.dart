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

abstract class Plant implements _i1.SerializableModel {
  Plant._({
    this.id,
    required this.trayId,
    required this.greenhouseId,
    required this.position,
    required this.species,
    this.variety,
    required this.growthStage,
    required this.healthScore,
    required this.isQuarantined,
    this.quarantineReason,
    required this.plantedAt,
    this.lastInspectedAt,
    this.estimatedHarvestDate,
    this.height,
    this.leafCount,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Plant({
    int? id,
    required int trayId,
    required int greenhouseId,
    required int position,
    required String species,
    String? variety,
    required String growthStage,
    required double healthScore,
    required bool isQuarantined,
    String? quarantineReason,
    required DateTime plantedAt,
    DateTime? lastInspectedAt,
    DateTime? estimatedHarvestDate,
    double? height,
    int? leafCount,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PlantImpl;

  factory Plant.fromJson(Map<String, dynamic> jsonSerialization) {
    return Plant(
      id: jsonSerialization['id'] as int?,
      trayId: jsonSerialization['trayId'] as int,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      position: jsonSerialization['position'] as int,
      species: jsonSerialization['species'] as String,
      variety: jsonSerialization['variety'] as String?,
      growthStage: jsonSerialization['growthStage'] as String,
      healthScore: (jsonSerialization['healthScore'] as num).toDouble(),
      isQuarantined: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isQuarantined'],
      ),
      quarantineReason: jsonSerialization['quarantineReason'] as String?,
      plantedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['plantedAt'],
      ),
      lastInspectedAt: jsonSerialization['lastInspectedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastInspectedAt'],
            ),
      estimatedHarvestDate: jsonSerialization['estimatedHarvestDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['estimatedHarvestDate'],
            ),
      height: (jsonSerialization['height'] as num?)?.toDouble(),
      leafCount: jsonSerialization['leafCount'] as int?,
      notes: jsonSerialization['notes'] as String?,
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

  int trayId;

  int greenhouseId;

  int position;

  String species;

  String? variety;

  String growthStage;

  double healthScore;

  bool isQuarantined;

  String? quarantineReason;

  DateTime plantedAt;

  DateTime? lastInspectedAt;

  DateTime? estimatedHarvestDate;

  double? height;

  int? leafCount;

  String? notes;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Plant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Plant copyWith({
    int? id,
    int? trayId,
    int? greenhouseId,
    int? position,
    String? species,
    String? variety,
    String? growthStage,
    double? healthScore,
    bool? isQuarantined,
    String? quarantineReason,
    DateTime? plantedAt,
    DateTime? lastInspectedAt,
    DateTime? estimatedHarvestDate,
    double? height,
    int? leafCount,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Plant',
      if (id != null) 'id': id,
      'trayId': trayId,
      'greenhouseId': greenhouseId,
      'position': position,
      'species': species,
      if (variety != null) 'variety': variety,
      'growthStage': growthStage,
      'healthScore': healthScore,
      'isQuarantined': isQuarantined,
      if (quarantineReason != null) 'quarantineReason': quarantineReason,
      'plantedAt': plantedAt.toJson(),
      if (lastInspectedAt != null) 'lastInspectedAt': lastInspectedAt?.toJson(),
      if (estimatedHarvestDate != null)
        'estimatedHarvestDate': estimatedHarvestDate?.toJson(),
      if (height != null) 'height': height,
      if (leafCount != null) 'leafCount': leafCount,
      if (notes != null) 'notes': notes,
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

class _PlantImpl extends Plant {
  _PlantImpl({
    int? id,
    required int trayId,
    required int greenhouseId,
    required int position,
    required String species,
    String? variety,
    required String growthStage,
    required double healthScore,
    required bool isQuarantined,
    String? quarantineReason,
    required DateTime plantedAt,
    DateTime? lastInspectedAt,
    DateTime? estimatedHarvestDate,
    double? height,
    int? leafCount,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         trayId: trayId,
         greenhouseId: greenhouseId,
         position: position,
         species: species,
         variety: variety,
         growthStage: growthStage,
         healthScore: healthScore,
         isQuarantined: isQuarantined,
         quarantineReason: quarantineReason,
         plantedAt: plantedAt,
         lastInspectedAt: lastInspectedAt,
         estimatedHarvestDate: estimatedHarvestDate,
         height: height,
         leafCount: leafCount,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Plant]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Plant copyWith({
    Object? id = _Undefined,
    int? trayId,
    int? greenhouseId,
    int? position,
    String? species,
    Object? variety = _Undefined,
    String? growthStage,
    double? healthScore,
    bool? isQuarantined,
    Object? quarantineReason = _Undefined,
    DateTime? plantedAt,
    Object? lastInspectedAt = _Undefined,
    Object? estimatedHarvestDate = _Undefined,
    Object? height = _Undefined,
    Object? leafCount = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Plant(
      id: id is int? ? id : this.id,
      trayId: trayId ?? this.trayId,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      position: position ?? this.position,
      species: species ?? this.species,
      variety: variety is String? ? variety : this.variety,
      growthStage: growthStage ?? this.growthStage,
      healthScore: healthScore ?? this.healthScore,
      isQuarantined: isQuarantined ?? this.isQuarantined,
      quarantineReason: quarantineReason is String?
          ? quarantineReason
          : this.quarantineReason,
      plantedAt: plantedAt ?? this.plantedAt,
      lastInspectedAt: lastInspectedAt is DateTime?
          ? lastInspectedAt
          : this.lastInspectedAt,
      estimatedHarvestDate: estimatedHarvestDate is DateTime?
          ? estimatedHarvestDate
          : this.estimatedHarvestDate,
      height: height is double? ? height : this.height,
      leafCount: leafCount is int? ? leafCount : this.leafCount,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
