library beacon;

import 'package:beacon/beacon_receiver.dart';

class Beacon {
  // Private static instance of Beacon
  static final Beacon _instance = Beacon._internal();

  // Factory constructor to return the singleton instance
  factory Beacon() => _instance;

  // Private constructor
  Beacon._internal();

  // List of registered receivers
  final List<BeaconReceiver> _receivers = [];

  /// Registers a new receiver
  static void attach(BeaconReceiver receiver) {
    _instance._receivers.add(receiver);
    receiver.initialize();
  }

  /// Emits an analytics event
  static void emit(String eventName, {Map<String, dynamic>? params}) {
    for (var receiver in _instance._receivers) {
      if (receiver.shouldProcess(eventName)) {
        receiver.onEvent(eventName, params ?? {});
      }
    }
  }

  /// Shuts down all receivers
  static void shutdown() {
    for (var receiver in _instance._receivers) {
      receiver.shutdown();
    }
  }
}
