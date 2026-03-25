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
import 'package:vertivo_server/src/generated/protocol.dart' as _i2;

abstract class NutritionalDeficiency
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  NutritionalDeficiency._({
    this.id,
    required this.plantId,
    required this.greenhouseId,
    required this.nutrient,
    required this.severity,
    this.symptoms,
    required this.confidence,
    this.recommendedAction,
    required this.isResolved,
    this.resolvedAt,
    required this.detectedAt,
    required this.createdAt,
  });

  factory NutritionalDeficiency({
    int? id,
    required int plantId,
    required int greenhouseId,
    required String nutrient,
    required String severity,
    List<String>? symptoms,
    required double confidence,
    String? recommendedAction,
    required bool isResolved,
    DateTime? resolvedAt,
    required DateTime detectedAt,
    required DateTime createdAt,
  }) = _NutritionalDeficiencyImpl;

  factory NutritionalDeficiency.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NutritionalDeficiency(
      id: jsonSerialization['id'] as int?,
      plantId: jsonSerialization['plantId'] as int,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      nutrient: jsonSerialization['nutrient'] as String,
      severity: jsonSerialization['severity'] as String,
      symptoms: jsonSerialization['symptoms'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['symptoms'],
            ),
      confidence: (jsonSerialization['confidence'] as num).toDouble(),
      recommendedAction: jsonSerialization['recommendedAction'] as String?,
      isResolved: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isResolved'],
      ),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
      detectedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['detectedAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = NutritionalDeficiencyTable();

  static const db = NutritionalDeficiencyRepository._();

  @override
  int? id;

  int plantId;

  int greenhouseId;

  String nutrient;

  String severity;

  List<String>? symptoms;

  double confidence;

  String? recommendedAction;

  bool isResolved;

  DateTime? resolvedAt;

  DateTime detectedAt;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [NutritionalDeficiency]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NutritionalDeficiency copyWith({
    int? id,
    int? plantId,
    int? greenhouseId,
    String? nutrient,
    String? severity,
    List<String>? symptoms,
    double? confidence,
    String? recommendedAction,
    bool? isResolved,
    DateTime? resolvedAt,
    DateTime? detectedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NutritionalDeficiency',
      if (id != null) 'id': id,
      'plantId': plantId,
      'greenhouseId': greenhouseId,
      'nutrient': nutrient,
      'severity': severity,
      if (symptoms != null) 'symptoms': symptoms?.toJson(),
      'confidence': confidence,
      if (recommendedAction != null) 'recommendedAction': recommendedAction,
      'isResolved': isResolved,
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      'detectedAt': detectedAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NutritionalDeficiency',
      if (id != null) 'id': id,
      'plantId': plantId,
      'greenhouseId': greenhouseId,
      'nutrient': nutrient,
      'severity': severity,
      if (symptoms != null) 'symptoms': symptoms?.toJson(),
      'confidence': confidence,
      if (recommendedAction != null) 'recommendedAction': recommendedAction,
      'isResolved': isResolved,
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      'detectedAt': detectedAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static NutritionalDeficiencyInclude include() {
    return NutritionalDeficiencyInclude._();
  }

  static NutritionalDeficiencyIncludeList includeList({
    _i1.WhereExpressionBuilder<NutritionalDeficiencyTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NutritionalDeficiencyTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NutritionalDeficiencyTable>? orderByList,
    NutritionalDeficiencyInclude? include,
  }) {
    return NutritionalDeficiencyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NutritionalDeficiency.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(NutritionalDeficiency.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NutritionalDeficiencyImpl extends NutritionalDeficiency {
  _NutritionalDeficiencyImpl({
    int? id,
    required int plantId,
    required int greenhouseId,
    required String nutrient,
    required String severity,
    List<String>? symptoms,
    required double confidence,
    String? recommendedAction,
    required bool isResolved,
    DateTime? resolvedAt,
    required DateTime detectedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         plantId: plantId,
         greenhouseId: greenhouseId,
         nutrient: nutrient,
         severity: severity,
         symptoms: symptoms,
         confidence: confidence,
         recommendedAction: recommendedAction,
         isResolved: isResolved,
         resolvedAt: resolvedAt,
         detectedAt: detectedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NutritionalDeficiency]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NutritionalDeficiency copyWith({
    Object? id = _Undefined,
    int? plantId,
    int? greenhouseId,
    String? nutrient,
    String? severity,
    Object? symptoms = _Undefined,
    double? confidence,
    Object? recommendedAction = _Undefined,
    bool? isResolved,
    Object? resolvedAt = _Undefined,
    DateTime? detectedAt,
    DateTime? createdAt,
  }) {
    return NutritionalDeficiency(
      id: id is int? ? id : this.id,
      plantId: plantId ?? this.plantId,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      nutrient: nutrient ?? this.nutrient,
      severity: severity ?? this.severity,
      symptoms: symptoms is List<String>?
          ? symptoms
          : this.symptoms?.map((e0) => e0).toList(),
      confidence: confidence ?? this.confidence,
      recommendedAction: recommendedAction is String?
          ? recommendedAction
          : this.recommendedAction,
      isResolved: isResolved ?? this.isResolved,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
      detectedAt: detectedAt ?? this.detectedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class NutritionalDeficiencyUpdateTable
    extends _i1.UpdateTable<NutritionalDeficiencyTable> {
  NutritionalDeficiencyUpdateTable(super.table);

  _i1.ColumnValue<int, int> plantId(int value) => _i1.ColumnValue(
    table.plantId,
    value,
  );

  _i1.ColumnValue<int, int> greenhouseId(int value) => _i1.ColumnValue(
    table.greenhouseId,
    value,
  );

  _i1.ColumnValue<String, String> nutrient(String value) => _i1.ColumnValue(
    table.nutrient,
    value,
  );

  _i1.ColumnValue<String, String> severity(String value) => _i1.ColumnValue(
    table.severity,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> symptoms(List<String>? value) =>
      _i1.ColumnValue(
        table.symptoms,
        value,
      );

  _i1.ColumnValue<double, double> confidence(double value) => _i1.ColumnValue(
    table.confidence,
    value,
  );

  _i1.ColumnValue<String, String> recommendedAction(String? value) =>
      _i1.ColumnValue(
        table.recommendedAction,
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

  _i1.ColumnValue<DateTime, DateTime> detectedAt(DateTime value) =>
      _i1.ColumnValue(
        table.detectedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class NutritionalDeficiencyTable extends _i1.Table<int?> {
  NutritionalDeficiencyTable({super.tableRelation})
    : super(tableName: 'nutritional_deficiencies') {
    updateTable = NutritionalDeficiencyUpdateTable(this);
    plantId = _i1.ColumnInt(
      'plantId',
      this,
    );
    greenhouseId = _i1.ColumnInt(
      'greenhouseId',
      this,
    );
    nutrient = _i1.ColumnString(
      'nutrient',
      this,
    );
    severity = _i1.ColumnString(
      'severity',
      this,
    );
    symptoms = _i1.ColumnSerializable<List<String>>(
      'symptoms',
      this,
    );
    confidence = _i1.ColumnDouble(
      'confidence',
      this,
    );
    recommendedAction = _i1.ColumnString(
      'recommendedAction',
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
    detectedAt = _i1.ColumnDateTime(
      'detectedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final NutritionalDeficiencyUpdateTable updateTable;

  late final _i1.ColumnInt plantId;

  late final _i1.ColumnInt greenhouseId;

  late final _i1.ColumnString nutrient;

  late final _i1.ColumnString severity;

  late final _i1.ColumnSerializable<List<String>> symptoms;

  late final _i1.ColumnDouble confidence;

  late final _i1.ColumnString recommendedAction;

  late final _i1.ColumnBool isResolved;

  late final _i1.ColumnDateTime resolvedAt;

  late final _i1.ColumnDateTime detectedAt;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    plantId,
    greenhouseId,
    nutrient,
    severity,
    symptoms,
    confidence,
    recommendedAction,
    isResolved,
    resolvedAt,
    detectedAt,
    createdAt,
  ];
}

class NutritionalDeficiencyInclude extends _i1.IncludeObject {
  NutritionalDeficiencyInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => NutritionalDeficiency.t;
}

class NutritionalDeficiencyIncludeList extends _i1.IncludeList {
  NutritionalDeficiencyIncludeList._({
    _i1.WhereExpressionBuilder<NutritionalDeficiencyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NutritionalDeficiency.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => NutritionalDeficiency.t;
}

class NutritionalDeficiencyRepository {
  const NutritionalDeficiencyRepository._();

  /// Returns a list of [NutritionalDeficiency]s matching the given query parameters.
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
  Future<List<NutritionalDeficiency>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NutritionalDeficiencyTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NutritionalDeficiencyTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NutritionalDeficiencyTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NutritionalDeficiency>(
      where: where?.call(NutritionalDeficiency.t),
      orderBy: orderBy?.call(NutritionalDeficiency.t),
      orderByList: orderByList?.call(NutritionalDeficiency.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NutritionalDeficiency] matching the given query parameters.
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
  Future<NutritionalDeficiency?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NutritionalDeficiencyTable>? where,
    int? offset,
    _i1.OrderByBuilder<NutritionalDeficiencyTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NutritionalDeficiencyTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NutritionalDeficiency>(
      where: where?.call(NutritionalDeficiency.t),
      orderBy: orderBy?.call(NutritionalDeficiency.t),
      orderByList: orderByList?.call(NutritionalDeficiency.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NutritionalDeficiency] by its [id] or null if no such row exists.
  Future<NutritionalDeficiency?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NutritionalDeficiency>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NutritionalDeficiency]s in the list and returns the inserted rows.
  ///
  /// The returned [NutritionalDeficiency]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<NutritionalDeficiency>> insert(
    _i1.Session session,
    List<NutritionalDeficiency> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<NutritionalDeficiency>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [NutritionalDeficiency] and returns the inserted row.
  ///
  /// The returned [NutritionalDeficiency] will have its `id` field set.
  Future<NutritionalDeficiency> insertRow(
    _i1.Session session,
    NutritionalDeficiency row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<NutritionalDeficiency>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [NutritionalDeficiency]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<NutritionalDeficiency>> update(
    _i1.Session session,
    List<NutritionalDeficiency> rows, {
    _i1.ColumnSelections<NutritionalDeficiencyTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<NutritionalDeficiency>(
      rows,
      columns: columns?.call(NutritionalDeficiency.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NutritionalDeficiency]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NutritionalDeficiency> updateRow(
    _i1.Session session,
    NutritionalDeficiency row, {
    _i1.ColumnSelections<NutritionalDeficiencyTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<NutritionalDeficiency>(
      row,
      columns: columns?.call(NutritionalDeficiency.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NutritionalDeficiency] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NutritionalDeficiency?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<NutritionalDeficiencyUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<NutritionalDeficiency>(
      id,
      columnValues: columnValues(NutritionalDeficiency.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NutritionalDeficiency]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<NutritionalDeficiency>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<NutritionalDeficiencyUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<NutritionalDeficiencyTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NutritionalDeficiencyTable>? orderBy,
    _i1.OrderByListBuilder<NutritionalDeficiencyTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<NutritionalDeficiency>(
      columnValues: columnValues(NutritionalDeficiency.t.updateTable),
      where: where(NutritionalDeficiency.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NutritionalDeficiency.t),
      orderByList: orderByList?.call(NutritionalDeficiency.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [NutritionalDeficiency]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<NutritionalDeficiency>> delete(
    _i1.Session session,
    List<NutritionalDeficiency> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<NutritionalDeficiency>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [NutritionalDeficiency].
  Future<NutritionalDeficiency> deleteRow(
    _i1.Session session,
    NutritionalDeficiency row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NutritionalDeficiency>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<NutritionalDeficiency>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<NutritionalDeficiencyTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<NutritionalDeficiency>(
      where: where(NutritionalDeficiency.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NutritionalDeficiencyTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<NutritionalDeficiency>(
      where: where?.call(NutritionalDeficiency.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NutritionalDeficiency] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<NutritionalDeficiencyTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NutritionalDeficiency>(
      where: where(NutritionalDeficiency.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
