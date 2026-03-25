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

abstract class ApiToken
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ApiToken._({
    this.id,
    required this.userId,
    required this.name,
    required this.token,
    required this.scopes,
    required this.isActive,
    this.lastUsedAt,
    this.expiresAt,
    required this.createdAt,
  });

  factory ApiToken({
    int? id,
    required String userId,
    required String name,
    required String token,
    required List<String> scopes,
    required bool isActive,
    DateTime? lastUsedAt,
    DateTime? expiresAt,
    required DateTime createdAt,
  }) = _ApiTokenImpl;

  factory ApiToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApiToken(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      name: jsonSerialization['name'] as String,
      token: jsonSerialization['token'] as String,
      scopes: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['scopes'],
      ),
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      lastUsedAt: jsonSerialization['lastUsedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastUsedAt']),
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = ApiTokenTable();

  static const db = ApiTokenRepository._();

  @override
  int? id;

  String userId;

  String name;

  String token;

  List<String> scopes;

  bool isActive;

  DateTime? lastUsedAt;

  DateTime? expiresAt;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ApiToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ApiToken copyWith({
    int? id,
    String? userId,
    String? name,
    String? token,
    List<String>? scopes,
    bool? isActive,
    DateTime? lastUsedAt,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApiToken',
      if (id != null) 'id': id,
      'userId': userId,
      'name': name,
      'token': token,
      'scopes': scopes.toJson(),
      'isActive': isActive,
      if (lastUsedAt != null) 'lastUsedAt': lastUsedAt?.toJson(),
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApiToken',
      if (id != null) 'id': id,
      'userId': userId,
      'name': name,
      'token': token,
      'scopes': scopes.toJson(),
      'isActive': isActive,
      if (lastUsedAt != null) 'lastUsedAt': lastUsedAt?.toJson(),
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static ApiTokenInclude include() {
    return ApiTokenInclude._();
  }

  static ApiTokenIncludeList includeList({
    _i1.WhereExpressionBuilder<ApiTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ApiTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ApiTokenTable>? orderByList,
    ApiTokenInclude? include,
  }) {
    return ApiTokenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ApiToken.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ApiToken.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApiTokenImpl extends ApiToken {
  _ApiTokenImpl({
    int? id,
    required String userId,
    required String name,
    required String token,
    required List<String> scopes,
    required bool isActive,
    DateTime? lastUsedAt,
    DateTime? expiresAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         name: name,
         token: token,
         scopes: scopes,
         isActive: isActive,
         lastUsedAt: lastUsedAt,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ApiToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ApiToken copyWith({
    Object? id = _Undefined,
    String? userId,
    String? name,
    String? token,
    List<String>? scopes,
    bool? isActive,
    Object? lastUsedAt = _Undefined,
    Object? expiresAt = _Undefined,
    DateTime? createdAt,
  }) {
    return ApiToken(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      token: token ?? this.token,
      scopes: scopes ?? this.scopes.map((e0) => e0).toList(),
      isActive: isActive ?? this.isActive,
      lastUsedAt: lastUsedAt is DateTime? ? lastUsedAt : this.lastUsedAt,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ApiTokenUpdateTable extends _i1.UpdateTable<ApiTokenTable> {
  ApiTokenUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> token(String value) => _i1.ColumnValue(
    table.token,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> scopes(List<String> value) =>
      _i1.ColumnValue(
        table.scopes,
        value,
      );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastUsedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.lastUsedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> expiresAt(DateTime? value) =>
      _i1.ColumnValue(
        table.expiresAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class ApiTokenTable extends _i1.Table<int?> {
  ApiTokenTable({super.tableRelation}) : super(tableName: 'api_tokens') {
    updateTable = ApiTokenUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    token = _i1.ColumnString(
      'token',
      this,
    );
    scopes = _i1.ColumnSerializable<List<String>>(
      'scopes',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
    lastUsedAt = _i1.ColumnDateTime(
      'lastUsedAt',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final ApiTokenUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString token;

  late final _i1.ColumnSerializable<List<String>> scopes;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime lastUsedAt;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    name,
    token,
    scopes,
    isActive,
    lastUsedAt,
    expiresAt,
    createdAt,
  ];
}

class ApiTokenInclude extends _i1.IncludeObject {
  ApiTokenInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ApiToken.t;
}

class ApiTokenIncludeList extends _i1.IncludeList {
  ApiTokenIncludeList._({
    _i1.WhereExpressionBuilder<ApiTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ApiToken.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ApiToken.t;
}

class ApiTokenRepository {
  const ApiTokenRepository._();

  /// Returns a list of [ApiToken]s matching the given query parameters.
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
  Future<List<ApiToken>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ApiTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ApiTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ApiTokenTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ApiToken>(
      where: where?.call(ApiToken.t),
      orderBy: orderBy?.call(ApiToken.t),
      orderByList: orderByList?.call(ApiToken.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ApiToken] matching the given query parameters.
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
  Future<ApiToken?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ApiTokenTable>? where,
    int? offset,
    _i1.OrderByBuilder<ApiTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ApiTokenTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ApiToken>(
      where: where?.call(ApiToken.t),
      orderBy: orderBy?.call(ApiToken.t),
      orderByList: orderByList?.call(ApiToken.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ApiToken] by its [id] or null if no such row exists.
  Future<ApiToken?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ApiToken>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ApiToken]s in the list and returns the inserted rows.
  ///
  /// The returned [ApiToken]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ApiToken>> insert(
    _i1.Session session,
    List<ApiToken> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ApiToken>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ApiToken] and returns the inserted row.
  ///
  /// The returned [ApiToken] will have its `id` field set.
  Future<ApiToken> insertRow(
    _i1.Session session,
    ApiToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ApiToken>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ApiToken]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ApiToken>> update(
    _i1.Session session,
    List<ApiToken> rows, {
    _i1.ColumnSelections<ApiTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ApiToken>(
      rows,
      columns: columns?.call(ApiToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ApiToken]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ApiToken> updateRow(
    _i1.Session session,
    ApiToken row, {
    _i1.ColumnSelections<ApiTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ApiToken>(
      row,
      columns: columns?.call(ApiToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ApiToken] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ApiToken?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ApiTokenUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ApiToken>(
      id,
      columnValues: columnValues(ApiToken.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ApiToken]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ApiToken>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ApiTokenUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ApiTokenTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ApiTokenTable>? orderBy,
    _i1.OrderByListBuilder<ApiTokenTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ApiToken>(
      columnValues: columnValues(ApiToken.t.updateTable),
      where: where(ApiToken.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ApiToken.t),
      orderByList: orderByList?.call(ApiToken.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ApiToken]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ApiToken>> delete(
    _i1.Session session,
    List<ApiToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ApiToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ApiToken].
  Future<ApiToken> deleteRow(
    _i1.Session session,
    ApiToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ApiToken>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ApiToken>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ApiTokenTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ApiToken>(
      where: where(ApiToken.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ApiTokenTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ApiToken>(
      where: where?.call(ApiToken.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ApiToken] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ApiTokenTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ApiToken>(
      where: where(ApiToken.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
