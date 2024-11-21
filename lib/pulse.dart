library pulse;

import 'package:pulse/pulse_receiver.dart';

class Pulse {
  // Private static instance of Pulse
  static final Pulse _instance = Pulse._internal();

  // Factory constructor to return the singleton instance
  factory Pulse() => _instance;

  // Private constructor
  Pulse._internal();

  // List of registered receivers
  final List<PulseReceiver> _receivers = [];

  /// Registers a new receiver
  static void register(PulseReceiver receiver) {
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
