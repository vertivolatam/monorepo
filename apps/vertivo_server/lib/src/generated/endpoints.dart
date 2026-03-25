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
import '../alerts/alert_endpoint.dart' as _i2;
import '../anomaly_management/anomaly_endpoint.dart' as _i3;
import '../auth/auth_endpoint.dart' as _i4;
import '../auth/email_idp_endpoint.dart' as _i5;
import '../auth/jwt_refresh_endpoint.dart' as _i6;
import '../crop_catalog/crop_catalog_endpoint.dart' as _i7;
import '../greenhouses/greenhouse_endpoint.dart' as _i8;
import '../greetings/greeting_endpoint.dart' as _i9;
import '../harvest_prediction/harvest_prediction_endpoint.dart' as _i10;
import '../management/management_endpoint.dart' as _i11;
import '../phytopathology/phytopathology_endpoint.dart' as _i12;
import '../traceability/traceability_endpoint.dart' as _i13;
import '../users/user_endpoint.dart' as _i14;
import 'package:vertivo_server/src/generated/alerts/alert.dart' as _i15;
import 'package:vertivo_server/src/generated/anomaly_management/anomaly.dart'
    as _i16;
import 'package:vertivo_server/src/generated/crop_catalog/crop_model.dart'
    as _i17;
import 'package:vertivo_server/src/generated/crop_catalog/growth_stage_definition.dart'
    as _i18;
import 'package:vertivo_server/src/generated/greenhouses/greenhouse.dart'
    as _i19;
import 'package:vertivo_server/src/generated/greenhouses/tray.dart' as _i20;
import 'package:vertivo_server/src/generated/greenhouses/plant.dart' as _i21;
import 'package:vertivo_server/src/generated/greenhouses/environmental_reading.dart'
    as _i22;
import 'package:vertivo_server/src/generated/greenhouses/irrigation_event.dart'
    as _i23;
import 'package:vertivo_server/src/generated/harvest_prediction/harvest_prediction.dart'
    as _i24;
import 'package:vertivo_server/src/generated/harvest_prediction/quality_prediction.dart'
    as _i25;
import 'package:vertivo_server/src/generated/management/kpi_metric.dart'
    as _i26;
import 'package:vertivo_server/src/generated/phytopathology/disease_detection.dart'
    as _i27;
import 'package:vertivo_server/src/generated/phytopathology/pest_identification.dart'
    as _i28;
import 'package:vertivo_server/src/generated/phytopathology/nutritional_deficiency.dart'
    as _i29;
import 'package:vertivo_server/src/generated/phytopathology/treatment_recommendation.dart'
    as _i30;
import 'package:vertivo_server/src/generated/traceability/traceability_record.dart'
    as _i31;
import 'package:vertivo_server/src/generated/users/user.dart' as _i32;
import 'package:vertivo_server/src/generated/users/user_preferences.dart'
    as _i33;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i34;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i35;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'alert': _i2.AlertEndpoint()
        ..initialize(
          server,
          'alert',
          null,
        ),
      'anomaly': _i3.AnomalyEndpoint()
        ..initialize(
          server,
          'anomaly',
          null,
        ),
      'auth': _i4.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'emailIdp': _i5.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i6.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'cropCatalog': _i7.CropCatalogEndpoint()
        ..initialize(
          server,
          'cropCatalog',
          null,
        ),
      'greenhouse': _i8.GreenhouseEndpoint()
        ..initialize(
          server,
          'greenhouse',
          null,
        ),
      'greeting': _i9.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
      'harvestPrediction': _i10.HarvestPredictionEndpoint()
        ..initialize(
          server,
          'harvestPrediction',
          null,
        ),
      'management': _i11.ManagementEndpoint()
        ..initialize(
          server,
          'management',
          null,
        ),
      'phytopathology': _i12.PhytopathologyEndpoint()
        ..initialize(
          server,
          'phytopathology',
          null,
        ),
      'traceability': _i13.TraceabilityEndpoint()
        ..initialize(
          server,
          'traceability',
          null,
        ),
      'user': _i14.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
    };
    connectors['alert'] = _i1.EndpointConnector(
      name: 'alert',
      endpoint: endpoints['alert']!,
      methodConnectors: {
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'alert': _i1.ParameterDescription(
              name: 'alert',
              type: _i1.getType<_i15.Alert>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['alert'] as _i2.AlertEndpoint).create(
                session,
                params['alert'],
              ),
        ),
        'getMyAlerts': _i1.MethodConnector(
          name: 'getMyAlerts',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['alert'] as _i2.AlertEndpoint).getMyAlerts(
                session,
                limit: params['limit'],
                offset: params['offset'],
              ),
        ),
        'getUnreadCount': _i1.MethodConnector(
          name: 'getUnreadCount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['alert'] as _i2.AlertEndpoint)
                  .getUnreadCount(session),
        ),
        'markAsRead': _i1.MethodConnector(
          name: 'markAsRead',
          params: {
            'alertId': _i1.ParameterDescription(
              name: 'alertId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['alert'] as _i2.AlertEndpoint).markAsRead(
                session,
                params['alertId'],
              ),
        ),
        'acknowledge': _i1.MethodConnector(
          name: 'acknowledge',
          params: {
            'alertId': _i1.ParameterDescription(
              name: 'alertId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['alert'] as _i2.AlertEndpoint).acknowledge(
                session,
                params['alertId'],
              ),
        ),
        'resolve': _i1.MethodConnector(
          name: 'resolve',
          params: {
            'alertId': _i1.ParameterDescription(
              name: 'alertId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['alert'] as _i2.AlertEndpoint).resolve(
                session,
                params['alertId'],
              ),
        ),
        'getForGreenhouse': _i1.MethodConnector(
          name: 'getForGreenhouse',
          params: {
            'greenhouseId': _i1.ParameterDescription(
              name: 'greenhouseId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['alert'] as _i2.AlertEndpoint).getForGreenhouse(
                    session,
                    params['greenhouseId'],
                    limit: params['limit'],
                  ),
        ),
        'getTemplates': _i1.MethodConnector(
          name: 'getTemplates',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['alert'] as _i2.AlertEndpoint).getTemplates(
                session,
              ),
        ),
      },
    );
    connectors['anomaly'] = _i1.EndpointConnector(
      name: 'anomaly',
      endpoint: endpoints['anomaly']!,
      methodConnectors: {
        'record': _i1.MethodConnector(
          name: 'record',
          params: {
            'anomaly': _i1.ParameterDescription(
              name: 'anomaly',
              type: _i1.getType<_i16.Anomaly>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['anomaly'] as _i3.AnomalyEndpoint).record(
                session,
                params['anomaly'],
              ),
        ),
        'getForGreenhouse': _i1.MethodConnector(
          name: 'getForGreenhouse',
          params: {
            'greenhouseId': _i1.ParameterDescription(
              name: 'greenhouseId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['anomaly'] as _i3.AnomalyEndpoint)
                  .getForGreenhouse(
                    session,
                    params['greenhouseId'],
                    limit: params['limit'],
                  ),
        ),
        'getUnresolved': _i1.MethodConnector(
          name: 'getUnresolved',
          params: {
            'greenhouseId': _i1.ParameterDescription(
              name: 'greenhouseId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['anomaly'] as _i3.AnomalyEndpoint).getUnresolved(
                    session,
                    params['greenhouseId'],
                  ),
        ),
        'classify': _i1.MethodConnector(
          name: 'classify',
          params: {
            'anomalyId': _i1.ParameterDescription(
              name: 'anomalyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'anomalyType': _i1.ParameterDescription(
              name: 'anomalyType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'severity': _i1.ParameterDescription(
              name: 'severity',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['anomaly'] as _i3.AnomalyEndpoint).classify(
                session,
                params['anomalyId'],
                params['anomalyType'],
                params['severity'],
              ),
        ),
        'resolve': _i1.MethodConnector(
          name: 'resolve',
          params: {
            'anomalyId': _i1.ParameterDescription(
              name: 'anomalyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'resolutionNotes': _i1.ParameterDescription(
              name: 'resolutionNotes',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['anomaly'] as _i3.AnomalyEndpoint).resolve(
                session,
                params['anomalyId'],
                params['resolutionNotes'],
              ),
        ),
      },
    );
    connectors['auth'] = _i1.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'createSession': _i1.MethodConnector(
          name: 'createSession',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deviceId': _i1.ParameterDescription(
              name: 'deviceId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deviceName': _i1.ParameterDescription(
              name: 'deviceName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'deviceType': _i1.ParameterDescription(
              name: 'deviceType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i4.AuthEndpoint).createSession(
                session,
                params['userId'],
                params['deviceId'],
                params['deviceName'],
                params['deviceType'],
              ),
        ),
        'revokeSession': _i1.MethodConnector(
          name: 'revokeSession',
          params: {
            'sessionId': _i1.ParameterDescription(
              name: 'sessionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i4.AuthEndpoint).revokeSession(
                session,
                params['sessionId'],
              ),
        ),
        'getActiveSessions': _i1.MethodConnector(
          name: 'getActiveSessions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i4.AuthEndpoint)
                  .getActiveSessions(session),
        ),
        'logSecurityEvent': _i1.MethodConnector(
          name: 'logSecurityEvent',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'eventType': _i1.ParameterDescription(
              name: 'eventType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'severity': _i1.ParameterDescription(
              name: 'severity',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'details': _i1.ParameterDescription(
              name: 'details',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['auth'] as _i4.AuthEndpoint).logSecurityEvent(
                    session,
                    params['userId'],
                    params['eventType'],
                    params['severity'],
                    params['details'],
                  ),
        ),
        'getSecurityEvents': _i1.MethodConnector(
          name: 'getSecurityEvents',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['auth'] as _i4.AuthEndpoint).getSecurityEvents(
                    session,
                    params['userId'],
                    limit: params['limit'],
                  ),
        ),
      },
    );
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i5.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i5.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i5.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i5.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i5.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i5.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i5.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i5.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i6.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['cropCatalog'] = _i1.EndpointConnector(
      name: 'cropCatalog',
      endpoint: endpoints['cropCatalog']!,
      methodConnectors: {
        'list': _i1.MethodConnector(
          name: 'list',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cropCatalog'] as _i7.CropCatalogEndpoint).list(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
        'get': _i1.MethodConnector(
          name: 'get',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cropCatalog'] as _i7.CropCatalogEndpoint).get(
                    session,
                    params['id'],
                  ),
        ),
        'search': _i1.MethodConnector(
          name: 'search',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cropCatalog'] as _i7.CropCatalogEndpoint).search(
                    session,
                    params['query'],
                  ),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'crop': _i1.ParameterDescription(
              name: 'crop',
              type: _i1.getType<_i17.CropModel>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cropCatalog'] as _i7.CropCatalogEndpoint).create(
                    session,
                    params['crop'],
                  ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'crop': _i1.ParameterDescription(
              name: 'crop',
              type: _i1.getType<_i17.CropModel>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cropCatalog'] as _i7.CropCatalogEndpoint).update(
                    session,
                    params['crop'],
                  ),
        ),
        'getGrowthStages': _i1.MethodConnector(
          name: 'getGrowthStages',
          params: {
            'cropModelId': _i1.ParameterDescription(
              name: 'cropModelId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['cropCatalog'] as _i7.CropCatalogEndpoint)
                  .getGrowthStages(
                    session,
                    params['cropModelId'],
                  ),
        ),
        'createGrowthStage': _i1.MethodConnector(
          name: 'createGrowthStage',
          params: {
            'stage': _i1.ParameterDescription(
              name: 'stage',
              type: _i1.getType<_i18.GrowthStageDefinition>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['cropCatalog'] as _i7.CropCatalogEndpoint)
                  .createGrowthStage(
                    session,
                    params['stage'],
                  ),
        ),
      },
    );
    connectors['greenhouse'] = _i1.EndpointConnector(
      name: 'greenhouse',
      endpoint: endpoints['greenhouse']!,
      methodConnectors: {
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'greenhouse': _i1.ParameterDescription(
              name: 'greenhouse',
              type: _i1.getType<_i19.Greenhouse>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greenhouse'] as _i8.GreenhouseEndpoint).create(
                    session,
                    params['greenhouse'],
                  ),
        ),
        'get': _i1.MethodConnector(
          name: 'get',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greenhouse'] as _i8.GreenhouseEndpoint).get(
                    session,
                    params['id'],
                  ),
        ),
        'listByUser': _i1.MethodConnector(
          name: 'listByUser',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greenhouse'] as _i8.GreenhouseEndpoint)
                  .listByUser(session),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'greenhouse': _i1.ParameterDescription(
              name: 'greenhouse',
              type: _i1.getType<_i19.Greenhouse>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greenhouse'] as _i8.GreenhouseEndpoint).update(
                    session,
                    params['greenhouse'],
                  ),
        ),
        'delete': _i1.MethodConnector(
          name: 'delete',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greenhouse'] as _i8.GreenhouseEndpoint).delete(
                    session,
                    params['id'],
                  ),
        ),
        'getTrays': _i1.MethodConnector(
          name: 'getTrays',
          params: {
            'greenhouseId': _i1.ParameterDescription(
              name: 'greenhouseId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greenhouse'] as _i8.GreenhouseEndpoint).getTrays(
                    session,
                    params['greenhouseId'],
                  ),
        ),
        'getPlants': _i1.MethodConnector(
          name: 'getPlants',
          params: {
            'trayId': _i1.ParameterDescription(
              name: 'trayId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greenhouse'] as _i8.GreenhouseEndpoint).getPlants(
                    session,
                    params['trayId'],
                  ),
        ),
        'createTray': _i1.MethodConnector(
          name: 'createTray',
          params: {
            'tray': _i1.ParameterDescription(
              name: 'tray',
              type: _i1.getType<_i20.Tray>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greenhouse'] as _i8.GreenhouseEndpoint)
                  .createTray(
                    session,
                    params['tray'],
                  ),
        ),
        'createPlant': _i1.MethodConnector(
          name: 'createPlant',
          params: {
            'plant': _i1.ParameterDescription(
              name: 'plant',
              type: _i1.getType<_i21.Plant>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greenhouse'] as _i8.GreenhouseEndpoint)
                  .createPlant(
                    session,
                    params['plant'],
                  ),
        ),
        'recordReading': _i1.MethodConnector(
          name: 'recordReading',
          params: {
            'reading': _i1.ParameterDescription(
              name: 'reading',
              type: _i1.getType<_i22.EnvironmentalReading>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greenhouse'] as _i8.GreenhouseEndpoint)
                  .recordReading(
                    session,
                    params['reading'],
                  ),
        ),
        'getReadings': _i1.MethodConnector(
          name: 'getReadings',
          params: {
            'greenhouseId': _i1.ParameterDescription(
              name: 'greenhouseId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'measurementType': _i1.ParameterDescription(
              name: 'measurementType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greenhouse'] as _i8.GreenhouseEndpoint)
                  .getReadings(
                    session,
                    params['greenhouseId'],
                    params['measurementType'],
                    limit: params['limit'],
                  ),
        ),
        'quarantinePlant': _i1.MethodConnector(
          name: 'quarantinePlant',
          params: {
            'plantId': _i1.ParameterDescription(
              name: 'plantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'reason': _i1.ParameterDescription(
              name: 'reason',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greenhouse'] as _i8.GreenhouseEndpoint)
                  .quarantinePlant(
                    session,
                    params['plantId'],
                    params['reason'],
                  ),
        ),
        'recordIrrigation': _i1.MethodConnector(
          name: 'recordIrrigation',
          params: {
            'event': _i1.ParameterDescription(
              name: 'event',
              type: _i1.getType<_i23.IrrigationEvent>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greenhouse'] as _i8.GreenhouseEndpoint)
                  .recordIrrigation(
                    session,
                    params['event'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i9.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    connectors['harvestPrediction'] = _i1.EndpointConnector(
      name: 'harvestPrediction',
      endpoint: endpoints['harvestPrediction']!,
      methodConnectors: {
        'getForGreenhouse': _i1.MethodConnector(
          name: 'getForGreenhouse',
          params: {
            'greenhouseId': _i1.ParameterDescription(
              name: 'greenhouseId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['harvestPrediction']
                          as _i10.HarvestPredictionEndpoint)
                      .getForGreenhouse(
                        session,
                        params['greenhouseId'],
                        limit: params['limit'],
                      ),
        ),
        'getForPlant': _i1.MethodConnector(
          name: 'getForPlant',
          params: {
            'plantId': _i1.ParameterDescription(
              name: 'plantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['harvestPrediction']
                          as _i10.HarvestPredictionEndpoint)
                      .getForPlant(
                        session,
                        params['plantId'],
                      ),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'prediction': _i1.ParameterDescription(
              name: 'prediction',
              type: _i1.getType<_i24.HarvestPrediction>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['harvestPrediction']
                          as _i10.HarvestPredictionEndpoint)
                      .create(
                        session,
                        params['prediction'],
                      ),
        ),
        'recordActual': _i1.MethodConnector(
          name: 'recordActual',
          params: {
            'predictionId': _i1.ParameterDescription(
              name: 'predictionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'actualYieldKg': _i1.ParameterDescription(
              name: 'actualYieldKg',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'actualQualityGrade': _i1.ParameterDescription(
              name: 'actualQualityGrade',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['harvestPrediction']
                          as _i10.HarvestPredictionEndpoint)
                      .recordActual(
                        session,
                        params['predictionId'],
                        params['actualYieldKg'],
                        params['actualQualityGrade'],
                      ),
        ),
        'getQuality': _i1.MethodConnector(
          name: 'getQuality',
          params: {
            'harvestPredictionId': _i1.ParameterDescription(
              name: 'harvestPredictionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['harvestPrediction']
                          as _i10.HarvestPredictionEndpoint)
                      .getQuality(
                        session,
                        params['harvestPredictionId'],
                      ),
        ),
        'createQuality': _i1.MethodConnector(
          name: 'createQuality',
          params: {
            'quality': _i1.ParameterDescription(
              name: 'quality',
              type: _i1.getType<_i25.QualityPrediction>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['harvestPrediction']
                          as _i10.HarvestPredictionEndpoint)
                      .createQuality(
                        session,
                        params['quality'],
                      ),
        ),
      },
    );
    connectors['management'] = _i1.EndpointConnector(
      name: 'management',
      endpoint: endpoints['management']!,
      methodConnectors: {
        'getMetrics': _i1.MethodConnector(
          name: 'getMetrics',
          params: {
            'greenhouseId': _i1.ParameterDescription(
              name: 'greenhouseId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'metricType': _i1.ParameterDescription(
              name: 'metricType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'periodType': _i1.ParameterDescription(
              name: 'periodType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['management'] as _i11.ManagementEndpoint)
                  .getMetrics(
                    session,
                    params['greenhouseId'],
                    metricType: params['metricType'],
                    periodType: params['periodType'],
                    limit: params['limit'],
                  ),
        ),
        'record': _i1.MethodConnector(
          name: 'record',
          params: {
            'metric': _i1.ParameterDescription(
              name: 'metric',
              type: _i1.getType<_i26.KpiMetric>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['management'] as _i11.ManagementEndpoint).record(
                    session,
                    params['metric'],
                  ),
        ),
        'getDashboardSummary': _i1.MethodConnector(
          name: 'getDashboardSummary',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['management'] as _i11.ManagementEndpoint)
                  .getDashboardSummary(session),
        ),
        'getMetricsByUser': _i1.MethodConnector(
          name: 'getMetricsByUser',
          params: {
            'metricType': _i1.ParameterDescription(
              name: 'metricType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'periodType': _i1.ParameterDescription(
              name: 'periodType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['management'] as _i11.ManagementEndpoint)
                  .getMetricsByUser(
                    session,
                    params['metricType'],
                    periodType: params['periodType'],
                    limit: params['limit'],
                  ),
        ),
      },
    );
    connectors['phytopathology'] = _i1.EndpointConnector(
      name: 'phytopathology',
      endpoint: endpoints['phytopathology']!,
      methodConnectors: {
        'recordDiseaseDetection': _i1.MethodConnector(
          name: 'recordDiseaseDetection',
          params: {
            'detection': _i1.ParameterDescription(
              name: 'detection',
              type: _i1.getType<_i27.DiseaseDetection>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['phytopathology'] as _i12.PhytopathologyEndpoint)
                      .recordDiseaseDetection(
                        session,
                        params['detection'],
                      ),
        ),
        'getDetectionsForPlant': _i1.MethodConnector(
          name: 'getDetectionsForPlant',
          params: {
            'plantId': _i1.ParameterDescription(
              name: 'plantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['phytopathology'] as _i12.PhytopathologyEndpoint)
                      .getDetectionsForPlant(
                        session,
                        params['plantId'],
                      ),
        ),
        'getDetectionsForGreenhouse': _i1.MethodConnector(
          name: 'getDetectionsForGreenhouse',
          params: {
            'greenhouseId': _i1.ParameterDescription(
              name: 'greenhouseId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['phytopathology'] as _i12.PhytopathologyEndpoint)
                      .getDetectionsForGreenhouse(
                        session,
                        params['greenhouseId'],
                        limit: params['limit'],
                      ),
        ),
        'confirmDetection': _i1.MethodConnector(
          name: 'confirmDetection',
          params: {
            'detectionId': _i1.ParameterDescription(
              name: 'detectionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'confirmedBy': _i1.ParameterDescription(
              name: 'confirmedBy',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['phytopathology'] as _i12.PhytopathologyEndpoint)
                      .confirmDetection(
                        session,
                        params['detectionId'],
                        params['confirmedBy'],
                      ),
        ),
        'recordPestIdentification': _i1.MethodConnector(
          name: 'recordPestIdentification',
          params: {
            'identification': _i1.ParameterDescription(
              name: 'identification',
              type: _i1.getType<_i28.PestIdentification>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['phytopathology'] as _i12.PhytopathologyEndpoint)
                      .recordPestIdentification(
                        session,
                        params['identification'],
                      ),
        ),
        'getPestsForGreenhouse': _i1.MethodConnector(
          name: 'getPestsForGreenhouse',
          params: {
            'greenhouseId': _i1.ParameterDescription(
              name: 'greenhouseId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['phytopathology'] as _i12.PhytopathologyEndpoint)
                      .getPestsForGreenhouse(
                        session,
                        params['greenhouseId'],
                        limit: params['limit'],
                      ),
        ),
        'recordDeficiency': _i1.MethodConnector(
          name: 'recordDeficiency',
          params: {
            'deficiency': _i1.ParameterDescription(
              name: 'deficiency',
              type: _i1.getType<_i29.NutritionalDeficiency>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['phytopathology'] as _i12.PhytopathologyEndpoint)
                      .recordDeficiency(
                        session,
                        params['deficiency'],
                      ),
        ),
        'getTreatments': _i1.MethodConnector(
          name: 'getTreatments',
          params: {
            'plantId': _i1.ParameterDescription(
              name: 'plantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['phytopathology'] as _i12.PhytopathologyEndpoint)
                      .getTreatments(
                        session,
                        params['plantId'],
                      ),
        ),
        'createTreatment': _i1.MethodConnector(
          name: 'createTreatment',
          params: {
            'treatment': _i1.ParameterDescription(
              name: 'treatment',
              type: _i1.getType<_i30.TreatmentRecommendation>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['phytopathology'] as _i12.PhytopathologyEndpoint)
                      .createTreatment(
                        session,
                        params['treatment'],
                      ),
        ),
        'markTreatmentApplied': _i1.MethodConnector(
          name: 'markTreatmentApplied',
          params: {
            'treatmentId': _i1.ParameterDescription(
              name: 'treatmentId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'effectivenessScore': _i1.ParameterDescription(
              name: 'effectivenessScore',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['phytopathology'] as _i12.PhytopathologyEndpoint)
                      .markTreatmentApplied(
                        session,
                        params['treatmentId'],
                        params['effectivenessScore'],
                      ),
        ),
      },
    );
    connectors['traceability'] = _i1.EndpointConnector(
      name: 'traceability',
      endpoint: endpoints['traceability']!,
      methodConnectors: {
        'addRecord': _i1.MethodConnector(
          name: 'addRecord',
          params: {
            'record': _i1.ParameterDescription(
              name: 'record',
              type: _i1.getType<_i31.TraceabilityRecord>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['traceability'] as _i13.TraceabilityEndpoint)
                      .addRecord(
                        session,
                        params['record'],
                      ),
        ),
        'getChain': _i1.MethodConnector(
          name: 'getChain',
          params: {
            'batchId': _i1.ParameterDescription(
              name: 'batchId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['traceability'] as _i13.TraceabilityEndpoint)
                      .getChain(
                        session,
                        params['batchId'],
                      ),
        ),
        'verifyChain': _i1.MethodConnector(
          name: 'verifyChain',
          params: {
            'batchId': _i1.ParameterDescription(
              name: 'batchId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['traceability'] as _i13.TraceabilityEndpoint)
                      .verifyChain(
                        session,
                        params['batchId'],
                      ),
        ),
        'generateReport': _i1.MethodConnector(
          name: 'generateReport',
          params: {
            'greenhouseId': _i1.ParameterDescription(
              name: 'greenhouseId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'templateId': _i1.ParameterDescription(
              name: 'templateId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'batchId': _i1.ParameterDescription(
              name: 'batchId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['traceability'] as _i13.TraceabilityEndpoint)
                      .generateReport(
                        session,
                        params['greenhouseId'],
                        params['templateId'],
                        batchId: params['batchId'],
                      ),
        ),
        'getReports': _i1.MethodConnector(
          name: 'getReports',
          params: {
            'greenhouseId': _i1.ParameterDescription(
              name: 'greenhouseId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['traceability'] as _i13.TraceabilityEndpoint)
                      .getReports(
                        session,
                        params['greenhouseId'],
                        limit: params['limit'],
                      ),
        ),
        'getTemplates': _i1.MethodConnector(
          name: 'getTemplates',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['traceability'] as _i13.TraceabilityEndpoint)
                      .getTemplates(session),
        ),
      },
    );
    connectors['user'] = _i1.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'getProfile': _i1.MethodConnector(
          name: 'getProfile',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _i14.UserEndpoint).getProfile(session),
        ),
        'updateProfile': _i1.MethodConnector(
          name: 'updateProfile',
          params: {
            'user': _i1.ParameterDescription(
              name: 'user',
              type: _i1.getType<_i32.User>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i14.UserEndpoint).updateProfile(
                session,
                params['user'],
              ),
        ),
        'getPreferences': _i1.MethodConnector(
          name: 'getPreferences',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i14.UserEndpoint)
                  .getPreferences(session),
        ),
        'updatePreferences': _i1.MethodConnector(
          name: 'updatePreferences',
          params: {
            'preferences': _i1.ParameterDescription(
              name: 'preferences',
              type: _i1.getType<_i33.UserPreferences>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _i14.UserEndpoint).updatePreferences(
                    session,
                    params['preferences'],
                  ),
        ),
        'getSubscriptionPlan': _i1.MethodConnector(
          name: 'getSubscriptionPlan',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i14.UserEndpoint)
                  .getSubscriptionPlan(session),
        ),
        'listBySegment': _i1.MethodConnector(
          name: 'listBySegment',
          params: {
            'segment': _i1.ParameterDescription(
              name: 'segment',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i14.UserEndpoint).listBySegment(
                session,
                params['segment'],
                limit: params['limit'],
                offset: params['offset'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i34.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i35.Endpoints()
      ..initializeEndpoints(server);
  }
}
