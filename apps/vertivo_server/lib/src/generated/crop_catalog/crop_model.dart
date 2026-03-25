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

abstract class CropModel
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CropModel._({
    this.id,
    required this.species,
    required this.commonName,
    this.scientificName,
    this.family,
    required this.category,
    required this.idealTemperatureMin,
    required this.idealTemperatureMax,
    required this.idealHumidityMin,
    required this.idealHumidityMax,
    required this.idealLightHoursMin,
    required this.idealLightHoursMax,
    required this.idealPhMin,
    required this.idealPhMax,
    this.idealCo2Min,
    this.idealCo2Max,
    required this.waterRequirement,
    required this.growthDurationDays,
    this.commonDiseases,
    this.commonPests,
    this.companionPlants,
    this.incompatiblePlants,
    required this.difficulty,
    required this.segments,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CropModel({
    int? id,
    required String species,
    required String commonName,
    String? scientificName,
    String? family,
    required String category,
    required double idealTemperatureMin,
    required double idealTemperatureMax,
    required double idealHumidityMin,
    required double idealHumidityMax,
    required double idealLightHoursMin,
    required double idealLightHoursMax,
    required double idealPhMin,
    required double idealPhMax,
    double? idealCo2Min,
    double? idealCo2Max,
    required String waterRequirement,
    required int growthDurationDays,
    List<String>? commonDiseases,
    List<String>? commonPests,
    List<String>? companionPlants,
    List<String>? incompatiblePlants,
    required String difficulty,
    required List<String> segments,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CropModelImpl;

  factory CropModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return CropModel(
      id: jsonSerialization['id'] as int?,
      species: jsonSerialization['species'] as String,
      commonName: jsonSerialization['commonName'] as String,
      scientificName: jsonSerialization['scientificName'] as String?,
      family: jsonSerialization['family'] as String?,
      category: jsonSerialization['category'] as String,
      idealTemperatureMin: (jsonSerialization['idealTemperatureMin'] as num)
          .toDouble(),
      idealTemperatureMax: (jsonSerialization['idealTemperatureMax'] as num)
          .toDouble(),
      idealHumidityMin: (jsonSerialization['idealHumidityMin'] as num)
          .toDouble(),
      idealHumidityMax: (jsonSerialization['idealHumidityMax'] as num)
          .toDouble(),
      idealLightHoursMin: (jsonSerialization['idealLightHoursMin'] as num)
          .toDouble(),
      idealLightHoursMax: (jsonSerialization['idealLightHoursMax'] as num)
          .toDouble(),
      idealPhMin: (jsonSerialization['idealPhMin'] as num).toDouble(),
      idealPhMax: (jsonSerialization['idealPhMax'] as num).toDouble(),
      idealCo2Min: (jsonSerialization['idealCo2Min'] as num?)?.toDouble(),
      idealCo2Max: (jsonSerialization['idealCo2Max'] as num?)?.toDouble(),
      waterRequirement: jsonSerialization['waterRequirement'] as String,
      growthDurationDays: jsonSerialization['growthDurationDays'] as int,
      commonDiseases: jsonSerialization['commonDiseases'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['commonDiseases'],
            ),
      commonPests: jsonSerialization['commonPests'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['commonPests'],
            ),
      companionPlants: jsonSerialization['companionPlants'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['companionPlants'],
            ),
      incompatiblePlants: jsonSerialization['incompatiblePlants'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['incompatiblePlants'],
            ),
      difficulty: jsonSerialization['difficulty'] as String,
      segments: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['segments'],
      ),
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = CropModelTable();

  static const db = CropModelRepository._();

  @override
  int? id;

  String species;

  String commonName;

  String? scientificName;

  String? family;

  String category;

  double idealTemperatureMin;

  double idealTemperatureMax;

  double idealHumidityMin;

  double idealHumidityMax;

  double idealLightHoursMin;

  double idealLightHoursMax;

  double idealPhMin;

  double idealPhMax;

  double? idealCo2Min;

  double? idealCo2Max;

  String waterRequirement;

  int growthDurationDays;

  List<String>? commonDiseases;

  List<String>? commonPests;

  List<String>? companionPlants;

  List<String>? incompatiblePlants;

  String difficulty;

  List<String> segments;

  bool isActive;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CropModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CropModel copyWith({
    int? id,
    String? species,
    String? commonName,
    String? scientificName,
    String? family,
    String? category,
    double? idealTemperatureMin,
    double? idealTemperatureMax,
    double? idealHumidityMin,
    double? idealHumidityMax,
    double? idealLightHoursMin,
    double? idealLightHoursMax,
    double? idealPhMin,
    double? idealPhMax,
    double? idealCo2Min,
    double? idealCo2Max,
    String? waterRequirement,
    int? growthDurationDays,
    List<String>? commonDiseases,
    List<String>? commonPests,
    List<String>? companionPlants,
    List<String>? incompatiblePlants,
    String? difficulty,
    List<String>? segments,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CropModel',
      if (id != null) 'id': id,
      'species': species,
      'commonName': commonName,
      if (scientificName != null) 'scientificName': scientificName,
      if (family != null) 'family': family,
      'category': category,
      'idealTemperatureMin': idealTemperatureMin,
      'idealTemperatureMax': idealTemperatureMax,
      'idealHumidityMin': idealHumidityMin,
      'idealHumidityMax': idealHumidityMax,
      'idealLightHoursMin': idealLightHoursMin,
      'idealLightHoursMax': idealLightHoursMax,
      'idealPhMin': idealPhMin,
      'idealPhMax': idealPhMax,
      if (idealCo2Min != null) 'idealCo2Min': idealCo2Min,
      if (idealCo2Max != null) 'idealCo2Max': idealCo2Max,
      'waterRequirement': waterRequirement,
      'growthDurationDays': growthDurationDays,
      if (commonDiseases != null) 'commonDiseases': commonDiseases?.toJson(),
      if (commonPests != null) 'commonPests': commonPests?.toJson(),
      if (companionPlants != null) 'companionPlants': companionPlants?.toJson(),
      if (incompatiblePlants != null)
        'incompatiblePlants': incompatiblePlants?.toJson(),
      'difficulty': difficulty,
      'segments': segments.toJson(),
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CropModel',
      if (id != null) 'id': id,
      'species': species,
      'commonName': commonName,
      if (scientificName != null) 'scientificName': scientificName,
      if (family != null) 'family': family,
      'category': category,
      'idealTemperatureMin': idealTemperatureMin,
      'idealTemperatureMax': idealTemperatureMax,
      'idealHumidityMin': idealHumidityMin,
      'idealHumidityMax': idealHumidityMax,
      'idealLightHoursMin': idealLightHoursMin,
      'idealLightHoursMax': idealLightHoursMax,
      'idealPhMin': idealPhMin,
      'idealPhMax': idealPhMax,
      if (idealCo2Min != null) 'idealCo2Min': idealCo2Min,
      if (idealCo2Max != null) 'idealCo2Max': idealCo2Max,
      'waterRequirement': waterRequirement,
      'growthDurationDays': growthDurationDays,
      if (commonDiseases != null) 'commonDiseases': commonDiseases?.toJson(),
      if (commonPests != null) 'commonPests': commonPests?.toJson(),
      if (companionPlants != null) 'companionPlants': companionPlants?.toJson(),
      if (incompatiblePlants != null)
        'incompatiblePlants': incompatiblePlants?.toJson(),
      'difficulty': difficulty,
      'segments': segments.toJson(),
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CropModelInclude include() {
    return CropModelInclude._();
  }

  static CropModelIncludeList includeList({
    _i1.WhereExpressionBuilder<CropModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CropModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CropModelTable>? orderByList,
    CropModelInclude? include,
  }) {
    return CropModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CropModel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CropModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CropModelImpl extends CropModel {
  _CropModelImpl({
    int? id,
    required String species,
    required String commonName,
    String? scientificName,
    String? family,
    required String category,
    required double idealTemperatureMin,
    required double idealTemperatureMax,
    required double idealHumidityMin,
    required double idealHumidityMax,
    required double idealLightHoursMin,
    required double idealLightHoursMax,
    required double idealPhMin,
    required double idealPhMax,
    double? idealCo2Min,
    double? idealCo2Max,
    required String waterRequirement,
    required int growthDurationDays,
    List<String>? commonDiseases,
    List<String>? commonPests,
    List<String>? companionPlants,
    List<String>? incompatiblePlants,
    required String difficulty,
    required List<String> segments,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         species: species,
         commonName: commonName,
         scientificName: scientificName,
         family: family,
         category: category,
         idealTemperatureMin: idealTemperatureMin,
         idealTemperatureMax: idealTemperatureMax,
         idealHumidityMin: idealHumidityMin,
         idealHumidityMax: idealHumidityMax,
         idealLightHoursMin: idealLightHoursMin,
         idealLightHoursMax: idealLightHoursMax,
         idealPhMin: idealPhMin,
         idealPhMax: idealPhMax,
         idealCo2Min: idealCo2Min,
         idealCo2Max: idealCo2Max,
         waterRequirement: waterRequirement,
         growthDurationDays: growthDurationDays,
         commonDiseases: commonDiseases,
         commonPests: commonPests,
         companionPlants: companionPlants,
         incompatiblePlants: incompatiblePlants,
         difficulty: difficulty,
         segments: segments,
         isActive: isActive,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CropModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CropModel copyWith({
    Object? id = _Undefined,
    String? species,
    String? commonName,
    Object? scientificName = _Undefined,
    Object? family = _Undefined,
    String? category,
    double? idealTemperatureMin,
    double? idealTemperatureMax,
    double? idealHumidityMin,
    double? idealHumidityMax,
    double? idealLightHoursMin,
    double? idealLightHoursMax,
    double? idealPhMin,
    double? idealPhMax,
    Object? idealCo2Min = _Undefined,
    Object? idealCo2Max = _Undefined,
    String? waterRequirement,
    int? growthDurationDays,
    Object? commonDiseases = _Undefined,
    Object? commonPests = _Undefined,
    Object? companionPlants = _Undefined,
    Object? incompatiblePlants = _Undefined,
    String? difficulty,
    List<String>? segments,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CropModel(
      id: id is int? ? id : this.id,
      species: species ?? this.species,
      commonName: commonName ?? this.commonName,
      scientificName: scientificName is String?
          ? scientificName
          : this.scientificName,
      family: family is String? ? family : this.family,
      category: category ?? this.category,
      idealTemperatureMin: idealTemperatureMin ?? this.idealTemperatureMin,
      idealTemperatureMax: idealTemperatureMax ?? this.idealTemperatureMax,
      idealHumidityMin: idealHumidityMin ?? this.idealHumidityMin,
      idealHumidityMax: idealHumidityMax ?? this.idealHumidityMax,
      idealLightHoursMin: idealLightHoursMin ?? this.idealLightHoursMin,
      idealLightHoursMax: idealLightHoursMax ?? this.idealLightHoursMax,
      idealPhMin: idealPhMin ?? this.idealPhMin,
      idealPhMax: idealPhMax ?? this.idealPhMax,
      idealCo2Min: idealCo2Min is double? ? idealCo2Min : this.idealCo2Min,
      idealCo2Max: idealCo2Max is double? ? idealCo2Max : this.idealCo2Max,
      waterRequirement: waterRequirement ?? this.waterRequirement,
      growthDurationDays: growthDurationDays ?? this.growthDurationDays,
      commonDiseases: commonDiseases is List<String>?
          ? commonDiseases
          : this.commonDiseases?.map((e0) => e0).toList(),
      commonPests: commonPests is List<String>?
          ? commonPests
          : this.commonPests?.map((e0) => e0).toList(),
      companionPlants: companionPlants is List<String>?
          ? companionPlants
          : this.companionPlants?.map((e0) => e0).toList(),
      incompatiblePlants: incompatiblePlants is List<String>?
          ? incompatiblePlants
          : this.incompatiblePlants?.map((e0) => e0).toList(),
      difficulty: difficulty ?? this.difficulty,
      segments: segments ?? this.segments.map((e0) => e0).toList(),
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CropModelUpdateTable extends _i1.UpdateTable<CropModelTable> {
  CropModelUpdateTable(super.table);

  _i1.ColumnValue<String, String> species(String value) => _i1.ColumnValue(
    table.species,
    value,
  );

  _i1.ColumnValue<String, String> commonName(String value) => _i1.ColumnValue(
    table.commonName,
    value,
  );

  _i1.ColumnValue<String, String> scientificName(String? value) =>
      _i1.ColumnValue(
        table.scientificName,
        value,
      );

  _i1.ColumnValue<String, String> family(String? value) => _i1.ColumnValue(
    table.family,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<double, double> idealTemperatureMin(double value) =>
      _i1.ColumnValue(
        table.idealTemperatureMin,
        value,
      );

  _i1.ColumnValue<double, double> idealTemperatureMax(double value) =>
      _i1.ColumnValue(
        table.idealTemperatureMax,
        value,
      );

  _i1.ColumnValue<double, double> idealHumidityMin(double value) =>
      _i1.ColumnValue(
        table.idealHumidityMin,
        value,
      );

  _i1.ColumnValue<double, double> idealHumidityMax(double value) =>
      _i1.ColumnValue(
        table.idealHumidityMax,
        value,
      );

  _i1.ColumnValue<double, double> idealLightHoursMin(double value) =>
      _i1.ColumnValue(
        table.idealLightHoursMin,
        value,
      );

  _i1.ColumnValue<double, double> idealLightHoursMax(double value) =>
      _i1.ColumnValue(
        table.idealLightHoursMax,
        value,
      );

  _i1.ColumnValue<double, double> idealPhMin(double value) => _i1.ColumnValue(
    table.idealPhMin,
    value,
  );

  _i1.ColumnValue<double, double> idealPhMax(double value) => _i1.ColumnValue(
    table.idealPhMax,
    value,
  );

  _i1.ColumnValue<double, double> idealCo2Min(double? value) => _i1.ColumnValue(
    table.idealCo2Min,
    value,
  );

  _i1.ColumnValue<double, double> idealCo2Max(double? value) => _i1.ColumnValue(
    table.idealCo2Max,
    value,
  );

  _i1.ColumnValue<String, String> waterRequirement(String value) =>
      _i1.ColumnValue(
        table.waterRequirement,
        value,
      );

  _i1.ColumnValue<int, int> growthDurationDays(int value) => _i1.ColumnValue(
    table.growthDurationDays,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> commonDiseases(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.commonDiseases,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> commonPests(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.commonPests,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> companionPlants(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.companionPlants,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> incompatiblePlants(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.incompatiblePlants,
    value,
  );

  _i1.ColumnValue<String, String> difficulty(String value) => _i1.ColumnValue(
    table.difficulty,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> segments(List<String> value) =>
      _i1.ColumnValue(
        table.segments,
        value,
      );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
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

class CropModelTable extends _i1.Table<int?> {
  CropModelTable({super.tableRelation}) : super(tableName: 'crop_models') {
    updateTable = CropModelUpdateTable(this);
    species = _i1.ColumnString(
      'species',
      this,
    );
    commonName = _i1.ColumnString(
      'commonName',
      this,
    );
    scientificName = _i1.ColumnString(
      'scientificName',
      this,
    );
    family = _i1.ColumnString(
      'family',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    idealTemperatureMin = _i1.ColumnDouble(
      'idealTemperatureMin',
      this,
    );
    idealTemperatureMax = _i1.ColumnDouble(
      'idealTemperatureMax',
      this,
    );
    idealHumidityMin = _i1.ColumnDouble(
      'idealHumidityMin',
      this,
    );
    idealHumidityMax = _i1.ColumnDouble(
      'idealHumidityMax',
      this,
    );
    idealLightHoursMin = _i1.ColumnDouble(
      'idealLightHoursMin',
      this,
    );
    idealLightHoursMax = _i1.ColumnDouble(
      'idealLightHoursMax',
      this,
    );
    idealPhMin = _i1.ColumnDouble(
      'idealPhMin',
      this,
    );
    idealPhMax = _i1.ColumnDouble(
      'idealPhMax',
      this,
    );
    idealCo2Min = _i1.ColumnDouble(
      'idealCo2Min',
      this,
    );
    idealCo2Max = _i1.ColumnDouble(
      'idealCo2Max',
      this,
    );
    waterRequirement = _i1.ColumnString(
      'waterRequirement',
      this,
    );
    growthDurationDays = _i1.ColumnInt(
      'growthDurationDays',
      this,
    );
    commonDiseases = _i1.ColumnSerializable<List<String>>(
      'commonDiseases',
      this,
    );
    commonPests = _i1.ColumnSerializable<List<String>>(
      'commonPests',
      this,
    );
    companionPlants = _i1.ColumnSerializable<List<String>>(
      'companionPlants',
      this,
    );
    incompatiblePlants = _i1.ColumnSerializable<List<String>>(
      'incompatiblePlants',
      this,
    );
    difficulty = _i1.ColumnString(
      'difficulty',
      this,
    );
    segments = _i1.ColumnSerializable<List<String>>(
      'segments',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
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

  late final CropModelUpdateTable updateTable;

  late final _i1.ColumnString species;

  late final _i1.ColumnString commonName;

  late final _i1.ColumnString scientificName;

  late final _i1.ColumnString family;

  late final _i1.ColumnString category;

  late final _i1.ColumnDouble idealTemperatureMin;

  late final _i1.ColumnDouble idealTemperatureMax;

  late final _i1.ColumnDouble idealHumidityMin;

  late final _i1.ColumnDouble idealHumidityMax;

  late final _i1.ColumnDouble idealLightHoursMin;

  late final _i1.ColumnDouble idealLightHoursMax;

  late final _i1.ColumnDouble idealPhMin;

  late final _i1.ColumnDouble idealPhMax;

  late final _i1.ColumnDouble idealCo2Min;

  late final _i1.ColumnDouble idealCo2Max;

  late final _i1.ColumnString waterRequirement;

  late final _i1.ColumnInt growthDurationDays;

  late final _i1.ColumnSerializable<List<String>> commonDiseases;

  late final _i1.ColumnSerializable<List<String>> commonPests;

  late final _i1.ColumnSerializable<List<String>> companionPlants;

  late final _i1.ColumnSerializable<List<String>> incompatiblePlants;

  late final _i1.ColumnString difficulty;

  late final _i1.ColumnSerializable<List<String>> segments;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    species,
    commonName,
    scientificName,
    family,
    category,
    idealTemperatureMin,
    idealTemperatureMax,
    idealHumidityMin,
    idealHumidityMax,
    idealLightHoursMin,
    idealLightHoursMax,
    idealPhMin,
    idealPhMax,
    idealCo2Min,
    idealCo2Max,
    waterRequirement,
    growthDurationDays,
    commonDiseases,
    commonPests,
    companionPlants,
    incompatiblePlants,
    difficulty,
    segments,
    isActive,
    createdAt,
    updatedAt,
  ];
}

class CropModelInclude extends _i1.IncludeObject {
  CropModelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CropModel.t;
}

class CropModelIncludeList extends _i1.IncludeList {
  CropModelIncludeList._({
    _i1.WhereExpressionBuilder<CropModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CropModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CropModel.t;
}

class CropModelRepository {
  const CropModelRepository._();

  /// Returns a list of [CropModel]s matching the given query parameters.
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
  Future<List<CropModel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CropModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CropModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CropModelTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CropModel>(
      where: where?.call(CropModel.t),
      orderBy: orderBy?.call(CropModel.t),
      orderByList: orderByList?.call(CropModel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CropModel] matching the given query parameters.
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
  Future<CropModel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CropModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<CropModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CropModelTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CropModel>(
      where: where?.call(CropModel.t),
      orderBy: orderBy?.call(CropModel.t),
      orderByList: orderByList?.call(CropModel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CropModel] by its [id] or null if no such row exists.
  Future<CropModel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CropModel>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CropModel]s in the list and returns the inserted rows.
  ///
  /// The returned [CropModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CropModel>> insert(
    _i1.Session session,
    List<CropModel> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CropModel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CropModel] and returns the inserted row.
  ///
  /// The returned [CropModel] will have its `id` field set.
  Future<CropModel> insertRow(
    _i1.Session session,
    CropModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CropModel>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CropModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CropModel>> update(
    _i1.Session session,
    List<CropModel> rows, {
    _i1.ColumnSelections<CropModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CropModel>(
      rows,
      columns: columns?.call(CropModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CropModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CropModel> updateRow(
    _i1.Session session,
    CropModel row, {
    _i1.ColumnSelections<CropModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CropModel>(
      row,
      columns: columns?.call(CropModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CropModel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CropModel?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CropModelUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CropModel>(
      id,
      columnValues: columnValues(CropModel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CropModel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CropModel>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CropModelUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CropModelTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CropModelTable>? orderBy,
    _i1.OrderByListBuilder<CropModelTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CropModel>(
      columnValues: columnValues(CropModel.t.updateTable),
      where: where(CropModel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CropModel.t),
      orderByList: orderByList?.call(CropModel.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CropModel]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CropModel>> delete(
    _i1.Session session,
    List<CropModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CropModel>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CropModel].
  Future<CropModel> deleteRow(
    _i1.Session session,
    CropModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CropModel>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CropModel>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CropModelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CropModel>(
      where: where(CropModel.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CropModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CropModel>(
      where: where?.call(CropModel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CropModel] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CropModelTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CropModel>(
      where: where(CropModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
