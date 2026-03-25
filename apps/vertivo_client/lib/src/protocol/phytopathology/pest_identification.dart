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

abstract class PestIdentification implements _i1.SerializableModel {
  PestIdentification._({
    this.id,
    required this.plantId,
    required this.greenhouseId,
    required this.pestType,
    required this.confidence,
    required this.infestationLevel,
    this.affectedPlantCount,
    this.imageUrl,
    this.aiModelVersion,
    required this.isConfirmed,
    this.confirmedBy,
    required this.detectedAt,
    required this.createdAt,
  });

  factory PestIdentification({
    int? id,
    required int plantId,
    required int greenhouseId,
    required String pestType,
    required double confidence,
    required String infestationLevel,
    int? affectedPlantCount,
    String? imageUrl,
    String? aiModelVersion,
    required bool isConfirmed,
    String? confirmedBy,
    required DateTime detectedAt,
    required DateTime createdAt,
  }) = _PestIdentificationImpl;

  factory PestIdentification.fromJson(Map<String, dynamic> jsonSerialization) {
    return PestIdentification(
      id: jsonSerialization['id'] as int?,
      plantId: jsonSerialization['plantId'] as int,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      pestType: jsonSerialization['pestType'] as String,
      confidence: (jsonSerialization['confidence'] as num).toDouble(),
      infestationLevel: jsonSerialization['infestationLevel'] as String,
      affectedPlantCount: jsonSerialization['affectedPlantCount'] as int?,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      aiModelVersion: jsonSerialization['aiModelVersion'] as String?,
      isConfirmed: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isConfirmed'],
      ),
      confirmedBy: jsonSerialization['confirmedBy'] as String?,
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

  String pestType;

  double confidence;

  String infestationLevel;

  int? affectedPlantCount;

  String? imageUrl;

  String? aiModelVersion;

  bool isConfirmed;

  String? confirmedBy;

  DateTime detectedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [PestIdentification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PestIdentification copyWith({
    int? id,
    int? plantId,
    int? greenhouseId,
    String? pestType,
    double? confidence,
    String? infestationLevel,
    int? affectedPlantCount,
    String? imageUrl,
    String? aiModelVersion,
    bool? isConfirmed,
    String? confirmedBy,
    DateTime? detectedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PestIdentification',
      if (id != null) 'id': id,
      'plantId': plantId,
      'greenhouseId': greenhouseId,
      'pestType': pestType,
      'confidence': confidence,
      'infestationLevel': infestationLevel,
      if (affectedPlantCount != null) 'affectedPlantCount': affectedPlantCount,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (aiModelVersion != null) 'aiModelVersion': aiModelVersion,
      'isConfirmed': isConfirmed,
      if (confirmedBy != null) 'confirmedBy': confirmedBy,
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

class _PestIdentificationImpl extends PestIdentification {
  _PestIdentificationImpl({
    int? id,
    required int plantId,
    required int greenhouseId,
    required String pestType,
    required double confidence,
    required String infestationLevel,
    int? affectedPlantCount,
    String? imageUrl,
    String? aiModelVersion,
    required bool isConfirmed,
    String? confirmedBy,
    required DateTime detectedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         plantId: plantId,
         greenhouseId: greenhouseId,
         pestType: pestType,
         confidence: confidence,
         infestationLevel: infestationLevel,
         affectedPlantCount: affectedPlantCount,
         imageUrl: imageUrl,
         aiModelVersion: aiModelVersion,
         isConfirmed: isConfirmed,
         confirmedBy: confirmedBy,
         detectedAt: detectedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PestIdentification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PestIdentification copyWith({
    Object? id = _Undefined,
    int? plantId,
    int? greenhouseId,
    String? pestType,
    double? confidence,
    String? infestationLevel,
    Object? affectedPlantCount = _Undefined,
    Object? imageUrl = _Undefined,
    Object? aiModelVersion = _Undefined,
    bool? isConfirmed,
    Object? confirmedBy = _Undefined,
    DateTime? detectedAt,
    DateTime? createdAt,
  }) {
    return PestIdentification(
      id: id is int? ? id : this.id,
      plantId: plantId ?? this.plantId,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      pestType: pestType ?? this.pestType,
      confidence: confidence ?? this.confidence,
      infestationLevel: infestationLevel ?? this.infestationLevel,
      affectedPlantCount: affectedPlantCount is int?
          ? affectedPlantCount
          : this.affectedPlantCount,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      aiModelVersion: aiModelVersion is String?
          ? aiModelVersion
          : this.aiModelVersion,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      confirmedBy: confirmedBy is String? ? confirmedBy : this.confirmedBy,
      detectedAt: detectedAt ?? this.detectedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
