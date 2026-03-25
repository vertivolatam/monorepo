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

abstract class SubscriptionPlan
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SubscriptionPlan._({
    this.id,
    required this.userId,
    required this.planType,
    required this.segment,
    required this.isActive,
    required this.features,
    required this.maxGreenhouses,
    required this.monthlyPriceUsd,
    required this.startDate,
    this.endDate,
    required this.createdAt,
  });

  factory SubscriptionPlan({
    int? id,
    required String userId,
    required String planType,
    required String segment,
    required bool isActive,
    required List<String> features,
    required int maxGreenhouses,
    required double monthlyPriceUsd,
    required DateTime startDate,
    DateTime? endDate,
    required DateTime createdAt,
  }) = _SubscriptionPlanImpl;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> jsonSerialization) {
    return SubscriptionPlan(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      planType: jsonSerialization['planType'] as String,
      segment: jsonSerialization['segment'] as String,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      features: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['features'],
      ),
      maxGreenhouses: jsonSerialization['maxGreenhouses'] as int,
      monthlyPriceUsd: (jsonSerialization['monthlyPriceUsd'] as num).toDouble(),
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = SubscriptionPlanTable();

  static const db = SubscriptionPlanRepository._();

  @override
  int? id;

  String userId;

  String planType;

  String segment;

  bool isActive;

  List<String> features;

  int maxGreenhouses;

  double monthlyPriceUsd;

  DateTime startDate;

  DateTime? endDate;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SubscriptionPlan]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SubscriptionPlan copyWith({
    int? id,
    String? userId,
    String? planType,
    String? segment,
    bool? isActive,
    List<String>? features,
    int? maxGreenhouses,
    double? monthlyPriceUsd,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SubscriptionPlan',
      if (id != null) 'id': id,
      'userId': userId,
      'planType': planType,
      'segment': segment,
      'isActive': isActive,
      'features': features.toJson(),
      'maxGreenhouses': maxGreenhouses,
      'monthlyPriceUsd': monthlyPriceUsd,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SubscriptionPlan',
      if (id != null) 'id': id,
      'userId': userId,
      'planType': planType,
      'segment': segment,
      'isActive': isActive,
      'features': features.toJson(),
      'maxGreenhouses': maxGreenhouses,
      'monthlyPriceUsd': monthlyPriceUsd,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static SubscriptionPlanInclude include() {
    return SubscriptionPlanInclude._();
  }

  static SubscriptionPlanIncludeList includeList({
    _i1.WhereExpressionBuilder<SubscriptionPlanTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SubscriptionPlanTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SubscriptionPlanTable>? orderByList,
    SubscriptionPlanInclude? include,
  }) {
    return SubscriptionPlanIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SubscriptionPlan.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SubscriptionPlan.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SubscriptionPlanImpl extends SubscriptionPlan {
  _SubscriptionPlanImpl({
    int? id,
    required String userId,
    required String planType,
    required String segment,
    required bool isActive,
    required List<String> features,
    required int maxGreenhouses,
    required double monthlyPriceUsd,
    required DateTime startDate,
    DateTime? endDate,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         planType: planType,
         segment: segment,
         isActive: isActive,
         features: features,
         maxGreenhouses: maxGreenhouses,
         monthlyPriceUsd: monthlyPriceUsd,
         startDate: startDate,
         endDate: endDate,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SubscriptionPlan]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SubscriptionPlan copyWith({
    Object? id = _Undefined,
    String? userId,
    String? planType,
    String? segment,
    bool? isActive,
    List<String>? features,
    int? maxGreenhouses,
    double? monthlyPriceUsd,
    DateTime? startDate,
    Object? endDate = _Undefined,
    DateTime? createdAt,
  }) {
    return SubscriptionPlan(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      planType: planType ?? this.planType,
      segment: segment ?? this.segment,
      isActive: isActive ?? this.isActive,
      features: features ?? this.features.map((e0) => e0).toList(),
      maxGreenhouses: maxGreenhouses ?? this.maxGreenhouses,
      monthlyPriceUsd: monthlyPriceUsd ?? this.monthlyPriceUsd,
      startDate: startDate ?? this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SubscriptionPlanUpdateTable
    extends _i1.UpdateTable<SubscriptionPlanTable> {
  SubscriptionPlanUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> planType(String value) => _i1.ColumnValue(
    table.planType,
    value,
  );

  _i1.ColumnValue<String, String> segment(String value) => _i1.ColumnValue(
    table.segment,
    value,
  );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> features(List<String> value) =>
      _i1.ColumnValue(
        table.features,
        value,
      );

  _i1.ColumnValue<int, int> maxGreenhouses(int value) => _i1.ColumnValue(
    table.maxGreenhouses,
    value,
  );

  _i1.ColumnValue<double, double> monthlyPriceUsd(double value) =>
      _i1.ColumnValue(
        table.monthlyPriceUsd,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> startDate(DateTime value) =>
      _i1.ColumnValue(
        table.startDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endDate(DateTime? value) =>
      _i1.ColumnValue(
        table.endDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class SubscriptionPlanTable extends _i1.Table<int?> {
  SubscriptionPlanTable({super.tableRelation})
    : super(tableName: 'subscription_plans') {
    updateTable = SubscriptionPlanUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    planType = _i1.ColumnString(
      'planType',
      this,
    );
    segment = _i1.ColumnString(
      'segment',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
    features = _i1.ColumnSerializable<List<String>>(
      'features',
      this,
    );
    maxGreenhouses = _i1.ColumnInt(
      'maxGreenhouses',
      this,
    );
    monthlyPriceUsd = _i1.ColumnDouble(
      'monthlyPriceUsd',
      this,
    );
    startDate = _i1.ColumnDateTime(
      'startDate',
      this,
    );
    endDate = _i1.ColumnDateTime(
      'endDate',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final SubscriptionPlanUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnString planType;

  late final _i1.ColumnString segment;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnSerializable<List<String>> features;

  late final _i1.ColumnInt maxGreenhouses;

  late final _i1.ColumnDouble monthlyPriceUsd;

  late final _i1.ColumnDateTime startDate;

  late final _i1.ColumnDateTime endDate;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    planType,
    segment,
    isActive,
    features,
    maxGreenhouses,
    monthlyPriceUsd,
    startDate,
    endDate,
    createdAt,
  ];
}

class SubscriptionPlanInclude extends _i1.IncludeObject {
  SubscriptionPlanInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SubscriptionPlan.t;
}

class SubscriptionPlanIncludeList extends _i1.IncludeList {
  SubscriptionPlanIncludeList._({
    _i1.WhereExpressionBuilder<SubscriptionPlanTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SubscriptionPlan.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SubscriptionPlan.t;
}

class SubscriptionPlanRepository {
  const SubscriptionPlanRepository._();

  /// Returns a list of [SubscriptionPlan]s matching the given query parameters.
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
  Future<List<SubscriptionPlan>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SubscriptionPlanTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SubscriptionPlanTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SubscriptionPlanTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SubscriptionPlan>(
      where: where?.call(SubscriptionPlan.t),
      orderBy: orderBy?.call(SubscriptionPlan.t),
      orderByList: orderByList?.call(SubscriptionPlan.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SubscriptionPlan] matching the given query parameters.
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
  Future<SubscriptionPlan?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SubscriptionPlanTable>? where,
    int? offset,
    _i1.OrderByBuilder<SubscriptionPlanTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SubscriptionPlanTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SubscriptionPlan>(
      where: where?.call(SubscriptionPlan.t),
      orderBy: orderBy?.call(SubscriptionPlan.t),
      orderByList: orderByList?.call(SubscriptionPlan.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SubscriptionPlan] by its [id] or null if no such row exists.
  Future<SubscriptionPlan?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SubscriptionPlan>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SubscriptionPlan]s in the list and returns the inserted rows.
  ///
  /// The returned [SubscriptionPlan]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<SubscriptionPlan>> insert(
    _i1.Session session,
    List<SubscriptionPlan> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<SubscriptionPlan>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [SubscriptionPlan] and returns the inserted row.
  ///
  /// The returned [SubscriptionPlan] will have its `id` field set.
  Future<SubscriptionPlan> insertRow(
    _i1.Session session,
    SubscriptionPlan row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SubscriptionPlan>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SubscriptionPlan]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SubscriptionPlan>> update(
    _i1.Session session,
    List<SubscriptionPlan> rows, {
    _i1.ColumnSelections<SubscriptionPlanTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SubscriptionPlan>(
      rows,
      columns: columns?.call(SubscriptionPlan.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SubscriptionPlan]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SubscriptionPlan> updateRow(
    _i1.Session session,
    SubscriptionPlan row, {
    _i1.ColumnSelections<SubscriptionPlanTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SubscriptionPlan>(
      row,
      columns: columns?.call(SubscriptionPlan.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SubscriptionPlan] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SubscriptionPlan?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<SubscriptionPlanUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SubscriptionPlan>(
      id,
      columnValues: columnValues(SubscriptionPlan.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SubscriptionPlan]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SubscriptionPlan>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SubscriptionPlanUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<SubscriptionPlanTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SubscriptionPlanTable>? orderBy,
    _i1.OrderByListBuilder<SubscriptionPlanTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SubscriptionPlan>(
      columnValues: columnValues(SubscriptionPlan.t.updateTable),
      where: where(SubscriptionPlan.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SubscriptionPlan.t),
      orderByList: orderByList?.call(SubscriptionPlan.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SubscriptionPlan]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SubscriptionPlan>> delete(
    _i1.Session session,
    List<SubscriptionPlan> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SubscriptionPlan>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SubscriptionPlan].
  Future<SubscriptionPlan> deleteRow(
    _i1.Session session,
    SubscriptionPlan row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SubscriptionPlan>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SubscriptionPlan>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SubscriptionPlanTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SubscriptionPlan>(
      where: where(SubscriptionPlan.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SubscriptionPlanTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SubscriptionPlan>(
      where: where?.call(SubscriptionPlan.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SubscriptionPlan] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SubscriptionPlanTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SubscriptionPlan>(
      where: where(SubscriptionPlan.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
