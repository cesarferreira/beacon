abstract class BeaconReceiver {
  // Initialize the receiver
  void initialize() {}

  // Shutdown the receiver
  void shutdown() {}

  // Check if the event should be processed
  bool shouldProcess(String eventName) => true;

  // Handle the event
  void onEvent(String eventName, Map<String, dynamic> params);
}
