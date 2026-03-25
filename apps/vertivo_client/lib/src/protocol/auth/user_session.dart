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

abstract class UserSession implements _i1.SerializableModel {
  UserSession._({
    this.id,
    required this.userId,
    required this.deviceId,
    this.deviceName,
    this.deviceType,
    this.ipAddress,
    this.userAgent,
    required this.accessToken,
    required this.refreshToken,
    required this.securityLevel,
    required this.isActive,
    required this.expiresAt,
    required this.lastActivityAt,
    required this.createdAt,
  });

  factory UserSession({
    int? id,
    required String userId,
    required String deviceId,
    String? deviceName,
    String? deviceType,
    String? ipAddress,
    String? userAgent,
    required String accessToken,
    required String refreshToken,
    required String securityLevel,
    required bool isActive,
    required DateTime expiresAt,
    required DateTime lastActivityAt,
    required DateTime createdAt,
  }) = _UserSessionImpl;

  factory UserSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserSession(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      deviceId: jsonSerialization['deviceId'] as String,
      deviceName: jsonSerialization['deviceName'] as String?,
      deviceType: jsonSerialization['deviceType'] as String?,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      userAgent: jsonSerialization['userAgent'] as String?,
      accessToken: jsonSerialization['accessToken'] as String,
      refreshToken: jsonSerialization['refreshToken'] as String,
      securityLevel: jsonSerialization['securityLevel'] as String,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      lastActivityAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastActivityAt'],
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

  String userId;

  String deviceId;

  String? deviceName;

  String? deviceType;

  String? ipAddress;

  String? userAgent;

  String accessToken;

  String refreshToken;

  String securityLevel;

  bool isActive;

  DateTime expiresAt;

  DateTime lastActivityAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [UserSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserSession copyWith({
    int? id,
    String? userId,
    String? deviceId,
    String? deviceName,
    String? deviceType,
    String? ipAddress,
    String? userAgent,
    String? accessToken,
    String? refreshToken,
    String? securityLevel,
    bool? isActive,
    DateTime? expiresAt,
    DateTime? lastActivityAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserSession',
      if (id != null) 'id': id,
      'userId': userId,
      'deviceId': deviceId,
      if (deviceName != null) 'deviceName': deviceName,
      if (deviceType != null) 'deviceType': deviceType,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (userAgent != null) 'userAgent': userAgent,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'securityLevel': securityLevel,
      'isActive': isActive,
      'expiresAt': expiresAt.toJson(),
      'lastActivityAt': lastActivityAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserSessionImpl extends UserSession {
  _UserSessionImpl({
    int? id,
    required String userId,
    required String deviceId,
    String? deviceName,
    String? deviceType,
    String? ipAddress,
    String? userAgent,
    required String accessToken,
    required String refreshToken,
    required String securityLevel,
    required bool isActive,
    required DateTime expiresAt,
    required DateTime lastActivityAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         deviceId: deviceId,
         deviceName: deviceName,
         deviceType: deviceType,
         ipAddress: ipAddress,
         userAgent: userAgent,
         accessToken: accessToken,
         refreshToken: refreshToken,
         securityLevel: securityLevel,
         isActive: isActive,
         expiresAt: expiresAt,
         lastActivityAt: lastActivityAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [UserSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserSession copyWith({
    Object? id = _Undefined,
    String? userId,
    String? deviceId,
    Object? deviceName = _Undefined,
    Object? deviceType = _Undefined,
    Object? ipAddress = _Undefined,
    Object? userAgent = _Undefined,
    String? accessToken,
    String? refreshToken,
    String? securityLevel,
    bool? isActive,
    DateTime? expiresAt,
    DateTime? lastActivityAt,
    DateTime? createdAt,
  }) {
    return UserSession(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName is String? ? deviceName : this.deviceName,
      deviceType: deviceType is String? ? deviceType : this.deviceType,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      userAgent: userAgent is String? ? userAgent : this.userAgent,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      securityLevel: securityLevel ?? this.securityLevel,
      isActive: isActive ?? this.isActive,
      expiresAt: expiresAt ?? this.expiresAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
