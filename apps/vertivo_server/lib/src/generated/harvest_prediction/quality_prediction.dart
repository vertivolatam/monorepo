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

abstract class QualityPrediction
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  QualityPrediction._({
    this.id,
    required this.harvestPredictionId,
    this.plantId,
    required this.greenhouseId,
    this.vitaminAScore,
    this.vitaminCScore,
    this.vitaminKScore,
    this.ironScore,
    this.calciumScore,
    this.potassiumScore,
    required this.overallNutritionalScore,
    this.appearanceColorScore,
    this.appearanceSizeScore,
    this.appearanceUniformityScore,
    required this.overallAppearanceScore,
    this.shelfLifeDays,
    this.modelVersion,
    required this.createdAt,
  });

  factory QualityPrediction({
    int? id,
    required int harvestPredictionId,
    int? plantId,
    required int greenhouseId,
    double? vitaminAScore,
    double? vitaminCScore,
    double? vitaminKScore,
    double? ironScore,
    double? calciumScore,
    double? potassiumScore,
    required double overallNutritionalScore,
    double? appearanceColorScore,
    double? appearanceSizeScore,
    double? appearanceUniformityScore,
    required double overallAppearanceScore,
    int? shelfLifeDays,
    String? modelVersion,
    required DateTime createdAt,
  }) = _QualityPredictionImpl;

  factory QualityPrediction.fromJson(Map<String, dynamic> jsonSerialization) {
    return QualityPrediction(
      id: jsonSerialization['id'] as int?,
      harvestPredictionId: jsonSerialization['harvestPredictionId'] as int,
      plantId: jsonSerialization['plantId'] as int?,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      vitaminAScore: (jsonSerialization['vitaminAScore'] as num?)?.toDouble(),
      vitaminCScore: (jsonSerialization['vitaminCScore'] as num?)?.toDouble(),
      vitaminKScore: (jsonSerialization['vitaminKScore'] as num?)?.toDouble(),
      ironScore: (jsonSerialization['ironScore'] as num?)?.toDouble(),
      calciumScore: (jsonSerialization['calciumScore'] as num?)?.toDouble(),
      potassiumScore: (jsonSerialization['potassiumScore'] as num?)?.toDouble(),
      overallNutritionalScore:
          (jsonSerialization['overallNutritionalScore'] as num).toDouble(),
      appearanceColorScore: (jsonSerialization['appearanceColorScore'] as num?)
          ?.toDouble(),
      appearanceSizeScore: (jsonSerialization['appearanceSizeScore'] as num?)
          ?.toDouble(),
      appearanceUniformityScore:
          (jsonSerialization['appearanceUniformityScore'] as num?)?.toDouble(),
      overallAppearanceScore:
          (jsonSerialization['overallAppearanceScore'] as num).toDouble(),
      shelfLifeDays: jsonSerialization['shelfLifeDays'] as int?,
      modelVersion: jsonSerialization['modelVersion'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = QualityPredictionTable();

  static const db = QualityPredictionRepository._();

  @override
  int? id;

  int harvestPredictionId;

  int? plantId;

  int greenhouseId;

  double? vitaminAScore;

  double? vitaminCScore;

  double? vitaminKScore;

  double? ironScore;

  double? calciumScore;

  double? potassiumScore;

  double overallNutritionalScore;

  double? appearanceColorScore;

  double? appearanceSizeScore;

  double? appearanceUniformityScore;

  double overallAppearanceScore;

  int? shelfLifeDays;

  String? modelVersion;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [QualityPrediction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  QualityPrediction copyWith({
    int? id,
    int? harvestPredictionId,
    int? plantId,
    int? greenhouseId,
    double? vitaminAScore,
    double? vitaminCScore,
    double? vitaminKScore,
    double? ironScore,
    double? calciumScore,
    double? potassiumScore,
    double? overallNutritionalScore,
    double? appearanceColorScore,
    double? appearanceSizeScore,
    double? appearanceUniformityScore,
    double? overallAppearanceScore,
    int? shelfLifeDays,
    String? modelVersion,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QualityPrediction',
      if (id != null) 'id': id,
      'harvestPredictionId': harvestPredictionId,
      if (plantId != null) 'plantId': plantId,
      'greenhouseId': greenhouseId,
      if (vitaminAScore != null) 'vitaminAScore': vitaminAScore,
      if (vitaminCScore != null) 'vitaminCScore': vitaminCScore,
      if (vitaminKScore != null) 'vitaminKScore': vitaminKScore,
      if (ironScore != null) 'ironScore': ironScore,
      if (calciumScore != null) 'calciumScore': calciumScore,
      if (potassiumScore != null) 'potassiumScore': potassiumScore,
      'overallNutritionalScore': overallNutritionalScore,
      if (appearanceColorScore != null)
        'appearanceColorScore': appearanceColorScore,
      if (appearanceSizeScore != null)
        'appearanceSizeScore': appearanceSizeScore,
      if (appearanceUniformityScore != null)
        'appearanceUniformityScore': appearanceUniformityScore,
      'overallAppearanceScore': overallAppearanceScore,
      if (shelfLifeDays != null) 'shelfLifeDays': shelfLifeDays,
      if (modelVersion != null) 'modelVersion': modelVersion,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QualityPrediction',
      if (id != null) 'id': id,
      'harvestPredictionId': harvestPredictionId,
      if (plantId != null) 'plantId': plantId,
      'greenhouseId': greenhouseId,
      if (vitaminAScore != null) 'vitaminAScore': vitaminAScore,
      if (vitaminCScore != null) 'vitaminCScore': vitaminCScore,
      if (vitaminKScore != null) 'vitaminKScore': vitaminKScore,
      if (ironScore != null) 'ironScore': ironScore,
      if (calciumScore != null) 'calciumScore': calciumScore,
      if (potassiumScore != null) 'potassiumScore': potassiumScore,
      'overallNutritionalScore': overallNutritionalScore,
      if (appearanceColorScore != null)
        'appearanceColorScore': appearanceColorScore,
      if (appearanceSizeScore != null)
        'appearanceSizeScore': appearanceSizeScore,
      if (appearanceUniformityScore != null)
        'appearanceUniformityScore': appearanceUniformityScore,
      'overallAppearanceScore': overallAppearanceScore,
      if (shelfLifeDays != null) 'shelfLifeDays': shelfLifeDays,
      if (modelVersion != null) 'modelVersion': modelVersion,
      'createdAt': createdAt.toJson(),
    };
  }

  static QualityPredictionInclude include() {
    return QualityPredictionInclude._();
  }

  static QualityPredictionIncludeList includeList({
    _i1.WhereExpressionBuilder<QualityPredictionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<QualityPredictionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<QualityPredictionTable>? orderByList,
    QualityPredictionInclude? include,
  }) {
    return QualityPredictionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(QualityPrediction.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(QualityPrediction.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QualityPredictionImpl extends QualityPrediction {
  _QualityPredictionImpl({
    int? id,
    required int harvestPredictionId,
    int? plantId,
    required int greenhouseId,
    double? vitaminAScore,
    double? vitaminCScore,
    double? vitaminKScore,
    double? ironScore,
    double? calciumScore,
    double? potassiumScore,
    required double overallNutritionalScore,
    double? appearanceColorScore,
    double? appearanceSizeScore,
    double? appearanceUniformityScore,
    required double overallAppearanceScore,
    int? shelfLifeDays,
    String? modelVersion,
    required DateTime createdAt,
  }) : super._(
         id: id,
         harvestPredictionId: harvestPredictionId,
         plantId: plantId,
         greenhouseId: greenhouseId,
         vitaminAScore: vitaminAScore,
         vitaminCScore: vitaminCScore,
         vitaminKScore: vitaminKScore,
         ironScore: ironScore,
         calciumScore: calciumScore,
         potassiumScore: potassiumScore,
         overallNutritionalScore: overallNutritionalScore,
         appearanceColorScore: appearanceColorScore,
         appearanceSizeScore: appearanceSizeScore,
         appearanceUniformityScore: appearanceUniformityScore,
         overallAppearanceScore: overallAppearanceScore,
         shelfLifeDays: shelfLifeDays,
         modelVersion: modelVersion,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [QualityPrediction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  QualityPrediction copyWith({
    Object? id = _Undefined,
    int? harvestPredictionId,
    Object? plantId = _Undefined,
    int? greenhouseId,
    Object? vitaminAScore = _Undefined,
    Object? vitaminCScore = _Undefined,
    Object? vitaminKScore = _Undefined,
    Object? ironScore = _Undefined,
    Object? calciumScore = _Undefined,
    Object? potassiumScore = _Undefined,
    double? overallNutritionalScore,
    Object? appearanceColorScore = _Undefined,
    Object? appearanceSizeScore = _Undefined,
    Object? appearanceUniformityScore = _Undefined,
    double? overallAppearanceScore,
    Object? shelfLifeDays = _Undefined,
    Object? modelVersion = _Undefined,
    DateTime? createdAt,
  }) {
    return QualityPrediction(
      id: id is int? ? id : this.id,
      harvestPredictionId: harvestPredictionId ?? this.harvestPredictionId,
      plantId: plantId is int? ? plantId : this.plantId,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      vitaminAScore: vitaminAScore is double?
          ? vitaminAScore
          : this.vitaminAScore,
      vitaminCScore: vitaminCScore is double?
          ? vitaminCScore
          : this.vitaminCScore,
      vitaminKScore: vitaminKScore is double?
          ? vitaminKScore
          : this.vitaminKScore,
      ironScore: ironScore is double? ? ironScore : this.ironScore,
      calciumScore: calciumScore is double? ? calciumScore : this.calciumScore,
      potassiumScore: potassiumScore is double?
          ? potassiumScore
          : this.potassiumScore,
      overallNutritionalScore:
          overallNutritionalScore ?? this.overallNutritionalScore,
      appearanceColorScore: appearanceColorScore is double?
          ? appearanceColorScore
          : this.appearanceColorScore,
      appearanceSizeScore: appearanceSizeScore is double?
          ? appearanceSizeScore
          : this.appearanceSizeScore,
      appearanceUniformityScore: appearanceUniformityScore is double?
          ? appearanceUniformityScore
          : this.appearanceUniformityScore,
      overallAppearanceScore:
          overallAppearanceScore ?? this.overallAppearanceScore,
      shelfLifeDays: shelfLifeDays is int? ? shelfLifeDays : this.shelfLifeDays,
      modelVersion: modelVersion is String? ? modelVersion : this.modelVersion,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class QualityPredictionUpdateTable
    extends _i1.UpdateTable<QualityPredictionTable> {
  QualityPredictionUpdateTable(super.table);

  _i1.ColumnValue<int, int> harvestPredictionId(int value) => _i1.ColumnValue(
    table.harvestPredictionId,
    value,
  );

  _i1.ColumnValue<int, int> plantId(int? value) => _i1.ColumnValue(
    table.plantId,
    value,
  );

  _i1.ColumnValue<int, int> greenhouseId(int value) => _i1.ColumnValue(
    table.greenhouseId,
    value,
  );

  _i1.ColumnValue<double, double> vitaminAScore(double? value) =>
      _i1.ColumnValue(
        table.vitaminAScore,
        value,
      );

  _i1.ColumnValue<double, double> vitaminCScore(double? value) =>
      _i1.ColumnValue(
        table.vitaminCScore,
        value,
      );

  _i1.ColumnValue<double, double> vitaminKScore(double? value) =>
      _i1.ColumnValue(
        table.vitaminKScore,
        value,
      );

  _i1.ColumnValue<double, double> ironScore(double? value) => _i1.ColumnValue(
    table.ironScore,
    value,
  );

  _i1.ColumnValue<double, double> calciumScore(double? value) =>
      _i1.ColumnValue(
        table.calciumScore,
        value,
      );

  _i1.ColumnValue<double, double> potassiumScore(double? value) =>
      _i1.ColumnValue(
        table.potassiumScore,
        value,
      );

  _i1.ColumnValue<double, double> overallNutritionalScore(double value) =>
      _i1.ColumnValue(
        table.overallNutritionalScore,
        value,
      );

  _i1.ColumnValue<double, double> appearanceColorScore(double? value) =>
      _i1.ColumnValue(
        table.appearanceColorScore,
        value,
      );

  _i1.ColumnValue<double, double> appearanceSizeScore(double? value) =>
      _i1.ColumnValue(
        table.appearanceSizeScore,
        value,
      );

  _i1.ColumnValue<double, double> appearanceUniformityScore(double? value) =>
      _i1.ColumnValue(
        table.appearanceUniformityScore,
        value,
      );

  _i1.ColumnValue<double, double> overallAppearanceScore(double value) =>
      _i1.ColumnValue(
        table.overallAppearanceScore,
        value,
      );

  _i1.ColumnValue<int, int> shelfLifeDays(int? value) => _i1.ColumnValue(
    table.shelfLifeDays,
    value,
  );

  _i1.ColumnValue<String, String> modelVersion(String? value) =>
      _i1.ColumnValue(
        table.modelVersion,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class QualityPredictionTable extends _i1.Table<int?> {
  QualityPredictionTable({super.tableRelation})
    : super(tableName: 'quality_predictions') {
    updateTable = QualityPredictionUpdateTable(this);
    harvestPredictionId = _i1.ColumnInt(
      'harvestPredictionId',
      this,
    );
    plantId = _i1.ColumnInt(
      'plantId',
      this,
    );
    greenhouseId = _i1.ColumnInt(
      'greenhouseId',
      this,
    );
    vitaminAScore = _i1.ColumnDouble(
      'vitaminAScore',
      this,
    );
    vitaminCScore = _i1.ColumnDouble(
      'vitaminCScore',
      this,
    );
    vitaminKScore = _i1.ColumnDouble(
      'vitaminKScore',
      this,
    );
    ironScore = _i1.ColumnDouble(
      'ironScore',
      this,
    );
    calciumScore = _i1.ColumnDouble(
      'calciumScore',
      this,
    );
    potassiumScore = _i1.ColumnDouble(
      'potassiumScore',
      this,
    );
    overallNutritionalScore = _i1.ColumnDouble(
      'overallNutritionalScore',
      this,
    );
    appearanceColorScore = _i1.ColumnDouble(
      'appearanceColorScore',
      this,
    );
    appearanceSizeScore = _i1.ColumnDouble(
      'appearanceSizeScore',
      this,
    );
    appearanceUniformityScore = _i1.ColumnDouble(
      'appearanceUniformityScore',
      this,
    );
    overallAppearanceScore = _i1.ColumnDouble(
      'overallAppearanceScore',
      this,
    );
    shelfLifeDays = _i1.ColumnInt(
      'shelfLifeDays',
      this,
    );
    modelVersion = _i1.ColumnString(
      'modelVersion',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final QualityPredictionUpdateTable updateTable;

  late final _i1.ColumnInt harvestPredictionId;

  late final _i1.ColumnInt plantId;

  late final _i1.ColumnInt greenhouseId;

  late final _i1.ColumnDouble vitaminAScore;

  late final _i1.ColumnDouble vitaminCScore;

  late final _i1.ColumnDouble vitaminKScore;

  late final _i1.ColumnDouble ironScore;

  late final _i1.ColumnDouble calciumScore;

  late final _i1.ColumnDouble potassiumScore;

  late final _i1.ColumnDouble overallNutritionalScore;

  late final _i1.ColumnDouble appearanceColorScore;

  late final _i1.ColumnDouble appearanceSizeScore;

  late final _i1.ColumnDouble appearanceUniformityScore;

  late final _i1.ColumnDouble overallAppearanceScore;

  late final _i1.ColumnInt shelfLifeDays;

  late final _i1.ColumnString modelVersion;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    harvestPredictionId,
    plantId,
    greenhouseId,
    vitaminAScore,
    vitaminCScore,
    vitaminKScore,
    ironScore,
    calciumScore,
    potassiumScore,
    overallNutritionalScore,
    appearanceColorScore,
    appearanceSizeScore,
    appearanceUniformityScore,
    overallAppearanceScore,
    shelfLifeDays,
    modelVersion,
    createdAt,
  ];
}

class QualityPredictionInclude extends _i1.IncludeObject {
  QualityPredictionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => QualityPrediction.t;
}

class QualityPredictionIncludeList extends _i1.IncludeList {
  QualityPredictionIncludeList._({
    _i1.WhereExpressionBuilder<QualityPredictionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(QualityPrediction.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => QualityPrediction.t;
}

class QualityPredictionRepository {
  const QualityPredictionRepository._();

  /// Returns a list of [QualityPrediction]s matching the given query parameters.
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
  Future<List<QualityPrediction>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<QualityPredictionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<QualityPredictionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<QualityPredictionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<QualityPrediction>(
      where: where?.call(QualityPrediction.t),
      orderBy: orderBy?.call(QualityPrediction.t),
      orderByList: orderByList?.call(QualityPrediction.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [QualityPrediction] matching the given query parameters.
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
  Future<QualityPrediction?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<QualityPredictionTable>? where,
    int? offset,
    _i1.OrderByBuilder<QualityPredictionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<QualityPredictionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<QualityPrediction>(
      where: where?.call(QualityPrediction.t),
      orderBy: orderBy?.call(QualityPrediction.t),
      orderByList: orderByList?.call(QualityPrediction.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [QualityPrediction] by its [id] or null if no such row exists.
  Future<QualityPrediction?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<QualityPrediction>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [QualityPrediction]s in the list and returns the inserted rows.
  ///
  /// The returned [QualityPrediction]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<QualityPrediction>> insert(
    _i1.Session session,
    List<QualityPrediction> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<QualityPrediction>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [QualityPrediction] and returns the inserted row.
  ///
  /// The returned [QualityPrediction] will have its `id` field set.
  Future<QualityPrediction> insertRow(
    _i1.Session session,
    QualityPrediction row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<QualityPrediction>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [QualityPrediction]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<QualityPrediction>> update(
    _i1.Session session,
    List<QualityPrediction> rows, {
    _i1.ColumnSelections<QualityPredictionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<QualityPrediction>(
      rows,
      columns: columns?.call(QualityPrediction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [QualityPrediction]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<QualityPrediction> updateRow(
    _i1.Session session,
    QualityPrediction row, {
    _i1.ColumnSelections<QualityPredictionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<QualityPrediction>(
      row,
      columns: columns?.call(QualityPrediction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [QualityPrediction] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<QualityPrediction?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<QualityPredictionUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<QualityPrediction>(
      id,
      columnValues: columnValues(QualityPrediction.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [QualityPrediction]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<QualityPrediction>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<QualityPredictionUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<QualityPredictionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<QualityPredictionTable>? orderBy,
    _i1.OrderByListBuilder<QualityPredictionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<QualityPrediction>(
      columnValues: columnValues(QualityPrediction.t.updateTable),
      where: where(QualityPrediction.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(QualityPrediction.t),
      orderByList: orderByList?.call(QualityPrediction.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [QualityPrediction]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<QualityPrediction>> delete(
    _i1.Session session,
    List<QualityPrediction> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<QualityPrediction>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [QualityPrediction].
  Future<QualityPrediction> deleteRow(
    _i1.Session session,
    QualityPrediction row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<QualityPrediction>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<QualityPrediction>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<QualityPredictionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<QualityPrediction>(
      where: where(QualityPrediction.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<QualityPredictionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<QualityPrediction>(
      where: where?.call(QualityPrediction.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [QualityPrediction] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<QualityPredictionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<QualityPrediction>(
      where: where(QualityPrediction.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
