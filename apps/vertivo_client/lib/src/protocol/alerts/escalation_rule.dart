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

abstract class EscalationRule implements _i1.SerializableModel {
  EscalationRule._({
    this.id,
    required this.alertType,
    required this.severity,
    required this.escalationLevel,
    required this.delayMinutes,
    required this.notifyChannels,
    this.notifyRoles,
    this.autoResolveAfterMinutes,
    required this.isActive,
    required this.createdAt,
  });

  factory EscalationRule({
    int? id,
    required String alertType,
    required String severity,
    required int escalationLevel,
    required int delayMinutes,
    required List<String> notifyChannels,
    List<String>? notifyRoles,
    int? autoResolveAfterMinutes,
    required bool isActive,
    required DateTime createdAt,
  }) = _EscalationRuleImpl;

  factory EscalationRule.fromJson(Map<String, dynamic> jsonSerialization) {
    return EscalationRule(
      id: jsonSerialization['id'] as int?,
      alertType: jsonSerialization['alertType'] as String,
      severity: jsonSerialization['severity'] as String,
      escalationLevel: jsonSerialization['escalationLevel'] as int,
      delayMinutes: jsonSerialization['delayMinutes'] as int,
      notifyChannels: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['notifyChannels'],
      ),
      notifyRoles: jsonSerialization['notifyRoles'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['notifyRoles'],
            ),
      autoResolveAfterMinutes:
          jsonSerialization['autoResolveAfterMinutes'] as int?,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String alertType;

  String severity;

  int escalationLevel;

  int delayMinutes;

  List<String> notifyChannels;

  List<String>? notifyRoles;

  int? autoResolveAfterMinutes;

  bool isActive;

  DateTime createdAt;

  /// Returns a shallow copy of this [EscalationRule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EscalationRule copyWith({
    int? id,
    String? alertType,
    String? severity,
    int? escalationLevel,
    int? delayMinutes,
    List<String>? notifyChannels,
    List<String>? notifyRoles,
    int? autoResolveAfterMinutes,
    bool? isActive,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EscalationRule',
      if (id != null) 'id': id,
      'alertType': alertType,
      'severity': severity,
      'escalationLevel': escalationLevel,
      'delayMinutes': delayMinutes,
      'notifyChannels': notifyChannels.toJson(),
      if (notifyRoles != null) 'notifyRoles': notifyRoles?.toJson(),
      if (autoResolveAfterMinutes != null)
        'autoResolveAfterMinutes': autoResolveAfterMinutes,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EscalationRuleImpl extends EscalationRule {
  _EscalationRuleImpl({
    int? id,
    required String alertType,
    required String severity,
    required int escalationLevel,
    required int delayMinutes,
    required List<String> notifyChannels,
    List<String>? notifyRoles,
    int? autoResolveAfterMinutes,
    required bool isActive,
    required DateTime createdAt,
  }) : super._(
         id: id,
         alertType: alertType,
         severity: severity,
         escalationLevel: escalationLevel,
         delayMinutes: delayMinutes,
         notifyChannels: notifyChannels,
         notifyRoles: notifyRoles,
         autoResolveAfterMinutes: autoResolveAfterMinutes,
         isActive: isActive,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [EscalationRule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EscalationRule copyWith({
    Object? id = _Undefined,
    String? alertType,
    String? severity,
    int? escalationLevel,
    int? delayMinutes,
    List<String>? notifyChannels,
    Object? notifyRoles = _Undefined,
    Object? autoResolveAfterMinutes = _Undefined,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return EscalationRule(
      id: id is int? ? id : this.id,
      alertType: alertType ?? this.alertType,
      severity: severity ?? this.severity,
      escalationLevel: escalationLevel ?? this.escalationLevel,
      delayMinutes: delayMinutes ?? this.delayMinutes,
      notifyChannels:
          notifyChannels ?? this.notifyChannels.map((e0) => e0).toList(),
      notifyRoles: notifyRoles is List<String>?
          ? notifyRoles
          : this.notifyRoles?.map((e0) => e0).toList(),
      autoResolveAfterMinutes: autoResolveAfterMinutes is int?
          ? autoResolveAfterMinutes
          : this.autoResolveAfterMinutes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
