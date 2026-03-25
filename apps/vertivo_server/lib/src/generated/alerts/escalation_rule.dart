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

abstract class EscalationRule
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  EscalationRule._({
    this.id,
    required this.alertType,
    required this.severity,
    required this.escalationLevel,
    required this.delayMinutes,
    required this.notifyChannels,
    this.notifyRoles,
    this.autoResolveAfterMinutes,
    required this.isActive,
    required this.createdAt,
  });

  factory EscalationRule({
    int? id,
    required String alertType,
    required String severity,
    required int escalationLevel,
    required int delayMinutes,
    required List<String> notifyChannels,
    List<String>? notifyRoles,
    int? autoResolveAfterMinutes,
    required bool isActive,
    required DateTime createdAt,
  }) = _EscalationRuleImpl;

  factory EscalationRule.fromJson(Map<String, dynamic> jsonSerialization) {
    return EscalationRule(
      id: jsonSerialization['id'] as int?,
      alertType: jsonSerialization['alertType'] as String,
      severity: jsonSerialization['severity'] as String,
      escalationLevel: jsonSerialization['escalationLevel'] as int,
      delayMinutes: jsonSerialization['delayMinutes'] as int,
      notifyChannels: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['notifyChannels'],
      ),
      notifyRoles: jsonSerialization['notifyRoles'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['notifyRoles'],
            ),
      autoResolveAfterMinutes:
          jsonSerialization['autoResolveAfterMinutes'] as int?,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = EscalationRuleTable();

  static const db = EscalationRuleRepository._();

  @override
  int? id;

  String alertType;

  String severity;

  int escalationLevel;

  int delayMinutes;

  List<String> notifyChannels;

  List<String>? notifyRoles;

  int? autoResolveAfterMinutes;

  bool isActive;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [EscalationRule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EscalationRule copyWith({
    int? id,
    String? alertType,
    String? severity,
    int? escalationLevel,
    int? delayMinutes,
    List<String>? notifyChannels,
    List<String>? notifyRoles,
    int? autoResolveAfterMinutes,
    bool? isActive,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EscalationRule',
      if (id != null) 'id': id,
      'alertType': alertType,
      'severity': severity,
      'escalationLevel': escalationLevel,
      'delayMinutes': delayMinutes,
      'notifyChannels': notifyChannels.toJson(),
      if (notifyRoles != null) 'notifyRoles': notifyRoles?.toJson(),
      if (autoResolveAfterMinutes != null)
        'autoResolveAfterMinutes': autoResolveAfterMinutes,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EscalationRule',
      if (id != null) 'id': id,
      'alertType': alertType,
      'severity': severity,
      'escalationLevel': escalationLevel,
      'delayMinutes': delayMinutes,
      'notifyChannels': notifyChannels.toJson(),
      if (notifyRoles != null) 'notifyRoles': notifyRoles?.toJson(),
      if (autoResolveAfterMinutes != null)
        'autoResolveAfterMinutes': autoResolveAfterMinutes,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  static EscalationRuleInclude include() {
    return EscalationRuleInclude._();
  }

  static EscalationRuleIncludeList includeList({
    _i1.WhereExpressionBuilder<EscalationRuleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EscalationRuleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EscalationRuleTable>? orderByList,
    EscalationRuleInclude? include,
  }) {
    return EscalationRuleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EscalationRule.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EscalationRule.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EscalationRuleImpl extends EscalationRule {
  _EscalationRuleImpl({
    int? id,
    required String alertType,
    required String severity,
    required int escalationLevel,
    required int delayMinutes,
    required List<String> notifyChannels,
    List<String>? notifyRoles,
    int? autoResolveAfterMinutes,
    required bool isActive,
    required DateTime createdAt,
  }) : super._(
         id: id,
         alertType: alertType,
         severity: severity,
         escalationLevel: escalationLevel,
         delayMinutes: delayMinutes,
         notifyChannels: notifyChannels,
         notifyRoles: notifyRoles,
         autoResolveAfterMinutes: autoResolveAfterMinutes,
         isActive: isActive,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [EscalationRule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EscalationRule copyWith({
    Object? id = _Undefined,
    String? alertType,
    String? severity,
    int? escalationLevel,
    int? delayMinutes,
    List<String>? notifyChannels,
    Object? notifyRoles = _Undefined,
    Object? autoResolveAfterMinutes = _Undefined,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return EscalationRule(
      id: id is int? ? id : this.id,
      alertType: alertType ?? this.alertType,
      severity: severity ?? this.severity,
      escalationLevel: escalationLevel ?? this.escalationLevel,
      delayMinutes: delayMinutes ?? this.delayMinutes,
      notifyChannels:
          notifyChannels ?? this.notifyChannels.map((e0) => e0).toList(),
      notifyRoles: notifyRoles is List<String>?
          ? notifyRoles
          : this.notifyRoles?.map((e0) => e0).toList(),
      autoResolveAfterMinutes: autoResolveAfterMinutes is int?
          ? autoResolveAfterMinutes
          : this.autoResolveAfterMinutes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class EscalationRuleUpdateTable extends _i1.UpdateTable<EscalationRuleTable> {
  EscalationRuleUpdateTable(super.table);

  _i1.ColumnValue<String, String> alertType(String value) => _i1.ColumnValue(
    table.alertType,
    value,
  );

  _i1.ColumnValue<String, String> severity(String value) => _i1.ColumnValue(
    table.severity,
    value,
  );

  _i1.ColumnValue<int, int> escalationLevel(int value) => _i1.ColumnValue(
    table.escalationLevel,
    value,
  );

  _i1.ColumnValue<int, int> delayMinutes(int value) => _i1.ColumnValue(
    table.delayMinutes,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> notifyChannels(
    List<String> value,
  ) => _i1.ColumnValue(
    table.notifyChannels,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> notifyRoles(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.notifyRoles,
    value,
  );

  _i1.ColumnValue<int, int> autoResolveAfterMinutes(int? value) =>
      _i1.ColumnValue(
        table.autoResolveAfterMinutes,
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
}

class EscalationRuleTable extends _i1.Table<int?> {
  EscalationRuleTable({super.tableRelation})
    : super(tableName: 'escalation_rules') {
    updateTable = EscalationRuleUpdateTable(this);
    alertType = _i1.ColumnString(
      'alertType',
      this,
    );
    severity = _i1.ColumnString(
      'severity',
      this,
    );
    escalationLevel = _i1.ColumnInt(
      'escalationLevel',
      this,
    );
    delayMinutes = _i1.ColumnInt(
      'delayMinutes',
      this,
    );
    notifyChannels = _i1.ColumnSerializable<List<String>>(
      'notifyChannels',
      this,
    );
    notifyRoles = _i1.ColumnSerializable<List<String>>(
      'notifyRoles',
      this,
    );
    autoResolveAfterMinutes = _i1.ColumnInt(
      'autoResolveAfterMinutes',
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
  }

  late final EscalationRuleUpdateTable updateTable;

  late final _i1.ColumnString alertType;

  late final _i1.ColumnString severity;

  late final _i1.ColumnInt escalationLevel;

  late final _i1.ColumnInt delayMinutes;

  late final _i1.ColumnSerializable<List<String>> notifyChannels;

  late final _i1.ColumnSerializable<List<String>> notifyRoles;

  late final _i1.ColumnInt autoResolveAfterMinutes;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    alertType,
    severity,
    escalationLevel,
    delayMinutes,
    notifyChannels,
    notifyRoles,
    autoResolveAfterMinutes,
    isActive,
    createdAt,
  ];
}

class EscalationRuleInclude extends _i1.IncludeObject {
  EscalationRuleInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => EscalationRule.t;
}

class EscalationRuleIncludeList extends _i1.IncludeList {
  EscalationRuleIncludeList._({
    _i1.WhereExpressionBuilder<EscalationRuleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EscalationRule.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => EscalationRule.t;
}

class EscalationRuleRepository {
  const EscalationRuleRepository._();

  /// Returns a list of [EscalationRule]s matching the given query parameters.
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
  Future<List<EscalationRule>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EscalationRuleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EscalationRuleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EscalationRuleTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EscalationRule>(
      where: where?.call(EscalationRule.t),
      orderBy: orderBy?.call(EscalationRule.t),
      orderByList: orderByList?.call(EscalationRule.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EscalationRule] matching the given query parameters.
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
  Future<EscalationRule?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EscalationRuleTable>? where,
    int? offset,
    _i1.OrderByBuilder<EscalationRuleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EscalationRuleTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EscalationRule>(
      where: where?.call(EscalationRule.t),
      orderBy: orderBy?.call(EscalationRule.t),
      orderByList: orderByList?.call(EscalationRule.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EscalationRule] by its [id] or null if no such row exists.
  Future<EscalationRule?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EscalationRule>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EscalationRule]s in the list and returns the inserted rows.
  ///
  /// The returned [EscalationRule]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<EscalationRule>> insert(
    _i1.Session session,
    List<EscalationRule> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<EscalationRule>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [EscalationRule] and returns the inserted row.
  ///
  /// The returned [EscalationRule] will have its `id` field set.
  Future<EscalationRule> insertRow(
    _i1.Session session,
    EscalationRule row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EscalationRule>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EscalationRule]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EscalationRule>> update(
    _i1.Session session,
    List<EscalationRule> rows, {
    _i1.ColumnSelections<EscalationRuleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EscalationRule>(
      rows,
      columns: columns?.call(EscalationRule.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EscalationRule]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EscalationRule> updateRow(
    _i1.Session session,
    EscalationRule row, {
    _i1.ColumnSelections<EscalationRuleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EscalationRule>(
      row,
      columns: columns?.call(EscalationRule.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EscalationRule] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EscalationRule?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<EscalationRuleUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<EscalationRule>(
      id,
      columnValues: columnValues(EscalationRule.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EscalationRule]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<EscalationRule>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<EscalationRuleUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<EscalationRuleTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EscalationRuleTable>? orderBy,
    _i1.OrderByListBuilder<EscalationRuleTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<EscalationRule>(
      columnValues: columnValues(EscalationRule.t.updateTable),
      where: where(EscalationRule.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EscalationRule.t),
      orderByList: orderByList?.call(EscalationRule.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [EscalationRule]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EscalationRule>> delete(
    _i1.Session session,
    List<EscalationRule> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EscalationRule>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EscalationRule].
  Future<EscalationRule> deleteRow(
    _i1.Session session,
    EscalationRule row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EscalationRule>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EscalationRule>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EscalationRuleTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EscalationRule>(
      where: where(EscalationRule.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EscalationRuleTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EscalationRule>(
      where: where?.call(EscalationRule.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EscalationRule] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EscalationRuleTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EscalationRule>(
      where: where(EscalationRule.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
