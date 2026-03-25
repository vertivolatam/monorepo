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

abstract class HarvestPrediction
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  HarvestPrediction._({
    this.id,
    required this.greenhouseId,
    this.plantId,
    required this.cropSpecies,
    required this.predictedYieldKg,
    required this.yieldConfidence,
    required this.qualityGrade,
    required this.harvestWindowStart,
    required this.harvestWindowEnd,
    required this.daysToHarvest,
    required this.scenarioType,
    this.actualYieldKg,
    this.actualQualityGrade,
    this.actualHarvestDate,
    this.modelVersion,
    this.notes,
    required this.createdAt,
  });

  factory HarvestPrediction({
    int? id,
    required int greenhouseId,
    int? plantId,
    required String cropSpecies,
    required double predictedYieldKg,
    required double yieldConfidence,
    required String qualityGrade,
    required DateTime harvestWindowStart,
    required DateTime harvestWindowEnd,
    required int daysToHarvest,
    required String scenarioType,
    double? actualYieldKg,
    String? actualQualityGrade,
    DateTime? actualHarvestDate,
    String? modelVersion,
    String? notes,
    required DateTime createdAt,
  }) = _HarvestPredictionImpl;

  factory HarvestPrediction.fromJson(Map<String, dynamic> jsonSerialization) {
    return HarvestPrediction(
      id: jsonSerialization['id'] as int?,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      plantId: jsonSerialization['plantId'] as int?,
      cropSpecies: jsonSerialization['cropSpecies'] as String,
      predictedYieldKg: (jsonSerialization['predictedYieldKg'] as num)
          .toDouble(),
      yieldConfidence: (jsonSerialization['yieldConfidence'] as num).toDouble(),
      qualityGrade: jsonSerialization['qualityGrade'] as String,
      harvestWindowStart: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['harvestWindowStart'],
      ),
      harvestWindowEnd: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['harvestWindowEnd'],
      ),
      daysToHarvest: jsonSerialization['daysToHarvest'] as int,
      scenarioType: jsonSerialization['scenarioType'] as String,
      actualYieldKg: (jsonSerialization['actualYieldKg'] as num?)?.toDouble(),
      actualQualityGrade: jsonSerialization['actualQualityGrade'] as String?,
      actualHarvestDate: jsonSerialization['actualHarvestDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['actualHarvestDate'],
            ),
      modelVersion: jsonSerialization['modelVersion'] as String?,
      notes: jsonSerialization['notes'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = HarvestPredictionTable();

  static const db = HarvestPredictionRepository._();

  @override
  int? id;

  int greenhouseId;

  int? plantId;

  String cropSpecies;

  double predictedYieldKg;

  double yieldConfidence;

  String qualityGrade;

  DateTime harvestWindowStart;

  DateTime harvestWindowEnd;

  int daysToHarvest;

  String scenarioType;

  double? actualYieldKg;

  String? actualQualityGrade;

  DateTime? actualHarvestDate;

  String? modelVersion;

  String? notes;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [HarvestPrediction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HarvestPrediction copyWith({
    int? id,
    int? greenhouseId,
    int? plantId,
    String? cropSpecies,
    double? predictedYieldKg,
    double? yieldConfidence,
    String? qualityGrade,
    DateTime? harvestWindowStart,
    DateTime? harvestWindowEnd,
    int? daysToHarvest,
    String? scenarioType,
    double? actualYieldKg,
    String? actualQualityGrade,
    DateTime? actualHarvestDate,
    String? modelVersion,
    String? notes,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HarvestPrediction',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      if (plantId != null) 'plantId': plantId,
      'cropSpecies': cropSpecies,
      'predictedYieldKg': predictedYieldKg,
      'yieldConfidence': yieldConfidence,
      'qualityGrade': qualityGrade,
      'harvestWindowStart': harvestWindowStart.toJson(),
      'harvestWindowEnd': harvestWindowEnd.toJson(),
      'daysToHarvest': daysToHarvest,
      'scenarioType': scenarioType,
      if (actualYieldKg != null) 'actualYieldKg': actualYieldKg,
      if (actualQualityGrade != null) 'actualQualityGrade': actualQualityGrade,
      if (actualHarvestDate != null)
        'actualHarvestDate': actualHarvestDate?.toJson(),
      if (modelVersion != null) 'modelVersion': modelVersion,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HarvestPrediction',
      if (id != null) 'id': id,
      'greenhouseId': greenhouseId,
      if (plantId != null) 'plantId': plantId,
      'cropSpecies': cropSpecies,
      'predictedYieldKg': predictedYieldKg,
      'yieldConfidence': yieldConfidence,
      'qualityGrade': qualityGrade,
      'harvestWindowStart': harvestWindowStart.toJson(),
      'harvestWindowEnd': harvestWindowEnd.toJson(),
      'daysToHarvest': daysToHarvest,
      'scenarioType': scenarioType,
      if (actualYieldKg != null) 'actualYieldKg': actualYieldKg,
      if (actualQualityGrade != null) 'actualQualityGrade': actualQualityGrade,
      if (actualHarvestDate != null)
        'actualHarvestDate': actualHarvestDate?.toJson(),
      if (modelVersion != null) 'modelVersion': modelVersion,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
    };
  }

  static HarvestPredictionInclude include() {
    return HarvestPredictionInclude._();
  }

  static HarvestPredictionIncludeList includeList({
    _i1.WhereExpressionBuilder<HarvestPredictionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HarvestPredictionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HarvestPredictionTable>? orderByList,
    HarvestPredictionInclude? include,
  }) {
    return HarvestPredictionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HarvestPrediction.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(HarvestPrediction.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HarvestPredictionImpl extends HarvestPrediction {
  _HarvestPredictionImpl({
    int? id,
    required int greenhouseId,
    int? plantId,
    required String cropSpecies,
    required double predictedYieldKg,
    required double yieldConfidence,
    required String qualityGrade,
    required DateTime harvestWindowStart,
    required DateTime harvestWindowEnd,
    required int daysToHarvest,
    required String scenarioType,
    double? actualYieldKg,
    String? actualQualityGrade,
    DateTime? actualHarvestDate,
    String? modelVersion,
    String? notes,
    required DateTime createdAt,
  }) : super._(
         id: id,
         greenhouseId: greenhouseId,
         plantId: plantId,
         cropSpecies: cropSpecies,
         predictedYieldKg: predictedYieldKg,
         yieldConfidence: yieldConfidence,
         qualityGrade: qualityGrade,
         harvestWindowStart: harvestWindowStart,
         harvestWindowEnd: harvestWindowEnd,
         daysToHarvest: daysToHarvest,
         scenarioType: scenarioType,
         actualYieldKg: actualYieldKg,
         actualQualityGrade: actualQualityGrade,
         actualHarvestDate: actualHarvestDate,
         modelVersion: modelVersion,
         notes: notes,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [HarvestPrediction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HarvestPrediction copyWith({
    Object? id = _Undefined,
    int? greenhouseId,
    Object? plantId = _Undefined,
    String? cropSpecies,
    double? predictedYieldKg,
    double? yieldConfidence,
    String? qualityGrade,
    DateTime? harvestWindowStart,
    DateTime? harvestWindowEnd,
    int? daysToHarvest,
    String? scenarioType,
    Object? actualYieldKg = _Undefined,
    Object? actualQualityGrade = _Undefined,
    Object? actualHarvestDate = _Undefined,
    Object? modelVersion = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
  }) {
    return HarvestPrediction(
      id: id is int? ? id : this.id,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      plantId: plantId is int? ? plantId : this.plantId,
      cropSpecies: cropSpecies ?? this.cropSpecies,
      predictedYieldKg: predictedYieldKg ?? this.predictedYieldKg,
      yieldConfidence: yieldConfidence ?? this.yieldConfidence,
      qualityGrade: qualityGrade ?? this.qualityGrade,
      harvestWindowStart: harvestWindowStart ?? this.harvestWindowStart,
      harvestWindowEnd: harvestWindowEnd ?? this.harvestWindowEnd,
      daysToHarvest: daysToHarvest ?? this.daysToHarvest,
      scenarioType: scenarioType ?? this.scenarioType,
      actualYieldKg: actualYieldKg is double?
          ? actualYieldKg
          : this.actualYieldKg,
      actualQualityGrade: actualQualityGrade is String?
          ? actualQualityGrade
          : this.actualQualityGrade,
      actualHarvestDate: actualHarvestDate is DateTime?
          ? actualHarvestDate
          : this.actualHarvestDate,
      modelVersion: modelVersion is String? ? modelVersion : this.modelVersion,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class HarvestPredictionUpdateTable
    extends _i1.UpdateTable<HarvestPredictionTable> {
  HarvestPredictionUpdateTable(super.table);

  _i1.ColumnValue<int, int> greenhouseId(int value) => _i1.ColumnValue(
    table.greenhouseId,
    value,
  );

  _i1.ColumnValue<int, int> plantId(int? value) => _i1.ColumnValue(
    table.plantId,
    value,
  );

  _i1.ColumnValue<String, String> cropSpecies(String value) => _i1.ColumnValue(
    table.cropSpecies,
    value,
  );

  _i1.ColumnValue<double, double> predictedYieldKg(double value) =>
      _i1.ColumnValue(
        table.predictedYieldKg,
        value,
      );

  _i1.ColumnValue<double, double> yieldConfidence(double value) =>
      _i1.ColumnValue(
        table.yieldConfidence,
        value,
      );

  _i1.ColumnValue<String, String> qualityGrade(String value) => _i1.ColumnValue(
    table.qualityGrade,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> harvestWindowStart(DateTime value) =>
      _i1.ColumnValue(
        table.harvestWindowStart,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> harvestWindowEnd(DateTime value) =>
      _i1.ColumnValue(
        table.harvestWindowEnd,
        value,
      );

  _i1.ColumnValue<int, int> daysToHarvest(int value) => _i1.ColumnValue(
    table.daysToHarvest,
    value,
  );

  _i1.ColumnValue<String, String> scenarioType(String value) => _i1.ColumnValue(
    table.scenarioType,
    value,
  );

  _i1.ColumnValue<double, double> actualYieldKg(double? value) =>
      _i1.ColumnValue(
        table.actualYieldKg,
        value,
      );

  _i1.ColumnValue<String, String> actualQualityGrade(String? value) =>
      _i1.ColumnValue(
        table.actualQualityGrade,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> actualHarvestDate(DateTime? value) =>
      _i1.ColumnValue(
        table.actualHarvestDate,
        value,
      );

  _i1.ColumnValue<String, String> modelVersion(String? value) =>
      _i1.ColumnValue(
        table.modelVersion,
        value,
      );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class HarvestPredictionTable extends _i1.Table<int?> {
  HarvestPredictionTable({super.tableRelation})
    : super(tableName: 'harvest_predictions') {
    updateTable = HarvestPredictionUpdateTable(this);
    greenhouseId = _i1.ColumnInt(
      'greenhouseId',
      this,
    );
    plantId = _i1.ColumnInt(
      'plantId',
      this,
    );
    cropSpecies = _i1.ColumnString(
      'cropSpecies',
      this,
    );
    predictedYieldKg = _i1.ColumnDouble(
      'predictedYieldKg',
      this,
    );
    yieldConfidence = _i1.ColumnDouble(
      'yieldConfidence',
      this,
    );
    qualityGrade = _i1.ColumnString(
      'qualityGrade',
      this,
    );
    harvestWindowStart = _i1.ColumnDateTime(
      'harvestWindowStart',
      this,
    );
    harvestWindowEnd = _i1.ColumnDateTime(
      'harvestWindowEnd',
      this,
    );
    daysToHarvest = _i1.ColumnInt(
      'daysToHarvest',
      this,
    );
    scenarioType = _i1.ColumnString(
      'scenarioType',
      this,
    );
    actualYieldKg = _i1.ColumnDouble(
      'actualYieldKg',
      this,
    );
    actualQualityGrade = _i1.ColumnString(
      'actualQualityGrade',
      this,
    );
    actualHarvestDate = _i1.ColumnDateTime(
      'actualHarvestDate',
      this,
    );
    modelVersion = _i1.ColumnString(
      'modelVersion',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final HarvestPredictionUpdateTable updateTable;

  late final _i1.ColumnInt greenhouseId;

  late final _i1.ColumnInt plantId;

  late final _i1.ColumnString cropSpecies;

  late final _i1.ColumnDouble predictedYieldKg;

  late final _i1.ColumnDouble yieldConfidence;

  late final _i1.ColumnString qualityGrade;

  late final _i1.ColumnDateTime harvestWindowStart;

  late final _i1.ColumnDateTime harvestWindowEnd;

  late final _i1.ColumnInt daysToHarvest;

  late final _i1.ColumnString scenarioType;

  late final _i1.ColumnDouble actualYieldKg;

  late final _i1.ColumnString actualQualityGrade;

  late final _i1.ColumnDateTime actualHarvestDate;

  late final _i1.ColumnString modelVersion;

  late final _i1.ColumnString notes;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    greenhouseId,
    plantId,
    cropSpecies,
    predictedYieldKg,
    yieldConfidence,
    qualityGrade,
    harvestWindowStart,
    harvestWindowEnd,
    daysToHarvest,
    scenarioType,
    actualYieldKg,
    actualQualityGrade,
    actualHarvestDate,
    modelVersion,
    notes,
    createdAt,
  ];
}

class HarvestPredictionInclude extends _i1.IncludeObject {
  HarvestPredictionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => HarvestPrediction.t;
}

class HarvestPredictionIncludeList extends _i1.IncludeList {
  HarvestPredictionIncludeList._({
    _i1.WhereExpressionBuilder<HarvestPredictionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(HarvestPrediction.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => HarvestPrediction.t;
}

class HarvestPredictionRepository {
  const HarvestPredictionRepository._();

  /// Returns a list of [HarvestPrediction]s matching the given query parameters.
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
  Future<List<HarvestPrediction>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<HarvestPredictionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HarvestPredictionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HarvestPredictionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<HarvestPrediction>(
      where: where?.call(HarvestPrediction.t),
      orderBy: orderBy?.call(HarvestPrediction.t),
      orderByList: orderByList?.call(HarvestPrediction.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [HarvestPrediction] matching the given query parameters.
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
  Future<HarvestPrediction?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<HarvestPredictionTable>? where,
    int? offset,
    _i1.OrderByBuilder<HarvestPredictionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HarvestPredictionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<HarvestPrediction>(
      where: where?.call(HarvestPrediction.t),
      orderBy: orderBy?.call(HarvestPrediction.t),
      orderByList: orderByList?.call(HarvestPrediction.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [HarvestPrediction] by its [id] or null if no such row exists.
  Future<HarvestPrediction?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<HarvestPrediction>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [HarvestPrediction]s in the list and returns the inserted rows.
  ///
  /// The returned [HarvestPrediction]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<HarvestPrediction>> insert(
    _i1.Session session,
    List<HarvestPrediction> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<HarvestPrediction>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [HarvestPrediction] and returns the inserted row.
  ///
  /// The returned [HarvestPrediction] will have its `id` field set.
  Future<HarvestPrediction> insertRow(
    _i1.Session session,
    HarvestPrediction row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<HarvestPrediction>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [HarvestPrediction]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<HarvestPrediction>> update(
    _i1.Session session,
    List<HarvestPrediction> rows, {
    _i1.ColumnSelections<HarvestPredictionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<HarvestPrediction>(
      rows,
      columns: columns?.call(HarvestPrediction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HarvestPrediction]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<HarvestPrediction> updateRow(
    _i1.Session session,
    HarvestPrediction row, {
    _i1.ColumnSelections<HarvestPredictionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<HarvestPrediction>(
      row,
      columns: columns?.call(HarvestPrediction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HarvestPrediction] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<HarvestPrediction?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<HarvestPredictionUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<HarvestPrediction>(
      id,
      columnValues: columnValues(HarvestPrediction.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [HarvestPrediction]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<HarvestPrediction>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<HarvestPredictionUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<HarvestPredictionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HarvestPredictionTable>? orderBy,
    _i1.OrderByListBuilder<HarvestPredictionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<HarvestPrediction>(
      columnValues: columnValues(HarvestPrediction.t.updateTable),
      where: where(HarvestPrediction.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HarvestPrediction.t),
      orderByList: orderByList?.call(HarvestPrediction.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [HarvestPrediction]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<HarvestPrediction>> delete(
    _i1.Session session,
    List<HarvestPrediction> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<HarvestPrediction>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [HarvestPrediction].
  Future<HarvestPrediction> deleteRow(
    _i1.Session session,
    HarvestPrediction row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<HarvestPrediction>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<HarvestPrediction>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<HarvestPredictionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<HarvestPrediction>(
      where: where(HarvestPrediction.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<HarvestPredictionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<HarvestPrediction>(
      where: where?.call(HarvestPrediction.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [HarvestPrediction] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<HarvestPredictionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<HarvestPrediction>(
      where: where(HarvestPrediction.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
