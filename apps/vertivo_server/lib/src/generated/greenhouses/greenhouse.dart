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

abstract class Greenhouse
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Greenhouse._({
    this.id,
    required this.userId,
    required this.name,
    this.description,
    this.location,
    this.latitude,
    this.longitude,
    this.climateType,
    required this.irrigationType,
    required this.totalTrays,
    required this.isActive,
    this.temperatureMin,
    this.temperatureMax,
    this.humidityMin,
    this.humidityMax,
    this.lightMin,
    this.lightMax,
    this.co2Min,
    this.co2Max,
    this.phMin,
    this.phMax,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Greenhouse({
    int? id,
    required String userId,
    required String name,
    String? description,
    String? location,
    double? latitude,
    double? longitude,
    String? climateType,
    required String irrigationType,
    required int totalTrays,
    required bool isActive,
    double? temperatureMin,
    double? temperatureMax,
    double? humidityMin,
    double? humidityMax,
    double? lightMin,
    double? lightMax,
    double? co2Min,
    double? co2Max,
    double? phMin,
    double? phMax,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _GreenhouseImpl;

  factory Greenhouse.fromJson(Map<String, dynamic> jsonSerialization) {
    return Greenhouse(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      location: jsonSerialization['location'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      climateType: jsonSerialization['climateType'] as String?,
      irrigationType: jsonSerialization['irrigationType'] as String,
      totalTrays: jsonSerialization['totalTrays'] as int,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      temperatureMin: (jsonSerialization['temperatureMin'] as num?)?.toDouble(),
      temperatureMax: (jsonSerialization['temperatureMax'] as num?)?.toDouble(),
      humidityMin: (jsonSerialization['humidityMin'] as num?)?.toDouble(),
      humidityMax: (jsonSerialization['humidityMax'] as num?)?.toDouble(),
      lightMin: (jsonSerialization['lightMin'] as num?)?.toDouble(),
      lightMax: (jsonSerialization['lightMax'] as num?)?.toDouble(),
      co2Min: (jsonSerialization['co2Min'] as num?)?.toDouble(),
      co2Max: (jsonSerialization['co2Max'] as num?)?.toDouble(),
      phMin: (jsonSerialization['phMin'] as num?)?.toDouble(),
      phMax: (jsonSerialization['phMax'] as num?)?.toDouble(),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = GreenhouseTable();

  static const db = GreenhouseRepository._();

  @override
  int? id;

  String userId;

  String name;

  String? description;

  String? location;

  double? latitude;

  double? longitude;

  String? climateType;

  String irrigationType;

  int totalTrays;

  bool isActive;

  double? temperatureMin;

  double? temperatureMax;

  double? humidityMin;

  double? humidityMax;

  double? lightMin;

  double? lightMax;

  double? co2Min;

  double? co2Max;

  double? phMin;

  double? phMax;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Greenhouse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Greenhouse copyWith({
    int? id,
    String? userId,
    String? name,
    String? description,
    String? location,
    double? latitude,
    double? longitude,
    String? climateType,
    String? irrigationType,
    int? totalTrays,
    bool? isActive,
    double? temperatureMin,
    double? temperatureMax,
    double? humidityMin,
    double? humidityMax,
    double? lightMin,
    double? lightMax,
    double? co2Min,
    double? co2Max,
    double? phMin,
    double? phMax,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Greenhouse',
      if (id != null) 'id': id,
      'userId': userId,
      'name': name,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (climateType != null) 'climateType': climateType,
      'irrigationType': irrigationType,
      'totalTrays': totalTrays,
      'isActive': isActive,
      if (temperatureMin != null) 'temperatureMin': temperatureMin,
      if (temperatureMax != null) 'temperatureMax': temperatureMax,
      if (humidityMin != null) 'humidityMin': humidityMin,
      if (humidityMax != null) 'humidityMax': humidityMax,
      if (lightMin != null) 'lightMin': lightMin,
      if (lightMax != null) 'lightMax': lightMax,
      if (co2Min != null) 'co2Min': co2Min,
      if (co2Max != null) 'co2Max': co2Max,
      if (phMin != null) 'phMin': phMin,
      if (phMax != null) 'phMax': phMax,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Greenhouse',
      if (id != null) 'id': id,
      'userId': userId,
      'name': name,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (climateType != null) 'climateType': climateType,
      'irrigationType': irrigationType,
      'totalTrays': totalTrays,
      'isActive': isActive,
      if (temperatureMin != null) 'temperatureMin': temperatureMin,
      if (temperatureMax != null) 'temperatureMax': temperatureMax,
      if (humidityMin != null) 'humidityMin': humidityMin,
      if (humidityMax != null) 'humidityMax': humidityMax,
      if (lightMin != null) 'lightMin': lightMin,
      if (lightMax != null) 'lightMax': lightMax,
      if (co2Min != null) 'co2Min': co2Min,
      if (co2Max != null) 'co2Max': co2Max,
      if (phMin != null) 'phMin': phMin,
      if (phMax != null) 'phMax': phMax,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static GreenhouseInclude include() {
    return GreenhouseInclude._();
  }

  static GreenhouseIncludeList includeList({
    _i1.WhereExpressionBuilder<GreenhouseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GreenhouseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GreenhouseTable>? orderByList,
    GreenhouseInclude? include,
  }) {
    return GreenhouseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Greenhouse.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Greenhouse.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GreenhouseImpl extends Greenhouse {
  _GreenhouseImpl({
    int? id,
    required String userId,
    required String name,
    String? description,
    String? location,
    double? latitude,
    double? longitude,
    String? climateType,
    required String irrigationType,
    required int totalTrays,
    required bool isActive,
    double? temperatureMin,
    double? temperatureMax,
    double? humidityMin,
    double? humidityMax,
    double? lightMin,
    double? lightMax,
    double? co2Min,
    double? co2Max,
    double? phMin,
    double? phMax,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         name: name,
         description: description,
         location: location,
         latitude: latitude,
         longitude: longitude,
         climateType: climateType,
         irrigationType: irrigationType,
         totalTrays: totalTrays,
         isActive: isActive,
         temperatureMin: temperatureMin,
         temperatureMax: temperatureMax,
         humidityMin: humidityMin,
         humidityMax: humidityMax,
         lightMin: lightMin,
         lightMax: lightMax,
         co2Min: co2Min,
         co2Max: co2Max,
         phMin: phMin,
         phMax: phMax,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Greenhouse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Greenhouse copyWith({
    Object? id = _Undefined,
    String? userId,
    String? name,
    Object? description = _Undefined,
    Object? location = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? climateType = _Undefined,
    String? irrigationType,
    int? totalTrays,
    bool? isActive,
    Object? temperatureMin = _Undefined,
    Object? temperatureMax = _Undefined,
    Object? humidityMin = _Undefined,
    Object? humidityMax = _Undefined,
    Object? lightMin = _Undefined,
    Object? lightMax = _Undefined,
    Object? co2Min = _Undefined,
    Object? co2Max = _Undefined,
    Object? phMin = _Undefined,
    Object? phMax = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Greenhouse(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      location: location is String? ? location : this.location,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      climateType: climateType is String? ? climateType : this.climateType,
      irrigationType: irrigationType ?? this.irrigationType,
      totalTrays: totalTrays ?? this.totalTrays,
      isActive: isActive ?? this.isActive,
      temperatureMin: temperatureMin is double?
          ? temperatureMin
          : this.temperatureMin,
      temperatureMax: temperatureMax is double?
          ? temperatureMax
          : this.temperatureMax,
      humidityMin: humidityMin is double? ? humidityMin : this.humidityMin,
      humidityMax: humidityMax is double? ? humidityMax : this.humidityMax,
      lightMin: lightMin is double? ? lightMin : this.lightMin,
      lightMax: lightMax is double? ? lightMax : this.lightMax,
      co2Min: co2Min is double? ? co2Min : this.co2Min,
      co2Max: co2Max is double? ? co2Max : this.co2Max,
      phMin: phMin is double? ? phMin : this.phMin,
      phMax: phMax is double? ? phMax : this.phMax,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class GreenhouseUpdateTable extends _i1.UpdateTable<GreenhouseTable> {
  GreenhouseUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> location(String? value) => _i1.ColumnValue(
    table.location,
    value,
  );

  _i1.ColumnValue<double, double> latitude(double? value) => _i1.ColumnValue(
    table.latitude,
    value,
  );

  _i1.ColumnValue<double, double> longitude(double? value) => _i1.ColumnValue(
    table.longitude,
    value,
  );

  _i1.ColumnValue<String, String> climateType(String? value) => _i1.ColumnValue(
    table.climateType,
    value,
  );

  _i1.ColumnValue<String, String> irrigationType(String value) =>
      _i1.ColumnValue(
        table.irrigationType,
        value,
      );

  _i1.ColumnValue<int, int> totalTrays(int value) => _i1.ColumnValue(
    table.totalTrays,
    value,
  );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<double, double> temperatureMin(double? value) =>
      _i1.ColumnValue(
        table.temperatureMin,
        value,
      );

  _i1.ColumnValue<double, double> temperatureMax(double? value) =>
      _i1.ColumnValue(
        table.temperatureMax,
        value,
      );

  _i1.ColumnValue<double, double> humidityMin(double? value) => _i1.ColumnValue(
    table.humidityMin,
    value,
  );

  _i1.ColumnValue<double, double> humidityMax(double? value) => _i1.ColumnValue(
    table.humidityMax,
    value,
  );

  _i1.ColumnValue<double, double> lightMin(double? value) => _i1.ColumnValue(
    table.lightMin,
    value,
  );

  _i1.ColumnValue<double, double> lightMax(double? value) => _i1.ColumnValue(
    table.lightMax,
    value,
  );

  _i1.ColumnValue<double, double> co2Min(double? value) => _i1.ColumnValue(
    table.co2Min,
    value,
  );

  _i1.ColumnValue<double, double> co2Max(double? value) => _i1.ColumnValue(
    table.co2Max,
    value,
  );

  _i1.ColumnValue<double, double> phMin(double? value) => _i1.ColumnValue(
    table.phMin,
    value,
  );

  _i1.ColumnValue<double, double> phMax(double? value) => _i1.ColumnValue(
    table.phMax,
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

class GreenhouseTable extends _i1.Table<int?> {
  GreenhouseTable({super.tableRelation}) : super(tableName: 'greenhouses') {
    updateTable = GreenhouseUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    location = _i1.ColumnString(
      'location',
      this,
    );
    latitude = _i1.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _i1.ColumnDouble(
      'longitude',
      this,
    );
    climateType = _i1.ColumnString(
      'climateType',
      this,
    );
    irrigationType = _i1.ColumnString(
      'irrigationType',
      this,
    );
    totalTrays = _i1.ColumnInt(
      'totalTrays',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
    temperatureMin = _i1.ColumnDouble(
      'temperatureMin',
      this,
    );
    temperatureMax = _i1.ColumnDouble(
      'temperatureMax',
      this,
    );
    humidityMin = _i1.ColumnDouble(
      'humidityMin',
      this,
    );
    humidityMax = _i1.ColumnDouble(
      'humidityMax',
      this,
    );
    lightMin = _i1.ColumnDouble(
      'lightMin',
      this,
    );
    lightMax = _i1.ColumnDouble(
      'lightMax',
      this,
    );
    co2Min = _i1.ColumnDouble(
      'co2Min',
      this,
    );
    co2Max = _i1.ColumnDouble(
      'co2Max',
      this,
    );
    phMin = _i1.ColumnDouble(
      'phMin',
      this,
    );
    phMax = _i1.ColumnDouble(
      'phMax',
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

  late final GreenhouseUpdateTable updateTable;

  late final _i1.ColumnString userId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnString location;

  late final _i1.ColumnDouble latitude;

  late final _i1.ColumnDouble longitude;

  late final _i1.ColumnString climateType;

  late final _i1.ColumnString irrigationType;

  late final _i1.ColumnInt totalTrays;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDouble temperatureMin;

  late final _i1.ColumnDouble temperatureMax;

  late final _i1.ColumnDouble humidityMin;

  late final _i1.ColumnDouble humidityMax;

  late final _i1.ColumnDouble lightMin;

  late final _i1.ColumnDouble lightMax;

  late final _i1.ColumnDouble co2Min;

  late final _i1.ColumnDouble co2Max;

  late final _i1.ColumnDouble phMin;

  late final _i1.ColumnDouble phMax;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    name,
    description,
    location,
    latitude,
    longitude,
    climateType,
    irrigationType,
    totalTrays,
    isActive,
    temperatureMin,
    temperatureMax,
    humidityMin,
    humidityMax,
    lightMin,
    lightMax,
    co2Min,
    co2Max,
    phMin,
    phMax,
    createdAt,
    updatedAt,
  ];
}

class GreenhouseInclude extends _i1.IncludeObject {
  GreenhouseInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Greenhouse.t;
}

class GreenhouseIncludeList extends _i1.IncludeList {
  GreenhouseIncludeList._({
    _i1.WhereExpressionBuilder<GreenhouseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Greenhouse.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Greenhouse.t;
}

class GreenhouseRepository {
  const GreenhouseRepository._();

  /// Returns a list of [Greenhouse]s matching the given query parameters.
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
  Future<List<Greenhouse>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GreenhouseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GreenhouseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GreenhouseTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Greenhouse>(
      where: where?.call(Greenhouse.t),
      orderBy: orderBy?.call(Greenhouse.t),
      orderByList: orderByList?.call(Greenhouse.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Greenhouse] matching the given query parameters.
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
  Future<Greenhouse?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GreenhouseTable>? where,
    int? offset,
    _i1.OrderByBuilder<GreenhouseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GreenhouseTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Greenhouse>(
      where: where?.call(Greenhouse.t),
      orderBy: orderBy?.call(Greenhouse.t),
      orderByList: orderByList?.call(Greenhouse.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Greenhouse] by its [id] or null if no such row exists.
  Future<Greenhouse?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Greenhouse>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Greenhouse]s in the list and returns the inserted rows.
  ///
  /// The returned [Greenhouse]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Greenhouse>> insert(
    _i1.Session session,
    List<Greenhouse> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Greenhouse>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Greenhouse] and returns the inserted row.
  ///
  /// The returned [Greenhouse] will have its `id` field set.
  Future<Greenhouse> insertRow(
    _i1.Session session,
    Greenhouse row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Greenhouse>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Greenhouse]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Greenhouse>> update(
    _i1.Session session,
    List<Greenhouse> rows, {
    _i1.ColumnSelections<GreenhouseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Greenhouse>(
      rows,
      columns: columns?.call(Greenhouse.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Greenhouse]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Greenhouse> updateRow(
    _i1.Session session,
    Greenhouse row, {
    _i1.ColumnSelections<GreenhouseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Greenhouse>(
      row,
      columns: columns?.call(Greenhouse.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Greenhouse] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Greenhouse?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<GreenhouseUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Greenhouse>(
      id,
      columnValues: columnValues(Greenhouse.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Greenhouse]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Greenhouse>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<GreenhouseUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<GreenhouseTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GreenhouseTable>? orderBy,
    _i1.OrderByListBuilder<GreenhouseTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Greenhouse>(
      columnValues: columnValues(Greenhouse.t.updateTable),
      where: where(Greenhouse.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Greenhouse.t),
      orderByList: orderByList?.call(Greenhouse.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Greenhouse]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Greenhouse>> delete(
    _i1.Session session,
    List<Greenhouse> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Greenhouse>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Greenhouse].
  Future<Greenhouse> deleteRow(
    _i1.Session session,
    Greenhouse row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Greenhouse>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Greenhouse>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<GreenhouseTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Greenhouse>(
      where: where(Greenhouse.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GreenhouseTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Greenhouse>(
      where: where?.call(Greenhouse.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Greenhouse] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<GreenhouseTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Greenhouse>(
      where: where(Greenhouse.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
