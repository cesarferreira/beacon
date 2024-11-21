import 'package:beacon/beacon_receiver.dart';

class DebugReceiver implements BeaconReceiver {
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
