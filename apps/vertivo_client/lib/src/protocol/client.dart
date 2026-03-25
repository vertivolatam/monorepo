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
import 'dart:async' as _i2;
import 'package:vertivo_client/src/protocol/alerts/alert.dart' as _i3;
import 'package:vertivo_client/src/protocol/alerts/alert_template.dart' as _i4;
import 'package:vertivo_client/src/protocol/anomaly_management/anomaly.dart'
    as _i5;
import 'package:vertivo_client/src/protocol/auth/user_session.dart' as _i6;
import 'package:vertivo_client/src/protocol/auth/security_event.dart' as _i7;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i8;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i9;
import 'package:vertivo_client/src/protocol/crop_catalog/crop_model.dart'
    as _i10;
import 'package:vertivo_client/src/protocol/crop_catalog/growth_stage_definition.dart'
    as _i11;
import 'package:vertivo_client/src/protocol/greenhouses/greenhouse.dart'
    as _i12;
import 'package:vertivo_client/src/protocol/greenhouses/tray.dart' as _i13;
import 'package:vertivo_client/src/protocol/greenhouses/plant.dart' as _i14;
import 'package:vertivo_client/src/protocol/greenhouses/environmental_reading.dart'
    as _i15;
import 'package:vertivo_client/src/protocol/greenhouses/irrigation_event.dart'
    as _i16;
import 'package:vertivo_client/src/protocol/greetings/greeting.dart' as _i17;
import 'package:vertivo_client/src/protocol/harvest_prediction/harvest_prediction.dart'
    as _i18;
import 'package:vertivo_client/src/protocol/harvest_prediction/quality_prediction.dart'
    as _i19;
import 'package:vertivo_client/src/protocol/management/kpi_metric.dart' as _i20;
import 'package:vertivo_client/src/protocol/phytopathology/disease_detection.dart'
    as _i21;
import 'package:vertivo_client/src/protocol/phytopathology/pest_identification.dart'
    as _i22;
import 'package:vertivo_client/src/protocol/phytopathology/nutritional_deficiency.dart'
    as _i23;
import 'package:vertivo_client/src/protocol/phytopathology/treatment_recommendation.dart'
    as _i24;
import 'package:vertivo_client/src/protocol/traceability/traceability_record.dart'
    as _i25;
import 'package:vertivo_client/src/protocol/traceability/compliance_report.dart'
    as _i26;
import 'package:vertivo_client/src/protocol/traceability/compliance_template.dart'
    as _i27;
import 'package:vertivo_client/src/protocol/users/user.dart' as _i28;
import 'package:vertivo_client/src/protocol/users/user_preferences.dart'
    as _i29;
import 'package:vertivo_client/src/protocol/users/subscription_plan.dart'
    as _i30;
import 'protocol.dart' as _i31;

/// {@category Endpoint}
class EndpointAlert extends _i1.EndpointRef {
  EndpointAlert(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'alert';

  /// Create an alert
  _i2.Future<_i3.Alert> create(_i3.Alert alert) =>
      caller.callServerEndpoint<_i3.Alert>(
        'alert',
        'create',
        {'alert': alert},
      );

  /// Get alerts for the authenticated user
  _i2.Future<List<_i3.Alert>> getMyAlerts({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i3.Alert>>(
    'alert',
    'getMyAlerts',
    {
      'limit': limit,
      'offset': offset,
    },
  );

  /// Get unread alert count
  _i2.Future<int> getUnreadCount() => caller.callServerEndpoint<int>(
    'alert',
    'getUnreadCount',
    {},
  );

  /// Mark alert as read
  _i2.Future<bool> markAsRead(int alertId) => caller.callServerEndpoint<bool>(
    'alert',
    'markAsRead',
    {'alertId': alertId},
  );

  /// Acknowledge an alert
  _i2.Future<bool> acknowledge(int alertId) => caller.callServerEndpoint<bool>(
    'alert',
    'acknowledge',
    {'alertId': alertId},
  );

  /// Resolve an alert
  _i2.Future<bool> resolve(int alertId) => caller.callServerEndpoint<bool>(
    'alert',
    'resolve',
    {'alertId': alertId},
  );

  /// Get alerts for a greenhouse
  _i2.Future<List<_i3.Alert>> getForGreenhouse(
    int greenhouseId, {
    required int limit,
  }) => caller.callServerEndpoint<List<_i3.Alert>>(
    'alert',
    'getForGreenhouse',
    {
      'greenhouseId': greenhouseId,
      'limit': limit,
    },
  );

  /// Get active alert templates
  _i2.Future<List<_i4.AlertTemplate>> getTemplates() =>
      caller.callServerEndpoint<List<_i4.AlertTemplate>>(
        'alert',
        'getTemplates',
        {},
      );
}

/// {@category Endpoint}
class EndpointAnomaly extends _i1.EndpointRef {
  EndpointAnomaly(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'anomaly';

  /// Record a new anomaly
  _i2.Future<_i5.Anomaly> record(_i5.Anomaly anomaly) =>
      caller.callServerEndpoint<_i5.Anomaly>(
        'anomaly',
        'record',
        {'anomaly': anomaly},
      );

  /// Get anomalies for a greenhouse
  _i2.Future<List<_i5.Anomaly>> getForGreenhouse(
    int greenhouseId, {
    required int limit,
  }) => caller.callServerEndpoint<List<_i5.Anomaly>>(
    'anomaly',
    'getForGreenhouse',
    {
      'greenhouseId': greenhouseId,
      'limit': limit,
    },
  );

  /// Get unresolved anomalies for a greenhouse
  _i2.Future<List<_i5.Anomaly>> getUnresolved(int greenhouseId) =>
      caller.callServerEndpoint<List<_i5.Anomaly>>(
        'anomaly',
        'getUnresolved',
        {'greenhouseId': greenhouseId},
      );

  /// Classify an anomaly (update type and severity)
  _i2.Future<_i5.Anomaly?> classify(
    int anomalyId,
    String anomalyType,
    String severity,
  ) => caller.callServerEndpoint<_i5.Anomaly?>(
    'anomaly',
    'classify',
    {
      'anomalyId': anomalyId,
      'anomalyType': anomalyType,
      'severity': severity,
    },
  );

  /// Resolve an anomaly
  _i2.Future<_i5.Anomaly?> resolve(
    int anomalyId,
    String resolutionNotes,
  ) => caller.callServerEndpoint<_i5.Anomaly?>(
    'anomaly',
    'resolve',
    {
      'anomalyId': anomalyId,
      'resolutionNotes': resolutionNotes,
    },
  );
}

/// {@category Endpoint}
class EndpointAuth extends _i1.EndpointRef {
  EndpointAuth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  /// Create a new user session after login
  _i2.Future<_i6.UserSession> createSession(
    String userId,
    String deviceId,
    String? deviceName,
    String? deviceType,
  ) => caller.callServerEndpoint<_i6.UserSession>(
    'auth',
    'createSession',
    {
      'userId': userId,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceType': deviceType,
    },
  );

  /// Revoke a session (logout)
  _i2.Future<bool> revokeSession(int sessionId) =>
      caller.callServerEndpoint<bool>(
        'auth',
        'revokeSession',
        {'sessionId': sessionId},
      );

  /// Get active sessions for current user
  _i2.Future<List<_i6.UserSession>> getActiveSessions() =>
      caller.callServerEndpoint<List<_i6.UserSession>>(
        'auth',
        'getActiveSessions',
        {},
      );

  /// Log a security event
  _i2.Future<_i7.SecurityEvent> logSecurityEvent(
    String? userId,
    String eventType,
    String severity,
    String? details,
  ) => caller.callServerEndpoint<_i7.SecurityEvent>(
    'auth',
    'logSecurityEvent',
    {
      'userId': userId,
      'eventType': eventType,
      'severity': severity,
      'details': details,
    },
  );

  /// Get security events for a user
  _i2.Future<List<_i7.SecurityEvent>> getSecurityEvents(
    String userId, {
    required int limit,
  }) => caller.callServerEndpoint<List<_i7.SecurityEvent>>(
    'auth',
    'getSecurityEvents',
    {
      'userId': userId,
      'limit': limit,
    },
  );
}

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i8.EndpointEmailIdpBase {
  EndpointEmailIdp(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<_i9.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i9.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i2.Future<_i1.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i2.Future<String> verifyRegistrationCode({
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i2.Future<_i9.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i9.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i2.Future<_i1.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i2.Future<String> verifyPasswordResetCode({
    required _i1.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _i2.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i9.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i2.Future<_i9.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i9.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// {@category Endpoint}
class EndpointCropCatalog extends _i1.EndpointRef {
  EndpointCropCatalog(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'cropCatalog';

  /// List all active crops in the catalog
  _i2.Future<List<_i10.CropModel>> list({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i10.CropModel>>(
    'cropCatalog',
    'list',
    {
      'limit': limit,
      'offset': offset,
    },
  );

  /// Get a crop by id
  _i2.Future<_i10.CropModel?> get(int id) =>
      caller.callServerEndpoint<_i10.CropModel?>(
        'cropCatalog',
        'get',
        {'id': id},
      );

  /// Search crops by species or common name
  _i2.Future<List<_i10.CropModel>> search(String query) =>
      caller.callServerEndpoint<List<_i10.CropModel>>(
        'cropCatalog',
        'search',
        {'query': query},
      );

  /// Create a crop in the catalog
  _i2.Future<_i10.CropModel> create(_i10.CropModel crop) =>
      caller.callServerEndpoint<_i10.CropModel>(
        'cropCatalog',
        'create',
        {'crop': crop},
      );

  /// Update a crop model
  _i2.Future<_i10.CropModel> update(_i10.CropModel crop) =>
      caller.callServerEndpoint<_i10.CropModel>(
        'cropCatalog',
        'update',
        {'crop': crop},
      );

  /// Get growth stage definitions for a crop
  _i2.Future<List<_i11.GrowthStageDefinition>> getGrowthStages(
    int cropModelId,
  ) => caller.callServerEndpoint<List<_i11.GrowthStageDefinition>>(
    'cropCatalog',
    'getGrowthStages',
    {'cropModelId': cropModelId},
  );

  /// Create a growth stage definition
  _i2.Future<_i11.GrowthStageDefinition> createGrowthStage(
    _i11.GrowthStageDefinition stage,
  ) => caller.callServerEndpoint<_i11.GrowthStageDefinition>(
    'cropCatalog',
    'createGrowthStage',
    {'stage': stage},
  );
}

/// {@category Endpoint}
class EndpointGreenhouse extends _i1.EndpointRef {
  EndpointGreenhouse(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greenhouse';

  /// Create a new greenhouse
  _i2.Future<_i12.Greenhouse> create(_i12.Greenhouse greenhouse) =>
      caller.callServerEndpoint<_i12.Greenhouse>(
        'greenhouse',
        'create',
        {'greenhouse': greenhouse},
      );

  /// Get greenhouse by id
  _i2.Future<_i12.Greenhouse?> get(int id) =>
      caller.callServerEndpoint<_i12.Greenhouse?>(
        'greenhouse',
        'get',
        {'id': id},
      );

  /// List greenhouses for the authenticated user
  _i2.Future<List<_i12.Greenhouse>> listByUser() =>
      caller.callServerEndpoint<List<_i12.Greenhouse>>(
        'greenhouse',
        'listByUser',
        {},
      );

  /// Update greenhouse settings
  _i2.Future<_i12.Greenhouse> update(_i12.Greenhouse greenhouse) =>
      caller.callServerEndpoint<_i12.Greenhouse>(
        'greenhouse',
        'update',
        {'greenhouse': greenhouse},
      );

  /// Delete greenhouse (soft delete)
  _i2.Future<bool> delete(int id) => caller.callServerEndpoint<bool>(
    'greenhouse',
    'delete',
    {'id': id},
  );

  /// Get trays for a greenhouse
  _i2.Future<List<_i13.Tray>> getTrays(int greenhouseId) =>
      caller.callServerEndpoint<List<_i13.Tray>>(
        'greenhouse',
        'getTrays',
        {'greenhouseId': greenhouseId},
      );

  /// Get plants for a tray
  _i2.Future<List<_i14.Plant>> getPlants(int trayId) =>
      caller.callServerEndpoint<List<_i14.Plant>>(
        'greenhouse',
        'getPlants',
        {'trayId': trayId},
      );

  /// Create a tray in a greenhouse
  _i2.Future<_i13.Tray> createTray(_i13.Tray tray) =>
      caller.callServerEndpoint<_i13.Tray>(
        'greenhouse',
        'createTray',
        {'tray': tray},
      );

  /// Plant a new plant in a tray
  _i2.Future<_i14.Plant> createPlant(_i14.Plant plant) =>
      caller.callServerEndpoint<_i14.Plant>(
        'greenhouse',
        'createPlant',
        {'plant': plant},
      );

  /// Record an environmental reading
  _i2.Future<_i15.EnvironmentalReading> recordReading(
    _i15.EnvironmentalReading reading,
  ) => caller.callServerEndpoint<_i15.EnvironmentalReading>(
    'greenhouse',
    'recordReading',
    {'reading': reading},
  );

  /// Get environmental readings for a greenhouse
  _i2.Future<List<_i15.EnvironmentalReading>> getReadings(
    int greenhouseId,
    String measurementType, {
    required int limit,
  }) => caller.callServerEndpoint<List<_i15.EnvironmentalReading>>(
    'greenhouse',
    'getReadings',
    {
      'greenhouseId': greenhouseId,
      'measurementType': measurementType,
      'limit': limit,
    },
  );

  /// Quarantine a plant
  _i2.Future<_i14.Plant?> quarantinePlant(
    int plantId,
    String reason,
  ) => caller.callServerEndpoint<_i14.Plant?>(
    'greenhouse',
    'quarantinePlant',
    {
      'plantId': plantId,
      'reason': reason,
    },
  );

  /// Record an irrigation event
  _i2.Future<_i16.IrrigationEvent> recordIrrigation(
    _i16.IrrigationEvent event,
  ) => caller.callServerEndpoint<_i16.IrrigationEvent>(
    'greenhouse',
    'recordIrrigation',
    {'event': event},
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i17.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i17.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

/// {@category Endpoint}
class EndpointHarvestPrediction extends _i1.EndpointRef {
  EndpointHarvestPrediction(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'harvestPrediction';

  /// Get harvest predictions for a greenhouse
  _i2.Future<List<_i18.HarvestPrediction>> getForGreenhouse(
    int greenhouseId, {
    required int limit,
  }) => caller.callServerEndpoint<List<_i18.HarvestPrediction>>(
    'harvestPrediction',
    'getForGreenhouse',
    {
      'greenhouseId': greenhouseId,
      'limit': limit,
    },
  );

  /// Get harvest predictions for a specific plant
  _i2.Future<List<_i18.HarvestPrediction>> getForPlant(int plantId) =>
      caller.callServerEndpoint<List<_i18.HarvestPrediction>>(
        'harvestPrediction',
        'getForPlant',
        {'plantId': plantId},
      );

  /// Create a harvest prediction
  _i2.Future<_i18.HarvestPrediction> create(
    _i18.HarvestPrediction prediction,
  ) => caller.callServerEndpoint<_i18.HarvestPrediction>(
    'harvestPrediction',
    'create',
    {'prediction': prediction},
  );

  /// Record actual harvest results against a prediction
  _i2.Future<_i18.HarvestPrediction?> recordActual(
    int predictionId,
    double actualYieldKg,
    String actualQualityGrade,
  ) => caller.callServerEndpoint<_i18.HarvestPrediction?>(
    'harvestPrediction',
    'recordActual',
    {
      'predictionId': predictionId,
      'actualYieldKg': actualYieldKg,
      'actualQualityGrade': actualQualityGrade,
    },
  );

  /// Get quality prediction for a harvest prediction
  _i2.Future<_i19.QualityPrediction?> getQuality(int harvestPredictionId) =>
      caller.callServerEndpoint<_i19.QualityPrediction?>(
        'harvestPrediction',
        'getQuality',
        {'harvestPredictionId': harvestPredictionId},
      );

  /// Create a quality prediction
  _i2.Future<_i19.QualityPrediction> createQuality(
    _i19.QualityPrediction quality,
  ) => caller.callServerEndpoint<_i19.QualityPrediction>(
    'harvestPrediction',
    'createQuality',
    {'quality': quality},
  );
}

/// {@category Endpoint}
class EndpointManagement extends _i1.EndpointRef {
  EndpointManagement(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'management';

  /// Get KPI metrics for a greenhouse
  _i2.Future<List<_i20.KpiMetric>> getMetrics(
    int greenhouseId, {
    String? metricType,
    required String periodType,
    required int limit,
  }) => caller.callServerEndpoint<List<_i20.KpiMetric>>(
    'management',
    'getMetrics',
    {
      'greenhouseId': greenhouseId,
      'metricType': metricType,
      'periodType': periodType,
      'limit': limit,
    },
  );

  /// Record a KPI metric
  _i2.Future<_i20.KpiMetric> record(_i20.KpiMetric metric) =>
      caller.callServerEndpoint<_i20.KpiMetric>(
        'management',
        'record',
        {'metric': metric},
      );

  /// Get dashboard summary: latest metric of each type for a user
  _i2.Future<List<_i20.KpiMetric>> getDashboardSummary() =>
      caller.callServerEndpoint<List<_i20.KpiMetric>>(
        'management',
        'getDashboardSummary',
        {},
      );

  /// Get metrics for a user across all greenhouses
  _i2.Future<List<_i20.KpiMetric>> getMetricsByUser(
    String metricType, {
    required String periodType,
    required int limit,
  }) => caller.callServerEndpoint<List<_i20.KpiMetric>>(
    'management',
    'getMetricsByUser',
    {
      'metricType': metricType,
      'periodType': periodType,
      'limit': limit,
    },
  );
}

/// {@category Endpoint}
class EndpointPhytopathology extends _i1.EndpointRef {
  EndpointPhytopathology(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'phytopathology';

  /// Record a disease detection
  _i2.Future<_i21.DiseaseDetection> recordDiseaseDetection(
    _i21.DiseaseDetection detection,
  ) => caller.callServerEndpoint<_i21.DiseaseDetection>(
    'phytopathology',
    'recordDiseaseDetection',
    {'detection': detection},
  );

  /// Get disease detections for a plant
  _i2.Future<List<_i21.DiseaseDetection>> getDetectionsForPlant(int plantId) =>
      caller.callServerEndpoint<List<_i21.DiseaseDetection>>(
        'phytopathology',
        'getDetectionsForPlant',
        {'plantId': plantId},
      );

  /// Get disease detections for a greenhouse
  _i2.Future<List<_i21.DiseaseDetection>> getDetectionsForGreenhouse(
    int greenhouseId, {
    required int limit,
  }) => caller.callServerEndpoint<List<_i21.DiseaseDetection>>(
    'phytopathology',
    'getDetectionsForGreenhouse',
    {
      'greenhouseId': greenhouseId,
      'limit': limit,
    },
  );

  /// Confirm a disease detection
  _i2.Future<_i21.DiseaseDetection?> confirmDetection(
    int detectionId,
    String confirmedBy,
  ) => caller.callServerEndpoint<_i21.DiseaseDetection?>(
    'phytopathology',
    'confirmDetection',
    {
      'detectionId': detectionId,
      'confirmedBy': confirmedBy,
    },
  );

  /// Record a pest identification
  _i2.Future<_i22.PestIdentification> recordPestIdentification(
    _i22.PestIdentification identification,
  ) => caller.callServerEndpoint<_i22.PestIdentification>(
    'phytopathology',
    'recordPestIdentification',
    {'identification': identification},
  );

  /// Get pest identifications for a greenhouse
  _i2.Future<List<_i22.PestIdentification>> getPestsForGreenhouse(
    int greenhouseId, {
    required int limit,
  }) => caller.callServerEndpoint<List<_i22.PestIdentification>>(
    'phytopathology',
    'getPestsForGreenhouse',
    {
      'greenhouseId': greenhouseId,
      'limit': limit,
    },
  );

  /// Record a nutritional deficiency
  _i2.Future<_i23.NutritionalDeficiency> recordDeficiency(
    _i23.NutritionalDeficiency deficiency,
  ) => caller.callServerEndpoint<_i23.NutritionalDeficiency>(
    'phytopathology',
    'recordDeficiency',
    {'deficiency': deficiency},
  );

  /// Get treatment recommendations for a plant
  _i2.Future<List<_i24.TreatmentRecommendation>> getTreatments(int plantId) =>
      caller.callServerEndpoint<List<_i24.TreatmentRecommendation>>(
        'phytopathology',
        'getTreatments',
        {'plantId': plantId},
      );

  /// Create a treatment recommendation
  _i2.Future<_i24.TreatmentRecommendation> createTreatment(
    _i24.TreatmentRecommendation treatment,
  ) => caller.callServerEndpoint<_i24.TreatmentRecommendation>(
    'phytopathology',
    'createTreatment',
    {'treatment': treatment},
  );

  /// Mark a treatment as applied and score effectiveness
  _i2.Future<_i24.TreatmentRecommendation?> markTreatmentApplied(
    int treatmentId,
    double? effectivenessScore,
  ) => caller.callServerEndpoint<_i24.TreatmentRecommendation?>(
    'phytopathology',
    'markTreatmentApplied',
    {
      'treatmentId': treatmentId,
      'effectivenessScore': effectivenessScore,
    },
  );
}

/// {@category Endpoint}
class EndpointTraceability extends _i1.EndpointRef {
  EndpointTraceability(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'traceability';

  /// Add a traceability record with automatic hash chain
  _i2.Future<_i25.TraceabilityRecord> addRecord(
    _i25.TraceabilityRecord record,
  ) => caller.callServerEndpoint<_i25.TraceabilityRecord>(
    'traceability',
    'addRecord',
    {'record': record},
  );

  /// Get the full traceability chain for a batch
  _i2.Future<List<_i25.TraceabilityRecord>> getChain(String batchId) =>
      caller.callServerEndpoint<List<_i25.TraceabilityRecord>>(
        'traceability',
        'getChain',
        {'batchId': batchId},
      );

  /// Verify the integrity of a batch's hash chain
  _i2.Future<bool> verifyChain(String batchId) =>
      caller.callServerEndpoint<bool>(
        'traceability',
        'verifyChain',
        {'batchId': batchId},
      );

  /// Generate a compliance report for a greenhouse against a template
  _i2.Future<_i26.ComplianceReport> generateReport(
    int greenhouseId,
    int templateId, {
    String? batchId,
  }) => caller.callServerEndpoint<_i26.ComplianceReport>(
    'traceability',
    'generateReport',
    {
      'greenhouseId': greenhouseId,
      'templateId': templateId,
      'batchId': batchId,
    },
  );

  /// Get compliance reports for a greenhouse
  _i2.Future<List<_i26.ComplianceReport>> getReports(
    int greenhouseId, {
    required int limit,
  }) => caller.callServerEndpoint<List<_i26.ComplianceReport>>(
    'traceability',
    'getReports',
    {
      'greenhouseId': greenhouseId,
      'limit': limit,
    },
  );

  /// Get available compliance templates
  _i2.Future<List<_i27.ComplianceTemplate>> getTemplates() =>
      caller.callServerEndpoint<List<_i27.ComplianceTemplate>>(
        'traceability',
        'getTemplates',
        {},
      );
}

/// {@category Endpoint}
class EndpointUser extends _i1.EndpointRef {
  EndpointUser(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  /// Get the authenticated user's profile
  _i2.Future<_i28.User?> getProfile() => caller.callServerEndpoint<_i28.User?>(
    'user',
    'getProfile',
    {},
  );

  /// Update user profile
  _i2.Future<_i28.User> updateProfile(_i28.User user) =>
      caller.callServerEndpoint<_i28.User>(
        'user',
        'updateProfile',
        {'user': user},
      );

  /// Get user preferences
  _i2.Future<_i29.UserPreferences?> getPreferences() =>
      caller.callServerEndpoint<_i29.UserPreferences?>(
        'user',
        'getPreferences',
        {},
      );

  /// Update user preferences
  _i2.Future<_i29.UserPreferences> updatePreferences(
    _i29.UserPreferences preferences,
  ) => caller.callServerEndpoint<_i29.UserPreferences>(
    'user',
    'updatePreferences',
    {'preferences': preferences},
  );

  /// Get user's subscription plan
  _i2.Future<_i30.SubscriptionPlan?> getSubscriptionPlan() =>
      caller.callServerEndpoint<_i30.SubscriptionPlan?>(
        'user',
        'getSubscriptionPlan',
        {},
      );

  /// List users by segment (admin only)
  _i2.Future<List<_i28.User>> listBySegment(
    String segment, {
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i28.User>>(
    'user',
    'listBySegment',
    {
      'segment': segment,
      'limit': limit,
      'offset': offset,
    },
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i8.Caller(client);
    serverpod_auth_core = _i9.Caller(client);
  }

  late final _i8.Caller serverpod_auth_idp;

  late final _i9.Caller serverpod_auth_core;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i31.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    alert = EndpointAlert(this);
    anomaly = EndpointAnomaly(this);
    auth = EndpointAuth(this);
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    cropCatalog = EndpointCropCatalog(this);
    greenhouse = EndpointGreenhouse(this);
    greeting = EndpointGreeting(this);
    harvestPrediction = EndpointHarvestPrediction(this);
    management = EndpointManagement(this);
    phytopathology = EndpointPhytopathology(this);
    traceability = EndpointTraceability(this);
    user = EndpointUser(this);
    modules = Modules(this);
  }

  late final EndpointAlert alert;

  late final EndpointAnomaly anomaly;

  late final EndpointAuth auth;

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointCropCatalog cropCatalog;

  late final EndpointGreenhouse greenhouse;

  late final EndpointGreeting greeting;

  late final EndpointHarvestPrediction harvestPrediction;

  late final EndpointManagement management;

  late final EndpointPhytopathology phytopathology;

  late final EndpointTraceability traceability;

  late final EndpointUser user;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'alert': alert,
    'anomaly': anomaly,
    'auth': auth,
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'cropCatalog': cropCatalog,
    'greenhouse': greenhouse,
    'greeting': greeting,
    'harvestPrediction': harvestPrediction,
    'management': management,
    'phytopathology': phytopathology,
    'traceability': traceability,
    'user': user,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
