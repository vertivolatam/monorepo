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

abstract class SecurityEvent implements _i1.SerializableModel {
  SecurityEvent._({
    this.id,
    this.userId,
    required this.eventType,
    required this.severity,
    this.ipAddress,
    this.deviceId,
    this.details,
    required this.createdAt,
  });

  factory SecurityEvent({
    int? id,
    String? userId,
    required String eventType,
    required String severity,
    String? ipAddress,
    String? deviceId,
    String? details,
    required DateTime createdAt,
  }) = _SecurityEventImpl;

  factory SecurityEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return SecurityEvent(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String?,
      eventType: jsonSerialization['eventType'] as String,
      severity: jsonSerialization['severity'] as String,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      deviceId: jsonSerialization['deviceId'] as String?,
      details: jsonSerialization['details'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? userId;

  String eventType;

  String severity;

  String? ipAddress;

  String? deviceId;

  String? details;

  DateTime createdAt;

  /// Returns a shallow copy of this [SecurityEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SecurityEvent copyWith({
    int? id,
    String? userId,
    String? eventType,
    String? severity,
    String? ipAddress,
    String? deviceId,
    String? details,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SecurityEvent',
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      'eventType': eventType,
      'severity': severity,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (deviceId != null) 'deviceId': deviceId,
      if (details != null) 'details': details,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SecurityEventImpl extends SecurityEvent {
  _SecurityEventImpl({
    int? id,
    String? userId,
    required String eventType,
    required String severity,
    String? ipAddress,
    String? deviceId,
    String? details,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         eventType: eventType,
         severity: severity,
         ipAddress: ipAddress,
         deviceId: deviceId,
         details: details,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SecurityEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SecurityEvent copyWith({
    Object? id = _Undefined,
    Object? userId = _Undefined,
    String? eventType,
    String? severity,
    Object? ipAddress = _Undefined,
    Object? deviceId = _Undefined,
    Object? details = _Undefined,
    DateTime? createdAt,
  }) {
    return SecurityEvent(
      id: id is int? ? id : this.id,
      userId: userId is String? ? userId : this.userId,
      eventType: eventType ?? this.eventType,
      severity: severity ?? this.severity,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      deviceId: deviceId is String? ? deviceId : this.deviceId,
      details: details is String? ? details : this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
