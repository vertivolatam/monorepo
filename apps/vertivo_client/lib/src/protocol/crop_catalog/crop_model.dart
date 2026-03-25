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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:vertivo_client/src/protocol/protocol.dart' as _i2;

abstract class CropModel implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
