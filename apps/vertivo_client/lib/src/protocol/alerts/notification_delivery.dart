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

abstract class NotificationDelivery implements _i1.SerializableModel {
  NotificationDelivery._({
    this.id,
    required this.alertId,
    required this.userId,
    required this.channel,
    required this.status,
    this.sentAt,
    this.deliveredAt,
    this.readAt,
    this.failureReason,
    required this.retryCount,
    required this.createdAt,
  });

  factory NotificationDelivery({
    int? id,
    required int alertId,
    required String userId,
    required String channel,
    required String status,
    DateTime? sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    String? failureReason,
    required int retryCount,
    required DateTime createdAt,
  }) = _NotificationDeliveryImpl;

  factory NotificationDelivery.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationDelivery(
      id: jsonSerialization['id'] as int?,
      alertId: jsonSerialization['alertId'] as int,
      userId: jsonSerialization['userId'] as String,
      channel: jsonSerialization['channel'] as String,
      status: jsonSerialization['status'] as String,
      sentAt: jsonSerialization['sentAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
      deliveredAt: jsonSerialization['deliveredAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveredAt'],
            ),
      readAt: jsonSerialization['readAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
      failureReason: jsonSerialization['failureReason'] as String?,
      retryCount: jsonSerialization['retryCount'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int alertId;

  String userId;

  String channel;

  String status;

  DateTime? sentAt;

  DateTime? deliveredAt;

  DateTime? readAt;

  String? failureReason;

  int retryCount;

  DateTime createdAt;

  /// Returns a shallow copy of this [NotificationDelivery]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationDelivery copyWith({
    int? id,
    int? alertId,
    String? userId,
    String? channel,
    String? status,
    DateTime? sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    String? failureReason,
    int? retryCount,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationDelivery',
      if (id != null) 'id': id,
      'alertId': alertId,
      'userId': userId,
      'channel': channel,
      'status': status,
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
      if (failureReason != null) 'failureReason': failureReason,
      'retryCount': retryCount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationDeliveryImpl extends NotificationDelivery {
  _NotificationDeliveryImpl({
    int? id,
    required int alertId,
    required String userId,
    required String channel,
    required String status,
    DateTime? sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    String? failureReason,
    required int retryCount,
    required DateTime createdAt,
  }) : super._(
         id: id,
         alertId: alertId,
         userId: userId,
         channel: channel,
         status: status,
         sentAt: sentAt,
         deliveredAt: deliveredAt,
         readAt: readAt,
         failureReason: failureReason,
         retryCount: retryCount,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NotificationDelivery]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationDelivery copyWith({
    Object? id = _Undefined,
    int? alertId,
    String? userId,
    String? channel,
    String? status,
    Object? sentAt = _Undefined,
    Object? deliveredAt = _Undefined,
    Object? readAt = _Undefined,
    Object? failureReason = _Undefined,
    int? retryCount,
    DateTime? createdAt,
  }) {
    return NotificationDelivery(
      id: id is int? ? id : this.id,
      alertId: alertId ?? this.alertId,
      userId: userId ?? this.userId,
      channel: channel ?? this.channel,
      status: status ?? this.status,
      sentAt: sentAt is DateTime? ? sentAt : this.sentAt,
      deliveredAt: deliveredAt is DateTime? ? deliveredAt : this.deliveredAt,
      readAt: readAt is DateTime? ? readAt : this.readAt,
      failureReason: failureReason is String?
          ? failureReason
          : this.failureReason,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
