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

abstract class ComplianceReport implements _i1.SerializableModel {
  ComplianceReport._({
    this.id,
    required this.greenhouseId,
    this.batchId,
    required this.templateId,
    required this.standardCode,
    required this.status,
    this.overallScore,
    required this.totalChecks,
    required this.passedChecks,
    required this.failedChecks,
    this.findings,
    this.recommendations,
    this.reportedBy,
    this.reviewedBy,
    this.reviewedAt,
    this.validUntil,
    required this.createdAt,
  });

  factory ComplianceReport({
    int? id,
    required int greenhouseId,
    String? batchId,
    required int templateId,
    required String standardCode,
    required String status,
    double? overallScore,
    required int totalChecks,
    required int passedChecks,
    required int failedChecks,
    String? findings,
    String? recommendations,
    String? reportedBy,
    String? reviewedBy,
    DateTime? reviewedAt,
    DateTime? validUntil,
    required DateTime createdAt,
  }) = _ComplianceReportImpl;

  factory ComplianceReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return ComplianceReport(
      id: jsonSerialization['id'] as int?,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      batchId: jsonSerialization['batchId'] as String?,
      templateId: jsonSerialization['templateId'] as int,
      standardCode: jsonSerialization['standardCode'] as String,
      status: jsonSerialization['status'] as String,
      overallScore: (jsonSerialization['overallScore'] as num?)?.toDouble(),
      totalChecks: jsonSerialization['totalChecks'] as int,
      passedChecks: jsonSerialization['passedChecks'] as int,
      failedChecks: jsonSerialization['failedChecks'] as int,
      findings: jsonSerialization['findings'] as String?,
      recommendations: jsonSerialization['recommendations'] as String?,
      reportedBy: jsonSerialization['reportedBy'] as String?,
      reviewedBy: jsonSerialization['reviewedBy'] as String?,
      reviewedAt: jsonSerialization['reviewedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['reviewedAt']),
      validUntil: jsonSerialization['validUntil'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['validUntil']),
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

  String? batchId;

  int templateId;

  String standardCode;

  String status;

  double? overallScore;

  int totalChecks;

  int passedChecks;

  int failedChecks;

  String? findings;

  String? recommendations;

  String? reportedBy;

  String? reviewedBy;

  DateTime? reviewedAt;

  DateTime? validUntil;

  DateTime createdAt;

  /// Returns a shallow copy of this [ComplianceReport]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ComplianceReport copyWith({
    int? id,
    int? greenhouseId,
    String? batchId,
    int? templateId,
    String? standardCode,
    String? status,
    double? overallScore,
    int? totalChecks,
    int? passedChecks,
    int? failedChecks,
    String? findings,
    String? recommendations,
    String? reportedBy,
    String? reviewedBy,
    DateTime? reviewedAt,
    DateTime? validUntil,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ComplianceReport',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      if (batchId != null) 'batchId': batchId,
      'templateId': templateId,
      'standardCode': standardCode,
      'status': status,
      if (overallScore != null) 'overallScore': overallScore,
      'totalChecks': totalChecks,
      'passedChecks': passedChecks,
      'failedChecks': failedChecks,
      if (findings != null) 'findings': findings,
      if (recommendations != null) 'recommendations': recommendations,
      if (reportedBy != null) 'reportedBy': reportedBy,
      if (reviewedBy != null) 'reviewedBy': reviewedBy,
      if (reviewedAt != null) 'reviewedAt': reviewedAt?.toJson(),
      if (validUntil != null) 'validUntil': validUntil?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ComplianceReportImpl extends ComplianceReport {
  _ComplianceReportImpl({
    int? id,
    required int greenhouseId,
    String? batchId,
    required int templateId,
    required String standardCode,
    required String status,
    double? overallScore,
    required int totalChecks,
    required int passedChecks,
    required int failedChecks,
    String? findings,
    String? recommendations,
    String? reportedBy,
    String? reviewedBy,
    DateTime? reviewedAt,
    DateTime? validUntil,
    required DateTime createdAt,
  }) : super._(
         id: id,
         greenhouseId: greenhouseId,
         batchId: batchId,
         templateId: templateId,
         standardCode: standardCode,
         status: status,
         overallScore: overallScore,
         totalChecks: totalChecks,
         passedChecks: passedChecks,
         failedChecks: failedChecks,
         findings: findings,
         recommendations: recommendations,
         reportedBy: reportedBy,
         reviewedBy: reviewedBy,
         reviewedAt: reviewedAt,
         validUntil: validUntil,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ComplianceReport]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ComplianceReport copyWith({
    Object? id = _Undefined,
    int? greenhouseId,
    Object? batchId = _Undefined,
    int? templateId,
    String? standardCode,
    String? status,
    Object? overallScore = _Undefined,
    int? totalChecks,
    int? passedChecks,
    int? failedChecks,
    Object? findings = _Undefined,
    Object? recommendations = _Undefined,
    Object? reportedBy = _Undefined,
    Object? reviewedBy = _Undefined,
    Object? reviewedAt = _Undefined,
    Object? validUntil = _Undefined,
    DateTime? createdAt,
  }) {
    return ComplianceReport(
      id: id is int? ? id : this.id,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      batchId: batchId is String? ? batchId : this.batchId,
      templateId: templateId ?? this.templateId,
      standardCode: standardCode ?? this.standardCode,
      status: status ?? this.status,
      overallScore: overallScore is double? ? overallScore : this.overallScore,
      totalChecks: totalChecks ?? this.totalChecks,
      passedChecks: passedChecks ?? this.passedChecks,
      failedChecks: failedChecks ?? this.failedChecks,
      findings: findings is String? ? findings : this.findings,
      recommendations: recommendations is String?
          ? recommendations
          : this.recommendations,
      reportedBy: reportedBy is String? ? reportedBy : this.reportedBy,
      reviewedBy: reviewedBy is String? ? reviewedBy : this.reviewedBy,
      reviewedAt: reviewedAt is DateTime? ? reviewedAt : this.reviewedAt,
      validUntil: validUntil is DateTime? ? validUntil : this.validUntil,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
