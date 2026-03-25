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

abstract class ComplianceTemplate
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ComplianceTemplate._({
    this.id,
    required this.standardCode,
    required this.standardName,
    required this.version,
    required this.region,
    required this.category,
    required this.requiredEventTypes,
    this.requiredDocuments,
    this.validationRules,
    required this.isActive,
    required this.effectiveFrom,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ComplianceTemplate({
    int? id,
    required String standardCode,
    required String standardName,
    required String version,
    required String region,
    required String category,
    required List<String> requiredEventTypes,
    List<String>? requiredDocuments,
    String? validationRules,
    required bool isActive,
    required DateTime effectiveFrom,
    DateTime? expiresAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ComplianceTemplateImpl;

  factory ComplianceTemplate.fromJson(Map<String, dynamic> jsonSerialization) {
    return ComplianceTemplate(
      id: jsonSerialization['id'] as int?,
      standardCode: jsonSerialization['standardCode'] as String,
      standardName: jsonSerialization['standardName'] as String,
      version: jsonSerialization['version'] as String,
      region: jsonSerialization['region'] as String,
      category: jsonSerialization['category'] as String,
      requiredEventTypes: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['requiredEventTypes'],
      ),
      requiredDocuments: jsonSerialization['requiredDocuments'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['requiredDocuments'],
            ),
      validationRules: jsonSerialization['validationRules'] as String?,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      effectiveFrom: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['effectiveFrom'],
      ),
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = ComplianceTemplateTable();

  static const db = ComplianceTemplateRepository._();

  @override
  int? id;

  String standardCode;

  String standardName;

  String version;

  String region;

  String category;

  List<String> requiredEventTypes;

  List<String>? requiredDocuments;

  String? validationRules;

  bool isActive;

  DateTime effectiveFrom;

  DateTime? expiresAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ComplianceTemplate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ComplianceTemplate copyWith({
    int? id,
    String? standardCode,
    String? standardName,
    String? version,
    String? region,
    String? category,
    List<String>? requiredEventTypes,
    List<String>? requiredDocuments,
    String? validationRules,
    bool? isActive,
    DateTime? effectiveFrom,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ComplianceTemplate',
      if (id != null) 'id': id,
      'standardCode': standardCode,
      'standardName': standardName,
      'version': version,
      'region': region,
      'category': category,
      'requiredEventTypes': requiredEventTypes.toJson(),
      if (requiredDocuments != null)
        'requiredDocuments': requiredDocuments?.toJson(),
      if (validationRules != null) 'validationRules': validationRules,
      'isActive': isActive,
      'effectiveFrom': effectiveFrom.toJson(),
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ComplianceTemplate',
      if (id != null) 'id': id,
      'standardCode': standardCode,
      'standardName': standardName,
      'version': version,
      'region': region,
      'category': category,
      'requiredEventTypes': requiredEventTypes.toJson(),
      if (requiredDocuments != null)
        'requiredDocuments': requiredDocuments?.toJson(),
      if (validationRules != null) 'validationRules': validationRules,
      'isActive': isActive,
      'effectiveFrom': effectiveFrom.toJson(),
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static ComplianceTemplateInclude include() {
    return ComplianceTemplateInclude._();
  }

  static ComplianceTemplateIncludeList includeList({
    _i1.WhereExpressionBuilder<ComplianceTemplateTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComplianceTemplateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComplianceTemplateTable>? orderByList,
    ComplianceTemplateInclude? include,
  }) {
    return ComplianceTemplateIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ComplianceTemplate.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ComplianceTemplate.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ComplianceTemplateImpl extends ComplianceTemplate {
  _ComplianceTemplateImpl({
    int? id,
    required String standardCode,
    required String standardName,
    required String version,
    required String region,
    required String category,
    required List<String> requiredEventTypes,
    List<String>? requiredDocuments,
    String? validationRules,
    required bool isActive,
    required DateTime effectiveFrom,
    DateTime? expiresAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         standardCode: standardCode,
         standardName: standardName,
         version: version,
         region: region,
         category: category,
         requiredEventTypes: requiredEventTypes,
         requiredDocuments: requiredDocuments,
         validationRules: validationRules,
         isActive: isActive,
         effectiveFrom: effectiveFrom,
         expiresAt: expiresAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ComplianceTemplate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ComplianceTemplate copyWith({
    Object? id = _Undefined,
    String? standardCode,
    String? standardName,
    String? version,
    String? region,
    String? category,
    List<String>? requiredEventTypes,
    Object? requiredDocuments = _Undefined,
    Object? validationRules = _Undefined,
    bool? isActive,
    DateTime? effectiveFrom,
    Object? expiresAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ComplianceTemplate(
      id: id is int? ? id : this.id,
      standardCode: standardCode ?? this.standardCode,
      standardName: standardName ?? this.standardName,
      version: version ?? this.version,
      region: region ?? this.region,
      category: category ?? this.category,
      requiredEventTypes:
          requiredEventTypes ??
          this.requiredEventTypes.map((e0) => e0).toList(),
      requiredDocuments: requiredDocuments is List<String>?
          ? requiredDocuments
          : this.requiredDocuments?.map((e0) => e0).toList(),
      validationRules: validationRules is String?
          ? validationRules
          : this.validationRules,
      isActive: isActive ?? this.isActive,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ComplianceTemplateUpdateTable
    extends _i1.UpdateTable<ComplianceTemplateTable> {
  ComplianceTemplateUpdateTable(super.table);

  _i1.ColumnValue<String, String> standardCode(String value) => _i1.ColumnValue(
    table.standardCode,
    value,
  );

  _i1.ColumnValue<String, String> standardName(String value) => _i1.ColumnValue(
    table.standardName,
    value,
  );

  _i1.ColumnValue<String, String> version(String value) => _i1.ColumnValue(
    table.version,
    value,
  );

  _i1.ColumnValue<String, String> region(String value) => _i1.ColumnValue(
    table.region,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> requiredEventTypes(
    List<String> value,
  ) => _i1.ColumnValue(
    table.requiredEventTypes,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> requiredDocuments(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.requiredDocuments,
    value,
  );

  _i1.ColumnValue<String, String> validationRules(String? value) =>
      _i1.ColumnValue(
        table.validationRules,
        value,
      );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> effectiveFrom(DateTime value) =>
      _i1.ColumnValue(
        table.effectiveFrom,
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

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class ComplianceTemplateTable extends _i1.Table<int?> {
  ComplianceTemplateTable({super.tableRelation})
    : super(tableName: 'compliance_templates') {
    updateTable = ComplianceTemplateUpdateTable(this);
    standardCode = _i1.ColumnString(
      'standardCode',
      this,
    );
    standardName = _i1.ColumnString(
      'standardName',
      this,
    );
    version = _i1.ColumnString(
      'version',
      this,
    );
    region = _i1.ColumnString(
      'region',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    requiredEventTypes = _i1.ColumnSerializable<List<String>>(
      'requiredEventTypes',
      this,
    );
    requiredDocuments = _i1.ColumnSerializable<List<String>>(
      'requiredDocuments',
      this,
    );
    validationRules = _i1.ColumnString(
      'validationRules',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
    effectiveFrom = _i1.ColumnDateTime(
      'effectiveFrom',
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
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final ComplianceTemplateUpdateTable updateTable;

  late final _i1.ColumnString standardCode;

  late final _i1.ColumnString standardName;

  late final _i1.ColumnString version;

  late final _i1.ColumnString region;

  late final _i1.ColumnString category;

  late final _i1.ColumnSerializable<List<String>> requiredEventTypes;

  late final _i1.ColumnSerializable<List<String>> requiredDocuments;

  late final _i1.ColumnString validationRules;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime effectiveFrom;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    standardCode,
    standardName,
    version,
    region,
    category,
    requiredEventTypes,
    requiredDocuments,
    validationRules,
    isActive,
    effectiveFrom,
    expiresAt,
    createdAt,
    updatedAt,
  ];
}

class ComplianceTemplateInclude extends _i1.IncludeObject {
  ComplianceTemplateInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ComplianceTemplate.t;
}

class ComplianceTemplateIncludeList extends _i1.IncludeList {
  ComplianceTemplateIncludeList._({
    _i1.WhereExpressionBuilder<ComplianceTemplateTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ComplianceTemplate.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ComplianceTemplate.t;
}

class ComplianceTemplateRepository {
  const ComplianceTemplateRepository._();

  /// Returns a list of [ComplianceTemplate]s matching the given query parameters.
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
  Future<List<ComplianceTemplate>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ComplianceTemplateTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComplianceTemplateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComplianceTemplateTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ComplianceTemplate>(
      where: where?.call(ComplianceTemplate.t),
      orderBy: orderBy?.call(ComplianceTemplate.t),
      orderByList: orderByList?.call(ComplianceTemplate.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ComplianceTemplate] matching the given query parameters.
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
  Future<ComplianceTemplate?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ComplianceTemplateTable>? where,
    int? offset,
    _i1.OrderByBuilder<ComplianceTemplateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ComplianceTemplateTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ComplianceTemplate>(
      where: where?.call(ComplianceTemplate.t),
      orderBy: orderBy?.call(ComplianceTemplate.t),
      orderByList: orderByList?.call(ComplianceTemplate.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ComplianceTemplate] by its [id] or null if no such row exists.
  Future<ComplianceTemplate?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ComplianceTemplate>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ComplianceTemplate]s in the list and returns the inserted rows.
  ///
  /// The returned [ComplianceTemplate]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ComplianceTemplate>> insert(
    _i1.Session session,
    List<ComplianceTemplate> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ComplianceTemplate>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ComplianceTemplate] and returns the inserted row.
  ///
  /// The returned [ComplianceTemplate] will have its `id` field set.
  Future<ComplianceTemplate> insertRow(
    _i1.Session session,
    ComplianceTemplate row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ComplianceTemplate>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ComplianceTemplate]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ComplianceTemplate>> update(
    _i1.Session session,
    List<ComplianceTemplate> rows, {
    _i1.ColumnSelections<ComplianceTemplateTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ComplianceTemplate>(
      rows,
      columns: columns?.call(ComplianceTemplate.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ComplianceTemplate]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ComplianceTemplate> updateRow(
    _i1.Session session,
    ComplianceTemplate row, {
    _i1.ColumnSelections<ComplianceTemplateTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ComplianceTemplate>(
      row,
      columns: columns?.call(ComplianceTemplate.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ComplianceTemplate] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ComplianceTemplate?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ComplianceTemplateUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ComplianceTemplate>(
      id,
      columnValues: columnValues(ComplianceTemplate.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ComplianceTemplate]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ComplianceTemplate>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ComplianceTemplateUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ComplianceTemplateTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ComplianceTemplateTable>? orderBy,
    _i1.OrderByListBuilder<ComplianceTemplateTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ComplianceTemplate>(
      columnValues: columnValues(ComplianceTemplate.t.updateTable),
      where: where(ComplianceTemplate.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ComplianceTemplate.t),
      orderByList: orderByList?.call(ComplianceTemplate.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ComplianceTemplate]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ComplianceTemplate>> delete(
    _i1.Session session,
    List<ComplianceTemplate> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ComplianceTemplate>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ComplianceTemplate].
  Future<ComplianceTemplate> deleteRow(
    _i1.Session session,
    ComplianceTemplate row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ComplianceTemplate>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ComplianceTemplate>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ComplianceTemplateTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ComplianceTemplate>(
      where: where(ComplianceTemplate.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ComplianceTemplateTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ComplianceTemplate>(
      where: where?.call(ComplianceTemplate.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ComplianceTemplate] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ComplianceTemplateTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ComplianceTemplate>(
      where: where(ComplianceTemplate.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
