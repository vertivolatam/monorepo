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

abstract class Alert implements _i1.SerializableModel {
  Alert._({
    this.id,
    required this.userId,
    this.greenhouseId,
    this.plantId,
    this.trayId,
    required this.alertType,
    required this.severity,
    required this.title,
    required this.message,
    this.sourceEntityType,
    this.sourceEntityId,
    required this.isRead,
    required this.isAcknowledged,
    this.acknowledgedAt,
    this.acknowledgedBy,
    required this.isResolved,
    this.resolvedAt,
    required this.escalationLevel,
    required this.createdAt,
  });

  factory Alert({
    int? id,
    required String userId,
    int? greenhouseId,
    int? plantId,
    int? trayId,
    required String alertType,
    required String severity,
    required String title,
    required String message,
    String? sourceEntityType,
    int? sourceEntityId,
    required bool isRead,
    required bool isAcknowledged,
    DateTime? acknowledgedAt,
    String? acknowledgedBy,
    required bool isResolved,
    DateTime? resolvedAt,
    required int escalationLevel,
    required DateTime createdAt,
  }) = _AlertImpl;

  factory Alert.fromJson(Map<String, dynamic> jsonSerialization) {
    return Alert(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      greenhouseId: jsonSerialization['greenhouseId'] as int?,
      plantId: jsonSerialization['plantId'] as int?,
      trayId: jsonSerialization['trayId'] as int?,
      alertType: jsonSerialization['alertType'] as String,
      severity: jsonSerialization['severity'] as String,
      title: jsonSerialization['title'] as String,
      message: jsonSerialization['message'] as String,
      sourceEntityType: jsonSerialization['sourceEntityType'] as String?,
      sourceEntityId: jsonSerialization['sourceEntityId'] as int?,
      isRead: _i1.BoolJsonExtension.fromJson(jsonSerialization['isRead']),
      isAcknowledged: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isAcknowledged'],
      ),
      acknowledgedAt: jsonSerialization['acknowledgedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['acknowledgedAt'],
            ),
      acknowledgedBy: jsonSerialization['acknowledgedBy'] as String?,
      isResolved: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isResolved'],
      ),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
      escalationLevel: jsonSerialization['escalationLevel'] as int,
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

  int? plantId;

  int? trayId;

  String alertType;

  String severity;

  String title;

  String message;

  String? sourceEntityType;

  int? sourceEntityId;

  bool isRead;

  bool isAcknowledged;

  DateTime? acknowledgedAt;

  String? acknowledgedBy;

  bool isResolved;

  DateTime? resolvedAt;

  int escalationLevel;

  DateTime createdAt;

  /// Returns a shallow copy of this [Alert]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Alert copyWith({
    int? id,
    String? userId,
    int? greenhouseId,
    int? plantId,
    int? trayId,
    String? alertType,
    String? severity,
    String? title,
    String? message,
    String? sourceEntityType,
    int? sourceEntityId,
    bool? isRead,
    bool? isAcknowledged,
    DateTime? acknowledgedAt,
    String? acknowledgedBy,
    bool? isResolved,
    DateTime? resolvedAt,
    int? escalationLevel,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Alert',
      if (id != null) 'id': id,
      'userId': userId,
      if (greenhouseId != null) 'greenhouseId': greenhouseId,
      if (plantId != null) 'plantId': plantId,
      if (trayId != null) 'trayId': trayId,
      'alertType': alertType,
      'severity': severity,
      'title': title,
      'message': message,
      if (sourceEntityType != null) 'sourceEntityType': sourceEntityType,
      if (sourceEntityId != null) 'sourceEntityId': sourceEntityId,
      'isRead': isRead,
      'isAcknowledged': isAcknowledged,
      if (acknowledgedAt != null) 'acknowledgedAt': acknowledgedAt?.toJson(),
      if (acknowledgedBy != null) 'acknowledgedBy': acknowledgedBy,
      'isResolved': isResolved,
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      'escalationLevel': escalationLevel,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AlertImpl extends Alert {
  _AlertImpl({
    int? id,
    required String userId,
    int? greenhouseId,
    int? plantId,
    int? trayId,
    required String alertType,
    required String severity,
    required String title,
    required String message,
    String? sourceEntityType,
    int? sourceEntityId,
    required bool isRead,
    required bool isAcknowledged,
    DateTime? acknowledgedAt,
    String? acknowledgedBy,
    required bool isResolved,
    DateTime? resolvedAt,
    required int escalationLevel,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         greenhouseId: greenhouseId,
         plantId: plantId,
         trayId: trayId,
         alertType: alertType,
         severity: severity,
         title: title,
         message: message,
         sourceEntityType: sourceEntityType,
         sourceEntityId: sourceEntityId,
         isRead: isRead,
         isAcknowledged: isAcknowledged,
         acknowledgedAt: acknowledgedAt,
         acknowledgedBy: acknowledgedBy,
         isResolved: isResolved,
         resolvedAt: resolvedAt,
         escalationLevel: escalationLevel,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Alert]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Alert copyWith({
    Object? id = _Undefined,
    String? userId,
    Object? greenhouseId = _Undefined,
    Object? plantId = _Undefined,
    Object? trayId = _Undefined,
    String? alertType,
    String? severity,
    String? title,
    String? message,
    Object? sourceEntityType = _Undefined,
    Object? sourceEntityId = _Undefined,
    bool? isRead,
    bool? isAcknowledged,
    Object? acknowledgedAt = _Undefined,
    Object? acknowledgedBy = _Undefined,
    bool? isResolved,
    Object? resolvedAt = _Undefined,
    int? escalationLevel,
    DateTime? createdAt,
  }) {
    return Alert(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      greenhouseId: greenhouseId is int? ? greenhouseId : this.greenhouseId,
      plantId: plantId is int? ? plantId : this.plantId,
      trayId: trayId is int? ? trayId : this.trayId,
      alertType: alertType ?? this.alertType,
      severity: severity ?? this.severity,
      title: title ?? this.title,
      message: message ?? this.message,
      sourceEntityType: sourceEntityType is String?
          ? sourceEntityType
          : this.sourceEntityType,
      sourceEntityId: sourceEntityId is int?
          ? sourceEntityId
          : this.sourceEntityId,
      isRead: isRead ?? this.isRead,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
      acknowledgedAt: acknowledgedAt is DateTime?
          ? acknowledgedAt
          : this.acknowledgedAt,
      acknowledgedBy: acknowledgedBy is String?
          ? acknowledgedBy
          : this.acknowledgedBy,
      isResolved: isResolved ?? this.isResolved,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
      escalationLevel: escalationLevel ?? this.escalationLevel,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
