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

abstract class IrrigationEvent
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  IrrigationEvent._({
    this.id,
    required this.greenhouseId,
    this.trayId,
    required this.irrigationType,
    required this.durationMinutes,
    this.waterVolumeLiters,
    this.nutrientMix,
    required this.triggeredBy,
    required this.createdAt,
  });

  factory IrrigationEvent({
    int? id,
    required int greenhouseId,
    int? trayId,
    required String irrigationType,
    required double durationMinutes,
    double? waterVolumeLiters,
    String? nutrientMix,
    required String triggeredBy,
    required DateTime createdAt,
  }) = _IrrigationEventImpl;

  factory IrrigationEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return IrrigationEvent(
      id: jsonSerialization['id'] as int?,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      trayId: jsonSerialization['trayId'] as int?,
      irrigationType: jsonSerialization['irrigationType'] as String,
      durationMinutes: (jsonSerialization['durationMinutes'] as num).toDouble(),
      waterVolumeLiters: (jsonSerialization['waterVolumeLiters'] as num?)
          ?.toDouble(),
      nutrientMix: jsonSerialization['nutrientMix'] as String?,
      triggeredBy: jsonSerialization['triggeredBy'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = IrrigationEventTable();

  static const db = IrrigationEventRepository._();

  @override
  int? id;

  int greenhouseId;

  int? trayId;

  String irrigationType;

  double durationMinutes;

  double? waterVolumeLiters;

  String? nutrientMix;

  String triggeredBy;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [IrrigationEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IrrigationEvent copyWith({
    int? id,
    int? greenhouseId,
    int? trayId,
    String? irrigationType,
    double? durationMinutes,
    double? waterVolumeLiters,
    String? nutrientMix,
    String? triggeredBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IrrigationEvent',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      if (trayId != null) 'trayId': trayId,
      'irrigationType': irrigationType,
      'durationMinutes': durationMinutes,
      if (waterVolumeLiters != null) 'waterVolumeLiters': waterVolumeLiters,
      if (nutrientMix != null) 'nutrientMix': nutrientMix,
      'triggeredBy': triggeredBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IrrigationEvent',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      if (trayId != null) 'trayId': trayId,
      'irrigationType': irrigationType,
      'durationMinutes': durationMinutes,
      if (waterVolumeLiters != null) 'waterVolumeLiters': waterVolumeLiters,
      if (nutrientMix != null) 'nutrientMix': nutrientMix,
      'triggeredBy': triggeredBy,
      'createdAt': createdAt.toJson(),
    };
  }

  static IrrigationEventInclude include() {
    return IrrigationEventInclude._();
  }

  static IrrigationEventIncludeList includeList({
    _i1.WhereExpressionBuilder<IrrigationEventTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IrrigationEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IrrigationEventTable>? orderByList,
    IrrigationEventInclude? include,
  }) {
    return IrrigationEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IrrigationEvent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(IrrigationEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IrrigationEventImpl extends IrrigationEvent {
  _IrrigationEventImpl({
    int? id,
    required int greenhouseId,
    int? trayId,
    required String irrigationType,
    required double durationMinutes,
    double? waterVolumeLiters,
    String? nutrientMix,
    required String triggeredBy,
    required DateTime createdAt,
  }) : super._(
         id: id,
         greenhouseId: greenhouseId,
         trayId: trayId,
         irrigationType: irrigationType,
         durationMinutes: durationMinutes,
         waterVolumeLiters: waterVolumeLiters,
         nutrientMix: nutrientMix,
         triggeredBy: triggeredBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [IrrigationEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IrrigationEvent copyWith({
    Object? id = _Undefined,
    int? greenhouseId,
    Object? trayId = _Undefined,
    String? irrigationType,
    double? durationMinutes,
    Object? waterVolumeLiters = _Undefined,
    Object? nutrientMix = _Undefined,
    String? triggeredBy,
    DateTime? createdAt,
  }) {
    return IrrigationEvent(
      id: id is int? ? id : this.id,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      trayId: trayId is int? ? trayId : this.trayId,
      irrigationType: irrigationType ?? this.irrigationType,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      waterVolumeLiters: waterVolumeLiters is double?
          ? waterVolumeLiters
          : this.waterVolumeLiters,
      nutrientMix: nutrientMix is String? ? nutrientMix : this.nutrientMix,
      triggeredBy: triggeredBy ?? this.triggeredBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class IrrigationEventUpdateTable extends _i1.UpdateTable<IrrigationEventTable> {
  IrrigationEventUpdateTable(super.table);

  _i1.ColumnValue<int, int> greenhouseId(int value) => _i1.ColumnValue(
    table.greenhouseId,
    value,
  );

  _i1.ColumnValue<int, int> trayId(int? value) => _i1.ColumnValue(
    table.trayId,
    value,
  );

  _i1.ColumnValue<String, String> irrigationType(String value) =>
      _i1.ColumnValue(
        table.irrigationType,
        value,
      );

  _i1.ColumnValue<double, double> durationMinutes(double value) =>
      _i1.ColumnValue(
        table.durationMinutes,
        value,
      );

  _i1.ColumnValue<double, double> waterVolumeLiters(double? value) =>
      _i1.ColumnValue(
        table.waterVolumeLiters,
        value,
      );

  _i1.ColumnValue<String, String> nutrientMix(String? value) => _i1.ColumnValue(
    table.nutrientMix,
    value,
  );

  _i1.ColumnValue<String, String> triggeredBy(String value) => _i1.ColumnValue(
    table.triggeredBy,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class IrrigationEventTable extends _i1.Table<int?> {
  IrrigationEventTable({super.tableRelation})
    : super(tableName: 'irrigation_events') {
    updateTable = IrrigationEventUpdateTable(this);
    greenhouseId = _i1.ColumnInt(
      'greenhouseId',
      this,
    );
    trayId = _i1.ColumnInt(
      'trayId',
      this,
    );
    irrigationType = _i1.ColumnString(
      'irrigationType',
      this,
    );
    durationMinutes = _i1.ColumnDouble(
      'durationMinutes',
      this,
    );
    waterVolumeLiters = _i1.ColumnDouble(
      'waterVolumeLiters',
      this,
    );
    nutrientMix = _i1.ColumnString(
      'nutrientMix',
      this,
    );
    triggeredBy = _i1.ColumnString(
      'triggeredBy',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final IrrigationEventUpdateTable updateTable;

  late final _i1.ColumnInt greenhouseId;

  late final _i1.ColumnInt trayId;

  late final _i1.ColumnString irrigationType;

  late final _i1.ColumnDouble durationMinutes;

  late final _i1.ColumnDouble waterVolumeLiters;

  late final _i1.ColumnString nutrientMix;

  late final _i1.ColumnString triggeredBy;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    greenhouseId,
    trayId,
    irrigationType,
    durationMinutes,
    waterVolumeLiters,
    nutrientMix,
    triggeredBy,
    createdAt,
  ];
}

class IrrigationEventInclude extends _i1.IncludeObject {
  IrrigationEventInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => IrrigationEvent.t;
}

class IrrigationEventIncludeList extends _i1.IncludeList {
  IrrigationEventIncludeList._({
    _i1.WhereExpressionBuilder<IrrigationEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IrrigationEvent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => IrrigationEvent.t;
}

class IrrigationEventRepository {
  const IrrigationEventRepository._();

  /// Returns a list of [IrrigationEvent]s matching the given query parameters.
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
  Future<List<IrrigationEvent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IrrigationEventTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IrrigationEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IrrigationEventTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<IrrigationEvent>(
      where: where?.call(IrrigationEvent.t),
      orderBy: orderBy?.call(IrrigationEvent.t),
      orderByList: orderByList?.call(IrrigationEvent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [IrrigationEvent] matching the given query parameters.
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
  Future<IrrigationEvent?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IrrigationEventTable>? where,
    int? offset,
    _i1.OrderByBuilder<IrrigationEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IrrigationEventTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<IrrigationEvent>(
      where: where?.call(IrrigationEvent.t),
      orderBy: orderBy?.call(IrrigationEvent.t),
      orderByList: orderByList?.call(IrrigationEvent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [IrrigationEvent] by its [id] or null if no such row exists.
  Future<IrrigationEvent?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<IrrigationEvent>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [IrrigationEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [IrrigationEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<IrrigationEvent>> insert(
    _i1.Session session,
    List<IrrigationEvent> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<IrrigationEvent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [IrrigationEvent] and returns the inserted row.
  ///
  /// The returned [IrrigationEvent] will have its `id` field set.
  Future<IrrigationEvent> insertRow(
    _i1.Session session,
    IrrigationEvent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<IrrigationEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [IrrigationEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<IrrigationEvent>> update(
    _i1.Session session,
    List<IrrigationEvent> rows, {
    _i1.ColumnSelections<IrrigationEventTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<IrrigationEvent>(
      rows,
      columns: columns?.call(IrrigationEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IrrigationEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IrrigationEvent> updateRow(
    _i1.Session session,
    IrrigationEvent row, {
    _i1.ColumnSelections<IrrigationEventTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<IrrigationEvent>(
      row,
      columns: columns?.call(IrrigationEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IrrigationEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<IrrigationEvent?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<IrrigationEventUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<IrrigationEvent>(
      id,
      columnValues: columnValues(IrrigationEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [IrrigationEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<IrrigationEvent>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<IrrigationEventUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<IrrigationEventTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IrrigationEventTable>? orderBy,
    _i1.OrderByListBuilder<IrrigationEventTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<IrrigationEvent>(
      columnValues: columnValues(IrrigationEvent.t.updateTable),
      where: where(IrrigationEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IrrigationEvent.t),
      orderByList: orderByList?.call(IrrigationEvent.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [IrrigationEvent]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<IrrigationEvent>> delete(
    _i1.Session session,
    List<IrrigationEvent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<IrrigationEvent>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [IrrigationEvent].
  Future<IrrigationEvent> deleteRow(
    _i1.Session session,
    IrrigationEvent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IrrigationEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<IrrigationEvent>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<IrrigationEventTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<IrrigationEvent>(
      where: where(IrrigationEvent.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IrrigationEventTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<IrrigationEvent>(
      where: where?.call(IrrigationEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [IrrigationEvent] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<IrrigationEventTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<IrrigationEvent>(
      where: where(IrrigationEvent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
