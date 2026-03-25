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

abstract class ApiToken implements _i1.SerializableModel {
  ApiToken._({
    this.id,
    required this.userId,
    required this.name,
    required this.token,
    required this.scopes,
    required this.isActive,
    this.lastUsedAt,
    this.expiresAt,
    required this.createdAt,
  });

  factory ApiToken({
    int? id,
    required String userId,
    required String name,
    required String token,
    required List<String> scopes,
    required bool isActive,
    DateTime? lastUsedAt,
    DateTime? expiresAt,
    required DateTime createdAt,
  }) = _ApiTokenImpl;

  factory ApiToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApiToken(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      name: jsonSerialization['name'] as String,
      token: jsonSerialization['token'] as String,
      scopes: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['scopes'],
      ),
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      lastUsedAt: jsonSerialization['lastUsedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastUsedAt']),
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
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

  String name;

  String token;

  List<String> scopes;

  bool isActive;

  DateTime? lastUsedAt;

  DateTime? expiresAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [ApiToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ApiToken copyWith({
    int? id,
    String? userId,
    String? name,
    String? token,
    List<String>? scopes,
    bool? isActive,
    DateTime? lastUsedAt,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApiToken',
      if (id != null) 'id': id,
      'userId': userId,
      'name': name,
      'token': token,
      'scopes': scopes.toJson(),
      'isActive': isActive,
      if (lastUsedAt != null) 'lastUsedAt': lastUsedAt?.toJson(),
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApiTokenImpl extends ApiToken {
  _ApiTokenImpl({
    int? id,
    required String userId,
    required String name,
    required String token,
    required List<String> scopes,
    required bool isActive,
    DateTime? lastUsedAt,
    DateTime? expiresAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         name: name,
         token: token,
         scopes: scopes,
         isActive: isActive,
         lastUsedAt: lastUsedAt,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ApiToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ApiToken copyWith({
    Object? id = _Undefined,
    String? userId,
    String? name,
    String? token,
    List<String>? scopes,
    bool? isActive,
    Object? lastUsedAt = _Undefined,
    Object? expiresAt = _Undefined,
    DateTime? createdAt,
  }) {
    return ApiToken(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      token: token ?? this.token,
      scopes: scopes ?? this.scopes.map((e0) => e0).toList(),
      isActive: isActive ?? this.isActive,
      lastUsedAt: lastUsedAt is DateTime? ? lastUsedAt : this.lastUsedAt,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
