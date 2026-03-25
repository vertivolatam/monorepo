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

abstract class Tray implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Tray._({
    this.id,
    required this.greenhouseId,
    required this.position,
    this.label,
    this.cropType,
    this.plantingDate,
    this.expectedHarvestDate,
    required this.status,
    required this.plantCount,
    this.healthScore,
    this.soilPh,
    this.soilMoisture,
    this.soilFertility,
    this.lastIrrigatedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tray({
    int? id,
    required int greenhouseId,
    required int position,
    String? label,
    String? cropType,
    DateTime? plantingDate,
    DateTime? expectedHarvestDate,
    required String status,
    required int plantCount,
    double? healthScore,
    double? soilPh,
    double? soilMoisture,
    String? soilFertility,
    DateTime? lastIrrigatedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TrayImpl;

  factory Tray.fromJson(Map<String, dynamic> jsonSerialization) {
    return Tray(
      id: jsonSerialization['id'] as int?,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      position: jsonSerialization['position'] as int,
      label: jsonSerialization['label'] as String?,
      cropType: jsonSerialization['cropType'] as String?,
      plantingDate: jsonSerialization['plantingDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['plantingDate'],
            ),
      expectedHarvestDate: jsonSerialization['expectedHarvestDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['expectedHarvestDate'],
            ),
      status: jsonSerialization['status'] as String,
      plantCount: jsonSerialization['plantCount'] as int,
      healthScore: (jsonSerialization['healthScore'] as num?)?.toDouble(),
      soilPh: (jsonSerialization['soilPh'] as num?)?.toDouble(),
      soilMoisture: (jsonSerialization['soilMoisture'] as num?)?.toDouble(),
      soilFertility: jsonSerialization['soilFertility'] as String?,
      lastIrrigatedAt: jsonSerialization['lastIrrigatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastIrrigatedAt'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = TrayTable();

  static const db = TrayRepository._();

  @override
  int? id;

  int greenhouseId;

  int position;

  String? label;

  String? cropType;

  DateTime? plantingDate;

  DateTime? expectedHarvestDate;

  String status;

  int plantCount;

  double? healthScore;

  double? soilPh;

  double? soilMoisture;

  String? soilFertility;

  DateTime? lastIrrigatedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Tray]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Tray copyWith({
    int? id,
    int? greenhouseId,
    int? position,
    String? label,
    String? cropType,
    DateTime? plantingDate,
    DateTime? expectedHarvestDate,
    String? status,
    int? plantCount,
    double? healthScore,
    double? soilPh,
    double? soilMoisture,
    String? soilFertility,
    DateTime? lastIrrigatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Tray',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      'position': position,
      if (label != null) 'label': label,
      if (cropType != null) 'cropType': cropType,
      if (plantingDate != null) 'plantingDate': plantingDate?.toJson(),
      if (expectedHarvestDate != null)
        'expectedHarvestDate': expectedHarvestDate?.toJson(),
      'status': status,
      'plantCount': plantCount,
      if (healthScore != null) 'healthScore': healthScore,
      if (soilPh != null) 'soilPh': soilPh,
      if (soilMoisture != null) 'soilMoisture': soilMoisture,
      if (soilFertility != null) 'soilFertility': soilFertility,
      if (lastIrrigatedAt != null) 'lastIrrigatedAt': lastIrrigatedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Tray',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      'position': position,
      if (label != null) 'label': label,
      if (cropType != null) 'cropType': cropType,
      if (plantingDate != null) 'plantingDate': plantingDate?.toJson(),
      if (expectedHarvestDate != null)
        'expectedHarvestDate': expectedHarvestDate?.toJson(),
      'status': status,
      'plantCount': plantCount,
      if (healthScore != null) 'healthScore': healthScore,
      if (soilPh != null) 'soilPh': soilPh,
      if (soilMoisture != null) 'soilMoisture': soilMoisture,
      if (soilFertility != null) 'soilFertility': soilFertility,
      if (lastIrrigatedAt != null) 'lastIrrigatedAt': lastIrrigatedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static TrayInclude include() {
    return TrayInclude._();
  }

  static TrayIncludeList includeList({
    _i1.WhereExpressionBuilder<TrayTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TrayTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TrayTable>? orderByList,
    TrayInclude? include,
  }) {
    return TrayIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Tray.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Tray.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TrayImpl extends Tray {
  _TrayImpl({
    int? id,
    required int greenhouseId,
    required int position,
    String? label,
    String? cropType,
    DateTime? plantingDate,
    DateTime? expectedHarvestDate,
    required String status,
    required int plantCount,
    double? healthScore,
    double? soilPh,
    double? soilMoisture,
    String? soilFertility,
    DateTime? lastIrrigatedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         greenhouseId: greenhouseId,
         position: position,
         label: label,
         cropType: cropType,
         plantingDate: plantingDate,
         expectedHarvestDate: expectedHarvestDate,
         status: status,
         plantCount: plantCount,
         healthScore: healthScore,
         soilPh: soilPh,
         soilMoisture: soilMoisture,
         soilFertility: soilFertility,
         lastIrrigatedAt: lastIrrigatedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Tray]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Tray copyWith({
    Object? id = _Undefined,
    int? greenhouseId,
    int? position,
    Object? label = _Undefined,
    Object? cropType = _Undefined,
    Object? plantingDate = _Undefined,
    Object? expectedHarvestDate = _Undefined,
    String? status,
    int? plantCount,
    Object? healthScore = _Undefined,
    Object? soilPh = _Undefined,
    Object? soilMoisture = _Undefined,
    Object? soilFertility = _Undefined,
    Object? lastIrrigatedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tray(
      id: id is int? ? id : this.id,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      position: position ?? this.position,
      label: label is String? ? label : this.label,
      cropType: cropType is String? ? cropType : this.cropType,
      plantingDate: plantingDate is DateTime?
          ? plantingDate
          : this.plantingDate,
      expectedHarvestDate: expectedHarvestDate is DateTime?
          ? expectedHarvestDate
          : this.expectedHarvestDate,
      status: status ?? this.status,
      plantCount: plantCount ?? this.plantCount,
      healthScore: healthScore is double? ? healthScore : this.healthScore,
      soilPh: soilPh is double? ? soilPh : this.soilPh,
      soilMoisture: soilMoisture is double? ? soilMoisture : this.soilMoisture,
      soilFertility: soilFertility is String?
          ? soilFertility
          : this.soilFertility,
      lastIrrigatedAt: lastIrrigatedAt is DateTime?
          ? lastIrrigatedAt
          : this.lastIrrigatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class TrayUpdateTable extends _i1.UpdateTable<TrayTable> {
  TrayUpdateTable(super.table);

  _i1.ColumnValue<int, int> greenhouseId(int value) => _i1.ColumnValue(
    table.greenhouseId,
    value,
  );

  _i1.ColumnValue<int, int> position(int value) => _i1.ColumnValue(
    table.position,
    value,
  );

  _i1.ColumnValue<String, String> label(String? value) => _i1.ColumnValue(
    table.label,
    value,
  );

  _i1.ColumnValue<String, String> cropType(String? value) => _i1.ColumnValue(
    table.cropType,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> plantingDate(DateTime? value) =>
      _i1.ColumnValue(
        table.plantingDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> expectedHarvestDate(DateTime? value) =>
      _i1.ColumnValue(
        table.expectedHarvestDate,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<int, int> plantCount(int value) => _i1.ColumnValue(
    table.plantCount,
    value,
  );

  _i1.ColumnValue<double, double> healthScore(double? value) => _i1.ColumnValue(
    table.healthScore,
    value,
  );

  _i1.ColumnValue<double, double> soilPh(double? value) => _i1.ColumnValue(
    table.soilPh,
    value,
  );

  _i1.ColumnValue<double, double> soilMoisture(double? value) =>
      _i1.ColumnValue(
        table.soilMoisture,
        value,
      );

  _i1.ColumnValue<String, String> soilFertility(String? value) =>
      _i1.ColumnValue(
        table.soilFertility,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> lastIrrigatedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.lastIrrigatedAt,
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

class TrayTable extends _i1.Table<int?> {
  TrayTable({super.tableRelation}) : super(tableName: 'trays') {
    updateTable = TrayUpdateTable(this);
    greenhouseId = _i1.ColumnInt(
      'greenhouseId',
      this,
    );
    position = _i1.ColumnInt(
      'position',
      this,
    );
    label = _i1.ColumnString(
      'label',
      this,
    );
    cropType = _i1.ColumnString(
      'cropType',
      this,
    );
    plantingDate = _i1.ColumnDateTime(
      'plantingDate',
      this,
    );
    expectedHarvestDate = _i1.ColumnDateTime(
      'expectedHarvestDate',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    plantCount = _i1.ColumnInt(
      'plantCount',
      this,
    );
    healthScore = _i1.ColumnDouble(
      'healthScore',
      this,
    );
    soilPh = _i1.ColumnDouble(
      'soilPh',
      this,
    );
    soilMoisture = _i1.ColumnDouble(
      'soilMoisture',
      this,
    );
    soilFertility = _i1.ColumnString(
      'soilFertility',
      this,
    );
    lastIrrigatedAt = _i1.ColumnDateTime(
      'lastIrrigatedAt',
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

  late final TrayUpdateTable updateTable;

  late final _i1.ColumnInt greenhouseId;

  late final _i1.ColumnInt position;

  late final _i1.ColumnString label;

  late final _i1.ColumnString cropType;

  late final _i1.ColumnDateTime plantingDate;

  late final _i1.ColumnDateTime expectedHarvestDate;

  late final _i1.ColumnString status;

  late final _i1.ColumnInt plantCount;

  late final _i1.ColumnDouble healthScore;

  late final _i1.ColumnDouble soilPh;

  late final _i1.ColumnDouble soilMoisture;

  late final _i1.ColumnString soilFertility;

  late final _i1.ColumnDateTime lastIrrigatedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    greenhouseId,
    position,
    label,
    cropType,
    plantingDate,
    expectedHarvestDate,
    status,
    plantCount,
    healthScore,
    soilPh,
    soilMoisture,
    soilFertility,
    lastIrrigatedAt,
    createdAt,
    updatedAt,
  ];
}

class TrayInclude extends _i1.IncludeObject {
  TrayInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Tray.t;
}

class TrayIncludeList extends _i1.IncludeList {
  TrayIncludeList._({
    _i1.WhereExpressionBuilder<TrayTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Tray.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Tray.t;
}

class TrayRepository {
  const TrayRepository._();

  /// Returns a list of [Tray]s matching the given query parameters.
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
  Future<List<Tray>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TrayTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TrayTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TrayTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Tray>(
      where: where?.call(Tray.t),
      orderBy: orderBy?.call(Tray.t),
      orderByList: orderByList?.call(Tray.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Tray] matching the given query parameters.
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
  Future<Tray?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TrayTable>? where,
    int? offset,
    _i1.OrderByBuilder<TrayTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TrayTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Tray>(
      where: where?.call(Tray.t),
      orderBy: orderBy?.call(Tray.t),
      orderByList: orderByList?.call(Tray.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Tray] by its [id] or null if no such row exists.
  Future<Tray?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Tray>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Tray]s in the list and returns the inserted rows.
  ///
  /// The returned [Tray]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Tray>> insert(
    _i1.Session session,
    List<Tray> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Tray>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Tray] and returns the inserted row.
  ///
  /// The returned [Tray] will have its `id` field set.
  Future<Tray> insertRow(
    _i1.Session session,
    Tray row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Tray>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Tray]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Tray>> update(
    _i1.Session session,
    List<Tray> rows, {
    _i1.ColumnSelections<TrayTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Tray>(
      rows,
      columns: columns?.call(Tray.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Tray]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Tray> updateRow(
    _i1.Session session,
    Tray row, {
    _i1.ColumnSelections<TrayTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Tray>(
      row,
      columns: columns?.call(Tray.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Tray] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Tray?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TrayUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Tray>(
      id,
      columnValues: columnValues(Tray.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Tray]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Tray>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TrayUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TrayTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TrayTable>? orderBy,
    _i1.OrderByListBuilder<TrayTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Tray>(
      columnValues: columnValues(Tray.t.updateTable),
      where: where(Tray.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Tray.t),
      orderByList: orderByList?.call(Tray.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Tray]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Tray>> delete(
    _i1.Session session,
    List<Tray> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Tray>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Tray].
  Future<Tray> deleteRow(
    _i1.Session session,
    Tray row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Tray>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Tray>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TrayTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Tray>(
      where: where(Tray.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TrayTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Tray>(
      where: where?.call(Tray.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Tray] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TrayTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Tray>(
      where: where(Tray.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
