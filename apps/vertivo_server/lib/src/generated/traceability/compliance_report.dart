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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ComplianceReport
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = ComplianceReportTable();

  static const db = ComplianceReportRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static ComplianceReportInclude include() {
    return ComplianceReportInclude._();
  }

  static ComplianceReportIncludeList includeList({
    _i1.WhereExpressionBuilder<ComplianceReportTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComplianceReportTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComplianceReportTable>? orderByList,
    ComplianceReportInclude? include,
  }) {
    return ComplianceReportIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ComplianceReport.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ComplianceReport.t),
      include: include,
    );
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

class ComplianceReportUpdateTable
    extends _i1.UpdateTable<ComplianceReportTable> {
  ComplianceReportUpdateTable(super.table);

  _i1.ColumnValue<int, int> greenhouseId(int value) => _i1.ColumnValue(
    table.greenhouseId,
    value,
  );

  _i1.ColumnValue<String, String> batchId(String? value) => _i1.ColumnValue(
    table.batchId,
    value,
  );

  _i1.ColumnValue<int, int> templateId(int value) => _i1.ColumnValue(
    table.templateId,
    value,
  );

  _i1.ColumnValue<String, String> standardCode(String value) => _i1.ColumnValue(
    table.standardCode,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<double, double> overallScore(double? value) =>
      _i1.ColumnValue(
        table.overallScore,
        value,
      );

  _i1.ColumnValue<int, int> totalChecks(int value) => _i1.ColumnValue(
    table.totalChecks,
    value,
  );

  _i1.ColumnValue<int, int> passedChecks(int value) => _i1.ColumnValue(
    table.passedChecks,
    value,
  );

  _i1.ColumnValue<int, int> failedChecks(int value) => _i1.ColumnValue(
    table.failedChecks,
    value,
  );

  _i1.ColumnValue<String, String> findings(String? value) => _i1.ColumnValue(
    table.findings,
    value,
  );

  _i1.ColumnValue<String, String> recommendations(String? value) =>
      _i1.ColumnValue(
        table.recommendations,
        value,
      );

  _i1.ColumnValue<String, String> reportedBy(String? value) => _i1.ColumnValue(
    table.reportedBy,
    value,
  );

  _i1.ColumnValue<String, String> reviewedBy(String? value) => _i1.ColumnValue(
    table.reviewedBy,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> reviewedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.reviewedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> validUntil(DateTime? value) =>
      _i1.ColumnValue(
        table.validUntil,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class ComplianceReportTable extends _i1.Table<int?> {
  ComplianceReportTable({super.tableRelation})
    : super(tableName: 'compliance_reports') {
    updateTable = ComplianceReportUpdateTable(this);
    greenhouseId = _i1.ColumnInt(
      'greenhouseId',
      this,
    );
    batchId = _i1.ColumnString(
      'batchId',
      this,
    );
    templateId = _i1.ColumnInt(
      'templateId',
      this,
    );
    standardCode = _i1.ColumnString(
      'standardCode',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    overallScore = _i1.ColumnDouble(
      'overallScore',
      this,
    );
    totalChecks = _i1.ColumnInt(
      'totalChecks',
      this,
    );
    passedChecks = _i1.ColumnInt(
      'passedChecks',
      this,
    );
    failedChecks = _i1.ColumnInt(
      'failedChecks',
      this,
    );
    findings = _i1.ColumnString(
      'findings',
      this,
    );
    recommendations = _i1.ColumnString(
      'recommendations',
      this,
    );
    reportedBy = _i1.ColumnString(
      'reportedBy',
      this,
    );
    reviewedBy = _i1.ColumnString(
      'reviewedBy',
      this,
    );
    reviewedAt = _i1.ColumnDateTime(
      'reviewedAt',
      this,
    );
    validUntil = _i1.ColumnDateTime(
      'validUntil',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final ComplianceReportUpdateTable updateTable;

  late final _i1.ColumnInt greenhouseId;

  late final _i1.ColumnString batchId;

  late final _i1.ColumnInt templateId;

  late final _i1.ColumnString standardCode;

  late final _i1.ColumnString status;

  late final _i1.ColumnDouble overallScore;

  late final _i1.ColumnInt totalChecks;

  late final _i1.ColumnInt passedChecks;

  late final _i1.ColumnInt failedChecks;

  late final _i1.ColumnString findings;

  late final _i1.ColumnString recommendations;

  late final _i1.ColumnString reportedBy;

  late final _i1.ColumnString reviewedBy;

  late final _i1.ColumnDateTime reviewedAt;

  late final _i1.ColumnDateTime validUntil;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    greenhouseId,
    batchId,
    templateId,
    standardCode,
    status,
    overallScore,
    totalChecks,
    passedChecks,
    failedChecks,
    findings,
    recommendations,
    reportedBy,
    reviewedBy,
    reviewedAt,
    validUntil,
    createdAt,
  ];
}

class ComplianceReportInclude extends _i1.IncludeObject {
  ComplianceReportInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ComplianceReport.t;
}

class ComplianceReportIncludeList extends _i1.IncludeList {
  ComplianceReportIncludeList._({
    _i1.WhereExpressionBuilder<ComplianceReportTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ComplianceReport.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ComplianceReport.t;
}

class ComplianceReportRepository {
  const ComplianceReportRepository._();

  /// Returns a list of [ComplianceReport]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ComplianceReport>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ComplianceReportTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComplianceReportTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComplianceReportTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ComplianceReport>(
      where: where?.call(ComplianceReport.t),
      orderBy: orderBy?.call(ComplianceReport.t),
      orderByList: orderByList?.call(ComplianceReport.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ComplianceReport] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ComplianceReport?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ComplianceReportTable>? where,
    int? offset,
    _i1.OrderByBuilder<ComplianceReportTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComplianceReportTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ComplianceReport>(
      where: where?.call(ComplianceReport.t),
      orderBy: orderBy?.call(ComplianceReport.t),
      orderByList: orderByList?.call(ComplianceReport.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ComplianceReport] by its [id] or null if no such row exists.
  Future<ComplianceReport?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ComplianceReport>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ComplianceReport]s in the list and returns the inserted rows.
  ///
  /// The returned [ComplianceReport]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ComplianceReport>> insert(
    _i1.Session session,
    List<ComplianceReport> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ComplianceReport>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ComplianceReport] and returns the inserted row.
  ///
  /// The returned [ComplianceReport] will have its `id` field set.
  Future<ComplianceReport> insertRow(
    _i1.Session session,
    ComplianceReport row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ComplianceReport>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ComplianceReport]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ComplianceReport>> update(
    _i1.Session session,
    List<ComplianceReport> rows, {
    _i1.ColumnSelections<ComplianceReportTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ComplianceReport>(
      rows,
      columns: columns?.call(ComplianceReport.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ComplianceReport]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ComplianceReport> updateRow(
    _i1.Session session,
    ComplianceReport row, {
    _i1.ColumnSelections<ComplianceReportTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ComplianceReport>(
      row,
      columns: columns?.call(ComplianceReport.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ComplianceReport] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ComplianceReport?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ComplianceReportUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ComplianceReport>(
      id,
      columnValues: columnValues(ComplianceReport.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ComplianceReport]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ComplianceReport>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ComplianceReportUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ComplianceReportTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComplianceReportTable>? orderBy,
    _i1.OrderByListBuilder<ComplianceReportTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ComplianceReport>(
      columnValues: columnValues(ComplianceReport.t.updateTable),
      where: where(ComplianceReport.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ComplianceReport.t),
      orderByList: orderByList?.call(ComplianceReport.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ComplianceReport]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ComplianceReport>> delete(
    _i1.Session session,
    List<ComplianceReport> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ComplianceReport>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ComplianceReport].
  Future<ComplianceReport> deleteRow(
    _i1.Session session,
    ComplianceReport row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ComplianceReport>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ComplianceReport>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ComplianceReportTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ComplianceReport>(
      where: where(ComplianceReport.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ComplianceReportTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ComplianceReport>(
      where: where?.call(ComplianceReport.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ComplianceReport] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ComplianceReportTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ComplianceReport>(
      where: where(ComplianceReport.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
