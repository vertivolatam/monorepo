import 'package:test/test.dart';
import 'package:vertivo_server/src/data/data_sources/mqtt_topics.dart';

void main() {
  test('parses a pH sensor topic into greenhouseId and type', () {
    final seg = MqttTopics.parse('vertivo/1/greenhouse/1/sensor/ph');
    expect(seg, isNotNull);
    expect(seg!.greenhouseId, 1);
    expect(seg.category, 'sensor');
    expect(seg.type, 'ph');
  });

  test('rejects a malformed topic', () {
    expect(MqttTopics.parse('vertivo/1/greenhouse'), isNull);
  });
}
