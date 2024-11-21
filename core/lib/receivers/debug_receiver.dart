import 'package:pulse/pulse_receiver.dart';

class DebugReceiver implements PulseReceiver {
  @override
  void initialize() {
    print("DebugReceiver initialized");
  }

  @override
  void shutdown() {
    print("DebugReceiver shutting down");
  }

  @override
  void onEvent(String eventName, Map<String, dynamic> params) {
    print("Debug Event: $eventName, Params: $params");
  }

  @override
  bool shouldProcess(String eventName) => true;
}
