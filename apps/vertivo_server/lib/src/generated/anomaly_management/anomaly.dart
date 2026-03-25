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

abstract class Anomaly
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Anomaly._({
    this.id,
    required this.greenhouseId,
    this.plantId,
    this.trayId,
    required this.anomalyType,
    required this.severity,
    required this.detectionMethod,
    this.measurementType,
    this.expectedValue,
    this.actualValue,
    this.deviationPercent,
    required this.description,
    required this.isResolved,
    this.resolvedAt,
    this.resolvedBy,
    this.resolutionNotes,
    this.sourceEntityType,
    this.sourceEntityId,
    required this.createdAt,
  });

  factory Anomaly({
    int? id,
    required int greenhouseId,
    int? plantId,
    int? trayId,
    required String anomalyType,
    required String severity,
    required String detectionMethod,
    String? measurementType,
    double? expectedValue,
    double? actualValue,
    double? deviationPercent,
    required String description,
    required bool isResolved,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNotes,
    String? sourceEntityType,
    int? sourceEntityId,
    required DateTime createdAt,
  }) = _AnomalyImpl;

  factory Anomaly.fromJson(Map<String, dynamic> jsonSerialization) {
    return Anomaly(
      id: jsonSerialization['id'] as int?,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      plantId: jsonSerialization['plantId'] as int?,
      trayId: jsonSerialization['trayId'] as int?,
      anomalyType: jsonSerialization['anomalyType'] as String,
      severity: jsonSerialization['severity'] as String,
      detectionMethod: jsonSerialization['detectionMethod'] as String,
      measurementType: jsonSerialization['measurementType'] as String?,
      expectedValue: (jsonSerialization['expectedValue'] as num?)?.toDouble(),
      actualValue: (jsonSerialization['actualValue'] as num?)?.toDouble(),
      deviationPercent: (jsonSerialization['deviationPercent'] as num?)
          ?.toDouble(),
      description: jsonSerialization['description'] as String,
      isResolved: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isResolved'],
      ),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
      resolvedBy: jsonSerialization['resolvedBy'] as String?,
      resolutionNotes: jsonSerialization['resolutionNotes'] as String?,
      sourceEntityType: jsonSerialization['sourceEntityType'] as String?,
      sourceEntityId: jsonSerialization['sourceEntityId'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AnomalyTable();

  static const db = AnomalyRepository._();

  @override
  int? id;

  int greenhouseId;

  int? plantId;

  int? trayId;

  String anomalyType;

  String severity;

  String detectionMethod;

  String? measurementType;

  double? expectedValue;

  double? actualValue;

  double? deviationPercent;

  String description;

  bool isResolved;

  DateTime? resolvedAt;

  String? resolvedBy;

  String? resolutionNotes;

  String? sourceEntityType;

  int? sourceEntityId;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Anomaly]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Anomaly copyWith({
    int? id,
    int? greenhouseId,
    int? plantId,
    int? trayId,
    String? anomalyType,
    String? severity,
    String? detectionMethod,
    String? measurementType,
    double? expectedValue,
    double? actualValue,
    double? deviationPercent,
    String? description,
    bool? isResolved,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNotes,
    String? sourceEntityType,
    int? sourceEntityId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Anomaly',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      if (plantId != null) 'plantId': plantId,
      if (trayId != null) 'trayId': trayId,
      'anomalyType': anomalyType,
      'severity': severity,
      'detectionMethod': detectionMethod,
      if (measurementType != null) 'measurementType': measurementType,
      if (expectedValue != null) 'expectedValue': expectedValue,
      if (actualValue != null) 'actualValue': actualValue,
      if (deviationPercent != null) 'deviationPercent': deviationPercent,
      'description': description,
      'isResolved': isResolved,
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      if (resolvedBy != null) 'resolvedBy': resolvedBy,
      if (resolutionNotes != null) 'resolutionNotes': resolutionNotes,
      if (sourceEntityType != null) 'sourceEntityType': sourceEntityType,
      if (sourceEntityId != null) 'sourceEntityId': sourceEntityId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Anomaly',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      if (plantId != null) 'plantId': plantId,
      if (trayId != null) 'trayId': trayId,
      'anomalyType': anomalyType,
      'severity': severity,
      'detectionMethod': detectionMethod,
      if (measurementType != null) 'measurementType': measurementType,
      if (expectedValue != null) 'expectedValue': expectedValue,
      if (actualValue != null) 'actualValue': actualValue,
      if (deviationPercent != null) 'deviationPercent': deviationPercent,
      'description': description,
      'isResolved': isResolved,
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      if (resolvedBy != null) 'resolvedBy': resolvedBy,
      if (resolutionNotes != null) 'resolutionNotes': resolutionNotes,
      if (sourceEntityType != null) 'sourceEntityType': sourceEntityType,
      if (sourceEntityId != null) 'sourceEntityId': sourceEntityId,
      'createdAt': createdAt.toJson(),
    };
  }

  static AnomalyInclude include() {
    return AnomalyInclude._();
  }

  static AnomalyIncludeList includeList({
    _i1.WhereExpressionBuilder<AnomalyTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnomalyTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnomalyTable>? orderByList,
    AnomalyInclude? include,
  }) {
    return AnomalyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Anomaly.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Anomaly.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnomalyImpl extends Anomaly {
  _AnomalyImpl({
    int? id,
    required int greenhouseId,
    int? plantId,
    int? trayId,
    required String anomalyType,
    required String severity,
    required String detectionMethod,
    String? measurementType,
    double? expectedValue,
    double? actualValue,
    double? deviationPercent,
    required String description,
    required bool isResolved,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolutionNotes,
    String? sourceEntityType,
    int? sourceEntityId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         greenhouseId: greenhouseId,
         plantId: plantId,
         trayId: trayId,
         anomalyType: anomalyType,
         severity: severity,
         detectionMethod: detectionMethod,
         measurementType: measurementType,
         expectedValue: expectedValue,
         actualValue: actualValue,
         deviationPercent: deviationPercent,
         description: description,
         isResolved: isResolved,
         resolvedAt: resolvedAt,
         resolvedBy: resolvedBy,
         resolutionNotes: resolutionNotes,
         sourceEntityType: sourceEntityType,
         sourceEntityId: sourceEntityId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Anomaly]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Anomaly copyWith({
    Object? id = _Undefined,
    int? greenhouseId,
    Object? plantId = _Undefined,
    Object? trayId = _Undefined,
    String? anomalyType,
    String? severity,
    String? detectionMethod,
    Object? measurementType = _Undefined,
    Object? expectedValue = _Undefined,
    Object? actualValue = _Undefined,
    Object? deviationPercent = _Undefined,
    String? description,
    bool? isResolved,
    Object? resolvedAt = _Undefined,
    Object? resolvedBy = _Undefined,
    Object? resolutionNotes = _Undefined,
    Object? sourceEntityType = _Undefined,
    Object? sourceEntityId = _Undefined,
    DateTime? createdAt,
  }) {
    return Anomaly(
      id: id is int? ? id : this.id,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      plantId: plantId is int? ? plantId : this.plantId,
      trayId: trayId is int? ? trayId : this.trayId,
      anomalyType: anomalyType ?? this.anomalyType,
      severity: severity ?? this.severity,
      detectionMethod: detectionMethod ?? this.detectionMethod,
      measurementType: measurementType is String?
          ? measurementType
          : this.measurementType,
      expectedValue: expectedValue is double?
          ? expectedValue
          : this.expectedValue,
      actualValue: actualValue is double? ? actualValue : this.actualValue,
      deviationPercent: deviationPercent is double?
          ? deviationPercent
          : this.deviationPercent,
      description: description ?? this.description,
      isResolved: isResolved ?? this.isResolved,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
      resolvedBy: resolvedBy is String? ? resolvedBy : this.resolvedBy,
      resolutionNotes: resolutionNotes is String?
          ? resolutionNotes
          : this.resolutionNotes,
      sourceEntityType: sourceEntityType is String?
          ? sourceEntityType
          : this.sourceEntityType,
      sourceEntityId: sourceEntityId is int?
          ? sourceEntityId
          : this.sourceEntityId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AnomalyUpdateTable extends _i1.UpdateTable<AnomalyTable> {
  AnomalyUpdateTable(super.table);

  _i1.ColumnValue<int, int> greenhouseId(int value) => _i1.ColumnValue(
    table.greenhouseId,
    value,
  );

  _i1.ColumnValue<int, int> plantId(int? value) => _i1.ColumnValue(
    table.plantId,
    value,
  );

  _i1.ColumnValue<int, int> trayId(int? value) => _i1.ColumnValue(
    table.trayId,
    value,
  );

  _i1.ColumnValue<String, String> anomalyType(String value) => _i1.ColumnValue(
    table.anomalyType,
    value,
  );

  _i1.ColumnValue<String, String> severity(String value) => _i1.ColumnValue(
    table.severity,
    value,
  );

  _i1.ColumnValue<String, String> detectionMethod(String value) =>
      _i1.ColumnValue(
        table.detectionMethod,
        value,
      );

  _i1.ColumnValue<String, String> measurementType(String? value) =>
      _i1.ColumnValue(
        table.measurementType,
        value,
      );

  _i1.ColumnValue<double, double> expectedValue(double? value) =>
      _i1.ColumnValue(
        table.expectedValue,
        value,
      );

  _i1.ColumnValue<double, double> actualValue(double? value) => _i1.ColumnValue(
    table.actualValue,
    value,
  );

  _i1.ColumnValue<double, double> deviationPercent(double? value) =>
      _i1.ColumnValue(
        table.deviationPercent,
        value,
      );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<bool, bool> isResolved(bool value) => _i1.ColumnValue(
    table.isResolved,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> resolvedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.resolvedAt,
        value,
      );

  _i1.ColumnValue<String, String> resolvedBy(String? value) => _i1.ColumnValue(
    table.resolvedBy,
    value,
  );

  _i1.ColumnValue<String, String> resolutionNotes(String? value) =>
      _i1.ColumnValue(
        table.resolutionNotes,
        value,
      );

  _i1.ColumnValue<String, String> sourceEntityType(String? value) =>
      _i1.ColumnValue(
        table.sourceEntityType,
        value,
      );

  _i1.ColumnValue<int, int> sourceEntityId(int? value) => _i1.ColumnValue(
    table.sourceEntityId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AnomalyTable extends _i1.Table<int?> {
  AnomalyTable({super.tableRelation}) : super(tableName: 'anomalies') {
    updateTable = AnomalyUpdateTable(this);
    greenhouseId = _i1.ColumnInt(
      'greenhouseId',
      this,
    );
    plantId = _i1.ColumnInt(
      'plantId',
      this,
    );
    trayId = _i1.ColumnInt(
      'trayId',
      this,
    );
    anomalyType = _i1.ColumnString(
      'anomalyType',
      this,
    );
    severity = _i1.ColumnString(
      'severity',
      this,
    );
    detectionMethod = _i1.ColumnString(
      'detectionMethod',
      this,
    );
    measurementType = _i1.ColumnString(
      'measurementType',
      this,
    );
    expectedValue = _i1.ColumnDouble(
      'expectedValue',
      this,
    );
    actualValue = _i1.ColumnDouble(
      'actualValue',
      this,
    );
    deviationPercent = _i1.ColumnDouble(
      'deviationPercent',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    isResolved = _i1.ColumnBool(
      'isResolved',
      this,
    );
    resolvedAt = _i1.ColumnDateTime(
      'resolvedAt',
      this,
    );
    resolvedBy = _i1.ColumnString(
      'resolvedBy',
      this,
    );
    resolutionNotes = _i1.ColumnString(
      'resolutionNotes',
      this,
    );
    sourceEntityType = _i1.ColumnString(
      'sourceEntityType',
      this,
    );
    sourceEntityId = _i1.ColumnInt(
      'sourceEntityId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AnomalyUpdateTable updateTable;

  late final _i1.ColumnInt greenhouseId;

  late final _i1.ColumnInt plantId;

  late final _i1.ColumnInt trayId;

  late final _i1.ColumnString anomalyType;

  late final _i1.ColumnString severity;

  late final _i1.ColumnString detectionMethod;

  late final _i1.ColumnString measurementType;

  late final _i1.ColumnDouble expectedValue;

  late final _i1.ColumnDouble actualValue;

  late final _i1.ColumnDouble deviationPercent;

  late final _i1.ColumnString description;

  late final _i1.ColumnBool isResolved;

  late final _i1.ColumnDateTime resolvedAt;

  late final _i1.ColumnString resolvedBy;

  late final _i1.ColumnString resolutionNotes;

  late final _i1.ColumnString sourceEntityType;

  late final _i1.ColumnInt sourceEntityId;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    greenhouseId,
    plantId,
    trayId,
    anomalyType,
    severity,
    detectionMethod,
    measurementType,
    expectedValue,
    actualValue,
    deviationPercent,
    description,
    isResolved,
    resolvedAt,
    resolvedBy,
    resolutionNotes,
    sourceEntityType,
    sourceEntityId,
    createdAt,
  ];
}

class AnomalyInclude extends _i1.IncludeObject {
  AnomalyInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Anomaly.t;
}

class AnomalyIncludeList extends _i1.IncludeList {
  AnomalyIncludeList._({
    _i1.WhereExpressionBuilder<AnomalyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Anomaly.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Anomaly.t;
}

class AnomalyRepository {
  const AnomalyRepository._();

  /// Returns a list of [Anomaly]s matching the given query parameters.
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
  Future<List<Anomaly>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnomalyTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnomalyTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnomalyTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Anomaly>(
      where: where?.call(Anomaly.t),
      orderBy: orderBy?.call(Anomaly.t),
      orderByList: orderByList?.call(Anomaly.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Anomaly] matching the given query parameters.
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
  Future<Anomaly?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnomalyTable>? where,
    int? offset,
    _i1.OrderByBuilder<AnomalyTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnomalyTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Anomaly>(
      where: where?.call(Anomaly.t),
      orderBy: orderBy?.call(Anomaly.t),
      orderByList: orderByList?.call(Anomaly.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Anomaly] by its [id] or null if no such row exists.
  Future<Anomaly?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Anomaly>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Anomaly]s in the list and returns the inserted rows.
  ///
  /// The returned [Anomaly]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Anomaly>> insert(
    _i1.Session session,
    List<Anomaly> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Anomaly>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Anomaly] and returns the inserted row.
  ///
  /// The returned [Anomaly] will have its `id` field set.
  Future<Anomaly> insertRow(
    _i1.Session session,
    Anomaly row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Anomaly>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Anomaly]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Anomaly>> update(
    _i1.Session session,
    List<Anomaly> rows, {
    _i1.ColumnSelections<AnomalyTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Anomaly>(
      rows,
      columns: columns?.call(Anomaly.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Anomaly]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Anomaly> updateRow(
    _i1.Session session,
    Anomaly row, {
    _i1.ColumnSelections<AnomalyTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Anomaly>(
      row,
      columns: columns?.call(Anomaly.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Anomaly] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Anomaly?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AnomalyUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Anomaly>(
      id,
      columnValues: columnValues(Anomaly.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Anomaly]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Anomaly>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AnomalyUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AnomalyTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnomalyTable>? orderBy,
    _i1.OrderByListBuilder<AnomalyTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Anomaly>(
      columnValues: columnValues(Anomaly.t.updateTable),
      where: where(Anomaly.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Anomaly.t),
      orderByList: orderByList?.call(Anomaly.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Anomaly]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Anomaly>> delete(
    _i1.Session session,
    List<Anomaly> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Anomaly>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Anomaly].
  Future<Anomaly> deleteRow(
    _i1.Session session,
    Anomaly row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Anomaly>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Anomaly>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AnomalyTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Anomaly>(
      where: where(Anomaly.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnomalyTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Anomaly>(
      where: where?.call(Anomaly.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Anomaly] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AnomalyTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Anomaly>(
      where: where(Anomaly.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
