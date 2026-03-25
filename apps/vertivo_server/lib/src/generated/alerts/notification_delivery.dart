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

abstract class NotificationDelivery
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  NotificationDelivery._({
    this.id,
    required this.alertId,
    required this.userId,
    required this.channel,
    required this.status,
    this.sentAt,
    this.deliveredAt,
    this.readAt,
    this.failureReason,
    required this.retryCount,
    required this.createdAt,
  });

  factory NotificationDelivery({
    int? id,
    required int alertId,
    required String userId,
    required String channel,
    required String status,
    DateTime? sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    String? failureReason,
    required int retryCount,
    required DateTime createdAt,
  }) = _NotificationDeliveryImpl;

  factory NotificationDelivery.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationDelivery(
      id: jsonSerialization['id'] as int?,
      alertId: jsonSerialization['alertId'] as int,
      userId: jsonSerialization['userId'] as String,
      channel: jsonSerialization['channel'] as String,
      status: jsonSerialization['status'] as String,
      sentAt: jsonSerialization['sentAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
      deliveredAt: jsonSerialization['deliveredAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveredAt'],
            ),
      readAt: jsonSerialization['readAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
      failureReason: jsonSerialization['failureReason'] as String?,
      retryCount: jsonSerialization['retryCount'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = NotificationDeliveryTable();

  static const db = NotificationDeliveryRepository._();

  @override
  int? id;

  int alertId;

  String userId;

  String channel;

  String status;

  DateTime? sentAt;

  DateTime? deliveredAt;

  DateTime? readAt;

  String? failureReason;

  int retryCount;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [NotificationDelivery]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationDelivery copyWith({
    int? id,
    int? alertId,
    String? userId,
    String? channel,
    String? status,
    DateTime? sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    String? failureReason,
    int? retryCount,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationDelivery',
      if (id != null) 'id': id,
      'alertId': alertId,
      'userId': userId,
      'channel': channel,
      'status': status,
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
      if (failureReason != null) 'failureReason': failureReason,
      'retryCount': retryCount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotificationDelivery',
      if (id != null) 'id': id,
      'alertId': alertId,
      'userId': userId,
      'channel': channel,
      'status': status,
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
      if (failureReason != null) 'failureReason': failureReason,
      'retryCount': retryCount,
      'createdAt': createdAt.toJson(),
    };
  }

  static NotificationDeliveryInclude include() {
    return NotificationDeliveryInclude._();
  }

  static NotificationDeliveryIncludeList includeList({
    _i1.WhereExpressionBuilder<NotificationDeliveryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationDeliveryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationDeliveryTable>? orderByList,
    NotificationDeliveryInclude? include,
  }) {
    return NotificationDeliveryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationDelivery.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(NotificationDelivery.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationDeliveryImpl extends NotificationDelivery {
  _NotificationDeliveryImpl({
    int? id,
    required int alertId,
    required String userId,
    required String channel,
    required String status,
    DateTime? sentAt,
    DateTime? deliveredAt,
    DateTime? readAt,
    String? failureReason,
    required int retryCount,
    required DateTime createdAt,
  }) : super._(
         id: id,
         alertId: alertId,
         userId: userId,
         channel: channel,
         status: status,
         sentAt: sentAt,
         deliveredAt: deliveredAt,
         readAt: readAt,
         failureReason: failureReason,
         retryCount: retryCount,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NotificationDelivery]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationDelivery copyWith({
    Object? id = _Undefined,
    int? alertId,
    String? userId,
    String? channel,
    String? status,
    Object? sentAt = _Undefined,
    Object? deliveredAt = _Undefined,
    Object? readAt = _Undefined,
    Object? failureReason = _Undefined,
    int? retryCount,
    DateTime? createdAt,
  }) {
    return NotificationDelivery(
      id: id is int? ? id : this.id,
      alertId: alertId ?? this.alertId,
      userId: userId ?? this.userId,
      channel: channel ?? this.channel,
      status: status ?? this.status,
      sentAt: sentAt is DateTime? ? sentAt : this.sentAt,
      deliveredAt: deliveredAt is DateTime? ? deliveredAt : this.deliveredAt,
      readAt: readAt is DateTime? ? readAt : this.readAt,
      failureReason: failureReason is String?
          ? failureReason
          : this.failureReason,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class NotificationDeliveryUpdateTable
    extends _i1.UpdateTable<NotificationDeliveryTable> {
  NotificationDeliveryUpdateTable(super.table);

  _i1.ColumnValue<int, int> alertId(int value) => _i1.ColumnValue(
    table.alertId,
    value,
  );

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> channel(String value) => _i1.ColumnValue(
    table.channel,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> sentAt(DateTime? value) =>
      _i1.ColumnValue(
        table.sentAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> deliveredAt(DateTime? value) =>
      _i1.ColumnValue(
        table.deliveredAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> readAt(DateTime? value) =>
      _i1.ColumnValue(
        table.readAt,
        value,
      );

  _i1.ColumnValue<String, String> failureReason(String? value) =>
      _i1.ColumnValue(
        table.failureReason,
        value,
      );

  _i1.ColumnValue<int, int> retryCount(int value) => _i1.ColumnValue(
    table.retryCount,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class NotificationDeliveryTable extends _i1.Table<int?> {
  NotificationDeliveryTable({super.tableRelation})
    : super(tableName: 'notification_deliveries') {
    updateTable = NotificationDeliveryUpdateTable(this);
    alertId = _i1.ColumnInt(
      'alertId',
      this,
    );
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    channel = _i1.ColumnString(
      'channel',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    sentAt = _i1.ColumnDateTime(
      'sentAt',
      this,
    );
    deliveredAt = _i1.ColumnDateTime(
      'deliveredAt',
      this,
    );
    readAt = _i1.ColumnDateTime(
      'readAt',
      this,
    );
    failureReason = _i1.ColumnString(
      'failureReason',
      this,
    );
    retryCount = _i1.ColumnInt(
      'retryCount',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final NotificationDeliveryUpdateTable updateTable;

  late final _i1.ColumnInt alertId;

  late final _i1.ColumnString userId;

  late final _i1.ColumnString channel;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime sentAt;

  late final _i1.ColumnDateTime deliveredAt;

  late final _i1.ColumnDateTime readAt;

  late final _i1.ColumnString failureReason;

  late final _i1.ColumnInt retryCount;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    alertId,
    userId,
    channel,
    status,
    sentAt,
    deliveredAt,
    readAt,
    failureReason,
    retryCount,
    createdAt,
  ];
}

class NotificationDeliveryInclude extends _i1.IncludeObject {
  NotificationDeliveryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => NotificationDelivery.t;
}

class NotificationDeliveryIncludeList extends _i1.IncludeList {
  NotificationDeliveryIncludeList._({
    _i1.WhereExpressionBuilder<NotificationDeliveryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotificationDelivery.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => NotificationDelivery.t;
}

class NotificationDeliveryRepository {
  const NotificationDeliveryRepository._();

  /// Returns a list of [NotificationDelivery]s matching the given query parameters.
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
  Future<List<NotificationDelivery>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NotificationDeliveryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationDeliveryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationDeliveryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotificationDelivery>(
      where: where?.call(NotificationDelivery.t),
      orderBy: orderBy?.call(NotificationDelivery.t),
      orderByList: orderByList?.call(NotificationDelivery.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotificationDelivery] matching the given query parameters.
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
  Future<NotificationDelivery?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NotificationDeliveryTable>? where,
    int? offset,
    _i1.OrderByBuilder<NotificationDeliveryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationDeliveryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotificationDelivery>(
      where: where?.call(NotificationDelivery.t),
      orderBy: orderBy?.call(NotificationDelivery.t),
      orderByList: orderByList?.call(NotificationDelivery.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotificationDelivery] by its [id] or null if no such row exists.
  Future<NotificationDelivery?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotificationDelivery>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotificationDelivery]s in the list and returns the inserted rows.
  ///
  /// The returned [NotificationDelivery]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<NotificationDelivery>> insert(
    _i1.Session session,
    List<NotificationDelivery> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<NotificationDelivery>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [NotificationDelivery] and returns the inserted row.
  ///
  /// The returned [NotificationDelivery] will have its `id` field set.
  Future<NotificationDelivery> insertRow(
    _i1.Session session,
    NotificationDelivery row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotificationDelivery>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [NotificationDelivery]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<NotificationDelivery>> update(
    _i1.Session session,
    List<NotificationDelivery> rows, {
    _i1.ColumnSelections<NotificationDeliveryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<NotificationDelivery>(
      rows,
      columns: columns?.call(NotificationDelivery.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationDelivery]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotificationDelivery> updateRow(
    _i1.Session session,
    NotificationDelivery row, {
    _i1.ColumnSelections<NotificationDeliveryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotificationDelivery>(
      row,
      columns: columns?.call(NotificationDelivery.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationDelivery] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotificationDelivery?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<NotificationDeliveryUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<NotificationDelivery>(
      id,
      columnValues: columnValues(NotificationDelivery.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotificationDelivery]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<NotificationDelivery>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<NotificationDeliveryUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<NotificationDeliveryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationDeliveryTable>? orderBy,
    _i1.OrderByListBuilder<NotificationDeliveryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<NotificationDelivery>(
      columnValues: columnValues(NotificationDelivery.t.updateTable),
      where: where(NotificationDelivery.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationDelivery.t),
      orderByList: orderByList?.call(NotificationDelivery.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [NotificationDelivery]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<NotificationDelivery>> delete(
    _i1.Session session,
    List<NotificationDelivery> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<NotificationDelivery>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [NotificationDelivery].
  Future<NotificationDelivery> deleteRow(
    _i1.Session session,
    NotificationDelivery row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotificationDelivery>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<NotificationDelivery>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<NotificationDeliveryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<NotificationDelivery>(
      where: where(NotificationDelivery.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NotificationDeliveryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<NotificationDelivery>(
      where: where?.call(NotificationDelivery.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotificationDelivery] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<NotificationDeliveryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotificationDelivery>(
      where: where(NotificationDelivery.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
