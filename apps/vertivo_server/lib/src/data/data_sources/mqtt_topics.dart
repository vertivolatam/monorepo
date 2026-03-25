/// MQTT topic patterns for the Vertivo IoT platform.
///
/// Topic structure: vertivo/{userId}/greenhouse/{greenhouseId}/sensor/{measurementType}
class MqttTopics {
  // Subscribe patterns (with MQTT wildcards)
  static const sensorWildcard = 'vertivo/+/greenhouse/+/sensor/#';
  static const commandWildcard = 'vertivo/+/greenhouse/+/command/#';
  static const statusWildcard = 'vertivo/+/greenhouse/+/status';

  // Publish patterns (template methods)
  static String sensorReading(
    int userId,
    int greenhouseId,
    String measurementType,
  ) =>
      'vertivo/$userId/greenhouse/$greenhouseId/sensor/$measurementType';

  static String command(
    int userId,
    int greenhouseId,
    String commandType,
  ) =>
      'vertivo/$userId/greenhouse/$greenhouseId/command/$commandType';

  static String status(int userId, int greenhouseId) =>
      'vertivo/$userId/greenhouse/$greenhouseId/status';

  static String alertNotification(int userId, int greenhouseId) =>
      'vertivo/$userId/greenhouse/$greenhouseId/alert';

  /// Parse topic segments from a received topic string.
  /// Returns null if the topic doesn't match the expected pattern.
  static MqttTopicSegments? parse(String topic) {
    final parts = topic.split('/');
    // Minimum: vertivo/{userId}/greenhouse/{ghId}/sensor/{type}
    if (parts.length < 6) return null;
    if (parts[0] != 'vertivo') return null;
    if (parts[2] != 'greenhouse') return null;

    final userId = int.tryParse(parts[1]);
    final greenhouseId = int.tryParse(parts[3]);
    if (userId == null || greenhouseId == null) return null;

    return MqttTopicSegments(
      userId: userId,
      greenhouseId: greenhouseId,
      category: parts[4], // sensor, command, status, alert
      type: parts.length > 5 ? parts[5] : null,
    );
  }
}

class MqttTopicSegments {
  final int userId;
  final int greenhouseId;
  final String category;
  final String? type;

  MqttTopicSegments({
    required this.userId,
    required this.greenhouseId,
    required this.category,
    this.type,
  });
}
