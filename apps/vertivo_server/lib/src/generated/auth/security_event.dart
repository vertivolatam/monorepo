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

abstract class SecurityEvent
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SecurityEvent._({
    this.id,
    this.userId,
    required this.eventType,
    required this.severity,
    this.ipAddress,
    this.deviceId,
    this.details,
    required this.createdAt,
  });

  factory SecurityEvent({
    int? id,
    String? userId,
    required String eventType,
    required String severity,
    String? ipAddress,
    String? deviceId,
    String? details,
    required DateTime createdAt,
  }) = _SecurityEventImpl;

  factory SecurityEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return SecurityEvent(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String?,
      eventType: jsonSerialization['eventType'] as String,
      severity: jsonSerialization['severity'] as String,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      deviceId: jsonSerialization['deviceId'] as String?,
      details: jsonSerialization['details'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = SecurityEventTable();

  static const db = SecurityEventRepository._();

  @override
  int? id;

  String? userId;

  String eventType;

  String severity;

  String? ipAddress;

  String? deviceId;

  String? details;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SecurityEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SecurityEvent copyWith({
    int? id,
    String? userId,
    String? eventType,
    String? severity,
    String? ipAddress,
    String? deviceId,
    String? details,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SecurityEvent',
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      'eventType': eventType,
      'severity': severity,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (deviceId != null) 'deviceId': deviceId,
      if (details != null) 'details': details,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SecurityEvent',
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      'eventType': eventType,
      'severity': severity,
      if (ipAddress != null) 'ipAddress': ipAddress,
      if (deviceId != null) 'deviceId': deviceId,
      if (details != null) 'details': details,
      'createdAt': createdAt.toJson(),
    };
  }

  static SecurityEventInclude include() {
    return SecurityEventInclude._();
  }

  static SecurityEventIncludeList includeList({
    _i1.WhereExpressionBuilder<SecurityEventTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SecurityEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SecurityEventTable>? orderByList,
    SecurityEventInclude? include,
  }) {
    return SecurityEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SecurityEvent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SecurityEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SecurityEventImpl extends SecurityEvent {
  _SecurityEventImpl({
    int? id,
    String? userId,
    required String eventType,
    required String severity,
    String? ipAddress,
    String? deviceId,
    String? details,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         eventType: eventType,
         severity: severity,
         ipAddress: ipAddress,
         deviceId: deviceId,
         details: details,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SecurityEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SecurityEvent copyWith({
    Object? id = _Undefined,
    Object? userId = _Undefined,
    String? eventType,
    String? severity,
    Object? ipAddress = _Undefined,
    Object? deviceId = _Undefined,
    Object? details = _Undefined,
    DateTime? createdAt,
  }) {
    return SecurityEvent(
      id: id is int? ? id : this.id,
      userId: userId is String? ? userId : this.userId,
      eventType: eventType ?? this.eventType,
      severity: severity ?? this.severity,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      deviceId: deviceId is String? ? deviceId : this.deviceId,
      details: details is String? ? details : this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SecurityEventUpdateTable extends _i1.UpdateTable<SecurityEventTable> {
  SecurityEventUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String? value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> eventType(String value) => _i1.ColumnValue(
    table.eventType,
    value,
  );

  _i1.ColumnValue<String, String> severity(String value) => _i1.ColumnValue(
    table.severity,
    value,
  );

  _i1.ColumnValue<String, String> ipAddress(String? value) => _i1.ColumnValue(
    table.ipAddress,
    value,
  );

  _i1.ColumnValue<String, String> deviceId(String? value) => _i1.ColumnValue(
    table.deviceId,
    value,
  );

  _i1.ColumnValue<String, String> details(String? value) => _i1.ColumnValue(
    table.details,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class SecurityEventTable extends _i1.Table<int?> {
  SecurityEventTable({super.tableRelation})
    : super(tableName: 'security_events') {
    updateTable = SecurityEventUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    eventType = _i1.ColumnString(
      'eventType',
      this,
    );
    severity = _i1.ColumnString(
      'severity',
      this,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
    deviceId = _i1.ColumnString(
      'deviceId',
      this,
    );
    details = _i1.ColumnString(
      'details',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final SecurityEventUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnString eventType;

  late final _i1.ColumnString severity;

  late final _i1.ColumnString ipAddress;

  late final _i1.ColumnString deviceId;

  late final _i1.ColumnString details;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    eventType,
    severity,
    ipAddress,
    deviceId,
    details,
    createdAt,
  ];
}

class SecurityEventInclude extends _i1.IncludeObject {
  SecurityEventInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SecurityEvent.t;
}

class SecurityEventIncludeList extends _i1.IncludeList {
  SecurityEventIncludeList._({
    _i1.WhereExpressionBuilder<SecurityEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SecurityEvent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SecurityEvent.t;
}

class SecurityEventRepository {
  const SecurityEventRepository._();

  /// Returns a list of [SecurityEvent]s matching the given query parameters.
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
  Future<List<SecurityEvent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SecurityEventTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SecurityEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SecurityEventTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SecurityEvent>(
      where: where?.call(SecurityEvent.t),
      orderBy: orderBy?.call(SecurityEvent.t),
      orderByList: orderByList?.call(SecurityEvent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SecurityEvent] matching the given query parameters.
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
  Future<SecurityEvent?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SecurityEventTable>? where,
    int? offset,
    _i1.OrderByBuilder<SecurityEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SecurityEventTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SecurityEvent>(
      where: where?.call(SecurityEvent.t),
      orderBy: orderBy?.call(SecurityEvent.t),
      orderByList: orderByList?.call(SecurityEvent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SecurityEvent] by its [id] or null if no such row exists.
  Future<SecurityEvent?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SecurityEvent>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SecurityEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [SecurityEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<SecurityEvent>> insert(
    _i1.Session session,
    List<SecurityEvent> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<SecurityEvent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [SecurityEvent] and returns the inserted row.
  ///
  /// The returned [SecurityEvent] will have its `id` field set.
  Future<SecurityEvent> insertRow(
    _i1.Session session,
    SecurityEvent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SecurityEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SecurityEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SecurityEvent>> update(
    _i1.Session session,
    List<SecurityEvent> rows, {
    _i1.ColumnSelections<SecurityEventTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SecurityEvent>(
      rows,
      columns: columns?.call(SecurityEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SecurityEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SecurityEvent> updateRow(
    _i1.Session session,
    SecurityEvent row, {
    _i1.ColumnSelections<SecurityEventTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SecurityEvent>(
      row,
      columns: columns?.call(SecurityEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SecurityEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SecurityEvent?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<SecurityEventUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SecurityEvent>(
      id,
      columnValues: columnValues(SecurityEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SecurityEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SecurityEvent>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SecurityEventUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<SecurityEventTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SecurityEventTable>? orderBy,
    _i1.OrderByListBuilder<SecurityEventTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SecurityEvent>(
      columnValues: columnValues(SecurityEvent.t.updateTable),
      where: where(SecurityEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SecurityEvent.t),
      orderByList: orderByList?.call(SecurityEvent.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SecurityEvent]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SecurityEvent>> delete(
    _i1.Session session,
    List<SecurityEvent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SecurityEvent>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SecurityEvent].
  Future<SecurityEvent> deleteRow(
    _i1.Session session,
    SecurityEvent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SecurityEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SecurityEvent>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SecurityEventTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SecurityEvent>(
      where: where(SecurityEvent.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SecurityEventTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SecurityEvent>(
      where: where?.call(SecurityEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SecurityEvent] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SecurityEventTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SecurityEvent>(
      where: where(SecurityEvent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
