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

abstract class EnvironmentalReading
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  EnvironmentalReading._({
    this.id,
    required this.greenhouseId,
    required this.measurementType,
    required this.value,
    required this.unit,
    this.source,
    required this.isAnomaly,
    required this.createdAt,
  });

  factory EnvironmentalReading({
    int? id,
    required int greenhouseId,
    required String measurementType,
    required double value,
    required String unit,
    String? source,
    required bool isAnomaly,
    required DateTime createdAt,
  }) = _EnvironmentalReadingImpl;

  factory EnvironmentalReading.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EnvironmentalReading(
      id: jsonSerialization['id'] as int?,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      measurementType: jsonSerialization['measurementType'] as String,
      value: (jsonSerialization['value'] as num).toDouble(),
      unit: jsonSerialization['unit'] as String,
      source: jsonSerialization['source'] as String?,
      isAnomaly: _i1.BoolJsonExtension.fromJson(jsonSerialization['isAnomaly']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = EnvironmentalReadingTable();

  static const db = EnvironmentalReadingRepository._();

  @override
  int? id;

  int greenhouseId;

  String measurementType;

  double value;

  String unit;

  String? source;

  bool isAnomaly;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [EnvironmentalReading]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EnvironmentalReading copyWith({
    int? id,
    int? greenhouseId,
    String? measurementType,
    double? value,
    String? unit,
    String? source,
    bool? isAnomaly,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EnvironmentalReading',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      'measurementType': measurementType,
      'value': value,
      'unit': unit,
      if (source != null) 'source': source,
      'isAnomaly': isAnomaly,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EnvironmentalReading',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      'measurementType': measurementType,
      'value': value,
      'unit': unit,
      if (source != null) 'source': source,
      'isAnomaly': isAnomaly,
      'createdAt': createdAt.toJson(),
    };
  }

  static EnvironmentalReadingInclude include() {
    return EnvironmentalReadingInclude._();
  }

  static EnvironmentalReadingIncludeList includeList({
    _i1.WhereExpressionBuilder<EnvironmentalReadingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnvironmentalReadingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnvironmentalReadingTable>? orderByList,
    EnvironmentalReadingInclude? include,
  }) {
    return EnvironmentalReadingIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnvironmentalReading.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EnvironmentalReading.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnvironmentalReadingImpl extends EnvironmentalReading {
  _EnvironmentalReadingImpl({
    int? id,
    required int greenhouseId,
    required String measurementType,
    required double value,
    required String unit,
    String? source,
    required bool isAnomaly,
    required DateTime createdAt,
  }) : super._(
         id: id,
         greenhouseId: greenhouseId,
         measurementType: measurementType,
         value: value,
         unit: unit,
         source: source,
         isAnomaly: isAnomaly,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [EnvironmentalReading]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EnvironmentalReading copyWith({
    Object? id = _Undefined,
    int? greenhouseId,
    String? measurementType,
    double? value,
    String? unit,
    Object? source = _Undefined,
    bool? isAnomaly,
    DateTime? createdAt,
  }) {
    return EnvironmentalReading(
      id: id is int? ? id : this.id,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      measurementType: measurementType ?? this.measurementType,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      source: source is String? ? source : this.source,
      isAnomaly: isAnomaly ?? this.isAnomaly,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class EnvironmentalReadingUpdateTable
    extends _i1.UpdateTable<EnvironmentalReadingTable> {
  EnvironmentalReadingUpdateTable(super.table);

  _i1.ColumnValue<int, int> greenhouseId(int value) => _i1.ColumnValue(
    table.greenhouseId,
    value,
  );

  _i1.ColumnValue<String, String> measurementType(String value) =>
      _i1.ColumnValue(
        table.measurementType,
        value,
      );

  _i1.ColumnValue<double, double> value(double value) => _i1.ColumnValue(
    table.value,
    value,
  );

  _i1.ColumnValue<String, String> unit(String value) => _i1.ColumnValue(
    table.unit,
    value,
  );

  _i1.ColumnValue<String, String> source(String? value) => _i1.ColumnValue(
    table.source,
    value,
  );

  _i1.ColumnValue<bool, bool> isAnomaly(bool value) => _i1.ColumnValue(
    table.isAnomaly,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class EnvironmentalReadingTable extends _i1.Table<int?> {
  EnvironmentalReadingTable({super.tableRelation})
    : super(tableName: 'environmental_readings') {
    updateTable = EnvironmentalReadingUpdateTable(this);
    greenhouseId = _i1.ColumnInt(
      'greenhouseId',
      this,
    );
    measurementType = _i1.ColumnString(
      'measurementType',
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
    source = _i1.ColumnString(
      'source',
      this,
    );
    isAnomaly = _i1.ColumnBool(
      'isAnomaly',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final EnvironmentalReadingUpdateTable updateTable;

  late final _i1.ColumnInt greenhouseId;

  late final _i1.ColumnString measurementType;

  late final _i1.ColumnDouble value;

  late final _i1.ColumnString unit;

  late final _i1.ColumnString source;

  late final _i1.ColumnBool isAnomaly;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    greenhouseId,
    measurementType,
    value,
    unit,
    source,
    isAnomaly,
    createdAt,
  ];
}

class EnvironmentalReadingInclude extends _i1.IncludeObject {
  EnvironmentalReadingInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => EnvironmentalReading.t;
}

class EnvironmentalReadingIncludeList extends _i1.IncludeList {
  EnvironmentalReadingIncludeList._({
    _i1.WhereExpressionBuilder<EnvironmentalReadingTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EnvironmentalReading.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => EnvironmentalReading.t;
}

class EnvironmentalReadingRepository {
  const EnvironmentalReadingRepository._();

  /// Returns a list of [EnvironmentalReading]s matching the given query parameters.
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
  Future<List<EnvironmentalReading>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnvironmentalReadingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnvironmentalReadingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnvironmentalReadingTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EnvironmentalReading>(
      where: where?.call(EnvironmentalReading.t),
      orderBy: orderBy?.call(EnvironmentalReading.t),
      orderByList: orderByList?.call(EnvironmentalReading.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EnvironmentalReading] matching the given query parameters.
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
  Future<EnvironmentalReading?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnvironmentalReadingTable>? where,
    int? offset,
    _i1.OrderByBuilder<EnvironmentalReadingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnvironmentalReadingTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EnvironmentalReading>(
      where: where?.call(EnvironmentalReading.t),
      orderBy: orderBy?.call(EnvironmentalReading.t),
      orderByList: orderByList?.call(EnvironmentalReading.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EnvironmentalReading] by its [id] or null if no such row exists.
  Future<EnvironmentalReading?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EnvironmentalReading>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EnvironmentalReading]s in the list and returns the inserted rows.
  ///
  /// The returned [EnvironmentalReading]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<EnvironmentalReading>> insert(
    _i1.Session session,
    List<EnvironmentalReading> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<EnvironmentalReading>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [EnvironmentalReading] and returns the inserted row.
  ///
  /// The returned [EnvironmentalReading] will have its `id` field set.
  Future<EnvironmentalReading> insertRow(
    _i1.Session session,
    EnvironmentalReading row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EnvironmentalReading>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EnvironmentalReading]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EnvironmentalReading>> update(
    _i1.Session session,
    List<EnvironmentalReading> rows, {
    _i1.ColumnSelections<EnvironmentalReadingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EnvironmentalReading>(
      rows,
      columns: columns?.call(EnvironmentalReading.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EnvironmentalReading]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EnvironmentalReading> updateRow(
    _i1.Session session,
    EnvironmentalReading row, {
    _i1.ColumnSelections<EnvironmentalReadingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EnvironmentalReading>(
      row,
      columns: columns?.call(EnvironmentalReading.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EnvironmentalReading] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EnvironmentalReading?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<EnvironmentalReadingUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<EnvironmentalReading>(
      id,
      columnValues: columnValues(EnvironmentalReading.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EnvironmentalReading]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<EnvironmentalReading>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<EnvironmentalReadingUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<EnvironmentalReadingTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnvironmentalReadingTable>? orderBy,
    _i1.OrderByListBuilder<EnvironmentalReadingTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<EnvironmentalReading>(
      columnValues: columnValues(EnvironmentalReading.t.updateTable),
      where: where(EnvironmentalReading.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnvironmentalReading.t),
      orderByList: orderByList?.call(EnvironmentalReading.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [EnvironmentalReading]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EnvironmentalReading>> delete(
    _i1.Session session,
    List<EnvironmentalReading> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EnvironmentalReading>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EnvironmentalReading].
  Future<EnvironmentalReading> deleteRow(
    _i1.Session session,
    EnvironmentalReading row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EnvironmentalReading>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EnvironmentalReading>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EnvironmentalReadingTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EnvironmentalReading>(
      where: where(EnvironmentalReading.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EnvironmentalReadingTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EnvironmentalReading>(
      where: where?.call(EnvironmentalReading.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EnvironmentalReading] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EnvironmentalReadingTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EnvironmentalReading>(
      where: where(EnvironmentalReading.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
