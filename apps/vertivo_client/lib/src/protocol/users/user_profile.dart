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

abstract class UserProfile implements _i1.SerializableModel {
  UserProfile._({
    this.id,
    required this.userId,
    required this.segment,
    this.familySize,
    this.dietaryPreferences,
    this.gardeningExperience,
    this.businessType,
    this.businessName,
    this.qualityRequirements,
    this.supplyChainGoals,
    this.complianceRequirements,
    this.sustainabilityGoals,
    this.erpIntegration,
    this.certifications,
    this.capabilities,
    this.workSchedule,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile({
    int? id,
    required String userId,
    required String segment,
    int? familySize,
    List<String>? dietaryPreferences,
    String? gardeningExperience,
    String? businessType,
    String? businessName,
    String? qualityRequirements,
    String? supplyChainGoals,
    List<String>? complianceRequirements,
    String? sustainabilityGoals,
    String? erpIntegration,
    List<String>? certifications,
    List<String>? capabilities,
    String? workSchedule,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfileImpl;

  factory UserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfile(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      segment: jsonSerialization['segment'] as String,
      familySize: jsonSerialization['familySize'] as int?,
      dietaryPreferences: jsonSerialization['dietaryPreferences'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['dietaryPreferences'],
            ),
      gardeningExperience: jsonSerialization['gardeningExperience'] as String?,
      businessType: jsonSerialization['businessType'] as String?,
      businessName: jsonSerialization['businessName'] as String?,
      qualityRequirements: jsonSerialization['qualityRequirements'] as String?,
      supplyChainGoals: jsonSerialization['supplyChainGoals'] as String?,
      complianceRequirements:
          jsonSerialization['complianceRequirements'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['complianceRequirements'],
            ),
      sustainabilityGoals: jsonSerialization['sustainabilityGoals'] as String?,
      erpIntegration: jsonSerialization['erpIntegration'] as String?,
      certifications: jsonSerialization['certifications'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['certifications'],
            ),
      capabilities: jsonSerialization['capabilities'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['capabilities'],
            ),
      workSchedule: jsonSerialization['workSchedule'] as String?,
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

  String segment;

  int? familySize;

  List<String>? dietaryPreferences;

  String? gardeningExperience;

  String? businessType;

  String? businessName;

  String? qualityRequirements;

  String? supplyChainGoals;

  List<String>? complianceRequirements;

  String? sustainabilityGoals;

  String? erpIntegration;

  List<String>? certifications;

  List<String>? capabilities;

  String? workSchedule;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfile copyWith({
    int? id,
    String? userId,
    String? segment,
    int? familySize,
    List<String>? dietaryPreferences,
    String? gardeningExperience,
    String? businessType,
    String? businessName,
    String? qualityRequirements,
    String? supplyChainGoals,
    List<String>? complianceRequirements,
    String? sustainabilityGoals,
    String? erpIntegration,
    List<String>? certifications,
    List<String>? capabilities,
    String? workSchedule,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserProfile',
      if (id != null) 'id': id,
      'userId': userId,
      'segment': segment,
      if (familySize != null) 'familySize': familySize,
      if (dietaryPreferences != null)
        'dietaryPreferences': dietaryPreferences?.toJson(),
      if (gardeningExperience != null)
        'gardeningExperience': gardeningExperience,
      if (businessType != null) 'businessType': businessType,
      if (businessName != null) 'businessName': businessName,
      if (qualityRequirements != null)
        'qualityRequirements': qualityRequirements,
      if (supplyChainGoals != null) 'supplyChainGoals': supplyChainGoals,
      if (complianceRequirements != null)
        'complianceRequirements': complianceRequirements?.toJson(),
      if (sustainabilityGoals != null)
        'sustainabilityGoals': sustainabilityGoals,
      if (erpIntegration != null) 'erpIntegration': erpIntegration,
      if (certifications != null) 'certifications': certifications?.toJson(),
      if (capabilities != null) 'capabilities': capabilities?.toJson(),
      if (workSchedule != null) 'workSchedule': workSchedule,
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

class _UserProfileImpl extends UserProfile {
  _UserProfileImpl({
    int? id,
    required String userId,
    required String segment,
    int? familySize,
    List<String>? dietaryPreferences,
    String? gardeningExperience,
    String? businessType,
    String? businessName,
    String? qualityRequirements,
    String? supplyChainGoals,
    List<String>? complianceRequirements,
    String? sustainabilityGoals,
    String? erpIntegration,
    List<String>? certifications,
    List<String>? capabilities,
    String? workSchedule,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         segment: segment,
         familySize: familySize,
         dietaryPreferences: dietaryPreferences,
         gardeningExperience: gardeningExperience,
         businessType: businessType,
         businessName: businessName,
         qualityRequirements: qualityRequirements,
         supplyChainGoals: supplyChainGoals,
         complianceRequirements: complianceRequirements,
         sustainabilityGoals: sustainabilityGoals,
         erpIntegration: erpIntegration,
         certifications: certifications,
         capabilities: capabilities,
         workSchedule: workSchedule,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfile copyWith({
    Object? id = _Undefined,
    String? userId,
    String? segment,
    Object? familySize = _Undefined,
    Object? dietaryPreferences = _Undefined,
    Object? gardeningExperience = _Undefined,
    Object? businessType = _Undefined,
    Object? businessName = _Undefined,
    Object? qualityRequirements = _Undefined,
    Object? supplyChainGoals = _Undefined,
    Object? complianceRequirements = _Undefined,
    Object? sustainabilityGoals = _Undefined,
    Object? erpIntegration = _Undefined,
    Object? certifications = _Undefined,
    Object? capabilities = _Undefined,
    Object? workSchedule = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      segment: segment ?? this.segment,
      familySize: familySize is int? ? familySize : this.familySize,
      dietaryPreferences: dietaryPreferences is List<String>?
          ? dietaryPreferences
          : this.dietaryPreferences?.map((e0) => e0).toList(),
      gardeningExperience: gardeningExperience is String?
          ? gardeningExperience
          : this.gardeningExperience,
      businessType: businessType is String? ? businessType : this.businessType,
      businessName: businessName is String? ? businessName : this.businessName,
      qualityRequirements: qualityRequirements is String?
          ? qualityRequirements
          : this.qualityRequirements,
      supplyChainGoals: supplyChainGoals is String?
          ? supplyChainGoals
          : this.supplyChainGoals,
      complianceRequirements: complianceRequirements is List<String>?
          ? complianceRequirements
          : this.complianceRequirements?.map((e0) => e0).toList(),
      sustainabilityGoals: sustainabilityGoals is String?
          ? sustainabilityGoals
          : this.sustainabilityGoals,
      erpIntegration: erpIntegration is String?
          ? erpIntegration
          : this.erpIntegration,
      certifications: certifications is List<String>?
          ? certifications
          : this.certifications?.map((e0) => e0).toList(),
      capabilities: capabilities is List<String>?
          ? capabilities
          : this.capabilities?.map((e0) => e0).toList(),
      workSchedule: workSchedule is String? ? workSchedule : this.workSchedule,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
