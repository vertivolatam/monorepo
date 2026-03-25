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

abstract class PestIdentification
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PestIdentification._({
    this.id,
    required this.plantId,
    required this.greenhouseId,
    required this.pestType,
    required this.confidence,
    required this.infestationLevel,
    this.affectedPlantCount,
    this.imageUrl,
    this.aiModelVersion,
    required this.isConfirmed,
    this.confirmedBy,
    required this.detectedAt,
    required this.createdAt,
  });

  factory PestIdentification({
    int? id,
    required int plantId,
    required int greenhouseId,
    required String pestType,
    required double confidence,
    required String infestationLevel,
    int? affectedPlantCount,
    String? imageUrl,
    String? aiModelVersion,
    required bool isConfirmed,
    String? confirmedBy,
    required DateTime detectedAt,
    required DateTime createdAt,
  }) = _PestIdentificationImpl;

  factory PestIdentification.fromJson(Map<String, dynamic> jsonSerialization) {
    return PestIdentification(
      id: jsonSerialization['id'] as int?,
      plantId: jsonSerialization['plantId'] as int,
      greenhouseId: jsonSerialization['greenhouseId'] as int,
      pestType: jsonSerialization['pestType'] as String,
      confidence: (jsonSerialization['confidence'] as num).toDouble(),
      infestationLevel: jsonSerialization['infestationLevel'] as String,
      affectedPlantCount: jsonSerialization['affectedPlantCount'] as int?,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      aiModelVersion: jsonSerialization['aiModelVersion'] as String?,
      isConfirmed: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isConfirmed'],
      ),
      confirmedBy: jsonSerialization['confirmedBy'] as String?,
      detectedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['detectedAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = PestIdentificationTable();

  static const db = PestIdentificationRepository._();

  @override
  int? id;

  int plantId;

  int greenhouseId;

  String pestType;

  double confidence;

  String infestationLevel;

  int? affectedPlantCount;

  String? imageUrl;

  String? aiModelVersion;

  bool isConfirmed;

  String? confirmedBy;

  DateTime detectedAt;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PestIdentification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PestIdentification copyWith({
    int? id,
    int? plantId,
    int? greenhouseId,
    String? pestType,
    double? confidence,
    String? infestationLevel,
    int? affectedPlantCount,
    String? imageUrl,
    String? aiModelVersion,
    bool? isConfirmed,
    String? confirmedBy,
    DateTime? detectedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PestIdentification',
      if (id != null) 'id': id,
      'plantId': plantId,
      'greenhouseId': greenhouseId,
      'pestType': pestType,
      'confidence': confidence,
      'infestationLevel': infestationLevel,
      if (affectedPlantCount != null) 'affectedPlantCount': affectedPlantCount,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (aiModelVersion != null) 'aiModelVersion': aiModelVersion,
      'isConfirmed': isConfirmed,
      if (confirmedBy != null) 'confirmedBy': confirmedBy,
      'detectedAt': detectedAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PestIdentification',
      if (id != null) 'id': id,
      'plantId': plantId,
      'greenhouseId': greenhouseId,
      'pestType': pestType,
      'confidence': confidence,
      'infestationLevel': infestationLevel,
      if (affectedPlantCount != null) 'affectedPlantCount': affectedPlantCount,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (aiModelVersion != null) 'aiModelVersion': aiModelVersion,
      'isConfirmed': isConfirmed,
      if (confirmedBy != null) 'confirmedBy': confirmedBy,
      'detectedAt': detectedAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static PestIdentificationInclude include() {
    return PestIdentificationInclude._();
  }

  static PestIdentificationIncludeList includeList({
    _i1.WhereExpressionBuilder<PestIdentificationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PestIdentificationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PestIdentificationTable>? orderByList,
    PestIdentificationInclude? include,
  }) {
    return PestIdentificationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PestIdentification.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PestIdentification.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PestIdentificationImpl extends PestIdentification {
  _PestIdentificationImpl({
    int? id,
    required int plantId,
    required int greenhouseId,
    required String pestType,
    required double confidence,
    required String infestationLevel,
    int? affectedPlantCount,
    String? imageUrl,
    String? aiModelVersion,
    required bool isConfirmed,
    String? confirmedBy,
    required DateTime detectedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         plantId: plantId,
         greenhouseId: greenhouseId,
         pestType: pestType,
         confidence: confidence,
         infestationLevel: infestationLevel,
         affectedPlantCount: affectedPlantCount,
         imageUrl: imageUrl,
         aiModelVersion: aiModelVersion,
         isConfirmed: isConfirmed,
         confirmedBy: confirmedBy,
         detectedAt: detectedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PestIdentification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PestIdentification copyWith({
    Object? id = _Undefined,
    int? plantId,
    int? greenhouseId,
    String? pestType,
    double? confidence,
    String? infestationLevel,
    Object? affectedPlantCount = _Undefined,
    Object? imageUrl = _Undefined,
    Object? aiModelVersion = _Undefined,
    bool? isConfirmed,
    Object? confirmedBy = _Undefined,
    DateTime? detectedAt,
    DateTime? createdAt,
  }) {
    return PestIdentification(
      id: id is int? ? id : this.id,
      plantId: plantId ?? this.plantId,
      greenhouseId: greenhouseId ?? this.greenhouseId,
      pestType: pestType ?? this.pestType,
      confidence: confidence ?? this.confidence,
      infestationLevel: infestationLevel ?? this.infestationLevel,
      affectedPlantCount: affectedPlantCount is int?
          ? affectedPlantCount
          : this.affectedPlantCount,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      aiModelVersion: aiModelVersion is String?
          ? aiModelVersion
          : this.aiModelVersion,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      confirmedBy: confirmedBy is String? ? confirmedBy : this.confirmedBy,
      detectedAt: detectedAt ?? this.detectedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class PestIdentificationUpdateTable
    extends _i1.UpdateTable<PestIdentificationTable> {
  PestIdentificationUpdateTable(super.table);

  _i1.ColumnValue<int, int> plantId(int value) => _i1.ColumnValue(
    table.plantId,
    value,
  );

  _i1.ColumnValue<int, int> greenhouseId(int value) => _i1.ColumnValue(
    table.greenhouseId,
    value,
  );

  _i1.ColumnValue<String, String> pestType(String value) => _i1.ColumnValue(
    table.pestType,
    value,
  );

  _i1.ColumnValue<double, double> confidence(double value) => _i1.ColumnValue(
    table.confidence,
    value,
  );

  _i1.ColumnValue<String, String> infestationLevel(String value) =>
      _i1.ColumnValue(
        table.infestationLevel,
        value,
      );

  _i1.ColumnValue<int, int> affectedPlantCount(int? value) => _i1.ColumnValue(
    table.affectedPlantCount,
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

class PestIdentificationTable extends _i1.Table<int?> {
  PestIdentificationTable({super.tableRelation})
    : super(tableName: 'pest_identifications') {
    updateTable = PestIdentificationUpdateTable(this);
    plantId = _i1.ColumnInt(
      'plantId',
      this,
    );
    greenhouseId = _i1.ColumnInt(
      'greenhouseId',
      this,
    );
    pestType = _i1.ColumnString(
      'pestType',
      this,
    );
    confidence = _i1.ColumnDouble(
      'confidence',
      this,
    );
    infestationLevel = _i1.ColumnString(
      'infestationLevel',
      this,
    );
    affectedPlantCount = _i1.ColumnInt(
      'affectedPlantCount',
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
    detectedAt = _i1.ColumnDateTime(
      'detectedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final PestIdentificationUpdateTable updateTable;

  late final _i1.ColumnInt plantId;

  late final _i1.ColumnInt greenhouseId;

  late final _i1.ColumnString pestType;

  late final _i1.ColumnDouble confidence;

  late final _i1.ColumnString infestationLevel;

  late final _i1.ColumnInt affectedPlantCount;

  late final _i1.ColumnString imageUrl;

  late final _i1.ColumnString aiModelVersion;

  late final _i1.ColumnBool isConfirmed;

  late final _i1.ColumnString confirmedBy;

  late final _i1.ColumnDateTime detectedAt;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    plantId,
    greenhouseId,
    pestType,
    confidence,
    infestationLevel,
    affectedPlantCount,
    imageUrl,
    aiModelVersion,
    isConfirmed,
    confirmedBy,
    detectedAt,
    createdAt,
  ];
}

class PestIdentificationInclude extends _i1.IncludeObject {
  PestIdentificationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PestIdentification.t;
}

class PestIdentificationIncludeList extends _i1.IncludeList {
  PestIdentificationIncludeList._({
    _i1.WhereExpressionBuilder<PestIdentificationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PestIdentification.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PestIdentification.t;
}

class PestIdentificationRepository {
  const PestIdentificationRepository._();

  /// Returns a list of [PestIdentification]s matching the given query parameters.
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
  Future<List<PestIdentification>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PestIdentificationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PestIdentificationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PestIdentificationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PestIdentification>(
      where: where?.call(PestIdentification.t),
      orderBy: orderBy?.call(PestIdentification.t),
      orderByList: orderByList?.call(PestIdentification.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PestIdentification] matching the given query parameters.
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
  Future<PestIdentification?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PestIdentificationTable>? where,
    int? offset,
    _i1.OrderByBuilder<PestIdentificationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PestIdentificationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PestIdentification>(
      where: where?.call(PestIdentification.t),
      orderBy: orderBy?.call(PestIdentification.t),
      orderByList: orderByList?.call(PestIdentification.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PestIdentification] by its [id] or null if no such row exists.
  Future<PestIdentification?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PestIdentification>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PestIdentification]s in the list and returns the inserted rows.
  ///
  /// The returned [PestIdentification]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<PestIdentification>> insert(
    _i1.Session session,
    List<PestIdentification> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<PestIdentification>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [PestIdentification] and returns the inserted row.
  ///
  /// The returned [PestIdentification] will have its `id` field set.
  Future<PestIdentification> insertRow(
    _i1.Session session,
    PestIdentification row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PestIdentification>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PestIdentification]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PestIdentification>> update(
    _i1.Session session,
    List<PestIdentification> rows, {
    _i1.ColumnSelections<PestIdentificationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PestIdentification>(
      rows,
      columns: columns?.call(PestIdentification.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PestIdentification]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PestIdentification> updateRow(
    _i1.Session session,
    PestIdentification row, {
    _i1.ColumnSelections<PestIdentificationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PestIdentification>(
      row,
      columns: columns?.call(PestIdentification.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PestIdentification] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PestIdentification?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PestIdentificationUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PestIdentification>(
      id,
      columnValues: columnValues(PestIdentification.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PestIdentification]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PestIdentification>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PestIdentificationUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PestIdentificationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PestIdentificationTable>? orderBy,
    _i1.OrderByListBuilder<PestIdentificationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PestIdentification>(
      columnValues: columnValues(PestIdentification.t.updateTable),
      where: where(PestIdentification.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PestIdentification.t),
      orderByList: orderByList?.call(PestIdentification.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PestIdentification]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PestIdentification>> delete(
    _i1.Session session,
    List<PestIdentification> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PestIdentification>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PestIdentification].
  Future<PestIdentification> deleteRow(
    _i1.Session session,
    PestIdentification row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PestIdentification>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PestIdentification>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PestIdentificationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PestIdentification>(
      where: where(PestIdentification.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PestIdentificationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PestIdentification>(
      where: where?.call(PestIdentification.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PestIdentification] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PestIdentificationTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PestIdentification>(
      where: where(PestIdentification.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
