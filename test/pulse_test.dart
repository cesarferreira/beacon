import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/pulse.dart';
import 'package:pulse/pulse_receiver.dart';

// Mock receiver for testing
class MockReceiver extends PulseReceiver {
  bool wasInitialized = false;
  bool wasShutdown = false;
  List<String> receivedEvents = [];
  List<Map<String, dynamic>> receivedParams = [];

  @override
  void initialize() {
    wasInitialized = true;
  }

  @override
  void shutdown() {
    wasShutdown = true;
  }

  @override
  bool shouldProcess(String eventName) {
    return eventName.startsWith('test_');
  }

  @override
  void onEvent(String eventName, Map<String, dynamic> params) {
    receivedEvents.add(eventName);
    receivedParams.add(params);
  }
}

void main() {
  group('Pulse', () {
    late MockReceiver mockReceiver;
    late MockReceiver mockReceiver2;

    setUp(() {
      mockReceiver = MockReceiver();
      mockReceiver2 = MockReceiver();
    });

    test('should be a singleton', () {
      final instance1 = Pulse();
      final instance2 = Pulse();
      expect(identical(instance1, instance2), true);
    });

    test('register() should initialize receiver', () {
      Pulse.register(mockReceiver);
      expect(mockReceiver.wasInitialized, true);
    });

    test('emit() should send events to registered receivers', () {
      Pulse.register(mockReceiver);

      Pulse.emit('test_event', params: {'key': 'value'});

      expect(mockReceiver.receivedEvents, ['test_event']);
      expect(mockReceiver.receivedParams, [
        {'key': 'value'}
      ]);
    });

    test('emit() should respect shouldProcess filter', () {
      Pulse.register(mockReceiver);

      Pulse.emit('test_event');
      Pulse.emit('other_event');

      expect(mockReceiver.receivedEvents, ['test_event']);
    });

    test('emit() should handle multiple receivers', () {
      Pulse.register(mockReceiver);
      Pulse.register(mockReceiver2);

      Pulse.emit('test_event', params: {'key': 'value'});

      expect(mockReceiver.receivedEvents, ['test_event']);
      expect(mockReceiver2.receivedEvents, ['test_event']);
    });

    test('emit() should handle null params', () {
      Pulse.register(mockReceiver);

      Pulse.emit('test_event');

      expect(mockReceiver.receivedEvents, ['test_event']);
      expect(mockReceiver.receivedParams, [{}]);
    });

    test('shutdown() should shutdown all receivers', () {
      Pulse.register(mockReceiver);
      Pulse.register(mockReceiver2);

      Pulse.shutdown();

      expect(mockReceiver.wasShutdown, true);
      expect(mockReceiver2.wasShutdown, true);
    });

    // Clean up after each test
    tearDown(() {
      Pulse.shutdown();
      // Reset the singleton instance (you'll need to add this method to Pulse)
      // Pulse.reset();
    });
  });
}
