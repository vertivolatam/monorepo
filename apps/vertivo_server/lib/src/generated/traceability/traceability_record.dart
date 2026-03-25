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

abstract class TraceabilityRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TraceabilityRecord._({
    this.id,
    required this.greenhouseId,
    required this.batchId,
    required this.eventType,
    required this.description,
    this.performedBy,
    this.metadata,
    required this.recordHash,
    required this.previousHash,
    required this.sequenceNumber,
    required this.isVerified,
    this.verifiedAt,
    this.verifiedBy,
    required this.createdAt,
  });

  factory TraceabilityRecord({
    int? id,
    required int greenhouseId,
    required String batchId,
    required String eventType,
    required String description,
    String? performedBy,
    String? metadata,
    required String recordHash,
    required String previousHash,
    required int sequenceNumber,
    required bool isVerified,
    DateTime? verifiedAt,
    String? verifiedBy,
    required DateTime createdAt,
  }) = _TraceabilityRecordImpl;

  factory TraceabilityRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return TraceabilityRecord(
      id: jsonSerialization['id'] as int?,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      batchId: jsonSerialization['batchId'] as String,
      eventType: jsonSerialization['eventType'] as String,
      description: jsonSerialization['description'] as String,
      performedBy: jsonSerialization['performedBy'] as String?,
      metadata: jsonSerialization['metadata'] as String?,
      recordHash: jsonSerialization['recordHash'] as String,
      previousHash: jsonSerialization['previousHash'] as String,
      sequenceNumber: jsonSerialization['sequenceNumber'] as int,
      isVerified: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isVerified'],
      ),
      verifiedAt: jsonSerialization['verifiedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['verifiedAt']),
      verifiedBy: jsonSerialization['verifiedBy'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = TraceabilityRecordTable();

  static const db = TraceabilityRecordRepository._();

  @override
  int? id;

  int greenhouseId;

  String batchId;

  String eventType;

  String description;

  String? performedBy;

  String? metadata;

  String recordHash;

  String previousHash;

  int sequenceNumber;

  bool isVerified;

  DateTime? verifiedAt;

  String? verifiedBy;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TraceabilityRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TraceabilityRecord copyWith({
    int? id,
    int? greenhouseId,
    String? batchId,
    String? eventType,
    String? description,
    String? performedBy,
    String? metadata,
    String? recordHash,
    String? previousHash,
    int? sequenceNumber,
    bool? isVerified,
    DateTime? verifiedAt,
    String? verifiedBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TraceabilityRecord',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      'batchId': batchId,
      'eventType': eventType,
      'description': description,
      if (performedBy != null) 'performedBy': performedBy,
      if (metadata != null) 'metadata': metadata,
      'recordHash': recordHash,
      'previousHash': previousHash,
      'sequenceNumber': sequenceNumber,
      'isVerified': isVerified,
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      if (verifiedBy != null) 'verifiedBy': verifiedBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TraceabilityRecord',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      'batchId': batchId,
      'eventType': eventType,
      'description': description,
      if (performedBy != null) 'performedBy': performedBy,
      if (metadata != null) 'metadata': metadata,
      'recordHash': recordHash,
      'previousHash': previousHash,
      'sequenceNumber': sequenceNumber,
      'isVerified': isVerified,
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      if (verifiedBy != null) 'verifiedBy': verifiedBy,
      'createdAt': createdAt.toJson(),
    };
  }

  static TraceabilityRecordInclude include() {
    return TraceabilityRecordInclude._();
  }

  static TraceabilityRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<TraceabilityRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TraceabilityRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TraceabilityRecordTable>? orderByList,
    TraceabilityRecordInclude? include,
  }) {
    return TraceabilityRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TraceabilityRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TraceabilityRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TraceabilityRecordImpl extends TraceabilityRecord {
  _TraceabilityRecordImpl({
    int? id,
    required int greenhouseId,
    required String batchId,
    required String eventType,
    required String description,
    String? performedBy,
    String? metadata,
    required String recordHash,
    required String previousHash,
    required int sequenceNumber,
    required bool isVerified,
    DateTime? verifiedAt,
    String? verifiedBy,
    required DateTime createdAt,
  }) : super._(
         id: id,
         greenhouseId: greenhouseId,
         batchId: batchId,
         eventType: eventType,
         description: description,
         performedBy: performedBy,
         metadata: metadata,
         recordHash: recordHash,
         previousHash: previousHash,
         sequenceNumber: sequenceNumber,
         isVerified: isVerified,
         verifiedAt: verifiedAt,
         verifiedBy: verifiedBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TraceabilityRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TraceabilityRecord copyWith({
    Object? id = _Undefined,
    int? greenhouseId,
    String? batchId,
    String? eventType,
    String? description,
    Object? performedBy = _Undefined,
    Object? metadata = _Undefined,
    String? recordHash,
    String? previousHash,
    int? sequenceNumber,
    bool? isVerified,
    Object? verifiedAt = _Undefined,
    Object? verifiedBy = _Undefined,
    DateTime? createdAt,
  }) {
    return TraceabilityRecord(
      id: id is int? ? id : this.id,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      batchId: batchId ?? this.batchId,
      eventType: eventType ?? this.eventType,
      description: description ?? this.description,
      performedBy: performedBy is String? ? performedBy : this.performedBy,
      metadata: metadata is String? ? metadata : this.metadata,
      recordHash: recordHash ?? this.recordHash,
      previousHash: previousHash ?? this.previousHash,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      isVerified: isVerified ?? this.isVerified,
      verifiedAt: verifiedAt is DateTime? ? verifiedAt : this.verifiedAt,
      verifiedBy: verifiedBy is String? ? verifiedBy : this.verifiedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TraceabilityRecordUpdateTable
    extends _i1.UpdateTable<TraceabilityRecordTable> {
  TraceabilityRecordUpdateTable(super.table);

  _i1.ColumnValue<int, int> greenhouseId(int value) => _i1.ColumnValue(
    table.greenhouseId,
    value,
  );

  _i1.ColumnValue<String, String> batchId(String value) => _i1.ColumnValue(
    table.batchId,
    value,
  );

  _i1.ColumnValue<String, String> eventType(String value) => _i1.ColumnValue(
    table.eventType,
    value,
  );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> performedBy(String? value) => _i1.ColumnValue(
    table.performedBy,
    value,
  );

  _i1.ColumnValue<String, String> metadata(String? value) => _i1.ColumnValue(
    table.metadata,
    value,
  );

  _i1.ColumnValue<String, String> recordHash(String value) => _i1.ColumnValue(
    table.recordHash,
    value,
  );

  _i1.ColumnValue<String, String> previousHash(String value) => _i1.ColumnValue(
    table.previousHash,
    value,
  );

  _i1.ColumnValue<int, int> sequenceNumber(int value) => _i1.ColumnValue(
    table.sequenceNumber,
    value,
  );

  _i1.ColumnValue<bool, bool> isVerified(bool value) => _i1.ColumnValue(
    table.isVerified,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> verifiedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.verifiedAt,
        value,
      );

  _i1.ColumnValue<String, String> verifiedBy(String? value) => _i1.ColumnValue(
    table.verifiedBy,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class TraceabilityRecordTable extends _i1.Table<int?> {
  TraceabilityRecordTable({super.tableRelation})
    : super(tableName: 'traceability_records') {
    updateTable = TraceabilityRecordUpdateTable(this);
    greenhouseId = _i1.ColumnInt(
      'greenhouseId',
      this,
    );
    batchId = _i1.ColumnString(
      'batchId',
      this,
    );
    eventType = _i1.ColumnString(
      'eventType',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    performedBy = _i1.ColumnString(
      'performedBy',
      this,
    );
    metadata = _i1.ColumnString(
      'metadata',
      this,
    );
    recordHash = _i1.ColumnString(
      'recordHash',
      this,
    );
    previousHash = _i1.ColumnString(
      'previousHash',
      this,
    );
    sequenceNumber = _i1.ColumnInt(
      'sequenceNumber',
      this,
    );
    isVerified = _i1.ColumnBool(
      'isVerified',
      this,
    );
    verifiedAt = _i1.ColumnDateTime(
      'verifiedAt',
      this,
    );
    verifiedBy = _i1.ColumnString(
      'verifiedBy',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final TraceabilityRecordUpdateTable updateTable;

  late final _i1.ColumnInt greenhouseId;

  late final _i1.ColumnString batchId;

  late final _i1.ColumnString eventType;

  late final _i1.ColumnString description;

  late final _i1.ColumnString performedBy;

  late final _i1.ColumnString metadata;

  late final _i1.ColumnString recordHash;

  late final _i1.ColumnString previousHash;

  late final _i1.ColumnInt sequenceNumber;

  late final _i1.ColumnBool isVerified;

  late final _i1.ColumnDateTime verifiedAt;

  late final _i1.ColumnString verifiedBy;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    greenhouseId,
    batchId,
    eventType,
    description,
    performedBy,
    metadata,
    recordHash,
    previousHash,
    sequenceNumber,
    isVerified,
    verifiedAt,
    verifiedBy,
    createdAt,
  ];
}

class TraceabilityRecordInclude extends _i1.IncludeObject {
  TraceabilityRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TraceabilityRecord.t;
}

class TraceabilityRecordIncludeList extends _i1.IncludeList {
  TraceabilityRecordIncludeList._({
    _i1.WhereExpressionBuilder<TraceabilityRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TraceabilityRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TraceabilityRecord.t;
}

class TraceabilityRecordRepository {
  const TraceabilityRecordRepository._();

  /// Returns a list of [TraceabilityRecord]s matching the given query parameters.
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
  Future<List<TraceabilityRecord>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TraceabilityRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TraceabilityRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TraceabilityRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TraceabilityRecord>(
      where: where?.call(TraceabilityRecord.t),
      orderBy: orderBy?.call(TraceabilityRecord.t),
      orderByList: orderByList?.call(TraceabilityRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TraceabilityRecord] matching the given query parameters.
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
  Future<TraceabilityRecord?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TraceabilityRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<TraceabilityRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TraceabilityRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TraceabilityRecord>(
      where: where?.call(TraceabilityRecord.t),
      orderBy: orderBy?.call(TraceabilityRecord.t),
      orderByList: orderByList?.call(TraceabilityRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TraceabilityRecord] by its [id] or null if no such row exists.
  Future<TraceabilityRecord?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TraceabilityRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TraceabilityRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [TraceabilityRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<TraceabilityRecord>> insert(
    _i1.Session session,
    List<TraceabilityRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<TraceabilityRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [TraceabilityRecord] and returns the inserted row.
  ///
  /// The returned [TraceabilityRecord] will have its `id` field set.
  Future<TraceabilityRecord> insertRow(
    _i1.Session session,
    TraceabilityRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TraceabilityRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TraceabilityRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TraceabilityRecord>> update(
    _i1.Session session,
    List<TraceabilityRecord> rows, {
    _i1.ColumnSelections<TraceabilityRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TraceabilityRecord>(
      rows,
      columns: columns?.call(TraceabilityRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TraceabilityRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TraceabilityRecord> updateRow(
    _i1.Session session,
    TraceabilityRecord row, {
    _i1.ColumnSelections<TraceabilityRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TraceabilityRecord>(
      row,
      columns: columns?.call(TraceabilityRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TraceabilityRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TraceabilityRecord?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TraceabilityRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TraceabilityRecord>(
      id,
      columnValues: columnValues(TraceabilityRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TraceabilityRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TraceabilityRecord>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TraceabilityRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<TraceabilityRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TraceabilityRecordTable>? orderBy,
    _i1.OrderByListBuilder<TraceabilityRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TraceabilityRecord>(
      columnValues: columnValues(TraceabilityRecord.t.updateTable),
      where: where(TraceabilityRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TraceabilityRecord.t),
      orderByList: orderByList?.call(TraceabilityRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TraceabilityRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TraceabilityRecord>> delete(
    _i1.Session session,
    List<TraceabilityRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TraceabilityRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TraceabilityRecord].
  Future<TraceabilityRecord> deleteRow(
    _i1.Session session,
    TraceabilityRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TraceabilityRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TraceabilityRecord>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TraceabilityRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TraceabilityRecord>(
      where: where(TraceabilityRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TraceabilityRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TraceabilityRecord>(
      where: where?.call(TraceabilityRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TraceabilityRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TraceabilityRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TraceabilityRecord>(
      where: where(TraceabilityRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
