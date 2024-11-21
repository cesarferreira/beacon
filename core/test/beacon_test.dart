import 'package:beacon/beacon.dart';
import 'package:beacon/beacon_receiver.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock receiver for testing
class MockReceiver extends BeaconReceiver {
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
      final instance1 = Beacon();
      final instance2 = Beacon();
      expect(identical(instance1, instance2), true);
    });

    test('register() should initialize receiver', () {
      Beacon.attach(mockReceiver);
      expect(mockReceiver.wasInitialized, true);
    });

    test('emit() should send events to registered receivers', () {
      Beacon.attach(mockReceiver);

      Beacon.emit('test_event', params: {'key': 'value'});

      expect(mockReceiver.receivedEvents, ['test_event']);
      expect(mockReceiver.receivedParams, [
        {'key': 'value'}
      ]);
    });

    test('emit() should respect shouldProcess filter', () {
      Beacon.attach(mockReceiver);

      Beacon.emit('test_event');
      Beacon.emit('other_event');

      expect(mockReceiver.receivedEvents, ['test_event']);
    });

    test('emit() should handle multiple receivers', () {
      Beacon.attach(mockReceiver);
      Beacon.attach(mockReceiver2);

      Beacon.emit('test_event', params: {'key': 'value'});

      expect(mockReceiver.receivedEvents, ['test_event']);
      expect(mockReceiver2.receivedEvents, ['test_event']);
    });

    test('emit() should handle null params', () {
      Beacon.attach(mockReceiver);

      Beacon.emit('test_event');

      expect(mockReceiver.receivedEvents, ['test_event']);
      expect(mockReceiver.receivedParams, [{}]);
    });

    test('shutdown() should shutdown all receivers', () {
      Beacon.attach(mockReceiver);
      Beacon.attach(mockReceiver2);

      Beacon.shutdown();

      expect(mockReceiver.wasShutdown, true);
      expect(mockReceiver2.wasShutdown, true);
    });

    // Clean up after each test
    tearDown(() {
      Beacon.shutdown();
      // Reset the singleton instance (you'll need to add this method to Pulse)
      // Pulse.reset();
    });
  });
}
