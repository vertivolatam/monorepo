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

abstract class AlertTemplate
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AlertTemplate._({
    this.id,
    required this.name,
    required this.alertType,
    required this.severity,
    required this.titleTemplate,
    required this.messageTemplate,
    required this.segmentTarget,
    required this.channels,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AlertTemplate({
    int? id,
    required String name,
    required String alertType,
    required String severity,
    required String titleTemplate,
    required String messageTemplate,
    required String segmentTarget,
    required List<String> channels,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AlertTemplateImpl;

  factory AlertTemplate.fromJson(Map<String, dynamic> jsonSerialization) {
    return AlertTemplate(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      alertType: jsonSerialization['alertType'] as String,
      severity: jsonSerialization['severity'] as String,
      titleTemplate: jsonSerialization['titleTemplate'] as String,
      messageTemplate: jsonSerialization['messageTemplate'] as String,
      segmentTarget: jsonSerialization['segmentTarget'] as String,
      channels: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['channels'],
      ),
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = AlertTemplateTable();

  static const db = AlertTemplateRepository._();

  @override
  int? id;

  String name;

  String alertType;

  String severity;

  String titleTemplate;

  String messageTemplate;

  String segmentTarget;

  List<String> channels;

  bool isActive;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AlertTemplate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AlertTemplate copyWith({
    int? id,
    String? name,
    String? alertType,
    String? severity,
    String? titleTemplate,
    String? messageTemplate,
    String? segmentTarget,
    List<String>? channels,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AlertTemplate',
      if (id != null) 'id': id,
      'name': name,
      'alertType': alertType,
      'severity': severity,
      'titleTemplate': titleTemplate,
      'messageTemplate': messageTemplate,
      'segmentTarget': segmentTarget,
      'channels': channels.toJson(),
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AlertTemplate',
      if (id != null) 'id': id,
      'name': name,
      'alertType': alertType,
      'severity': severity,
      'titleTemplate': titleTemplate,
      'messageTemplate': messageTemplate,
      'segmentTarget': segmentTarget,
      'channels': channels.toJson(),
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static AlertTemplateInclude include() {
    return AlertTemplateInclude._();
  }

  static AlertTemplateIncludeList includeList({
    _i1.WhereExpressionBuilder<AlertTemplateTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AlertTemplateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AlertTemplateTable>? orderByList,
    AlertTemplateInclude? include,
  }) {
    return AlertTemplateIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AlertTemplate.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AlertTemplate.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AlertTemplateImpl extends AlertTemplate {
  _AlertTemplateImpl({
    int? id,
    required String name,
    required String alertType,
    required String severity,
    required String titleTemplate,
    required String messageTemplate,
    required String segmentTarget,
    required List<String> channels,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         name: name,
         alertType: alertType,
         severity: severity,
         titleTemplate: titleTemplate,
         messageTemplate: messageTemplate,
         segmentTarget: segmentTarget,
         channels: channels,
         isActive: isActive,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AlertTemplate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AlertTemplate copyWith({
    Object? id = _Undefined,
    String? name,
    String? alertType,
    String? severity,
    String? titleTemplate,
    String? messageTemplate,
    String? segmentTarget,
    List<String>? channels,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AlertTemplate(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      alertType: alertType ?? this.alertType,
      severity: severity ?? this.severity,
      titleTemplate: titleTemplate ?? this.titleTemplate,
      messageTemplate: messageTemplate ?? this.messageTemplate,
      segmentTarget: segmentTarget ?? this.segmentTarget,
      channels: channels ?? this.channels.map((e0) => e0).toList(),
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AlertTemplateUpdateTable extends _i1.UpdateTable<AlertTemplateTable> {
  AlertTemplateUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
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

  _i1.ColumnValue<String, String> titleTemplate(String value) =>
      _i1.ColumnValue(
        table.titleTemplate,
        value,
      );

  _i1.ColumnValue<String, String> messageTemplate(String value) =>
      _i1.ColumnValue(
        table.messageTemplate,
        value,
      );

  _i1.ColumnValue<String, String> segmentTarget(String value) =>
      _i1.ColumnValue(
        table.segmentTarget,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> channels(List<String> value) =>
      _i1.ColumnValue(
        table.channels,
        value,
      );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class AlertTemplateTable extends _i1.Table<int?> {
  AlertTemplateTable({super.tableRelation})
    : super(tableName: 'alert_templates') {
    updateTable = AlertTemplateUpdateTable(this);
    name = _i1.ColumnString(
      'name',
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
    titleTemplate = _i1.ColumnString(
      'titleTemplate',
      this,
    );
    messageTemplate = _i1.ColumnString(
      'messageTemplate',
      this,
    );
    segmentTarget = _i1.ColumnString(
      'segmentTarget',
      this,
    );
    channels = _i1.ColumnSerializable<List<String>>(
      'channels',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final AlertTemplateUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString alertType;

  late final _i1.ColumnString severity;

  late final _i1.ColumnString titleTemplate;

  late final _i1.ColumnString messageTemplate;

  late final _i1.ColumnString segmentTarget;

  late final _i1.ColumnSerializable<List<String>> channels;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    alertType,
    severity,
    titleTemplate,
    messageTemplate,
    segmentTarget,
    channels,
    isActive,
    createdAt,
    updatedAt,
  ];
}

class AlertTemplateInclude extends _i1.IncludeObject {
  AlertTemplateInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AlertTemplate.t;
}

class AlertTemplateIncludeList extends _i1.IncludeList {
  AlertTemplateIncludeList._({
    _i1.WhereExpressionBuilder<AlertTemplateTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AlertTemplate.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AlertTemplate.t;
}

class AlertTemplateRepository {
  const AlertTemplateRepository._();

  /// Returns a list of [AlertTemplate]s matching the given query parameters.
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
  Future<List<AlertTemplate>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AlertTemplateTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AlertTemplateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AlertTemplateTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AlertTemplate>(
      where: where?.call(AlertTemplate.t),
      orderBy: orderBy?.call(AlertTemplate.t),
      orderByList: orderByList?.call(AlertTemplate.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AlertTemplate] matching the given query parameters.
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
  Future<AlertTemplate?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AlertTemplateTable>? where,
    int? offset,
    _i1.OrderByBuilder<AlertTemplateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AlertTemplateTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AlertTemplate>(
      where: where?.call(AlertTemplate.t),
      orderBy: orderBy?.call(AlertTemplate.t),
      orderByList: orderByList?.call(AlertTemplate.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AlertTemplate] by its [id] or null if no such row exists.
  Future<AlertTemplate?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AlertTemplate>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AlertTemplate]s in the list and returns the inserted rows.
  ///
  /// The returned [AlertTemplate]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AlertTemplate>> insert(
    _i1.Session session,
    List<AlertTemplate> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AlertTemplate>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AlertTemplate] and returns the inserted row.
  ///
  /// The returned [AlertTemplate] will have its `id` field set.
  Future<AlertTemplate> insertRow(
    _i1.Session session,
    AlertTemplate row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AlertTemplate>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AlertTemplate]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AlertTemplate>> update(
    _i1.Session session,
    List<AlertTemplate> rows, {
    _i1.ColumnSelections<AlertTemplateTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AlertTemplate>(
      rows,
      columns: columns?.call(AlertTemplate.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AlertTemplate]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AlertTemplate> updateRow(
    _i1.Session session,
    AlertTemplate row, {
    _i1.ColumnSelections<AlertTemplateTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AlertTemplate>(
      row,
      columns: columns?.call(AlertTemplate.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AlertTemplate] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AlertTemplate?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AlertTemplateUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AlertTemplate>(
      id,
      columnValues: columnValues(AlertTemplate.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AlertTemplate]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AlertTemplate>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AlertTemplateUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AlertTemplateTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AlertTemplateTable>? orderBy,
    _i1.OrderByListBuilder<AlertTemplateTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AlertTemplate>(
      columnValues: columnValues(AlertTemplate.t.updateTable),
      where: where(AlertTemplate.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AlertTemplate.t),
      orderByList: orderByList?.call(AlertTemplate.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AlertTemplate]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AlertTemplate>> delete(
    _i1.Session session,
    List<AlertTemplate> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AlertTemplate>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AlertTemplate].
  Future<AlertTemplate> deleteRow(
    _i1.Session session,
    AlertTemplate row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AlertTemplate>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AlertTemplate>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AlertTemplateTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AlertTemplate>(
      where: where(AlertTemplate.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AlertTemplateTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AlertTemplate>(
      where: where?.call(AlertTemplate.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AlertTemplate] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AlertTemplateTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AlertTemplate>(
      where: where(AlertTemplate.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
