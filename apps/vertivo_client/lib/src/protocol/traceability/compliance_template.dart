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

abstract class ComplianceTemplate implements _i1.SerializableModel {
  ComplianceTemplate._({
    this.id,
    required this.standardCode,
    required this.standardName,
    required this.version,
    required this.region,
    required this.category,
    required this.requiredEventTypes,
    this.requiredDocuments,
    this.validationRules,
    required this.isActive,
    required this.effectiveFrom,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ComplianceTemplate({
    int? id,
    required String standardCode,
    required String standardName,
    required String version,
    required String region,
    required String category,
    required List<String> requiredEventTypes,
    List<String>? requiredDocuments,
    String? validationRules,
    required bool isActive,
    required DateTime effectiveFrom,
    DateTime? expiresAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ComplianceTemplateImpl;

  factory ComplianceTemplate.fromJson(Map<String, dynamic> jsonSerialization) {
    return ComplianceTemplate(
      id: jsonSerialization['id'] as int?,
      standardCode: jsonSerialization['standardCode'] as String,
      standardName: jsonSerialization['standardName'] as String,
      version: jsonSerialization['version'] as String,
      region: jsonSerialization['region'] as String,
      category: jsonSerialization['category'] as String,
      requiredEventTypes: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['requiredEventTypes'],
      ),
      requiredDocuments: jsonSerialization['requiredDocuments'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['requiredDocuments'],
            ),
      validationRules: jsonSerialization['validationRules'] as String?,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      effectiveFrom: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['effectiveFrom'],
      ),
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
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

  String standardCode;

  String standardName;

  String version;

  String region;

  String category;

  List<String> requiredEventTypes;

  List<String>? requiredDocuments;

  String? validationRules;

  bool isActive;

  DateTime effectiveFrom;

  DateTime? expiresAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [ComplianceTemplate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ComplianceTemplate copyWith({
    int? id,
    String? standardCode,
    String? standardName,
    String? version,
    String? region,
    String? category,
    List<String>? requiredEventTypes,
    List<String>? requiredDocuments,
    String? validationRules,
    bool? isActive,
    DateTime? effectiveFrom,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ComplianceTemplate',
      if (id != null) 'id': id,
      'standardCode': standardCode,
      'standardName': standardName,
      'version': version,
      'region': region,
      'category': category,
      'requiredEventTypes': requiredEventTypes.toJson(),
      if (requiredDocuments != null)
        'requiredDocuments': requiredDocuments?.toJson(),
      if (validationRules != null) 'validationRules': validationRules,
      'isActive': isActive,
      'effectiveFrom': effectiveFrom.toJson(),
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
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

class _ComplianceTemplateImpl extends ComplianceTemplate {
  _ComplianceTemplateImpl({
    int? id,
    required String standardCode,
    required String standardName,
    required String version,
    required String region,
    required String category,
    required List<String> requiredEventTypes,
    List<String>? requiredDocuments,
    String? validationRules,
    required bool isActive,
    required DateTime effectiveFrom,
    DateTime? expiresAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         standardCode: standardCode,
         standardName: standardName,
         version: version,
         region: region,
         category: category,
         requiredEventTypes: requiredEventTypes,
         requiredDocuments: requiredDocuments,
         validationRules: validationRules,
         isActive: isActive,
         effectiveFrom: effectiveFrom,
         expiresAt: expiresAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ComplianceTemplate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ComplianceTemplate copyWith({
    Object? id = _Undefined,
    String? standardCode,
    String? standardName,
    String? version,
    String? region,
    String? category,
    List<String>? requiredEventTypes,
    Object? requiredDocuments = _Undefined,
    Object? validationRules = _Undefined,
    bool? isActive,
    DateTime? effectiveFrom,
    Object? expiresAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ComplianceTemplate(
      id: id is int? ? id : this.id,
      standardCode: standardCode ?? this.standardCode,
      standardName: standardName ?? this.standardName,
      version: version ?? this.version,
      region: region ?? this.region,
      category: category ?? this.category,
      requiredEventTypes:
          requiredEventTypes ??
          this.requiredEventTypes.map((e0) => e0).toList(),
      requiredDocuments: requiredDocuments is List<String>?
          ? requiredDocuments
          : this.requiredDocuments?.map((e0) => e0).toList(),
      validationRules: validationRules is String?
          ? validationRules
          : this.validationRules,
      isActive: isActive ?? this.isActive,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
