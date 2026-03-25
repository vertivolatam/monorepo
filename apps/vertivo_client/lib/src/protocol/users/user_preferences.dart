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

abstract class UserPreferences implements _i1.SerializableModel {
  UserPreferences._({
    this.id,
    required this.userId,
    required this.notificationEmail,
    required this.notificationPush,
    required this.notificationSms,
    required this.notificationWhatsapp,
    required this.displayLanguage,
    required this.displayTimezone,
    required this.displayTemperatureUnit,
    required this.privacyShareData,
    required this.privacyAnalytics,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserPreferences({
    int? id,
    required String userId,
    required bool notificationEmail,
    required bool notificationPush,
    required bool notificationSms,
    required bool notificationWhatsapp,
    required String displayLanguage,
    required String displayTimezone,
    required String displayTemperatureUnit,
    required bool privacyShareData,
    required bool privacyAnalytics,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserPreferencesImpl;

  factory UserPreferences.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserPreferences(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      notificationEmail: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['notificationEmail'],
      ),
      notificationPush: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['notificationPush'],
      ),
      notificationSms: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['notificationSms'],
      ),
      notificationWhatsapp: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['notificationWhatsapp'],
      ),
      displayLanguage: jsonSerialization['displayLanguage'] as String,
      displayTimezone: jsonSerialization['displayTimezone'] as String,
      displayTemperatureUnit:
          jsonSerialization['displayTemperatureUnit'] as String,
      privacyShareData: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['privacyShareData'],
      ),
      privacyAnalytics: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['privacyAnalytics'],
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

  String userId;

  bool notificationEmail;

  bool notificationPush;

  bool notificationSms;

  bool notificationWhatsapp;

  String displayLanguage;

  String displayTimezone;

  String displayTemperatureUnit;

  bool privacyShareData;

  bool privacyAnalytics;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [UserPreferences]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserPreferences copyWith({
    int? id,
    String? userId,
    bool? notificationEmail,
    bool? notificationPush,
    bool? notificationSms,
    bool? notificationWhatsapp,
    String? displayLanguage,
    String? displayTimezone,
    String? displayTemperatureUnit,
    bool? privacyShareData,
    bool? privacyAnalytics,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserPreferences',
      if (id != null) 'id': id,
      'userId': userId,
      'notificationEmail': notificationEmail,
      'notificationPush': notificationPush,
      'notificationSms': notificationSms,
      'notificationWhatsapp': notificationWhatsapp,
      'displayLanguage': displayLanguage,
      'displayTimezone': displayTimezone,
      'displayTemperatureUnit': displayTemperatureUnit,
      'privacyShareData': privacyShareData,
      'privacyAnalytics': privacyAnalytics,
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

class _UserPreferencesImpl extends UserPreferences {
  _UserPreferencesImpl({
    int? id,
    required String userId,
    required bool notificationEmail,
    required bool notificationPush,
    required bool notificationSms,
    required bool notificationWhatsapp,
    required String displayLanguage,
    required String displayTimezone,
    required String displayTemperatureUnit,
    required bool privacyShareData,
    required bool privacyAnalytics,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         notificationEmail: notificationEmail,
         notificationPush: notificationPush,
         notificationSms: notificationSms,
         notificationWhatsapp: notificationWhatsapp,
         displayLanguage: displayLanguage,
         displayTimezone: displayTimezone,
         displayTemperatureUnit: displayTemperatureUnit,
         privacyShareData: privacyShareData,
         privacyAnalytics: privacyAnalytics,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserPreferences]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserPreferences copyWith({
    Object? id = _Undefined,
    String? userId,
    bool? notificationEmail,
    bool? notificationPush,
    bool? notificationSms,
    bool? notificationWhatsapp,
    String? displayLanguage,
    String? displayTimezone,
    String? displayTemperatureUnit,
    bool? privacyShareData,
    bool? privacyAnalytics,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserPreferences(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      notificationEmail: notificationEmail ?? this.notificationEmail,
      notificationPush: notificationPush ?? this.notificationPush,
      notificationSms: notificationSms ?? this.notificationSms,
      notificationWhatsapp: notificationWhatsapp ?? this.notificationWhatsapp,
      displayLanguage: displayLanguage ?? this.displayLanguage,
      displayTimezone: displayTimezone ?? this.displayTimezone,
      displayTemperatureUnit:
          displayTemperatureUnit ?? this.displayTemperatureUnit,
      privacyShareData: privacyShareData ?? this.privacyShareData,
      privacyAnalytics: privacyAnalytics ?? this.privacyAnalytics,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
