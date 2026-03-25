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

abstract class KpiMetric
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  KpiMetric._({
    this.id,
    required this.userId,
    this.greenhouseId,
    required this.metricType,
    required this.value,
    this.unit,
    required this.periodStart,
    required this.periodEnd,
    required this.periodType,
    this.previousValue,
    this.changePercent,
    this.targetValue,
    this.segment,
    this.notes,
    required this.createdAt,
  });

  factory KpiMetric({
    int? id,
    required String userId,
    int? greenhouseId,
    required String metricType,
    required double value,
    String? unit,
    required DateTime periodStart,
    required DateTime periodEnd,
    required String periodType,
    double? previousValue,
    double? changePercent,
    double? targetValue,
    String? segment,
    String? notes,
    required DateTime createdAt,
  }) = _KpiMetricImpl;

  factory KpiMetric.fromJson(Map<String, dynamic> jsonSerialization) {
    return KpiMetric(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      greenhouseId: jsonSerialization['greenhouseId'] as int?,
      metricType: jsonSerialization['metricType'] as String,
      value: (jsonSerialization['value'] as num).toDouble(),
      unit: jsonSerialization['unit'] as String?,
      periodStart: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['periodStart'],
      ),
      periodEnd: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['periodEnd'],
      ),
      periodType: jsonSerialization['periodType'] as String,
      previousValue: (jsonSerialization['previousValue'] as num?)?.toDouble(),
      changePercent: (jsonSerialization['changePercent'] as num?)?.toDouble(),
      targetValue: (jsonSerialization['targetValue'] as num?)?.toDouble(),
      segment: jsonSerialization['segment'] as String?,
      notes: jsonSerialization['notes'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = KpiMetricTable();

  static const db = KpiMetricRepository._();

  @override
  int? id;

  String userId;

  int? greenhouseId;

  String metricType;

  double value;

  String? unit;

  DateTime periodStart;

  DateTime periodEnd;

  String periodType;

  double? previousValue;

  double? changePercent;

  double? targetValue;

  String? segment;

  String? notes;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [KpiMetric]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  KpiMetric copyWith({
    int? id,
    String? userId,
    int? greenhouseId,
    String? metricType,
    double? value,
    String? unit,
    DateTime? periodStart,
    DateTime? periodEnd,
    String? periodType,
    double? previousValue,
    double? changePercent,
    double? targetValue,
    String? segment,
    String? notes,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'KpiMetric',
      if (id != null) 'id': id,
      'userId': userId,
      if (greenhouseId != null) 'greenhouseId': greenhouseId,
      'metricType': metricType,
      'value': value,
      if (unit != null) 'unit': unit,
      'periodStart': periodStart.toJson(),
      'periodEnd': periodEnd.toJson(),
      'periodType': periodType,
      if (previousValue != null) 'previousValue': previousValue,
      if (changePercent != null) 'changePercent': changePercent,
      if (targetValue != null) 'targetValue': targetValue,
      if (segment != null) 'segment': segment,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'KpiMetric',
      if (id != null) 'id': id,
      'userId': userId,
      if (greenhouseId != null) 'greenhouseId': greenhouseId,
      'metricType': metricType,
      'value': value,
      if (unit != null) 'unit': unit,
      'periodStart': periodStart.toJson(),
      'periodEnd': periodEnd.toJson(),
      'periodType': periodType,
      if (previousValue != null) 'previousValue': previousValue,
      if (changePercent != null) 'changePercent': changePercent,
      if (targetValue != null) 'targetValue': targetValue,
      if (segment != null) 'segment': segment,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
    };
  }

  static KpiMetricInclude include() {
    return KpiMetricInclude._();
  }

  static KpiMetricIncludeList includeList({
    _i1.WhereExpressionBuilder<KpiMetricTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<KpiMetricTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<KpiMetricTable>? orderByList,
    KpiMetricInclude? include,
  }) {
    return KpiMetricIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(KpiMetric.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(KpiMetric.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _KpiMetricImpl extends KpiMetric {
  _KpiMetricImpl({
    int? id,
    required String userId,
    int? greenhouseId,
    required String metricType,
    required double value,
    String? unit,
    required DateTime periodStart,
    required DateTime periodEnd,
    required String periodType,
    double? previousValue,
    double? changePercent,
    double? targetValue,
    String? segment,
    String? notes,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         greenhouseId: greenhouseId,
         metricType: metricType,
         value: value,
         unit: unit,
         periodStart: periodStart,
         periodEnd: periodEnd,
         periodType: periodType,
         previousValue: previousValue,
         changePercent: changePercent,
         targetValue: targetValue,
         segment: segment,
         notes: notes,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [KpiMetric]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  KpiMetric copyWith({
    Object? id = _Undefined,
    String? userId,
    Object? greenhouseId = _Undefined,
    String? metricType,
    double? value,
    Object? unit = _Undefined,
    DateTime? periodStart,
    DateTime? periodEnd,
    String? periodType,
    Object? previousValue = _Undefined,
    Object? changePercent = _Undefined,
    Object? targetValue = _Undefined,
    Object? segment = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
  }) {
    return KpiMetric(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      greenhouseId: greenhouseId is int? ? greenhouseId : this.greenhouseId,
      metricType: metricType ?? this.metricType,
      value: value ?? this.value,
      unit: unit is String? ? unit : this.unit,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      periodType: periodType ?? this.periodType,
      previousValue: previousValue is double?
          ? previousValue
          : this.previousValue,
      changePercent: changePercent is double?
          ? changePercent
          : this.changePercent,
      targetValue: targetValue is double? ? targetValue : this.targetValue,
      segment: segment is String? ? segment : this.segment,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class KpiMetricUpdateTable extends _i1.UpdateTable<KpiMetricTable> {
  KpiMetricUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> greenhouseId(int? value) => _i1.ColumnValue(
    table.greenhouseId,
    value,
  );

  _i1.ColumnValue<String, String> metricType(String value) => _i1.ColumnValue(
    table.metricType,
    value,
  );

  _i1.ColumnValue<double, double> value(double value) => _i1.ColumnValue(
    table.value,
    value,
  );

  _i1.ColumnValue<String, String> unit(String? value) => _i1.ColumnValue(
    table.unit,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> periodStart(DateTime value) =>
      _i1.ColumnValue(
        table.periodStart,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> periodEnd(DateTime value) =>
      _i1.ColumnValue(
        table.periodEnd,
        value,
      );

  _i1.ColumnValue<String, String> periodType(String value) => _i1.ColumnValue(
    table.periodType,
    value,
  );

  _i1.ColumnValue<double, double> previousValue(double? value) =>
      _i1.ColumnValue(
        table.previousValue,
        value,
      );

  _i1.ColumnValue<double, double> changePercent(double? value) =>
      _i1.ColumnValue(
        table.changePercent,
        value,
      );

  _i1.ColumnValue<double, double> targetValue(double? value) => _i1.ColumnValue(
    table.targetValue,
    value,
  );

  _i1.ColumnValue<String, String> segment(String? value) => _i1.ColumnValue(
    table.segment,
    value,
  );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class KpiMetricTable extends _i1.Table<int?> {
  KpiMetricTable({super.tableRelation}) : super(tableName: 'kpi_metrics') {
    updateTable = KpiMetricUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    greenhouseId = _i1.ColumnInt(
      'greenhouseId',
      this,
    );
    metricType = _i1.ColumnString(
      'metricType',
      this,
    );
    value = _i1.ColumnDouble(
      'value',
      this,
    );
    unit = _i1.ColumnString(
      'unit',
      this,
    );
    periodStart = _i1.ColumnDateTime(
      'periodStart',
      this,
    );
    periodEnd = _i1.ColumnDateTime(
      'periodEnd',
      this,
    );
    periodType = _i1.ColumnString(
      'periodType',
      this,
    );
    previousValue = _i1.ColumnDouble(
      'previousValue',
      this,
    );
    changePercent = _i1.ColumnDouble(
      'changePercent',
      this,
    );
    targetValue = _i1.ColumnDouble(
      'targetValue',
      this,
    );
    segment = _i1.ColumnString(
      'segment',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final KpiMetricUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnInt greenhouseId;

  late final _i1.ColumnString metricType;

  late final _i1.ColumnDouble value;

  late final _i1.ColumnString unit;

  late final _i1.ColumnDateTime periodStart;

  late final _i1.ColumnDateTime periodEnd;

  late final _i1.ColumnString periodType;

  late final _i1.ColumnDouble previousValue;

  late final _i1.ColumnDouble changePercent;

  late final _i1.ColumnDouble targetValue;

  late final _i1.ColumnString segment;

  late final _i1.ColumnString notes;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    greenhouseId,
    metricType,
    value,
    unit,
    periodStart,
    periodEnd,
    periodType,
    previousValue,
    changePercent,
    targetValue,
    segment,
    notes,
    createdAt,
  ];
}

class KpiMetricInclude extends _i1.IncludeObject {
  KpiMetricInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => KpiMetric.t;
}

class KpiMetricIncludeList extends _i1.IncludeList {
  KpiMetricIncludeList._({
    _i1.WhereExpressionBuilder<KpiMetricTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(KpiMetric.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => KpiMetric.t;
}

class KpiMetricRepository {
  const KpiMetricRepository._();

  /// Returns a list of [KpiMetric]s matching the given query parameters.
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
  Future<List<KpiMetric>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<KpiMetricTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<KpiMetricTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<KpiMetricTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<KpiMetric>(
      where: where?.call(KpiMetric.t),
      orderBy: orderBy?.call(KpiMetric.t),
      orderByList: orderByList?.call(KpiMetric.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [KpiMetric] matching the given query parameters.
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
  Future<KpiMetric?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<KpiMetricTable>? where,
    int? offset,
    _i1.OrderByBuilder<KpiMetricTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<KpiMetricTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<KpiMetric>(
      where: where?.call(KpiMetric.t),
      orderBy: orderBy?.call(KpiMetric.t),
      orderByList: orderByList?.call(KpiMetric.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [KpiMetric] by its [id] or null if no such row exists.
  Future<KpiMetric?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<KpiMetric>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [KpiMetric]s in the list and returns the inserted rows.
  ///
  /// The returned [KpiMetric]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<KpiMetric>> insert(
    _i1.Session session,
    List<KpiMetric> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<KpiMetric>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [KpiMetric] and returns the inserted row.
  ///
  /// The returned [KpiMetric] will have its `id` field set.
  Future<KpiMetric> insertRow(
    _i1.Session session,
    KpiMetric row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<KpiMetric>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [KpiMetric]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<KpiMetric>> update(
    _i1.Session session,
    List<KpiMetric> rows, {
    _i1.ColumnSelections<KpiMetricTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<KpiMetric>(
      rows,
      columns: columns?.call(KpiMetric.t),
      transaction: transaction,
    );
  }

  /// Updates a single [KpiMetric]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<KpiMetric> updateRow(
    _i1.Session session,
    KpiMetric row, {
    _i1.ColumnSelections<KpiMetricTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<KpiMetric>(
      row,
      columns: columns?.call(KpiMetric.t),
      transaction: transaction,
    );
  }

  /// Updates a single [KpiMetric] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<KpiMetric?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<KpiMetricUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<KpiMetric>(
      id,
      columnValues: columnValues(KpiMetric.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [KpiMetric]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<KpiMetric>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<KpiMetricUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<KpiMetricTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<KpiMetricTable>? orderBy,
    _i1.OrderByListBuilder<KpiMetricTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<KpiMetric>(
      columnValues: columnValues(KpiMetric.t.updateTable),
      where: where(KpiMetric.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(KpiMetric.t),
      orderByList: orderByList?.call(KpiMetric.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [KpiMetric]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<KpiMetric>> delete(
    _i1.Session session,
    List<KpiMetric> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<KpiMetric>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [KpiMetric].
  Future<KpiMetric> deleteRow(
    _i1.Session session,
    KpiMetric row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<KpiMetric>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<KpiMetric>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<KpiMetricTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<KpiMetric>(
      where: where(KpiMetric.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<KpiMetricTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<KpiMetric>(
      where: where?.call(KpiMetric.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [KpiMetric] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<KpiMetricTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<KpiMetric>(
      where: where(KpiMetric.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
