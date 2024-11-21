import 'package:flutter_test/flutter_test.dart';


import 'package:pulse/pulse_receiver.dart';

// Mock implementation of PulseReceiver for testing
class MockPulseReceiver extends PulseReceiver {
  bool wasInitialized = false;
  bool wasShutdown = false;
  List<String> processedEvents = [];
  List<Map<String, dynamic>> processedParams = [];

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
    // Only process events that start with 'test_'
    return eventName.startsWith('test_');
  }

  @override
  void onEvent(String eventName, Map<String, dynamic> params) {
    processedEvents.add(eventName);
    processedParams.add(params);
  }
}

void main() {
  group('PulseReceiver', () {
    late MockPulseReceiver receiver;

    setUp(() {
      receiver = MockPulseReceiver();
    });

    test('initialize() should mark receiver as initialized', () {
      receiver.initialize();
      expect(receiver.wasInitialized, true);
    });

    test('shutdown() should mark receiver as shutdown', () {
      receiver.shutdown();
      expect(receiver.wasShutdown, true);
    });

    test('shouldProcess() should only accept events with correct prefix', () {
      expect(receiver.shouldProcess('test_event'), true);
      expect(receiver.shouldProcess('other_event'), false);
    });

    test('onEvent() should store event and parameters', () {
      final testParams = {'key': 'value'};

      receiver.onEvent('test_event', testParams);

      expect(receiver.processedEvents, ['test_event']);
      expect(receiver.processedParams, [testParams]);
    });

    test('onEvent() can handle multiple events', () {
      receiver.onEvent('test_event1', {'key1': 'value1'});
      receiver.onEvent('test_event2', {'key2': 'value2'});

      expect(receiver.processedEvents, ['test_event1', 'test_event2']);
      expect(receiver.processedParams, [
        {'key1': 'value1'},
        {'key2': 'value2'}
      ]);
    });
  });
}
