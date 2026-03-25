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
import 'alerts/alert.dart' as _i2;
import 'alerts/alert_template.dart' as _i3;
import 'alerts/escalation_rule.dart' as _i4;
import 'alerts/notification_delivery.dart' as _i5;
import 'anomaly_management/anomaly.dart' as _i6;
import 'auth/api_token.dart' as _i7;
import 'auth/security_event.dart' as _i8;
import 'auth/user_session.dart' as _i9;
import 'crop_catalog/crop_model.dart' as _i10;
import 'crop_catalog/growth_stage_definition.dart' as _i11;
import 'greenhouses/environmental_reading.dart' as _i12;
import 'greenhouses/greenhouse.dart' as _i13;
import 'greenhouses/irrigation_event.dart' as _i14;
import 'greenhouses/plant.dart' as _i15;
import 'greenhouses/tray.dart' as _i16;
import 'greetings/greeting.dart' as _i17;
import 'harvest_prediction/harvest_prediction.dart' as _i18;
import 'harvest_prediction/quality_prediction.dart' as _i19;
import 'management/kpi_metric.dart' as _i20;
import 'phytopathology/disease_detection.dart' as _i21;
import 'phytopathology/nutritional_deficiency.dart' as _i22;
import 'phytopathology/pest_identification.dart' as _i23;
import 'phytopathology/treatment_recommendation.dart' as _i24;
import 'traceability/compliance_report.dart' as _i25;
import 'traceability/compliance_template.dart' as _i26;
import 'traceability/traceability_record.dart' as _i27;
import 'users/subscription_plan.dart' as _i28;
import 'users/user.dart' as _i29;
import 'users/user_preferences.dart' as _i30;
import 'users/user_profile.dart' as _i31;
import 'package:vertivo_client/src/protocol/alerts/alert.dart' as _i32;
import 'package:vertivo_client/src/protocol/alerts/alert_template.dart' as _i33;
import 'package:vertivo_client/src/protocol/anomaly_management/anomaly.dart'
    as _i34;
import 'package:vertivo_client/src/protocol/auth/user_session.dart' as _i35;
import 'package:vertivo_client/src/protocol/auth/security_event.dart' as _i36;
import 'package:vertivo_client/src/protocol/crop_catalog/crop_model.dart'
    as _i37;
import 'package:vertivo_client/src/protocol/crop_catalog/growth_stage_definition.dart'
    as _i38;
import 'package:vertivo_client/src/protocol/greenhouses/greenhouse.dart'
    as _i39;
import 'package:vertivo_client/src/protocol/greenhouses/tray.dart' as _i40;
import 'package:vertivo_client/src/protocol/greenhouses/plant.dart' as _i41;
import 'package:vertivo_client/src/protocol/greenhouses/environmental_reading.dart'
    as _i42;
import 'package:vertivo_client/src/protocol/harvest_prediction/harvest_prediction.dart'
    as _i43;
import 'package:vertivo_client/src/protocol/management/kpi_metric.dart' as _i44;
import 'package:vertivo_client/src/protocol/phytopathology/disease_detection.dart'
    as _i45;
import 'package:vertivo_client/src/protocol/phytopathology/pest_identification.dart'
    as _i46;
import 'package:vertivo_client/src/protocol/phytopathology/treatment_recommendation.dart'
    as _i47;
import 'package:vertivo_client/src/protocol/traceability/traceability_record.dart'
    as _i48;
import 'package:vertivo_client/src/protocol/traceability/compliance_report.dart'
    as _i49;
import 'package:vertivo_client/src/protocol/traceability/compliance_template.dart'
    as _i50;
import 'package:vertivo_client/src/protocol/users/user.dart' as _i51;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i52;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i53;
export 'alerts/alert.dart';
export 'alerts/alert_template.dart';
export 'alerts/escalation_rule.dart';
export 'alerts/notification_delivery.dart';
export 'anomaly_management/anomaly.dart';
export 'auth/api_token.dart';
export 'auth/security_event.dart';
export 'auth/user_session.dart';
export 'crop_catalog/crop_model.dart';
export 'crop_catalog/growth_stage_definition.dart';
export 'greenhouses/environmental_reading.dart';
export 'greenhouses/greenhouse.dart';
export 'greenhouses/irrigation_event.dart';
export 'greenhouses/plant.dart';
export 'greenhouses/tray.dart';
export 'greetings/greeting.dart';
export 'harvest_prediction/harvest_prediction.dart';
export 'harvest_prediction/quality_prediction.dart';
export 'management/kpi_metric.dart';
export 'phytopathology/disease_detection.dart';
export 'phytopathology/nutritional_deficiency.dart';
export 'phytopathology/pest_identification.dart';
export 'phytopathology/treatment_recommendation.dart';
export 'traceability/compliance_report.dart';
export 'traceability/compliance_template.dart';
export 'traceability/traceability_record.dart';
export 'users/subscription_plan.dart';
export 'users/user.dart';
export 'users/user_preferences.dart';
export 'users/user_profile.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.Alert) {
      return _i2.Alert.fromJson(data) as T;
    }
    if (t == _i3.AlertTemplate) {
      return _i3.AlertTemplate.fromJson(data) as T;
    }
    if (t == _i4.EscalationRule) {
      return _i4.EscalationRule.fromJson(data) as T;
    }
    if (t == _i5.NotificationDelivery) {
      return _i5.NotificationDelivery.fromJson(data) as T;
    }
    if (t == _i6.Anomaly) {
      return _i6.Anomaly.fromJson(data) as T;
    }
    if (t == _i7.ApiToken) {
      return _i7.ApiToken.fromJson(data) as T;
    }
    if (t == _i8.SecurityEvent) {
      return _i8.SecurityEvent.fromJson(data) as T;
    }
    if (t == _i9.UserSession) {
      return _i9.UserSession.fromJson(data) as T;
    }
    if (t == _i10.CropModel) {
      return _i10.CropModel.fromJson(data) as T;
    }
    if (t == _i11.GrowthStageDefinition) {
      return _i11.GrowthStageDefinition.fromJson(data) as T;
    }
    if (t == _i12.EnvironmentalReading) {
      return _i12.EnvironmentalReading.fromJson(data) as T;
    }
    if (t == _i13.Greenhouse) {
      return _i13.Greenhouse.fromJson(data) as T;
    }
    if (t == _i14.IrrigationEvent) {
      return _i14.IrrigationEvent.fromJson(data) as T;
    }
    if (t == _i15.Plant) {
      return _i15.Plant.fromJson(data) as T;
    }
    if (t == _i16.Tray) {
      return _i16.Tray.fromJson(data) as T;
    }
    if (t == _i17.Greeting) {
      return _i17.Greeting.fromJson(data) as T;
    }
    if (t == _i18.HarvestPrediction) {
      return _i18.HarvestPrediction.fromJson(data) as T;
    }
    if (t == _i19.QualityPrediction) {
      return _i19.QualityPrediction.fromJson(data) as T;
    }
    if (t == _i20.KpiMetric) {
      return _i20.KpiMetric.fromJson(data) as T;
    }
    if (t == _i21.DiseaseDetection) {
      return _i21.DiseaseDetection.fromJson(data) as T;
    }
    if (t == _i22.NutritionalDeficiency) {
      return _i22.NutritionalDeficiency.fromJson(data) as T;
    }
    if (t == _i23.PestIdentification) {
      return _i23.PestIdentification.fromJson(data) as T;
    }
    if (t == _i24.TreatmentRecommendation) {
      return _i24.TreatmentRecommendation.fromJson(data) as T;
    }
    if (t == _i25.ComplianceReport) {
      return _i25.ComplianceReport.fromJson(data) as T;
    }
    if (t == _i26.ComplianceTemplate) {
      return _i26.ComplianceTemplate.fromJson(data) as T;
    }
    if (t == _i27.TraceabilityRecord) {
      return _i27.TraceabilityRecord.fromJson(data) as T;
    }
    if (t == _i28.SubscriptionPlan) {
      return _i28.SubscriptionPlan.fromJson(data) as T;
    }
    if (t == _i29.User) {
      return _i29.User.fromJson(data) as T;
    }
    if (t == _i30.UserPreferences) {
      return _i30.UserPreferences.fromJson(data) as T;
    }
    if (t == _i31.UserProfile) {
      return _i31.UserProfile.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Alert?>()) {
      return (data != null ? _i2.Alert.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AlertTemplate?>()) {
      return (data != null ? _i3.AlertTemplate.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.EscalationRule?>()) {
      return (data != null ? _i4.EscalationRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.NotificationDelivery?>()) {
      return (data != null ? _i5.NotificationDelivery.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.Anomaly?>()) {
      return (data != null ? _i6.Anomaly.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ApiToken?>()) {
      return (data != null ? _i7.ApiToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.SecurityEvent?>()) {
      return (data != null ? _i8.SecurityEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.UserSession?>()) {
      return (data != null ? _i9.UserSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.CropModel?>()) {
      return (data != null ? _i10.CropModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.GrowthStageDefinition?>()) {
      return (data != null ? _i11.GrowthStageDefinition.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.EnvironmentalReading?>()) {
      return (data != null ? _i12.EnvironmentalReading.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.Greenhouse?>()) {
      return (data != null ? _i13.Greenhouse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.IrrigationEvent?>()) {
      return (data != null ? _i14.IrrigationEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Plant?>()) {
      return (data != null ? _i15.Plant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.Tray?>()) {
      return (data != null ? _i16.Tray.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.Greeting?>()) {
      return (data != null ? _i17.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.HarvestPrediction?>()) {
      return (data != null ? _i18.HarvestPrediction.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.QualityPrediction?>()) {
      return (data != null ? _i19.QualityPrediction.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.KpiMetric?>()) {
      return (data != null ? _i20.KpiMetric.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.DiseaseDetection?>()) {
      return (data != null ? _i21.DiseaseDetection.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.NutritionalDeficiency?>()) {
      return (data != null ? _i22.NutritionalDeficiency.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.PestIdentification?>()) {
      return (data != null ? _i23.PestIdentification.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.TreatmentRecommendation?>()) {
      return (data != null ? _i24.TreatmentRecommendation.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i25.ComplianceReport?>()) {
      return (data != null ? _i25.ComplianceReport.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.ComplianceTemplate?>()) {
      return (data != null ? _i26.ComplianceTemplate.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i27.TraceabilityRecord?>()) {
      return (data != null ? _i27.TraceabilityRecord.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i28.SubscriptionPlan?>()) {
      return (data != null ? _i28.SubscriptionPlan.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.User?>()) {
      return (data != null ? _i29.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.UserPreferences?>()) {
      return (data != null ? _i30.UserPreferences.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.UserProfile?>()) {
      return (data != null ? _i31.UserProfile.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i32.Alert>) {
      return (data as List).map((e) => deserialize<_i32.Alert>(e)).toList()
          as T;
    }
    if (t == List<_i33.AlertTemplate>) {
      return (data as List)
              .map((e) => deserialize<_i33.AlertTemplate>(e))
              .toList()
          as T;
    }
    if (t == List<_i34.Anomaly>) {
      return (data as List).map((e) => deserialize<_i34.Anomaly>(e)).toList()
          as T;
    }
    if (t == List<_i35.UserSession>) {
      return (data as List)
              .map((e) => deserialize<_i35.UserSession>(e))
              .toList()
          as T;
    }
    if (t == List<_i36.SecurityEvent>) {
      return (data as List)
              .map((e) => deserialize<_i36.SecurityEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_i37.CropModel>) {
      return (data as List).map((e) => deserialize<_i37.CropModel>(e)).toList()
          as T;
    }
    if (t == List<_i38.GrowthStageDefinition>) {
      return (data as List)
              .map((e) => deserialize<_i38.GrowthStageDefinition>(e))
              .toList()
          as T;
    }
    if (t == List<_i39.Greenhouse>) {
      return (data as List).map((e) => deserialize<_i39.Greenhouse>(e)).toList()
          as T;
    }
    if (t == List<_i40.Tray>) {
      return (data as List).map((e) => deserialize<_i40.Tray>(e)).toList() as T;
    }
    if (t == List<_i41.Plant>) {
      return (data as List).map((e) => deserialize<_i41.Plant>(e)).toList()
          as T;
    }
    if (t == List<_i42.EnvironmentalReading>) {
      return (data as List)
              .map((e) => deserialize<_i42.EnvironmentalReading>(e))
              .toList()
          as T;
    }
    if (t == List<_i43.HarvestPrediction>) {
      return (data as List)
              .map((e) => deserialize<_i43.HarvestPrediction>(e))
              .toList()
          as T;
    }
    if (t == List<_i44.KpiMetric>) {
      return (data as List).map((e) => deserialize<_i44.KpiMetric>(e)).toList()
          as T;
    }
    if (t == List<_i45.DiseaseDetection>) {
      return (data as List)
              .map((e) => deserialize<_i45.DiseaseDetection>(e))
              .toList()
          as T;
    }
    if (t == List<_i46.PestIdentification>) {
      return (data as List)
              .map((e) => deserialize<_i46.PestIdentification>(e))
              .toList()
          as T;
    }
    if (t == List<_i47.TreatmentRecommendation>) {
      return (data as List)
              .map((e) => deserialize<_i47.TreatmentRecommendation>(e))
              .toList()
          as T;
    }
    if (t == List<_i48.TraceabilityRecord>) {
      return (data as List)
              .map((e) => deserialize<_i48.TraceabilityRecord>(e))
              .toList()
          as T;
    }
    if (t == List<_i49.ComplianceReport>) {
      return (data as List)
              .map((e) => deserialize<_i49.ComplianceReport>(e))
              .toList()
          as T;
    }
    if (t == List<_i50.ComplianceTemplate>) {
      return (data as List)
              .map((e) => deserialize<_i50.ComplianceTemplate>(e))
              .toList()
          as T;
    }
    if (t == List<_i51.User>) {
      return (data as List).map((e) => deserialize<_i51.User>(e)).toList() as T;
    }
    try {
      return _i52.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i53.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Alert => 'Alert',
      _i3.AlertTemplate => 'AlertTemplate',
      _i4.EscalationRule => 'EscalationRule',
      _i5.NotificationDelivery => 'NotificationDelivery',
      _i6.Anomaly => 'Anomaly',
      _i7.ApiToken => 'ApiToken',
      _i8.SecurityEvent => 'SecurityEvent',
      _i9.UserSession => 'UserSession',
      _i10.CropModel => 'CropModel',
      _i11.GrowthStageDefinition => 'GrowthStageDefinition',
      _i12.EnvironmentalReading => 'EnvironmentalReading',
      _i13.Greenhouse => 'Greenhouse',
      _i14.IrrigationEvent => 'IrrigationEvent',
      _i15.Plant => 'Plant',
      _i16.Tray => 'Tray',
      _i17.Greeting => 'Greeting',
      _i18.HarvestPrediction => 'HarvestPrediction',
      _i19.QualityPrediction => 'QualityPrediction',
      _i20.KpiMetric => 'KpiMetric',
      _i21.DiseaseDetection => 'DiseaseDetection',
      _i22.NutritionalDeficiency => 'NutritionalDeficiency',
      _i23.PestIdentification => 'PestIdentification',
      _i24.TreatmentRecommendation => 'TreatmentRecommendation',
      _i25.ComplianceReport => 'ComplianceReport',
      _i26.ComplianceTemplate => 'ComplianceTemplate',
      _i27.TraceabilityRecord => 'TraceabilityRecord',
      _i28.SubscriptionPlan => 'SubscriptionPlan',
      _i29.User => 'User',
      _i30.UserPreferences => 'UserPreferences',
      _i31.UserProfile => 'UserProfile',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('vertivo.', '');
    }

    switch (data) {
      case _i2.Alert():
        return 'Alert';
      case _i3.AlertTemplate():
        return 'AlertTemplate';
      case _i4.EscalationRule():
        return 'EscalationRule';
      case _i5.NotificationDelivery():
        return 'NotificationDelivery';
      case _i6.Anomaly():
        return 'Anomaly';
      case _i7.ApiToken():
        return 'ApiToken';
      case _i8.SecurityEvent():
        return 'SecurityEvent';
      case _i9.UserSession():
        return 'UserSession';
      case _i10.CropModel():
        return 'CropModel';
      case _i11.GrowthStageDefinition():
        return 'GrowthStageDefinition';
      case _i12.EnvironmentalReading():
        return 'EnvironmentalReading';
      case _i13.Greenhouse():
        return 'Greenhouse';
      case _i14.IrrigationEvent():
        return 'IrrigationEvent';
      case _i15.Plant():
        return 'Plant';
      case _i16.Tray():
        return 'Tray';
      case _i17.Greeting():
        return 'Greeting';
      case _i18.HarvestPrediction():
        return 'HarvestPrediction';
      case _i19.QualityPrediction():
        return 'QualityPrediction';
      case _i20.KpiMetric():
        return 'KpiMetric';
      case _i21.DiseaseDetection():
        return 'DiseaseDetection';
      case _i22.NutritionalDeficiency():
        return 'NutritionalDeficiency';
      case _i23.PestIdentification():
        return 'PestIdentification';
      case _i24.TreatmentRecommendation():
        return 'TreatmentRecommendation';
      case _i25.ComplianceReport():
        return 'ComplianceReport';
      case _i26.ComplianceTemplate():
        return 'ComplianceTemplate';
      case _i27.TraceabilityRecord():
        return 'TraceabilityRecord';
      case _i28.SubscriptionPlan():
        return 'SubscriptionPlan';
      case _i29.User():
        return 'User';
      case _i30.UserPreferences():
        return 'UserPreferences';
      case _i31.UserProfile():
        return 'UserProfile';
    }
    className = _i52.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i53.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Alert') {
      return deserialize<_i2.Alert>(data['data']);
    }
    if (dataClassName == 'AlertTemplate') {
      return deserialize<_i3.AlertTemplate>(data['data']);
    }
    if (dataClassName == 'EscalationRule') {
      return deserialize<_i4.EscalationRule>(data['data']);
    }
    if (dataClassName == 'NotificationDelivery') {
      return deserialize<_i5.NotificationDelivery>(data['data']);
    }
    if (dataClassName == 'Anomaly') {
      return deserialize<_i6.Anomaly>(data['data']);
    }
    if (dataClassName == 'ApiToken') {
      return deserialize<_i7.ApiToken>(data['data']);
    }
    if (dataClassName == 'SecurityEvent') {
      return deserialize<_i8.SecurityEvent>(data['data']);
    }
    if (dataClassName == 'UserSession') {
      return deserialize<_i9.UserSession>(data['data']);
    }
    if (dataClassName == 'CropModel') {
      return deserialize<_i10.CropModel>(data['data']);
    }
    if (dataClassName == 'GrowthStageDefinition') {
      return deserialize<_i11.GrowthStageDefinition>(data['data']);
    }
    if (dataClassName == 'EnvironmentalReading') {
      return deserialize<_i12.EnvironmentalReading>(data['data']);
    }
    if (dataClassName == 'Greenhouse') {
      return deserialize<_i13.Greenhouse>(data['data']);
    }
    if (dataClassName == 'IrrigationEvent') {
      return deserialize<_i14.IrrigationEvent>(data['data']);
    }
    if (dataClassName == 'Plant') {
      return deserialize<_i15.Plant>(data['data']);
    }
    if (dataClassName == 'Tray') {
      return deserialize<_i16.Tray>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i17.Greeting>(data['data']);
    }
    if (dataClassName == 'HarvestPrediction') {
      return deserialize<_i18.HarvestPrediction>(data['data']);
    }
    if (dataClassName == 'QualityPrediction') {
      return deserialize<_i19.QualityPrediction>(data['data']);
    }
    if (dataClassName == 'KpiMetric') {
      return deserialize<_i20.KpiMetric>(data['data']);
    }
    if (dataClassName == 'DiseaseDetection') {
      return deserialize<_i21.DiseaseDetection>(data['data']);
    }
    if (dataClassName == 'NutritionalDeficiency') {
      return deserialize<_i22.NutritionalDeficiency>(data['data']);
    }
    if (dataClassName == 'PestIdentification') {
      return deserialize<_i23.PestIdentification>(data['data']);
    }
    if (dataClassName == 'TreatmentRecommendation') {
      return deserialize<_i24.TreatmentRecommendation>(data['data']);
    }
    if (dataClassName == 'ComplianceReport') {
      return deserialize<_i25.ComplianceReport>(data['data']);
    }
    if (dataClassName == 'ComplianceTemplate') {
      return deserialize<_i26.ComplianceTemplate>(data['data']);
    }
    if (dataClassName == 'TraceabilityRecord') {
      return deserialize<_i27.TraceabilityRecord>(data['data']);
    }
    if (dataClassName == 'SubscriptionPlan') {
      return deserialize<_i28.SubscriptionPlan>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i29.User>(data['data']);
    }
    if (dataClassName == 'UserPreferences') {
      return deserialize<_i30.UserPreferences>(data['data']);
    }
    if (dataClassName == 'UserProfile') {
      return deserialize<_i31.UserProfile>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i52.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i53.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i52.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i53.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
