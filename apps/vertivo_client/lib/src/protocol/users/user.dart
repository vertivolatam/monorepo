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

abstract class User implements _i1.SerializableModel {
  User._({
    this.id,
    required this.authIdentifier,
    required this.email,
    required this.displayName,
    required this.segment,
    required this.isActive,
    required this.isEmailVerified,
    required this.passwordHash,
    required this.twoFactorEnabled,
    this.twoFactorSecret,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User({
    int? id,
    required String authIdentifier,
    required String email,
    required String displayName,
    required String segment,
    required bool isActive,
    required bool isEmailVerified,
    required String passwordHash,
    required bool twoFactorEnabled,
    String? twoFactorSecret,
    DateTime? lastLoginAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserImpl;

  factory User.fromJson(Map<String, dynamic> jsonSerialization) {
    return User(
      id: jsonSerialization['id'] as int?,
      authIdentifier: jsonSerialization['authIdentifier'] as String,
      email: jsonSerialization['email'] as String,
      displayName: jsonSerialization['displayName'] as String,
      segment: jsonSerialization['segment'] as String,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      isEmailVerified: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isEmailVerified'],
      ),
      passwordHash: jsonSerialization['passwordHash'] as String,
      twoFactorEnabled: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['twoFactorEnabled'],
      ),
      twoFactorSecret: jsonSerialization['twoFactorSecret'] as String?,
      lastLoginAt: jsonSerialization['lastLoginAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastLoginAt'],
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

  String authIdentifier;

  String email;

  String displayName;

  String segment;

  bool isActive;

  bool isEmailVerified;

  String passwordHash;

  bool twoFactorEnabled;

  String? twoFactorSecret;

  DateTime? lastLoginAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  User copyWith({
    int? id,
    String? authIdentifier,
    String? email,
    String? displayName,
    String? segment,
    bool? isActive,
    bool? isEmailVerified,
    String? passwordHash,
    bool? twoFactorEnabled,
    String? twoFactorSecret,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'User',
      if (id != null) 'id': id,
      'authIdentifier': authIdentifier,
      'email': email,
      'displayName': displayName,
      'segment': segment,
      'isActive': isActive,
      'isEmailVerified': isEmailVerified,
      'passwordHash': passwordHash,
      'twoFactorEnabled': twoFactorEnabled,
      if (twoFactorSecret != null) 'twoFactorSecret': twoFactorSecret,
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
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

class _UserImpl extends User {
  _UserImpl({
    int? id,
    required String authIdentifier,
    required String email,
    required String displayName,
    required String segment,
    required bool isActive,
    required bool isEmailVerified,
    required String passwordHash,
    required bool twoFactorEnabled,
    String? twoFactorSecret,
    DateTime? lastLoginAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         authIdentifier: authIdentifier,
         email: email,
         displayName: displayName,
         segment: segment,
         isActive: isActive,
         isEmailVerified: isEmailVerified,
         passwordHash: passwordHash,
         twoFactorEnabled: twoFactorEnabled,
         twoFactorSecret: twoFactorSecret,
         lastLoginAt: lastLoginAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  User copyWith({
    Object? id = _Undefined,
    String? authIdentifier,
    String? email,
    String? displayName,
    String? segment,
    bool? isActive,
    bool? isEmailVerified,
    String? passwordHash,
    bool? twoFactorEnabled,
    Object? twoFactorSecret = _Undefined,
    Object? lastLoginAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id is int? ? id : this.id,
      authIdentifier: authIdentifier ?? this.authIdentifier,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      segment: segment ?? this.segment,
      isActive: isActive ?? this.isActive,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      passwordHash: passwordHash ?? this.passwordHash,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      twoFactorSecret: twoFactorSecret is String?
          ? twoFactorSecret
          : this.twoFactorSecret,
      lastLoginAt: lastLoginAt is DateTime? ? lastLoginAt : this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
