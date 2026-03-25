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

abstract class DiseaseDetection implements _i1.SerializableModel {
  DiseaseDetection._({
    this.id,
    required this.plantId,
    required this.greenhouseId,
    required this.diseaseType,
    required this.diseaseName,
    required this.confidence,
    required this.severity,
    this.affectedAreaPercent,
    this.anatomicalParts,
    this.imageUrl,
    this.aiModelVersion,
    required this.isConfirmed,
    this.confirmedBy,
    this.notes,
    required this.detectedAt,
    required this.createdAt,
  });

  factory DiseaseDetection({
    int? id,
    required int plantId,
    required int greenhouseId,
    required String diseaseType,
    required String diseaseName,
    required double confidence,
    required String severity,
    double? affectedAreaPercent,
    List<String>? anatomicalParts,
    String? imageUrl,
    String? aiModelVersion,
    required bool isConfirmed,
    String? confirmedBy,
    String? notes,
    required DateTime detectedAt,
    required DateTime createdAt,
  }) = _DiseaseDetectionImpl;

  factory DiseaseDetection.fromJson(Map<String, dynamic> jsonSerialization) {
    return DiseaseDetection(
      id: jsonSerialization['id'] as int?,
      plantId: jsonSerialization['plantId'] as int,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      diseaseType: jsonSerialization['diseaseType'] as String,
      diseaseName: jsonSerialization['diseaseName'] as String,
      confidence: (jsonSerialization['confidence'] as num).toDouble(),
      severity: jsonSerialization['severity'] as String,
      affectedAreaPercent: (jsonSerialization['affectedAreaPercent'] as num?)
          ?.toDouble(),
      anatomicalParts: jsonSerialization['anatomicalParts'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['anatomicalParts'],
            ),
      imageUrl: jsonSerialization['imageUrl'] as String?,
      aiModelVersion: jsonSerialization['aiModelVersion'] as String?,
      isConfirmed: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isConfirmed'],
      ),
      confirmedBy: jsonSerialization['confirmedBy'] as String?,
      notes: jsonSerialization['notes'] as String?,
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

  String diseaseType;

  String diseaseName;

  double confidence;

  String severity;

  double? affectedAreaPercent;

  List<String>? anatomicalParts;

  String? imageUrl;

  String? aiModelVersion;

  bool isConfirmed;

  String? confirmedBy;

  String? notes;

  DateTime detectedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [DiseaseDetection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DiseaseDetection copyWith({
    int? id,
    int? plantId,
    int? greenhouseId,
    String? diseaseType,
    String? diseaseName,
    double? confidence,
    String? severity,
    double? affectedAreaPercent,
    List<String>? anatomicalParts,
    String? imageUrl,
    String? aiModelVersion,
    bool? isConfirmed,
    String? confirmedBy,
    String? notes,
    DateTime? detectedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DiseaseDetection',
      if (id != null) 'id': id,
      'plantId': plantId,
      'greenhouseId': greenhouseId,
      'diseaseType': diseaseType,
      'diseaseName': diseaseName,
      'confidence': confidence,
      'severity': severity,
      if (affectedAreaPercent != null)
        'affectedAreaPercent': affectedAreaPercent,
      if (anatomicalParts != null) 'anatomicalParts': anatomicalParts?.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (aiModelVersion != null) 'aiModelVersion': aiModelVersion,
      'isConfirmed': isConfirmed,
      if (confirmedBy != null) 'confirmedBy': confirmedBy,
      if (notes != null) 'notes': notes,
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

class _DiseaseDetectionImpl extends DiseaseDetection {
  _DiseaseDetectionImpl({
    int? id,
    required int plantId,
    required int greenhouseId,
    required String diseaseType,
    required String diseaseName,
    required double confidence,
    required String severity,
    double? affectedAreaPercent,
    List<String>? anatomicalParts,
    String? imageUrl,
    String? aiModelVersion,
    required bool isConfirmed,
    String? confirmedBy,
    String? notes,
    required DateTime detectedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         plantId: plantId,
         greenhouseId: greenhouseId,
         diseaseType: diseaseType,
         diseaseName: diseaseName,
         confidence: confidence,
         severity: severity,
         affectedAreaPercent: affectedAreaPercent,
         anatomicalParts: anatomicalParts,
         imageUrl: imageUrl,
         aiModelVersion: aiModelVersion,
         isConfirmed: isConfirmed,
         confirmedBy: confirmedBy,
         notes: notes,
         detectedAt: detectedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DiseaseDetection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DiseaseDetection copyWith({
    Object? id = _Undefined,
    int? plantId,
    int? greenhouseId,
    String? diseaseType,
    String? diseaseName,
    double? confidence,
    String? severity,
    Object? affectedAreaPercent = _Undefined,
    Object? anatomicalParts = _Undefined,
    Object? imageUrl = _Undefined,
    Object? aiModelVersion = _Undefined,
    bool? isConfirmed,
    Object? confirmedBy = _Undefined,
    Object? notes = _Undefined,
    DateTime? detectedAt,
    DateTime? createdAt,
  }) {
    return DiseaseDetection(
      id: id is int? ? id : this.id,
      plantId: plantId ?? this.plantId,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      diseaseType: diseaseType ?? this.diseaseType,
      diseaseName: diseaseName ?? this.diseaseName,
      confidence: confidence ?? this.confidence,
      severity: severity ?? this.severity,
      affectedAreaPercent: affectedAreaPercent is double?
          ? affectedAreaPercent
          : this.affectedAreaPercent,
      anatomicalParts: anatomicalParts is List<String>?
          ? anatomicalParts
          : this.anatomicalParts?.map((e0) => e0).toList(),
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      aiModelVersion: aiModelVersion is String?
          ? aiModelVersion
          : this.aiModelVersion,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      confirmedBy: confirmedBy is String? ? confirmedBy : this.confirmedBy,
      notes: notes is String? ? notes : this.notes,
      detectedAt: detectedAt ?? this.detectedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
