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

abstract class GrowthStageDefinition
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  GrowthStageDefinition._({
    this.id,
    required this.cropModelId,
    required this.stageName,
    required this.stageOrder,
    required this.durationDaysMin,
    required this.durationDaysMax,
    this.description,
    this.careInstructions,
    this.expectedHeightMinCm,
    this.expectedHeightMaxCm,
    this.expectedLeafCountMin,
    this.expectedLeafCountMax,
    this.temperatureMinOverride,
    this.temperatureMaxOverride,
    this.humidityMinOverride,
    this.humidityMaxOverride,
    this.lightHoursMinOverride,
    this.lightHoursMaxOverride,
    this.wateringFrequencyDays,
    this.fertilizerType,
    this.keyIndicators,
    required this.createdAt,
  });

  factory GrowthStageDefinition({
    int? id,
    required int cropModelId,
    required String stageName,
    required int stageOrder,
    required int durationDaysMin,
    required int durationDaysMax,
    String? description,
    String? careInstructions,
    double? expectedHeightMinCm,
    double? expectedHeightMaxCm,
    int? expectedLeafCountMin,
    int? expectedLeafCountMax,
    double? temperatureMinOverride,
    double? temperatureMaxOverride,
    double? humidityMinOverride,
    double? humidityMaxOverride,
    double? lightHoursMinOverride,
    double? lightHoursMaxOverride,
    int? wateringFrequencyDays,
    String? fertilizerType,
    List<String>? keyIndicators,
    required DateTime createdAt,
  }) = _GrowthStageDefinitionImpl;

  factory GrowthStageDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return GrowthStageDefinition(
      id: jsonSerialization['id'] as int?,
      cropModelId: jsonSerialization['cropModelId'] as int,
      stageName: jsonSerialization['stageName'] as String,
      stageOrder: jsonSerialization['stageOrder'] as int,
      durationDaysMin: jsonSerialization['durationDaysMin'] as int,
      durationDaysMax: jsonSerialization['durationDaysMax'] as int,
      description: jsonSerialization['description'] as String?,
      careInstructions: jsonSerialization['careInstructions'] as String?,
      expectedHeightMinCm: (jsonSerialization['expectedHeightMinCm'] as num?)
          ?.toDouble(),
      expectedHeightMaxCm: (jsonSerialization['expectedHeightMaxCm'] as num?)
          ?.toDouble(),
      expectedLeafCountMin: jsonSerialization['expectedLeafCountMin'] as int?,
      expectedLeafCountMax: jsonSerialization['expectedLeafCountMax'] as int?,
      temperatureMinOverride:
          (jsonSerialization['temperatureMinOverride'] as num?)?.toDouble(),
      temperatureMaxOverride:
          (jsonSerialization['temperatureMaxOverride'] as num?)?.toDouble(),
      humidityMinOverride: (jsonSerialization['humidityMinOverride'] as num?)
          ?.toDouble(),
      humidityMaxOverride: (jsonSerialization['humidityMaxOverride'] as num?)
          ?.toDouble(),
      lightHoursMinOverride:
          (jsonSerialization['lightHoursMinOverride'] as num?)?.toDouble(),
      lightHoursMaxOverride:
          (jsonSerialization['lightHoursMaxOverride'] as num?)?.toDouble(),
      wateringFrequencyDays: jsonSerialization['wateringFrequencyDays'] as int?,
      fertilizerType: jsonSerialization['fertilizerType'] as String?,
      keyIndicators: jsonSerialization['keyIndicators'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['keyIndicators'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = GrowthStageDefinitionTable();

  static const db = GrowthStageDefinitionRepository._();

  @override
  int? id;

  int cropModelId;

  String stageName;

  int stageOrder;

  int durationDaysMin;

  int durationDaysMax;

  String? description;

  String? careInstructions;

  double? expectedHeightMinCm;

  double? expectedHeightMaxCm;

  int? expectedLeafCountMin;

  int? expectedLeafCountMax;

  double? temperatureMinOverride;

  double? temperatureMaxOverride;

  double? humidityMinOverride;

  double? humidityMaxOverride;

  double? lightHoursMinOverride;

  double? lightHoursMaxOverride;

  int? wateringFrequencyDays;

  String? fertilizerType;

  List<String>? keyIndicators;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [GrowthStageDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GrowthStageDefinition copyWith({
    int? id,
    int? cropModelId,
    String? stageName,
    int? stageOrder,
    int? durationDaysMin,
    int? durationDaysMax,
    String? description,
    String? careInstructions,
    double? expectedHeightMinCm,
    double? expectedHeightMaxCm,
    int? expectedLeafCountMin,
    int? expectedLeafCountMax,
    double? temperatureMinOverride,
    double? temperatureMaxOverride,
    double? humidityMinOverride,
    double? humidityMaxOverride,
    double? lightHoursMinOverride,
    double? lightHoursMaxOverride,
    int? wateringFrequencyDays,
    String? fertilizerType,
    List<String>? keyIndicators,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GrowthStageDefinition',
      if (id != null) 'id': id,
      'cropModelId': cropModelId,
      'stageName': stageName,
      'stageOrder': stageOrder,
      'durationDaysMin': durationDaysMin,
      'durationDaysMax': durationDaysMax,
      if (description != null) 'description': description,
      if (careInstructions != null) 'careInstructions': careInstructions,
      if (expectedHeightMinCm != null)
        'expectedHeightMinCm': expectedHeightMinCm,
      if (expectedHeightMaxCm != null)
        'expectedHeightMaxCm': expectedHeightMaxCm,
      if (expectedLeafCountMin != null)
        'expectedLeafCountMin': expectedLeafCountMin,
      if (expectedLeafCountMax != null)
        'expectedLeafCountMax': expectedLeafCountMax,
      if (temperatureMinOverride != null)
        'temperatureMinOverride': temperatureMinOverride,
      if (temperatureMaxOverride != null)
        'temperatureMaxOverride': temperatureMaxOverride,
      if (humidityMinOverride != null)
        'humidityMinOverride': humidityMinOverride,
      if (humidityMaxOverride != null)
        'humidityMaxOverride': humidityMaxOverride,
      if (lightHoursMinOverride != null)
        'lightHoursMinOverride': lightHoursMinOverride,
      if (lightHoursMaxOverride != null)
        'lightHoursMaxOverride': lightHoursMaxOverride,
      if (wateringFrequencyDays != null)
        'wateringFrequencyDays': wateringFrequencyDays,
      if (fertilizerType != null) 'fertilizerType': fertilizerType,
      if (keyIndicators != null) 'keyIndicators': keyIndicators?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GrowthStageDefinition',
      if (id != null) 'id': id,
      'cropModelId': cropModelId,
      'stageName': stageName,
      'stageOrder': stageOrder,
      'durationDaysMin': durationDaysMin,
      'durationDaysMax': durationDaysMax,
      if (description != null) 'description': description,
      if (careInstructions != null) 'careInstructions': careInstructions,
      if (expectedHeightMinCm != null)
        'expectedHeightMinCm': expectedHeightMinCm,
      if (expectedHeightMaxCm != null)
        'expectedHeightMaxCm': expectedHeightMaxCm,
      if (expectedLeafCountMin != null)
        'expectedLeafCountMin': expectedLeafCountMin,
      if (expectedLeafCountMax != null)
        'expectedLeafCountMax': expectedLeafCountMax,
      if (temperatureMinOverride != null)
        'temperatureMinOverride': temperatureMinOverride,
      if (temperatureMaxOverride != null)
        'temperatureMaxOverride': temperatureMaxOverride,
      if (humidityMinOverride != null)
        'humidityMinOverride': humidityMinOverride,
      if (humidityMaxOverride != null)
        'humidityMaxOverride': humidityMaxOverride,
      if (lightHoursMinOverride != null)
        'lightHoursMinOverride': lightHoursMinOverride,
      if (lightHoursMaxOverride != null)
        'lightHoursMaxOverride': lightHoursMaxOverride,
      if (wateringFrequencyDays != null)
        'wateringFrequencyDays': wateringFrequencyDays,
      if (fertilizerType != null) 'fertilizerType': fertilizerType,
      if (keyIndicators != null) 'keyIndicators': keyIndicators?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static GrowthStageDefinitionInclude include() {
    return GrowthStageDefinitionInclude._();
  }

  static GrowthStageDefinitionIncludeList includeList({
    _i1.WhereExpressionBuilder<GrowthStageDefinitionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GrowthStageDefinitionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GrowthStageDefinitionTable>? orderByList,
    GrowthStageDefinitionInclude? include,
  }) {
    return GrowthStageDefinitionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GrowthStageDefinition.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(GrowthStageDefinition.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GrowthStageDefinitionImpl extends GrowthStageDefinition {
  _GrowthStageDefinitionImpl({
    int? id,
    required int cropModelId,
    required String stageName,
    required int stageOrder,
    required int durationDaysMin,
    required int durationDaysMax,
    String? description,
    String? careInstructions,
    double? expectedHeightMinCm,
    double? expectedHeightMaxCm,
    int? expectedLeafCountMin,
    int? expectedLeafCountMax,
    double? temperatureMinOverride,
    double? temperatureMaxOverride,
    double? humidityMinOverride,
    double? humidityMaxOverride,
    double? lightHoursMinOverride,
    double? lightHoursMaxOverride,
    int? wateringFrequencyDays,
    String? fertilizerType,
    List<String>? keyIndicators,
    required DateTime createdAt,
  }) : super._(
         id: id,
         cropModelId: cropModelId,
         stageName: stageName,
         stageOrder: stageOrder,
         durationDaysMin: durationDaysMin,
         durationDaysMax: durationDaysMax,
         description: description,
         careInstructions: careInstructions,
         expectedHeightMinCm: expectedHeightMinCm,
         expectedHeightMaxCm: expectedHeightMaxCm,
         expectedLeafCountMin: expectedLeafCountMin,
         expectedLeafCountMax: expectedLeafCountMax,
         temperatureMinOverride: temperatureMinOverride,
         temperatureMaxOverride: temperatureMaxOverride,
         humidityMinOverride: humidityMinOverride,
         humidityMaxOverride: humidityMaxOverride,
         lightHoursMinOverride: lightHoursMinOverride,
         lightHoursMaxOverride: lightHoursMaxOverride,
         wateringFrequencyDays: wateringFrequencyDays,
         fertilizerType: fertilizerType,
         keyIndicators: keyIndicators,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [GrowthStageDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GrowthStageDefinition copyWith({
    Object? id = _Undefined,
    int? cropModelId,
    String? stageName,
    int? stageOrder,
    int? durationDaysMin,
    int? durationDaysMax,
    Object? description = _Undefined,
    Object? careInstructions = _Undefined,
    Object? expectedHeightMinCm = _Undefined,
    Object? expectedHeightMaxCm = _Undefined,
    Object? expectedLeafCountMin = _Undefined,
    Object? expectedLeafCountMax = _Undefined,
    Object? temperatureMinOverride = _Undefined,
    Object? temperatureMaxOverride = _Undefined,
    Object? humidityMinOverride = _Undefined,
    Object? humidityMaxOverride = _Undefined,
    Object? lightHoursMinOverride = _Undefined,
    Object? lightHoursMaxOverride = _Undefined,
    Object? wateringFrequencyDays = _Undefined,
    Object? fertilizerType = _Undefined,
    Object? keyIndicators = _Undefined,
    DateTime? createdAt,
  }) {
    return GrowthStageDefinition(
      id: id is int? ? id : this.id,
      cropModelId: cropModelId ?? this.cropModelId,
      stageName: stageName ?? this.stageName,
      stageOrder: stageOrder ?? this.stageOrder,
      durationDaysMin: durationDaysMin ?? this.durationDaysMin,
      durationDaysMax: durationDaysMax ?? this.durationDaysMax,
      description: description is String? ? description : this.description,
      careInstructions: careInstructions is String?
          ? careInstructions
          : this.careInstructions,
      expectedHeightMinCm: expectedHeightMinCm is double?
          ? expectedHeightMinCm
          : this.expectedHeightMinCm,
      expectedHeightMaxCm: expectedHeightMaxCm is double?
          ? expectedHeightMaxCm
          : this.expectedHeightMaxCm,
      expectedLeafCountMin: expectedLeafCountMin is int?
          ? expectedLeafCountMin
          : this.expectedLeafCountMin,
      expectedLeafCountMax: expectedLeafCountMax is int?
          ? expectedLeafCountMax
          : this.expectedLeafCountMax,
      temperatureMinOverride: temperatureMinOverride is double?
          ? temperatureMinOverride
          : this.temperatureMinOverride,
      temperatureMaxOverride: temperatureMaxOverride is double?
          ? temperatureMaxOverride
          : this.temperatureMaxOverride,
      humidityMinOverride: humidityMinOverride is double?
          ? humidityMinOverride
          : this.humidityMinOverride,
      humidityMaxOverride: humidityMaxOverride is double?
          ? humidityMaxOverride
          : this.humidityMaxOverride,
      lightHoursMinOverride: lightHoursMinOverride is double?
          ? lightHoursMinOverride
          : this.lightHoursMinOverride,
      lightHoursMaxOverride: lightHoursMaxOverride is double?
          ? lightHoursMaxOverride
          : this.lightHoursMaxOverride,
      wateringFrequencyDays: wateringFrequencyDays is int?
          ? wateringFrequencyDays
          : this.wateringFrequencyDays,
      fertilizerType: fertilizerType is String?
          ? fertilizerType
          : this.fertilizerType,
      keyIndicators: keyIndicators is List<String>?
          ? keyIndicators
          : this.keyIndicators?.map((e0) => e0).toList(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class GrowthStageDefinitionUpdateTable
    extends _i1.UpdateTable<GrowthStageDefinitionTable> {
  GrowthStageDefinitionUpdateTable(super.table);

  _i1.ColumnValue<int, int> cropModelId(int value) => _i1.ColumnValue(
    table.cropModelId,
    value,
  );

  _i1.ColumnValue<String, String> stageName(String value) => _i1.ColumnValue(
    table.stageName,
    value,
  );

  _i1.ColumnValue<int, int> stageOrder(int value) => _i1.ColumnValue(
    table.stageOrder,
    value,
  );

  _i1.ColumnValue<int, int> durationDaysMin(int value) => _i1.ColumnValue(
    table.durationDaysMin,
    value,
  );

  _i1.ColumnValue<int, int> durationDaysMax(int value) => _i1.ColumnValue(
    table.durationDaysMax,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> careInstructions(String? value) =>
      _i1.ColumnValue(
        table.careInstructions,
        value,
      );

  _i1.ColumnValue<double, double> expectedHeightMinCm(double? value) =>
      _i1.ColumnValue(
        table.expectedHeightMinCm,
        value,
      );

  _i1.ColumnValue<double, double> expectedHeightMaxCm(double? value) =>
      _i1.ColumnValue(
        table.expectedHeightMaxCm,
        value,
      );

  _i1.ColumnValue<int, int> expectedLeafCountMin(int? value) => _i1.ColumnValue(
    table.expectedLeafCountMin,
    value,
  );

  _i1.ColumnValue<int, int> expectedLeafCountMax(int? value) => _i1.ColumnValue(
    table.expectedLeafCountMax,
    value,
  );

  _i1.ColumnValue<double, double> temperatureMinOverride(double? value) =>
      _i1.ColumnValue(
        table.temperatureMinOverride,
        value,
      );

  _i1.ColumnValue<double, double> temperatureMaxOverride(double? value) =>
      _i1.ColumnValue(
        table.temperatureMaxOverride,
        value,
      );

  _i1.ColumnValue<double, double> humidityMinOverride(double? value) =>
      _i1.ColumnValue(
        table.humidityMinOverride,
        value,
      );

  _i1.ColumnValue<double, double> humidityMaxOverride(double? value) =>
      _i1.ColumnValue(
        table.humidityMaxOverride,
        value,
      );

  _i1.ColumnValue<double, double> lightHoursMinOverride(double? value) =>
      _i1.ColumnValue(
        table.lightHoursMinOverride,
        value,
      );

  _i1.ColumnValue<double, double> lightHoursMaxOverride(double? value) =>
      _i1.ColumnValue(
        table.lightHoursMaxOverride,
        value,
      );

  _i1.ColumnValue<int, int> wateringFrequencyDays(int? value) =>
      _i1.ColumnValue(
        table.wateringFrequencyDays,
        value,
      );

  _i1.ColumnValue<String, String> fertilizerType(String? value) =>
      _i1.ColumnValue(
        table.fertilizerType,
        value,
      );

  _i1.ColumnValue<List<String>, List<String>> keyIndicators(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.keyIndicators,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class GrowthStageDefinitionTable extends _i1.Table<int?> {
  GrowthStageDefinitionTable({super.tableRelation})
    : super(tableName: 'growth_stage_definitions') {
    updateTable = GrowthStageDefinitionUpdateTable(this);
    cropModelId = _i1.ColumnInt(
      'cropModelId',
      this,
    );
    stageName = _i1.ColumnString(
      'stageName',
      this,
    );
    stageOrder = _i1.ColumnInt(
      'stageOrder',
      this,
    );
    durationDaysMin = _i1.ColumnInt(
      'durationDaysMin',
      this,
    );
    durationDaysMax = _i1.ColumnInt(
      'durationDaysMax',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    careInstructions = _i1.ColumnString(
      'careInstructions',
      this,
    );
    expectedHeightMinCm = _i1.ColumnDouble(
      'expectedHeightMinCm',
      this,
    );
    expectedHeightMaxCm = _i1.ColumnDouble(
      'expectedHeightMaxCm',
      this,
    );
    expectedLeafCountMin = _i1.ColumnInt(
      'expectedLeafCountMin',
      this,
    );
    expectedLeafCountMax = _i1.ColumnInt(
      'expectedLeafCountMax',
      this,
    );
    temperatureMinOverride = _i1.ColumnDouble(
      'temperatureMinOverride',
      this,
    );
    temperatureMaxOverride = _i1.ColumnDouble(
      'temperatureMaxOverride',
      this,
    );
    humidityMinOverride = _i1.ColumnDouble(
      'humidityMinOverride',
      this,
    );
    humidityMaxOverride = _i1.ColumnDouble(
      'humidityMaxOverride',
      this,
    );
    lightHoursMinOverride = _i1.ColumnDouble(
      'lightHoursMinOverride',
      this,
    );
    lightHoursMaxOverride = _i1.ColumnDouble(
      'lightHoursMaxOverride',
      this,
    );
    wateringFrequencyDays = _i1.ColumnInt(
      'wateringFrequencyDays',
      this,
    );
    fertilizerType = _i1.ColumnString(
      'fertilizerType',
      this,
    );
    keyIndicators = _i1.ColumnSerializable<List<String>>(
      'keyIndicators',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final GrowthStageDefinitionUpdateTable updateTable;

  late final _i1.ColumnInt cropModelId;

  late final _i1.ColumnString stageName;

  late final _i1.ColumnInt stageOrder;

  late final _i1.ColumnInt durationDaysMin;

  late final _i1.ColumnInt durationDaysMax;

  late final _i1.ColumnString description;

  late final _i1.ColumnString careInstructions;

  late final _i1.ColumnDouble expectedHeightMinCm;

  late final _i1.ColumnDouble expectedHeightMaxCm;

  late final _i1.ColumnInt expectedLeafCountMin;

  late final _i1.ColumnInt expectedLeafCountMax;

  late final _i1.ColumnDouble temperatureMinOverride;

  late final _i1.ColumnDouble temperatureMaxOverride;

  late final _i1.ColumnDouble humidityMinOverride;

  late final _i1.ColumnDouble humidityMaxOverride;

  late final _i1.ColumnDouble lightHoursMinOverride;

  late final _i1.ColumnDouble lightHoursMaxOverride;

  late final _i1.ColumnInt wateringFrequencyDays;

  late final _i1.ColumnString fertilizerType;

  late final _i1.ColumnSerializable<List<String>> keyIndicators;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    cropModelId,
    stageName,
    stageOrder,
    durationDaysMin,
    durationDaysMax,
    description,
    careInstructions,
    expectedHeightMinCm,
    expectedHeightMaxCm,
    expectedLeafCountMin,
    expectedLeafCountMax,
    temperatureMinOverride,
    temperatureMaxOverride,
    humidityMinOverride,
    humidityMaxOverride,
    lightHoursMinOverride,
    lightHoursMaxOverride,
    wateringFrequencyDays,
    fertilizerType,
    keyIndicators,
    createdAt,
  ];
}

class GrowthStageDefinitionInclude extends _i1.IncludeObject {
  GrowthStageDefinitionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => GrowthStageDefinition.t;
}

class GrowthStageDefinitionIncludeList extends _i1.IncludeList {
  GrowthStageDefinitionIncludeList._({
    _i1.WhereExpressionBuilder<GrowthStageDefinitionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(GrowthStageDefinition.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => GrowthStageDefinition.t;
}

class GrowthStageDefinitionRepository {
  const GrowthStageDefinitionRepository._();

  /// Returns a list of [GrowthStageDefinition]s matching the given query parameters.
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
  Future<List<GrowthStageDefinition>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GrowthStageDefinitionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GrowthStageDefinitionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GrowthStageDefinitionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<GrowthStageDefinition>(
      where: where?.call(GrowthStageDefinition.t),
      orderBy: orderBy?.call(GrowthStageDefinition.t),
      orderByList: orderByList?.call(GrowthStageDefinition.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [GrowthStageDefinition] matching the given query parameters.
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
  Future<GrowthStageDefinition?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GrowthStageDefinitionTable>? where,
    int? offset,
    _i1.OrderByBuilder<GrowthStageDefinitionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<GrowthStageDefinitionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<GrowthStageDefinition>(
      where: where?.call(GrowthStageDefinition.t),
      orderBy: orderBy?.call(GrowthStageDefinition.t),
      orderByList: orderByList?.call(GrowthStageDefinition.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [GrowthStageDefinition] by its [id] or null if no such row exists.
  Future<GrowthStageDefinition?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<GrowthStageDefinition>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [GrowthStageDefinition]s in the list and returns the inserted rows.
  ///
  /// The returned [GrowthStageDefinition]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<GrowthStageDefinition>> insert(
    _i1.Session session,
    List<GrowthStageDefinition> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<GrowthStageDefinition>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [GrowthStageDefinition] and returns the inserted row.
  ///
  /// The returned [GrowthStageDefinition] will have its `id` field set.
  Future<GrowthStageDefinition> insertRow(
    _i1.Session session,
    GrowthStageDefinition row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<GrowthStageDefinition>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [GrowthStageDefinition]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<GrowthStageDefinition>> update(
    _i1.Session session,
    List<GrowthStageDefinition> rows, {
    _i1.ColumnSelections<GrowthStageDefinitionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<GrowthStageDefinition>(
      rows,
      columns: columns?.call(GrowthStageDefinition.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GrowthStageDefinition]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<GrowthStageDefinition> updateRow(
    _i1.Session session,
    GrowthStageDefinition row, {
    _i1.ColumnSelections<GrowthStageDefinitionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<GrowthStageDefinition>(
      row,
      columns: columns?.call(GrowthStageDefinition.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GrowthStageDefinition] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<GrowthStageDefinition?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<GrowthStageDefinitionUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<GrowthStageDefinition>(
      id,
      columnValues: columnValues(GrowthStageDefinition.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [GrowthStageDefinition]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<GrowthStageDefinition>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<GrowthStageDefinitionUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<GrowthStageDefinitionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GrowthStageDefinitionTable>? orderBy,
    _i1.OrderByListBuilder<GrowthStageDefinitionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<GrowthStageDefinition>(
      columnValues: columnValues(GrowthStageDefinition.t.updateTable),
      where: where(GrowthStageDefinition.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GrowthStageDefinition.t),
      orderByList: orderByList?.call(GrowthStageDefinition.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [GrowthStageDefinition]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<GrowthStageDefinition>> delete(
    _i1.Session session,
    List<GrowthStageDefinition> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<GrowthStageDefinition>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [GrowthStageDefinition].
  Future<GrowthStageDefinition> deleteRow(
    _i1.Session session,
    GrowthStageDefinition row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<GrowthStageDefinition>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<GrowthStageDefinition>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<GrowthStageDefinitionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<GrowthStageDefinition>(
      where: where(GrowthStageDefinition.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<GrowthStageDefinitionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<GrowthStageDefinition>(
      where: where?.call(GrowthStageDefinition.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [GrowthStageDefinition] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<GrowthStageDefinitionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<GrowthStageDefinition>(
      where: where(GrowthStageDefinition.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
