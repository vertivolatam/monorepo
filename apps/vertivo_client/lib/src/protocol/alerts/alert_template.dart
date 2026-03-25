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

abstract class AlertTemplate implements _i1.SerializableModel {
  AlertTemplate._({
    this.id,
    required this.name,
    required this.alertType,
    required this.severity,
    required this.titleTemplate,
    required this.messageTemplate,
    required this.segmentTarget,
    required this.channels,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AlertTemplate({
    int? id,
    required String name,
    required String alertType,
    required String severity,
    required String titleTemplate,
    required String messageTemplate,
    required String segmentTarget,
    required List<String> channels,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AlertTemplateImpl;

  factory AlertTemplate.fromJson(Map<String, dynamic> jsonSerialization) {
    return AlertTemplate(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      alertType: jsonSerialization['alertType'] as String,
      severity: jsonSerialization['severity'] as String,
      titleTemplate: jsonSerialization['titleTemplate'] as String,
      messageTemplate: jsonSerialization['messageTemplate'] as String,
      segmentTarget: jsonSerialization['segmentTarget'] as String,
      channels: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['channels'],
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

  String name;

  String alertType;

  String severity;

  String titleTemplate;

  String messageTemplate;

  String segmentTarget;

  List<String> channels;

  bool isActive;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [AlertTemplate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AlertTemplate copyWith({
    int? id,
    String? name,
    String? alertType,
    String? severity,
    String? titleTemplate,
    String? messageTemplate,
    String? segmentTarget,
    List<String>? channels,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AlertTemplate',
      if (id != null) 'id': id,
      'name': name,
      'alertType': alertType,
      'severity': severity,
      'titleTemplate': titleTemplate,
      'messageTemplate': messageTemplate,
      'segmentTarget': segmentTarget,
      'channels': channels.toJson(),
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

class _AlertTemplateImpl extends AlertTemplate {
  _AlertTemplateImpl({
    int? id,
    required String name,
    required String alertType,
    required String severity,
    required String titleTemplate,
    required String messageTemplate,
    required String segmentTarget,
    required List<String> channels,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         name: name,
         alertType: alertType,
         severity: severity,
         titleTemplate: titleTemplate,
         messageTemplate: messageTemplate,
         segmentTarget: segmentTarget,
         channels: channels,
         isActive: isActive,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AlertTemplate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AlertTemplate copyWith({
    Object? id = _Undefined,
    String? name,
    String? alertType,
    String? severity,
    String? titleTemplate,
    String? messageTemplate,
    String? segmentTarget,
    List<String>? channels,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AlertTemplate(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      alertType: alertType ?? this.alertType,
      severity: severity ?? this.severity,
      titleTemplate: titleTemplate ?? this.titleTemplate,
      messageTemplate: messageTemplate ?? this.messageTemplate,
      segmentTarget: segmentTarget ?? this.segmentTarget,
      channels: channels ?? this.channels.map((e0) => e0).toList(),
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
