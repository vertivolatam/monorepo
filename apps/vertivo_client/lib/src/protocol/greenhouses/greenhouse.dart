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

abstract class Greenhouse implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
