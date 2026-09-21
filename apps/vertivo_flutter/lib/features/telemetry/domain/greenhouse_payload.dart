/// MQTT-style payload envelope for greenhouse telemetry (REHM Módulo 3).
///
/// RF-3.1: el payload claro se estructura como JSON con campos
/// `topic`, `sender`, `timestamp` y `body`.
/// El árbol de tópicos canónico es el del backend
/// (`MqttTopics` en vertivo_server):
/// `vertivo/{userId}/greenhouse/{greenhouseId}/sensor/{measurementType}`.
class GreenhouseMqttPayload {
  final String topic;
  final String sender;
  final DateTime timestamp;
  final Map<String, dynamic> body;

  const GreenhouseMqttPayload({
    required this.topic,
    required this.sender,
    required this.timestamp,
    required this.body,
  });

  ///measurement type extraído del último segmento del tópico
  /// (`vertivo/1/greenhouse/2/sensor/temperature` → `temperature`).
  /// null si el tópico no tiene el formato esperado.
  String? get measurementType {
    final parts = topic.split('/');
    if (parts.length < 6) return null;
    if (parts[0] != 'vertivo' || parts[2] != 'greenhouse') return null;
    if (parts[4] != 'sensor') return null;
    return parts[5];
  }

  /// greenhouse id extraído del tópico, null si no parsea.
  int? get greenhouseId {
    final parts = topic.split('/');
    if (parts.length < 4) return null;
    return int.tryParse(parts[3]);
  }

  /// RF-3.2: matcheo con wildcards MQTT (`+` un nivel, `#` resto).
  bool matches(String pattern) {
    final patternParts = pattern.split('/');
    final topicParts = topic.split('/');
    var i = 0;
    for (; i < patternParts.length; i++) {
      final p = patternParts[i];
      if (p == '#') return true;
      if (i >= topicParts.length) return false;
      if (p != '+' && p != topicParts[i]) return false;
    }
    return i == topicParts.length;
  }

  Map<String, dynamic> toJson() => {
        'topic': topic,
        'sender': sender,
        'timestamp': timestamp.toIso8601String(),
        'body': body,
      };

  factory GreenhouseMqttPayload.fromJson(Map<String, dynamic> json) {
    return GreenhouseMqttPayload(
      topic: json['topic'] as String,
      sender: json['sender'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      body: Map<String, dynamic>.from(json['body'] as Map),
    );
  }
}
