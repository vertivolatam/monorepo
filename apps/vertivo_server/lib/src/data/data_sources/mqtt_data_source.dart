import 'dart:async';
import 'dart:math';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'mqtt_topics.dart';

/// Singleton MQTT data source for connecting to the EMQX broker.
class MqttDataSource {
  static MqttDataSource? _instance;
  MqttServerClient? _client;
  bool _isConnected = false;
  int _reconnectAttempts = 0;
  static const _maxReconnectAttempts = 10;
  Timer? _reconnectTimer;

  final StreamController<MqttReceivedMessage> _messageController =
      StreamController<MqttReceivedMessage>.broadcast();

  /// Stream of incoming MQTT messages
  Stream<MqttReceivedMessage> get messages => _messageController.stream;

  bool get isConnected => _isConnected;

  MqttDataSource._();

  /// Get or create the singleton instance
  static MqttDataSource get instance {
    _instance ??= MqttDataSource._();
    return _instance!;
  }

  /// Initialize and connect to the MQTT broker using Serverpod config.
  Future<void> initialize(String runMode) async {
    final config = _getConfig(runMode);
    final host = config['host'] as String? ?? 'emqx-listeners';
    final port = config['port'] as int? ?? 1883;
    final clientId =
        config['clientId'] as String? ?? 'vertivo-server-$runMode';

    _client = MqttServerClient(host, clientId)
      ..port = port
      ..keepAlivePeriod = 60
      ..autoReconnect = true
      ..onConnected = _onConnected
      ..onDisconnected = _onDisconnected
      ..onAutoReconnected = _onReconnected
      ..logging(on: false);

    await _connect();
  }

  Map<String, dynamic> _getConfig(String runMode) {
    // Default dev config; in production, read from Serverpod's config files
    return {
      'host': 'emqx-listeners',
      'port': 1883,
      'clientId': 'vertivo-server-dev',
    };
  }

  Future<void> _connect() async {
    try {
      await _client!.connect();
    } catch (e) {
      _isConnected = false;
      _scheduleReconnect();
    }
  }

  void _onConnected() {
    _isConnected = true;
    _reconnectAttempts = 0;

    // Subscribe to all sensor data
    _client!.subscribe(MqttTopics.sensorWildcard, MqttQos.atLeastOnce);
    _client!.subscribe(MqttTopics.statusWildcard, MqttQos.atLeastOnce);

    // Forward messages to stream
    _client!.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (final msg in messages) {
        _messageController.add(msg);
      }
    });
  }

  void _onDisconnected() {
    _isConnected = false;
    _scheduleReconnect();
  }

  void _onReconnected() {
    _isConnected = true;
    _reconnectAttempts = 0;
  }

  /// Exponential backoff reconnect
  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) return;
    _reconnectTimer?.cancel();
    final delay = Duration(seconds: pow(2, _reconnectAttempts).toInt());
    _reconnectAttempts++;
    _reconnectTimer = Timer(delay, () async {
      await _connect();
    });
  }

  /// Publish a message to a topic
  void publish(String topic, String payload, {MqttQos qos = MqttQos.atLeastOnce}) {
    if (!_isConnected || _client == null) return;
    final builder = MqttClientPayloadBuilder()..addString(payload);
    _client!.publishMessage(topic, qos, builder.payload!);
  }

  /// Subscribe to a topic
  void subscribe(String topic, {MqttQos qos = MqttQos.atLeastOnce}) {
    if (!_isConnected || _client == null) return;
    _client!.subscribe(topic, qos);
  }

  /// Disconnect and clean up
  Future<void> dispose() async {
    _reconnectTimer?.cancel();
    _client?.disconnect();
    await _messageController.close();
    _instance = null;
  }
}
