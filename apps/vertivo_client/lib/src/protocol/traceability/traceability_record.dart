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

abstract class TraceabilityRecord implements _i1.SerializableModel {
  TraceabilityRecord._({
    this.id,
    required this.greenhouseId,
    required this.batchId,
    required this.eventType,
    required this.description,
    this.performedBy,
    this.metadata,
    required this.recordHash,
    required this.previousHash,
    required this.sequenceNumber,
    required this.isVerified,
    this.verifiedAt,
    this.verifiedBy,
    required this.createdAt,
  });

  factory TraceabilityRecord({
    int? id,
    required int greenhouseId,
    required String batchId,
    required String eventType,
    required String description,
    String? performedBy,
    String? metadata,
    required String recordHash,
    required String previousHash,
    required int sequenceNumber,
    required bool isVerified,
    DateTime? verifiedAt,
    String? verifiedBy,
    required DateTime createdAt,
  }) = _TraceabilityRecordImpl;

  factory TraceabilityRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return TraceabilityRecord(
      id: jsonSerialization['id'] as int?,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      batchId: jsonSerialization['batchId'] as String,
      eventType: jsonSerialization['eventType'] as String,
      description: jsonSerialization['description'] as String,
      performedBy: jsonSerialization['performedBy'] as String?,
      metadata: jsonSerialization['metadata'] as String?,
      recordHash: jsonSerialization['recordHash'] as String,
      previousHash: jsonSerialization['previousHash'] as String,
      sequenceNumber: jsonSerialization['sequenceNumber'] as int,
      isVerified: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isVerified'],
      ),
      verifiedAt: jsonSerialization['verifiedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['verifiedAt']),
      verifiedBy: jsonSerialization['verifiedBy'] as String?,
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

  String batchId;

  String eventType;

  String description;

  String? performedBy;

  String? metadata;

  String recordHash;

  String previousHash;

  int sequenceNumber;

  bool isVerified;

  DateTime? verifiedAt;

  String? verifiedBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [TraceabilityRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TraceabilityRecord copyWith({
    int? id,
    int? greenhouseId,
    String? batchId,
    String? eventType,
    String? description,
    String? performedBy,
    String? metadata,
    String? recordHash,
    String? previousHash,
    int? sequenceNumber,
    bool? isVerified,
    DateTime? verifiedAt,
    String? verifiedBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TraceabilityRecord',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      'batchId': batchId,
      'eventType': eventType,
      'description': description,
      if (performedBy != null) 'performedBy': performedBy,
      if (metadata != null) 'metadata': metadata,
      'recordHash': recordHash,
      'previousHash': previousHash,
      'sequenceNumber': sequenceNumber,
      'isVerified': isVerified,
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      if (verifiedBy != null) 'verifiedBy': verifiedBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TraceabilityRecordImpl extends TraceabilityRecord {
  _TraceabilityRecordImpl({
    int? id,
    required int greenhouseId,
    required String batchId,
    required String eventType,
    required String description,
    String? performedBy,
    String? metadata,
    required String recordHash,
    required String previousHash,
    required int sequenceNumber,
    required bool isVerified,
    DateTime? verifiedAt,
    String? verifiedBy,
    required DateTime createdAt,
  }) : super._(
         id: id,
         greenhouseId: greenhouseId,
         batchId: batchId,
         eventType: eventType,
         description: description,
         performedBy: performedBy,
         metadata: metadata,
         recordHash: recordHash,
         previousHash: previousHash,
         sequenceNumber: sequenceNumber,
         isVerified: isVerified,
         verifiedAt: verifiedAt,
         verifiedBy: verifiedBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TraceabilityRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TraceabilityRecord copyWith({
    Object? id = _Undefined,
    int? greenhouseId,
    String? batchId,
    String? eventType,
    String? description,
    Object? performedBy = _Undefined,
    Object? metadata = _Undefined,
    String? recordHash,
    String? previousHash,
    int? sequenceNumber,
    bool? isVerified,
    Object? verifiedAt = _Undefined,
    Object? verifiedBy = _Undefined,
    DateTime? createdAt,
  }) {
    return TraceabilityRecord(
      id: id is int? ? id : this.id,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      batchId: batchId ?? this.batchId,
      eventType: eventType ?? this.eventType,
      description: description ?? this.description,
      performedBy: performedBy is String? ? performedBy : this.performedBy,
      metadata: metadata is String? ? metadata : this.metadata,
      recordHash: recordHash ?? this.recordHash,
      previousHash: previousHash ?? this.previousHash,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      isVerified: isVerified ?? this.isVerified,
      verifiedAt: verifiedAt is DateTime? ? verifiedAt : this.verifiedAt,
      verifiedBy: verifiedBy is String? ? verifiedBy : this.verifiedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
