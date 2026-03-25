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

abstract class Alert implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Alert._({
    this.id,
    required this.userId,
    this.greenhouseId,
    this.plantId,
    this.trayId,
    required this.alertType,
    required this.severity,
    required this.title,
    required this.message,
    this.sourceEntityType,
    this.sourceEntityId,
    required this.isRead,
    required this.isAcknowledged,
    this.acknowledgedAt,
    this.acknowledgedBy,
    required this.isResolved,
    this.resolvedAt,
    required this.escalationLevel,
    required this.createdAt,
  });

  factory Alert({
    int? id,
    required String userId,
    int? greenhouseId,
    int? plantId,
    int? trayId,
    required String alertType,
    required String severity,
    required String title,
    required String message,
    String? sourceEntityType,
    int? sourceEntityId,
    required bool isRead,
    required bool isAcknowledged,
    DateTime? acknowledgedAt,
    String? acknowledgedBy,
    required bool isResolved,
    DateTime? resolvedAt,
    required int escalationLevel,
    required DateTime createdAt,
  }) = _AlertImpl;

  factory Alert.fromJson(Map<String, dynamic> jsonSerialization) {
    return Alert(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      greenhouseId: jsonSerialization['greenhouseId'] as int?,
      plantId: jsonSerialization['plantId'] as int?,
      trayId: jsonSerialization['trayId'] as int?,
      alertType: jsonSerialization['alertType'] as String,
      severity: jsonSerialization['severity'] as String,
      title: jsonSerialization['title'] as String,
      message: jsonSerialization['message'] as String,
      sourceEntityType: jsonSerialization['sourceEntityType'] as String?,
      sourceEntityId: jsonSerialization['sourceEntityId'] as int?,
      isRead: _i1.BoolJsonExtension.fromJson(jsonSerialization['isRead']),
      isAcknowledged: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isAcknowledged'],
      ),
      acknowledgedAt: jsonSerialization['acknowledgedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['acknowledgedAt'],
            ),
      acknowledgedBy: jsonSerialization['acknowledgedBy'] as String?,
      isResolved: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isResolved'],
      ),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
      escalationLevel: jsonSerialization['escalationLevel'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AlertTable();

  static const db = AlertRepository._();

  @override
  int? id;

  String userId;

  int? greenhouseId;

  int? plantId;

  int? trayId;

  String alertType;

  String severity;

  String title;

  String message;

  String? sourceEntityType;

  int? sourceEntityId;

  bool isRead;

  bool isAcknowledged;

  DateTime? acknowledgedAt;

  String? acknowledgedBy;

  bool isResolved;

  DateTime? resolvedAt;

  int escalationLevel;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Alert]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Alert copyWith({
    int? id,
    String? userId,
    int? greenhouseId,
    int? plantId,
    int? trayId,
    String? alertType,
    String? severity,
    String? title,
    String? message,
    String? sourceEntityType,
    int? sourceEntityId,
    bool? isRead,
    bool? isAcknowledged,
    DateTime? acknowledgedAt,
    String? acknowledgedBy,
    bool? isResolved,
    DateTime? resolvedAt,
    int? escalationLevel,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Alert',
      if (id != null) 'id': id,
      'userId': userId,
      if (greenhouseId != null) 'greenhouseId': greenhouseId,
      if (plantId != null) 'plantId': plantId,
      if (trayId != null) 'trayId': trayId,
      'alertType': alertType,
      'severity': severity,
      'title': title,
      'message': message,
      if (sourceEntityType != null) 'sourceEntityType': sourceEntityType,
      if (sourceEntityId != null) 'sourceEntityId': sourceEntityId,
      'isRead': isRead,
      'isAcknowledged': isAcknowledged,
      if (acknowledgedAt != null) 'acknowledgedAt': acknowledgedAt?.toJson(),
      if (acknowledgedBy != null) 'acknowledgedBy': acknowledgedBy,
      'isResolved': isResolved,
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      'escalationLevel': escalationLevel,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Alert',
      if (id != null) 'id': id,
      'userId': userId,
      if (greenhouseId != null) 'greenhouseId': greenhouseId,
      if (plantId != null) 'plantId': plantId,
      if (trayId != null) 'trayId': trayId,
      'alertType': alertType,
      'severity': severity,
      'title': title,
      'message': message,
      if (sourceEntityType != null) 'sourceEntityType': sourceEntityType,
      if (sourceEntityId != null) 'sourceEntityId': sourceEntityId,
      'isRead': isRead,
      'isAcknowledged': isAcknowledged,
      if (acknowledgedAt != null) 'acknowledgedAt': acknowledgedAt?.toJson(),
      if (acknowledgedBy != null) 'acknowledgedBy': acknowledgedBy,
      'isResolved': isResolved,
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      'escalationLevel': escalationLevel,
      'createdAt': createdAt.toJson(),
    };
  }

  static AlertInclude include() {
    return AlertInclude._();
  }

  static AlertIncludeList includeList({
    _i1.WhereExpressionBuilder<AlertTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AlertTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AlertTable>? orderByList,
    AlertInclude? include,
  }) {
    return AlertIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Alert.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Alert.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AlertImpl extends Alert {
  _AlertImpl({
    int? id,
    required String userId,
    int? greenhouseId,
    int? plantId,
    int? trayId,
    required String alertType,
    required String severity,
    required String title,
    required String message,
    String? sourceEntityType,
    int? sourceEntityId,
    required bool isRead,
    required bool isAcknowledged,
    DateTime? acknowledgedAt,
    String? acknowledgedBy,
    required bool isResolved,
    DateTime? resolvedAt,
    required int escalationLevel,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         greenhouseId: greenhouseId,
         plantId: plantId,
         trayId: trayId,
         alertType: alertType,
         severity: severity,
         title: title,
         message: message,
         sourceEntityType: sourceEntityType,
         sourceEntityId: sourceEntityId,
         isRead: isRead,
         isAcknowledged: isAcknowledged,
         acknowledgedAt: acknowledgedAt,
         acknowledgedBy: acknowledgedBy,
         isResolved: isResolved,
         resolvedAt: resolvedAt,
         escalationLevel: escalationLevel,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Alert]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Alert copyWith({
    Object? id = _Undefined,
    String? userId,
    Object? greenhouseId = _Undefined,
    Object? plantId = _Undefined,
    Object? trayId = _Undefined,
    String? alertType,
    String? severity,
    String? title,
    String? message,
    Object? sourceEntityType = _Undefined,
    Object? sourceEntityId = _Undefined,
    bool? isRead,
    bool? isAcknowledged,
    Object? acknowledgedAt = _Undefined,
    Object? acknowledgedBy = _Undefined,
    bool? isResolved,
    Object? resolvedAt = _Undefined,
    int? escalationLevel,
    DateTime? createdAt,
  }) {
    return Alert(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      greenhouseId: greenhouseId is int? ? greenhouseId : this.greenhouseId,
      plantId: plantId is int? ? plantId : this.plantId,
      trayId: trayId is int? ? trayId : this.trayId,
      alertType: alertType ?? this.alertType,
      severity: severity ?? this.severity,
      title: title ?? this.title,
      message: message ?? this.message,
      sourceEntityType: sourceEntityType is String?
          ? sourceEntityType
          : this.sourceEntityType,
      sourceEntityId: sourceEntityId is int?
          ? sourceEntityId
          : this.sourceEntityId,
      isRead: isRead ?? this.isRead,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
      acknowledgedAt: acknowledgedAt is DateTime?
          ? acknowledgedAt
          : this.acknowledgedAt,
      acknowledgedBy: acknowledgedBy is String?
          ? acknowledgedBy
          : this.acknowledgedBy,
      isResolved: isResolved ?? this.isResolved,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
      escalationLevel: escalationLevel ?? this.escalationLevel,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AlertUpdateTable extends _i1.UpdateTable<AlertTable> {
  AlertUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> greenhouseId(int? value) => _i1.ColumnValue(
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

  _i1.ColumnValue<String, String> alertType(String value) => _i1.ColumnValue(
    table.alertType,
    value,
  );

  _i1.ColumnValue<String, String> severity(String value) => _i1.ColumnValue(
    table.severity,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> message(String value) => _i1.ColumnValue(
    table.message,
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

  _i1.ColumnValue<bool, bool> isRead(bool value) => _i1.ColumnValue(
    table.isRead,
    value,
  );

  _i1.ColumnValue<bool, bool> isAcknowledged(bool value) => _i1.ColumnValue(
    table.isAcknowledged,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> acknowledgedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.acknowledgedAt,
        value,
      );

  _i1.ColumnValue<String, String> acknowledgedBy(String? value) =>
      _i1.ColumnValue(
        table.acknowledgedBy,
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

  _i1.ColumnValue<int, int> escalationLevel(int value) => _i1.ColumnValue(
    table.escalationLevel,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AlertTable extends _i1.Table<int?> {
  AlertTable({super.tableRelation}) : super(tableName: 'alerts') {
    updateTable = AlertUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
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
    alertType = _i1.ColumnString(
      'alertType',
      this,
    );
    severity = _i1.ColumnString(
      'severity',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    message = _i1.ColumnString(
      'message',
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
    isRead = _i1.ColumnBool(
      'isRead',
      this,
    );
    isAcknowledged = _i1.ColumnBool(
      'isAcknowledged',
      this,
    );
    acknowledgedAt = _i1.ColumnDateTime(
      'acknowledgedAt',
      this,
    );
    acknowledgedBy = _i1.ColumnString(
      'acknowledgedBy',
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
    escalationLevel = _i1.ColumnInt(
      'escalationLevel',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AlertUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnInt greenhouseId;

  late final _i1.ColumnInt plantId;

  late final _i1.ColumnInt trayId;

  late final _i1.ColumnString alertType;

  late final _i1.ColumnString severity;

  late final _i1.ColumnString title;

  late final _i1.ColumnString message;

  late final _i1.ColumnString sourceEntityType;

  late final _i1.ColumnInt sourceEntityId;

  late final _i1.ColumnBool isRead;

  late final _i1.ColumnBool isAcknowledged;

  late final _i1.ColumnDateTime acknowledgedAt;

  late final _i1.ColumnString acknowledgedBy;

  late final _i1.ColumnBool isResolved;

  late final _i1.ColumnDateTime resolvedAt;

  late final _i1.ColumnInt escalationLevel;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    greenhouseId,
    plantId,
    trayId,
    alertType,
    severity,
    title,
    message,
    sourceEntityType,
    sourceEntityId,
    isRead,
    isAcknowledged,
    acknowledgedAt,
    acknowledgedBy,
    isResolved,
    resolvedAt,
    escalationLevel,
    createdAt,
  ];
}

class AlertInclude extends _i1.IncludeObject {
  AlertInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Alert.t;
}

class AlertIncludeList extends _i1.IncludeList {
  AlertIncludeList._({
    _i1.WhereExpressionBuilder<AlertTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Alert.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Alert.t;
}

class AlertRepository {
  const AlertRepository._();

  /// Returns a list of [Alert]s matching the given query parameters.
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
  Future<List<Alert>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AlertTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AlertTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AlertTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Alert>(
      where: where?.call(Alert.t),
      orderBy: orderBy?.call(Alert.t),
      orderByList: orderByList?.call(Alert.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Alert] matching the given query parameters.
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
  Future<Alert?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AlertTable>? where,
    int? offset,
    _i1.OrderByBuilder<AlertTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AlertTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Alert>(
      where: where?.call(Alert.t),
      orderBy: orderBy?.call(Alert.t),
      orderByList: orderByList?.call(Alert.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Alert] by its [id] or null if no such row exists.
  Future<Alert?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Alert>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Alert]s in the list and returns the inserted rows.
  ///
  /// The returned [Alert]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Alert>> insert(
    _i1.Session session,
    List<Alert> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Alert>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Alert] and returns the inserted row.
  ///
  /// The returned [Alert] will have its `id` field set.
  Future<Alert> insertRow(
    _i1.Session session,
    Alert row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Alert>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Alert]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Alert>> update(
    _i1.Session session,
    List<Alert> rows, {
    _i1.ColumnSelections<AlertTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Alert>(
      rows,
      columns: columns?.call(Alert.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Alert]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Alert> updateRow(
    _i1.Session session,
    Alert row, {
    _i1.ColumnSelections<AlertTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Alert>(
      row,
      columns: columns?.call(Alert.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Alert] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Alert?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AlertUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Alert>(
      id,
      columnValues: columnValues(Alert.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Alert]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Alert>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AlertUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AlertTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AlertTable>? orderBy,
    _i1.OrderByListBuilder<AlertTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Alert>(
      columnValues: columnValues(Alert.t.updateTable),
      where: where(Alert.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Alert.t),
      orderByList: orderByList?.call(Alert.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Alert]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Alert>> delete(
    _i1.Session session,
    List<Alert> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Alert>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Alert].
  Future<Alert> deleteRow(
    _i1.Session session,
    Alert row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Alert>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Alert>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AlertTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Alert>(
      where: where(Alert.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AlertTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Alert>(
      where: where?.call(Alert.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Alert] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AlertTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Alert>(
      where: where(Alert.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
