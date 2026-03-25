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

abstract class SubscriptionPlan implements _i1.SerializableModel {
  SubscriptionPlan._({
    this.id,
    required this.userId,
    required this.planType,
    required this.segment,
    required this.isActive,
    required this.features,
    required this.maxGreenhouses,
    required this.monthlyPriceUsd,
    required this.startDate,
    this.endDate,
    required this.createdAt,
  });

  factory SubscriptionPlan({
    int? id,
    required String userId,
    required String planType,
    required String segment,
    required bool isActive,
    required List<String> features,
    required int maxGreenhouses,
    required double monthlyPriceUsd,
    required DateTime startDate,
    DateTime? endDate,
    required DateTime createdAt,
  }) = _SubscriptionPlanImpl;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> jsonSerialization) {
    return SubscriptionPlan(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      planType: jsonSerialization['planType'] as String,
      segment: jsonSerialization['segment'] as String,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      features: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['features'],
      ),
      maxGreenhouses: jsonSerialization['maxGreenhouses'] as int,
      monthlyPriceUsd: (jsonSerialization['monthlyPriceUsd'] as num).toDouble(),
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userId;

  String planType;

  String segment;

  bool isActive;

  List<String> features;

  int maxGreenhouses;

  double monthlyPriceUsd;

  DateTime startDate;

  DateTime? endDate;

  DateTime createdAt;

  /// Returns a shallow copy of this [SubscriptionPlan]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SubscriptionPlan copyWith({
    int? id,
    String? userId,
    String? planType,
    String? segment,
    bool? isActive,
    List<String>? features,
    int? maxGreenhouses,
    double? monthlyPriceUsd,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SubscriptionPlan',
      if (id != null) 'id': id,
      'userId': userId,
      'planType': planType,
      'segment': segment,
      'isActive': isActive,
      'features': features.toJson(),
      'maxGreenhouses': maxGreenhouses,
      'monthlyPriceUsd': monthlyPriceUsd,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SubscriptionPlanImpl extends SubscriptionPlan {
  _SubscriptionPlanImpl({
    int? id,
    required String userId,
    required String planType,
    required String segment,
    required bool isActive,
    required List<String> features,
    required int maxGreenhouses,
    required double monthlyPriceUsd,
    required DateTime startDate,
    DateTime? endDate,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         planType: planType,
         segment: segment,
         isActive: isActive,
         features: features,
         maxGreenhouses: maxGreenhouses,
         monthlyPriceUsd: monthlyPriceUsd,
         startDate: startDate,
         endDate: endDate,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SubscriptionPlan]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SubscriptionPlan copyWith({
    Object? id = _Undefined,
    String? userId,
    String? planType,
    String? segment,
    bool? isActive,
    List<String>? features,
    int? maxGreenhouses,
    double? monthlyPriceUsd,
    DateTime? startDate,
    Object? endDate = _Undefined,
    DateTime? createdAt,
  }) {
    return SubscriptionPlan(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      planType: planType ?? this.planType,
      segment: segment ?? this.segment,
      isActive: isActive ?? this.isActive,
      features: features ?? this.features.map((e0) => e0).toList(),
      maxGreenhouses: maxGreenhouses ?? this.maxGreenhouses,
      monthlyPriceUsd: monthlyPriceUsd ?? this.monthlyPriceUsd,
      startDate: startDate ?? this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
