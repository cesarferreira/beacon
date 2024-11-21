# **📡 Beacon**

<!-- <p align="center">
  <img src="assets/lighthouse.jpg" alt="Beacon Lighthouse" width="100%"/>
</p> -->

> A lightweight and extensible Flutter library for managing and logging analytics events.

---

## 🚀 **Features**

- 📦 **Plug-and-Play Analytics**: Easily integrate multiple analytics platforms like Mixpanel, Firebase, or custom solutions.
- 🌐 **Extensible**: Add your own custom receivers for any analytics provider.
- ⚡ **Asynchronous**: Non-blocking event logging ensures smooth app performance.
- 🛠 **Customizable**: Filter events, add default parameters, and transform data effortlessly.
- ✅ **Lifecycle Management**: Initialize and shutdown receivers cleanly.

## Packages

### Core Library
- [`beacon`](./core): Core library for event management.

### Integrations
- [`beacon_mixpanel`](./integrations/beacon_mixpanel): Mixpanel integration.
- [`beacon_firebase`](./integrations/beacon_firebase): Firebase integration.
- [`beacon_amplitude`](./integrations/beacon_amplitude): Amplitude integration.

### Example App
- [`example`](./example): Demo app showcasing the usage of Beacon.

---

## 📖 **Getting Started**

### Installation

Add `beacon` to your `pubspec.yaml` file:

```yaml
dependencies:
  beacon: ^1.0.0
```

Then, fetch the package:

```bash
flutter pub get
```

---

## 🛠 **Usage**

### Step 1: Import Beacon

```dart
import 'package:beacon/beacon.dart';
```

### Step 2: Register Analytics Receivers

Add your desired analytics platforms during app initialization:

```dart
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

void main() async {
  // Initialize Mixpanel
  final mixpanel = await Mixpanel.init('YOUR_MIXPANEL_PROJECT_TOKEN');

  // Register receivers
  Beacon.attach(MixpanelReceiver(
    mixpanel: mixpanel,
    defaultParams: {
      'app_version': '1.0.0',
      'platform': 'Flutter',
    },
  ));

  // Optionally, add a debug receiver for testing
  Beacon.attach(DebugReceiver());

  runApp(MyApp());
}
```

### Step 3: Emit Events

Log analytics events anywhere in your app:

```dart
Beacon.emit('button_click', params: {'button_name': 'example_button'});

Beacon.emit('purchase', params: {
  'item_id': '12345',
  'price': 19.99,
  'currency': 'USD',
});
```

### Step 4: Clean Up (Optional)

Shut down all receivers when the app exits:

```dart
@override
void dispose() {
  Beacon.shutdown();
  super.dispose();
}
```

---

## 📦 **Receivers**

Beacon uses **receivers** to handle events for different analytics platforms.

### Built-in Receivers

#### MixpanelReceiver

Logs events to Mixpanel:

```dart
Beacon.attach(MixpanelReceiver(
  mixpanel: mixpanel,
  defaultParams: {
    'app_version': '1.0.0',
    'platform': 'Flutter',
  },
));
```

#### DebugReceiver

Logs events to the console for debugging:

```dart
Beacon.attach(DebugReceiver());
```

### Creating Custom Receivers

Implement the `BeaconReceiver` interface to create your own receiver:

```dart
class MyCustomReceiver implements BeaconReceiver {
  @override
  void initialize() {
    print("Custom receiver initialized");
  }

  @override
  void shutdown() {
    print("Custom receiver shutting down");
  }

  @override
  bool shouldProcess(String eventName) {
    return !eventName.startsWith('debug_');
  }

  @override
  void onEvent(String eventName, Map<String, dynamic> params) {
    print("Custom Event: $eventName, Params: $params");
  }
}
```

Register it like any other receiver:

```dart
Beacon.attach(MyCustomReceiver());
```

---

## 🧪 **Testing**

Run the following command to test the library:

```bash
flutter test
```

Example unit test for `Beacon`:

```dart
void main() {
  test('Beacon logs events to all registered receivers', () {
    final debugReceiver = DebugReceiver();
    Beacon.attach(debugReceiver);

    expect(() => Beacon.emit('test_event'), prints(contains('test_event')));
  });
}
```

---

## 📖 **API Reference**

### `Beacon` Methods

| Method           | Description                                             |
|-------------------|---------------------------------------------------------|
| `register()`      | Registers a new analytics receiver.                    |
| `emit()`          | Logs an event to all registered receivers.             |
| `shutdown()`      | Cleans up resources for all receivers.                 |

### `BeaconReceiver` Interface

| Method           | Description                                             |
|-------------------|---------------------------------------------------------|
| `initialize()`    | Initializes the receiver.                              |
| `shutdown()`      | Cleans up the receiver when no longer needed.          |
| `shouldProcess()` | Filters events; return `false` to skip specific events. |
| `onEvent()`       | Handles the analytics event.                           |

---

## 📜 **Changelog**

See [CHANGELOG.md](CHANGELOG.md) for details on updates and new features.

---

## 🛡 **License**

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 🙌 **Contributing**

We welcome contributions! Here's how you can help:

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature-name`.
3. Commit your changes: `git commit -m 'Add new feature'`.
4. Push to the branch: `git push origin feature-name`.
5. Open a pull request.

---

## 📫 **Contact**

For questions or suggestions, feel free to reach out:

- **GitHub**: [Beacon on GitHub](https://github.com/cesarferreira/beacon)
- **Twitter**: [@cesarmcferreira](https://twitter.com/cesarmcferreira)

---

## 🔗 **Resources**

- [Mixpanel Documentation](https://developer.mixpanel.com/docs/flutter)
- [Firebase Analytics](https://firebase.google.com/docs/analytics)
- [Flutter Packages](https://pub.dev)

