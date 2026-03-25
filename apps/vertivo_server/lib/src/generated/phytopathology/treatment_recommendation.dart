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

abstract class TreatmentRecommendation
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TreatmentRecommendation._({
    this.id,
    this.diseaseDetectionId,
    this.pestIdentificationId,
    required this.plantId,
    required this.treatmentType,
    required this.description,
    this.ingredients,
    this.applicationMethod,
    this.frequencyDays,
    this.durationDays,
    this.estimatedCost,
    required this.segmentTarget,
    required this.priority,
    required this.isApplied,
    this.appliedAt,
    this.effectivenessScore,
    required this.createdAt,
  });

  factory TreatmentRecommendation({
    int? id,
    int? diseaseDetectionId,
    int? pestIdentificationId,
    required int plantId,
    required String treatmentType,
    required String description,
    List<String>? ingredients,
    String? applicationMethod,
    int? frequencyDays,
    int? durationDays,
    double? estimatedCost,
    required String segmentTarget,
    required String priority,
    required bool isApplied,
    DateTime? appliedAt,
    double? effectivenessScore,
    required DateTime createdAt,
  }) = _TreatmentRecommendationImpl;

  factory TreatmentRecommendation.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TreatmentRecommendation(
      id: jsonSerialization['id'] as int?,
      diseaseDetectionId: jsonSerialization['diseaseDetectionId'] as int?,
      pestIdentificationId: jsonSerialization['pestIdentificationId'] as int?,
      plantId: jsonSerialization['plantId'] as int,
      treatmentType: jsonSerialization['treatmentType'] as String,
      description: jsonSerialization['description'] as String,
      ingredients: jsonSerialization['ingredients'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['ingredients'],
            ),
      applicationMethod: jsonSerialization['applicationMethod'] as String?,
      frequencyDays: jsonSerialization['frequencyDays'] as int?,
      durationDays: jsonSerialization['durationDays'] as int?,
      estimatedCost: (jsonSerialization['estimatedCost'] as num?)?.toDouble(),
      segmentTarget: jsonSerialization['segmentTarget'] as String,
      priority: jsonSerialization['priority'] as String,
      isApplied: _i1.BoolJsonExtension.fromJson(jsonSerialization['isApplied']),
      appliedAt: jsonSerialization['appliedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['appliedAt']),
      effectivenessScore: (jsonSerialization['effectivenessScore'] as num?)
          ?.toDouble(),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = TreatmentRecommendationTable();

  static const db = TreatmentRecommendationRepository._();

  @override
  int? id;

  int? diseaseDetectionId;

  int? pestIdentificationId;

  int plantId;

  String treatmentType;

  String description;

  List<String>? ingredients;

  String? applicationMethod;

  int? frequencyDays;

  int? durationDays;

  double? estimatedCost;

  String segmentTarget;

  String priority;

  bool isApplied;

  DateTime? appliedAt;

  double? effectivenessScore;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TreatmentRecommendation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TreatmentRecommendation copyWith({
    int? id,
    int? diseaseDetectionId,
    int? pestIdentificationId,
    int? plantId,
    String? treatmentType,
    String? description,
    List<String>? ingredients,
    String? applicationMethod,
    int? frequencyDays,
    int? durationDays,
    double? estimatedCost,
    String? segmentTarget,
    String? priority,
    bool? isApplied,
    DateTime? appliedAt,
    double? effectivenessScore,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TreatmentRecommendation',
      if (id != null) 'id': id,
      if (diseaseDetectionId != null) 'diseaseDetectionId': diseaseDetectionId,
      if (pestIdentificationId != null)
        'pestIdentificationId': pestIdentificationId,
      'plantId': plantId,
      'treatmentType': treatmentType,
      'description': description,
      if (ingredients != null) 'ingredients': ingredients?.toJson(),
      if (applicationMethod != null) 'applicationMethod': applicationMethod,
      if (frequencyDays != null) 'frequencyDays': frequencyDays,
      if (durationDays != null) 'durationDays': durationDays,
      if (estimatedCost != null) 'estimatedCost': estimatedCost,
      'segmentTarget': segmentTarget,
      'priority': priority,
      'isApplied': isApplied,
      if (appliedAt != null) 'appliedAt': appliedAt?.toJson(),
      if (effectivenessScore != null) 'effectivenessScore': effectivenessScore,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TreatmentRecommendation',
      if (id != null) 'id': id,
      if (diseaseDetectionId != null) 'diseaseDetectionId': diseaseDetectionId,
      if (pestIdentificationId != null)
        'pestIdentificationId': pestIdentificationId,
      'plantId': plantId,
      'treatmentType': treatmentType,
      'description': description,
      if (ingredients != null) 'ingredients': ingredients?.toJson(),
      if (applicationMethod != null) 'applicationMethod': applicationMethod,
      if (frequencyDays != null) 'frequencyDays': frequencyDays,
      if (durationDays != null) 'durationDays': durationDays,
      if (estimatedCost != null) 'estimatedCost': estimatedCost,
      'segmentTarget': segmentTarget,
      'priority': priority,
      'isApplied': isApplied,
      if (appliedAt != null) 'appliedAt': appliedAt?.toJson(),
      if (effectivenessScore != null) 'effectivenessScore': effectivenessScore,
      'createdAt': createdAt.toJson(),
    };
  }

  static TreatmentRecommendationInclude include() {
    return TreatmentRecommendationInclude._();
  }

  static TreatmentRecommendationIncludeList includeList({
    _i1.WhereExpressionBuilder<TreatmentRecommendationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TreatmentRecommendationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TreatmentRecommendationTable>? orderByList,
    TreatmentRecommendationInclude? include,
  }) {
    return TreatmentRecommendationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TreatmentRecommendation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TreatmentRecommendation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TreatmentRecommendationImpl extends TreatmentRecommendation {
  _TreatmentRecommendationImpl({
    int? id,
    int? diseaseDetectionId,
    int? pestIdentificationId,
    required int plantId,
    required String treatmentType,
    required String description,
    List<String>? ingredients,
    String? applicationMethod,
    int? frequencyDays,
    int? durationDays,
    double? estimatedCost,
    required String segmentTarget,
    required String priority,
    required bool isApplied,
    DateTime? appliedAt,
    double? effectivenessScore,
    required DateTime createdAt,
  }) : super._(
         id: id,
         diseaseDetectionId: diseaseDetectionId,
         pestIdentificationId: pestIdentificationId,
         plantId: plantId,
         treatmentType: treatmentType,
         description: description,
         ingredients: ingredients,
         applicationMethod: applicationMethod,
         frequencyDays: frequencyDays,
         durationDays: durationDays,
         estimatedCost: estimatedCost,
         segmentTarget: segmentTarget,
         priority: priority,
         isApplied: isApplied,
         appliedAt: appliedAt,
         effectivenessScore: effectivenessScore,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TreatmentRecommendation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TreatmentRecommendation copyWith({
    Object? id = _Undefined,
    Object? diseaseDetectionId = _Undefined,
    Object? pestIdentificationId = _Undefined,
    int? plantId,
    String? treatmentType,
    String? description,
    Object? ingredients = _Undefined,
    Object? applicationMethod = _Undefined,
    Object? frequencyDays = _Undefined,
    Object? durationDays = _Undefined,
    Object? estimatedCost = _Undefined,
    String? segmentTarget,
    String? priority,
    bool? isApplied,
    Object? appliedAt = _Undefined,
    Object? effectivenessScore = _Undefined,
    DateTime? createdAt,
  }) {
    return TreatmentRecommendation(
      id: id is int? ? id : this.id,
      diseaseDetectionId: diseaseDetectionId is int?
          ? diseaseDetectionId
          : this.diseaseDetectionId,
      pestIdentificationId: pestIdentificationId is int?
          ? pestIdentificationId
          : this.pestIdentificationId,
      plantId: plantId ?? this.plantId,
      treatmentType: treatmentType ?? this.treatmentType,
      description: description ?? this.description,
      ingredients: ingredients is List<String>?
          ? ingredients
          : this.ingredients?.map((e0) => e0).toList(),
      applicationMethod: applicationMethod is String?
          ? applicationMethod
          : this.applicationMethod,
      frequencyDays: frequencyDays is int? ? frequencyDays : this.frequencyDays,
      durationDays: durationDays is int? ? durationDays : this.durationDays,
      estimatedCost: estimatedCost is double?
          ? estimatedCost
          : this.estimatedCost,
      segmentTarget: segmentTarget ?? this.segmentTarget,
      priority: priority ?? this.priority,
      isApplied: isApplied ?? this.isApplied,
      appliedAt: appliedAt is DateTime? ? appliedAt : this.appliedAt,
      effectivenessScore: effectivenessScore is double?
          ? effectivenessScore
          : this.effectivenessScore,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TreatmentRecommendationUpdateTable
    extends _i1.UpdateTable<TreatmentRecommendationTable> {
  TreatmentRecommendationUpdateTable(super.table);

  _i1.ColumnValue<int, int> diseaseDetectionId(int? value) => _i1.ColumnValue(
    table.diseaseDetectionId,
    value,
  );

  _i1.ColumnValue<int, int> pestIdentificationId(int? value) => _i1.ColumnValue(
    table.pestIdentificationId,
    value,
  );

  _i1.ColumnValue<int, int> plantId(int value) => _i1.ColumnValue(
    table.plantId,
    value,
  );

  _i1.ColumnValue<String, String> treatmentType(String value) =>
      _i1.ColumnValue(
        table.treatmentType,
        value,
      );

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> ingredients(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.ingredients,
    value,
  );

  _i1.ColumnValue<String, String> applicationMethod(String? value) =>
      _i1.ColumnValue(
        table.applicationMethod,
        value,
      );

  _i1.ColumnValue<int, int> frequencyDays(int? value) => _i1.ColumnValue(
    table.frequencyDays,
    value,
  );

  _i1.ColumnValue<int, int> durationDays(int? value) => _i1.ColumnValue(
    table.durationDays,
    value,
  );

  _i1.ColumnValue<double, double> estimatedCost(double? value) =>
      _i1.ColumnValue(
        table.estimatedCost,
        value,
      );

  _i1.ColumnValue<String, String> segmentTarget(String value) =>
      _i1.ColumnValue(
        table.segmentTarget,
        value,
      );

  _i1.ColumnValue<String, String> priority(String value) => _i1.ColumnValue(
    table.priority,
    value,
  );

  _i1.ColumnValue<bool, bool> isApplied(bool value) => _i1.ColumnValue(
    table.isApplied,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> appliedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.appliedAt,
        value,
      );

  _i1.ColumnValue<double, double> effectivenessScore(double? value) =>
      _i1.ColumnValue(
        table.effectivenessScore,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class TreatmentRecommendationTable extends _i1.Table<int?> {
  TreatmentRecommendationTable({super.tableRelation})
    : super(tableName: 'treatment_recommendations') {
    updateTable = TreatmentRecommendationUpdateTable(this);
    diseaseDetectionId = _i1.ColumnInt(
      'diseaseDetectionId',
      this,
    );
    pestIdentificationId = _i1.ColumnInt(
      'pestIdentificationId',
      this,
    );
    plantId = _i1.ColumnInt(
      'plantId',
      this,
    );
    treatmentType = _i1.ColumnString(
      'treatmentType',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    ingredients = _i1.ColumnSerializable<List<String>>(
      'ingredients',
      this,
    );
    applicationMethod = _i1.ColumnString(
      'applicationMethod',
      this,
    );
    frequencyDays = _i1.ColumnInt(
      'frequencyDays',
      this,
    );
    durationDays = _i1.ColumnInt(
      'durationDays',
      this,
    );
    estimatedCost = _i1.ColumnDouble(
      'estimatedCost',
      this,
    );
    segmentTarget = _i1.ColumnString(
      'segmentTarget',
      this,
    );
    priority = _i1.ColumnString(
      'priority',
      this,
    );
    isApplied = _i1.ColumnBool(
      'isApplied',
      this,
    );
    appliedAt = _i1.ColumnDateTime(
      'appliedAt',
      this,
    );
    effectivenessScore = _i1.ColumnDouble(
      'effectivenessScore',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final TreatmentRecommendationUpdateTable updateTable;

  late final _i1.ColumnInt diseaseDetectionId;

  late final _i1.ColumnInt pestIdentificationId;

  late final _i1.ColumnInt plantId;

  late final _i1.ColumnString treatmentType;

  late final _i1.ColumnString description;

  late final _i1.ColumnSerializable<List<String>> ingredients;

  late final _i1.ColumnString applicationMethod;

  late final _i1.ColumnInt frequencyDays;

  late final _i1.ColumnInt durationDays;

  late final _i1.ColumnDouble estimatedCost;

  late final _i1.ColumnString segmentTarget;

  late final _i1.ColumnString priority;

  late final _i1.ColumnBool isApplied;

  late final _i1.ColumnDateTime appliedAt;

  late final _i1.ColumnDouble effectivenessScore;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    diseaseDetectionId,
    pestIdentificationId,
    plantId,
    treatmentType,
    description,
    ingredients,
    applicationMethod,
    frequencyDays,
    durationDays,
    estimatedCost,
    segmentTarget,
    priority,
    isApplied,
    appliedAt,
    effectivenessScore,
    createdAt,
  ];
}

class TreatmentRecommendationInclude extends _i1.IncludeObject {
  TreatmentRecommendationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TreatmentRecommendation.t;
}

class TreatmentRecommendationIncludeList extends _i1.IncludeList {
  TreatmentRecommendationIncludeList._({
    _i1.WhereExpressionBuilder<TreatmentRecommendationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TreatmentRecommendation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TreatmentRecommendation.t;
}

class TreatmentRecommendationRepository {
  const TreatmentRecommendationRepository._();

  /// Returns a list of [TreatmentRecommendation]s matching the given query parameters.
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
  Future<List<TreatmentRecommendation>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TreatmentRecommendationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TreatmentRecommendationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TreatmentRecommendationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TreatmentRecommendation>(
      where: where?.call(TreatmentRecommendation.t),
      orderBy: orderBy?.call(TreatmentRecommendation.t),
      orderByList: orderByList?.call(TreatmentRecommendation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TreatmentRecommendation] matching the given query parameters.
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
  Future<TreatmentRecommendation?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TreatmentRecommendationTable>? where,
    int? offset,
    _i1.OrderByBuilder<TreatmentRecommendationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TreatmentRecommendationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TreatmentRecommendation>(
      where: where?.call(TreatmentRecommendation.t),
      orderBy: orderBy?.call(TreatmentRecommendation.t),
      orderByList: orderByList?.call(TreatmentRecommendation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TreatmentRecommendation] by its [id] or null if no such row exists.
  Future<TreatmentRecommendation?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TreatmentRecommendation>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TreatmentRecommendation]s in the list and returns the inserted rows.
  ///
  /// The returned [TreatmentRecommendation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<TreatmentRecommendation>> insert(
    _i1.Session session,
    List<TreatmentRecommendation> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<TreatmentRecommendation>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [TreatmentRecommendation] and returns the inserted row.
  ///
  /// The returned [TreatmentRecommendation] will have its `id` field set.
  Future<TreatmentRecommendation> insertRow(
    _i1.Session session,
    TreatmentRecommendation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TreatmentRecommendation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TreatmentRecommendation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TreatmentRecommendation>> update(
    _i1.Session session,
    List<TreatmentRecommendation> rows, {
    _i1.ColumnSelections<TreatmentRecommendationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TreatmentRecommendation>(
      rows,
      columns: columns?.call(TreatmentRecommendation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TreatmentRecommendation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TreatmentRecommendation> updateRow(
    _i1.Session session,
    TreatmentRecommendation row, {
    _i1.ColumnSelections<TreatmentRecommendationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TreatmentRecommendation>(
      row,
      columns: columns?.call(TreatmentRecommendation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TreatmentRecommendation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TreatmentRecommendation?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TreatmentRecommendationUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TreatmentRecommendation>(
      id,
      columnValues: columnValues(TreatmentRecommendation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TreatmentRecommendation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TreatmentRecommendation>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TreatmentRecommendationUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<TreatmentRecommendationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TreatmentRecommendationTable>? orderBy,
    _i1.OrderByListBuilder<TreatmentRecommendationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TreatmentRecommendation>(
      columnValues: columnValues(TreatmentRecommendation.t.updateTable),
      where: where(TreatmentRecommendation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TreatmentRecommendation.t),
      orderByList: orderByList?.call(TreatmentRecommendation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TreatmentRecommendation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TreatmentRecommendation>> delete(
    _i1.Session session,
    List<TreatmentRecommendation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TreatmentRecommendation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TreatmentRecommendation].
  Future<TreatmentRecommendation> deleteRow(
    _i1.Session session,
    TreatmentRecommendation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TreatmentRecommendation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TreatmentRecommendation>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TreatmentRecommendationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TreatmentRecommendation>(
      where: where(TreatmentRecommendation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TreatmentRecommendationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TreatmentRecommendation>(
      where: where?.call(TreatmentRecommendation.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TreatmentRecommendation] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TreatmentRecommendationTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TreatmentRecommendation>(
      where: where(TreatmentRecommendation.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
