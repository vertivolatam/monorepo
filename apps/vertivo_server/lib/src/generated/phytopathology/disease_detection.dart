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

abstract class DiseaseDetection
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  DiseaseDetection._({
    this.id,
    required this.plantId,
    required this.greenhouseId,
    required this.diseaseType,
    required this.diseaseName,
    required this.confidence,
    required this.severity,
    this.affectedAreaPercent,
    this.anatomicalParts,
    this.imageUrl,
    this.aiModelVersion,
    required this.isConfirmed,
    this.confirmedBy,
    this.notes,
    required this.detectedAt,
    required this.createdAt,
  });

  factory DiseaseDetection({
    int? id,
    required int plantId,
    required int greenhouseId,
    required String diseaseType,
    required String diseaseName,
    required double confidence,
    required String severity,
    double? affectedAreaPercent,
    List<String>? anatomicalParts,
    String? imageUrl,
    String? aiModelVersion,
    required bool isConfirmed,
    String? confirmedBy,
    String? notes,
    required DateTime detectedAt,
    required DateTime createdAt,
  }) = _DiseaseDetectionImpl;

  factory DiseaseDetection.fromJson(Map<String, dynamic> jsonSerialization) {
    return DiseaseDetection(
      id: jsonSerialization['id'] as int?,
      plantId: jsonSerialization['plantId'] as int,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      diseaseType: jsonSerialization['diseaseType'] as String,
      diseaseName: jsonSerialization['diseaseName'] as String,
      confidence: (jsonSerialization['confidence'] as num).toDouble(),
      severity: jsonSerialization['severity'] as String,
      affectedAreaPercent: (jsonSerialization['affectedAreaPercent'] as num?)
          ?.toDouble(),
      anatomicalParts: jsonSerialization['anatomicalParts'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['anatomicalParts'],
            ),
      imageUrl: jsonSerialization['imageUrl'] as String?,
      aiModelVersion: jsonSerialization['aiModelVersion'] as String?,
      isConfirmed: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isConfirmed'],
      ),
      confirmedBy: jsonSerialization['confirmedBy'] as String?,
      notes: jsonSerialization['notes'] as String?,
      detectedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['detectedAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = DiseaseDetectionTable();

  static const db = DiseaseDetectionRepository._();

  @override
  int? id;

  int plantId;

  int greenhouseId;

  String diseaseType;

  String diseaseName;

  double confidence;

  String severity;

  double? affectedAreaPercent;

  List<String>? anatomicalParts;

  String? imageUrl;

  String? aiModelVersion;

  bool isConfirmed;

  String? confirmedBy;

  String? notes;

  DateTime detectedAt;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DiseaseDetection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DiseaseDetection copyWith({
    int? id,
    int? plantId,
    int? greenhouseId,
    String? diseaseType,
    String? diseaseName,
    double? confidence,
    String? severity,
    double? affectedAreaPercent,
    List<String>? anatomicalParts,
    String? imageUrl,
    String? aiModelVersion,
    bool? isConfirmed,
    String? confirmedBy,
    String? notes,
    DateTime? detectedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DiseaseDetection',
      if (id != null) 'id': id,
      'plantId': plantId,
      'greenhouseId': greenhouseId,
      'diseaseType': diseaseType,
      'diseaseName': diseaseName,
      'confidence': confidence,
      'severity': severity,
      if (affectedAreaPercent != null)
        'affectedAreaPercent': affectedAreaPercent,
      if (anatomicalParts != null) 'anatomicalParts': anatomicalParts?.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (aiModelVersion != null) 'aiModelVersion': aiModelVersion,
      'isConfirmed': isConfirmed,
      if (confirmedBy != null) 'confirmedBy': confirmedBy,
      if (notes != null) 'notes': notes,
      'detectedAt': detectedAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DiseaseDetection',
      if (id != null) 'id': id,
      'plantId': plantId,
      'greenhouseId': greenhouseId,
      'diseaseType': diseaseType,
      'diseaseName': diseaseName,
      'confidence': confidence,
      'severity': severity,
      if (affectedAreaPercent != null)
        'affectedAreaPercent': affectedAreaPercent,
      if (anatomicalParts != null) 'anatomicalParts': anatomicalParts?.toJson(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (aiModelVersion != null) 'aiModelVersion': aiModelVersion,
      'isConfirmed': isConfirmed,
      if (confirmedBy != null) 'confirmedBy': confirmedBy,
      if (notes != null) 'notes': notes,
      'detectedAt': detectedAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static DiseaseDetectionInclude include() {
    return DiseaseDetectionInclude._();
  }

  static DiseaseDetectionIncludeList includeList({
    _i1.WhereExpressionBuilder<DiseaseDetectionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DiseaseDetectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DiseaseDetectionTable>? orderByList,
    DiseaseDetectionInclude? include,
  }) {
    return DiseaseDetectionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DiseaseDetection.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DiseaseDetection.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DiseaseDetectionImpl extends DiseaseDetection {
  _DiseaseDetectionImpl({
    int? id,
    required int plantId,
    required int greenhouseId,
    required String diseaseType,
    required String diseaseName,
    required double confidence,
    required String severity,
    double? affectedAreaPercent,
    List<String>? anatomicalParts,
    String? imageUrl,
    String? aiModelVersion,
    required bool isConfirmed,
    String? confirmedBy,
    String? notes,
    required DateTime detectedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         plantId: plantId,
         greenhouseId: greenhouseId,
         diseaseType: diseaseType,
         diseaseName: diseaseName,
         confidence: confidence,
         severity: severity,
         affectedAreaPercent: affectedAreaPercent,
         anatomicalParts: anatomicalParts,
         imageUrl: imageUrl,
         aiModelVersion: aiModelVersion,
         isConfirmed: isConfirmed,
         confirmedBy: confirmedBy,
         notes: notes,
         detectedAt: detectedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DiseaseDetection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DiseaseDetection copyWith({
    Object? id = _Undefined,
    int? plantId,
    int? greenhouseId,
    String? diseaseType,
    String? diseaseName,
    double? confidence,
    String? severity,
    Object? affectedAreaPercent = _Undefined,
    Object? anatomicalParts = _Undefined,
    Object? imageUrl = _Undefined,
    Object? aiModelVersion = _Undefined,
    bool? isConfirmed,
    Object? confirmedBy = _Undefined,
    Object? notes = _Undefined,
    DateTime? detectedAt,
    DateTime? createdAt,
  }) {
    return DiseaseDetection(
      id: id is int? ? id : this.id,
      plantId: plantId ?? this.plantId,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      diseaseType: diseaseType ?? this.diseaseType,
      diseaseName: diseaseName ?? this.diseaseName,
      confidence: confidence ?? this.confidence,
      severity: severity ?? this.severity,
      affectedAreaPercent: affectedAreaPercent is double?
          ? affectedAreaPercent
          : this.affectedAreaPercent,
      anatomicalParts: anatomicalParts is List<String>?
          ? anatomicalParts
          : this.anatomicalParts?.map((e0) => e0).toList(),
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      aiModelVersion: aiModelVersion is String?
          ? aiModelVersion
          : this.aiModelVersion,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      confirmedBy: confirmedBy is String? ? confirmedBy : this.confirmedBy,
      notes: notes is String? ? notes : this.notes,
      detectedAt: detectedAt ?? this.detectedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DiseaseDetectionUpdateTable
    extends _i1.UpdateTable<DiseaseDetectionTable> {
  DiseaseDetectionUpdateTable(super.table);

  _i1.ColumnValue<int, int> plantId(int value) => _i1.ColumnValue(
    table.plantId,
    value,
  );

  _i1.ColumnValue<int, int> greenhouseId(int value) => _i1.ColumnValue(
    table.greenhouseId,
    value,
  );

  _i1.ColumnValue<String, String> diseaseType(String value) => _i1.ColumnValue(
    table.diseaseType,
    value,
  );

  _i1.ColumnValue<String, String> diseaseName(String value) => _i1.ColumnValue(
    table.diseaseName,
    value,
  );

  _i1.ColumnValue<double, double> confidence(double value) => _i1.ColumnValue(
    table.confidence,
    value,
  );

  _i1.ColumnValue<String, String> severity(String value) => _i1.ColumnValue(
    table.severity,
    value,
  );

  _i1.ColumnValue<double, double> affectedAreaPercent(double? value) =>
      _i1.ColumnValue(
        table.affectedAreaPercent,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> anatomicalParts(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.anatomicalParts,
    value,
  );

  _i1.ColumnValue<String, String> imageUrl(String? value) => _i1.ColumnValue(
    table.imageUrl,
    value,
  );

  _i1.ColumnValue<String, String> aiModelVersion(String? value) =>
      _i1.ColumnValue(
        table.aiModelVersion,
        value,
      );

  _i1.ColumnValue<bool, bool> isConfirmed(bool value) => _i1.ColumnValue(
    table.isConfirmed,
    value,
  );

  _i1.ColumnValue<String, String> confirmedBy(String? value) => _i1.ColumnValue(
    table.confirmedBy,
    value,
  );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> detectedAt(DateTime value) =>
      _i1.ColumnValue(
        table.detectedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class DiseaseDetectionTable extends _i1.Table<int?> {
  DiseaseDetectionTable({super.tableRelation})
    : super(tableName: 'disease_detections') {
    updateTable = DiseaseDetectionUpdateTable(this);
    plantId = _i1.ColumnInt(
      'plantId',
      this,
    );
    greenhouseId = _i1.ColumnInt(
      'greenhouseId',
      this,
    );
    diseaseType = _i1.ColumnString(
      'diseaseType',
      this,
    );
    diseaseName = _i1.ColumnString(
      'diseaseName',
      this,
    );
    confidence = _i1.ColumnDouble(
      'confidence',
      this,
    );
    severity = _i1.ColumnString(
      'severity',
      this,
    );
    affectedAreaPercent = _i1.ColumnDouble(
      'affectedAreaPercent',
      this,
    );
    anatomicalParts = _i1.ColumnSerializable<List<String>>(
      'anatomicalParts',
      this,
    );
    imageUrl = _i1.ColumnString(
      'imageUrl',
      this,
    );
    aiModelVersion = _i1.ColumnString(
      'aiModelVersion',
      this,
    );
    isConfirmed = _i1.ColumnBool(
      'isConfirmed',
      this,
    );
    confirmedBy = _i1.ColumnString(
      'confirmedBy',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
    detectedAt = _i1.ColumnDateTime(
      'detectedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final DiseaseDetectionUpdateTable updateTable;

  late final _i1.ColumnInt plantId;

  late final _i1.ColumnInt greenhouseId;

  late final _i1.ColumnString diseaseType;

  late final _i1.ColumnString diseaseName;

  late final _i1.ColumnDouble confidence;

  late final _i1.ColumnString severity;

  late final _i1.ColumnDouble affectedAreaPercent;

  late final _i1.ColumnSerializable<List<String>> anatomicalParts;

  late final _i1.ColumnString imageUrl;

  late final _i1.ColumnString aiModelVersion;

  late final _i1.ColumnBool isConfirmed;

  late final _i1.ColumnString confirmedBy;

  late final _i1.ColumnString notes;

  late final _i1.ColumnDateTime detectedAt;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    plantId,
    greenhouseId,
    diseaseType,
    diseaseName,
    confidence,
    severity,
    affectedAreaPercent,
    anatomicalParts,
    imageUrl,
    aiModelVersion,
    isConfirmed,
    confirmedBy,
    notes,
    detectedAt,
    createdAt,
  ];
}

class DiseaseDetectionInclude extends _i1.IncludeObject {
  DiseaseDetectionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DiseaseDetection.t;
}

class DiseaseDetectionIncludeList extends _i1.IncludeList {
  DiseaseDetectionIncludeList._({
    _i1.WhereExpressionBuilder<DiseaseDetectionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DiseaseDetection.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DiseaseDetection.t;
}

class DiseaseDetectionRepository {
  const DiseaseDetectionRepository._();

  /// Returns a list of [DiseaseDetection]s matching the given query parameters.
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
  Future<List<DiseaseDetection>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DiseaseDetectionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DiseaseDetectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DiseaseDetectionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DiseaseDetection>(
      where: where?.call(DiseaseDetection.t),
      orderBy: orderBy?.call(DiseaseDetection.t),
      orderByList: orderByList?.call(DiseaseDetection.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DiseaseDetection] matching the given query parameters.
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
  Future<DiseaseDetection?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DiseaseDetectionTable>? where,
    int? offset,
    _i1.OrderByBuilder<DiseaseDetectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DiseaseDetectionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DiseaseDetection>(
      where: where?.call(DiseaseDetection.t),
      orderBy: orderBy?.call(DiseaseDetection.t),
      orderByList: orderByList?.call(DiseaseDetection.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DiseaseDetection] by its [id] or null if no such row exists.
  Future<DiseaseDetection?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DiseaseDetection>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DiseaseDetection]s in the list and returns the inserted rows.
  ///
  /// The returned [DiseaseDetection]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DiseaseDetection>> insert(
    _i1.Session session,
    List<DiseaseDetection> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DiseaseDetection>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DiseaseDetection] and returns the inserted row.
  ///
  /// The returned [DiseaseDetection] will have its `id` field set.
  Future<DiseaseDetection> insertRow(
    _i1.Session session,
    DiseaseDetection row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DiseaseDetection>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DiseaseDetection]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DiseaseDetection>> update(
    _i1.Session session,
    List<DiseaseDetection> rows, {
    _i1.ColumnSelections<DiseaseDetectionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DiseaseDetection>(
      rows,
      columns: columns?.call(DiseaseDetection.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DiseaseDetection]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DiseaseDetection> updateRow(
    _i1.Session session,
    DiseaseDetection row, {
    _i1.ColumnSelections<DiseaseDetectionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DiseaseDetection>(
      row,
      columns: columns?.call(DiseaseDetection.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DiseaseDetection] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DiseaseDetection?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<DiseaseDetectionUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DiseaseDetection>(
      id,
      columnValues: columnValues(DiseaseDetection.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DiseaseDetection]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DiseaseDetection>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<DiseaseDetectionUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<DiseaseDetectionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DiseaseDetectionTable>? orderBy,
    _i1.OrderByListBuilder<DiseaseDetectionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DiseaseDetection>(
      columnValues: columnValues(DiseaseDetection.t.updateTable),
      where: where(DiseaseDetection.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DiseaseDetection.t),
      orderByList: orderByList?.call(DiseaseDetection.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DiseaseDetection]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DiseaseDetection>> delete(
    _i1.Session session,
    List<DiseaseDetection> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DiseaseDetection>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DiseaseDetection].
  Future<DiseaseDetection> deleteRow(
    _i1.Session session,
    DiseaseDetection row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DiseaseDetection>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DiseaseDetection>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DiseaseDetectionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DiseaseDetection>(
      where: where(DiseaseDetection.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DiseaseDetectionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DiseaseDetection>(
      where: where?.call(DiseaseDetection.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DiseaseDetection] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DiseaseDetectionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DiseaseDetection>(
      where: where(DiseaseDetection.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
