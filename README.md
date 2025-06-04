# kelcy_local_auth

An Android-only Flutter plugin for local authentication using biometrics (fingerprint, face) or device credentials (PIN, pattern, password). This is a modified version of the original `local_auth` plugin, specifically tailored for Android-only use.

## Features

*   Authenticate using biometrics or device credentials on Android.
*   Check if biometrics are available on the device.
*   Customizable authentication messages.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  kelcy_local_auth:
    git:
      url: https://github.com/kelcyazef/kelcy_local_auth.git # Or path: if local
      # ref: <branch_name_or_tag>
```

Then run `flutter pub get`.

*(Note: Once published to pub.dev, the installation will be simpler, e.g., `kelcy_local_auth: ^1.0.0`)*

## Usage

```dart
import 'package:kelcy_local_auth/local_auth.dart';
import 'package:flutter/services.dart';

final LocalAuthentication auth = LocalAuthentication();

Future<void> _authenticate() async {
  bool authenticated = false;
  try {
    authenticated = await auth.authenticate(
      localizedReason: 'Please authenticate to show account balance',
      useErrorDialogs: true,
      stickyAuth: true,
      // androidAuthStrings: const AndroidAuthMessages(biometricHint: '') // Optional
    );
  } on PlatformException catch (e) {
    print(e);
    // Handle error
    return;
  }
  if (!mounted) return;

  final String message = authenticated ? 'Authorized' : 'Not Authorized';
  // Use the result
}

// You can also check for available biometrics:
// List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

// Or check if the device can check biometrics:
// bool canCheckBiometrics = await auth.canCheckBiometrics;
```

## Android Configuration

Update your `android/app/src/main/AndroidManifest.xml` to include the `USE_FINGERPRINT` (deprecated but still needed for older SDKs) or `USE_BIOMETRIC` permission:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.app">
    <uses-permission android:name="android.permission.USE_BIOMETRIC" />
    <!-- <uses-permission android:name="android.permission.USE_FINGERPRINT" /> -->
    <application ...>
</manifest>
```

Also, ensure your `MainActivity.java` (or `MainActivity.kt`) extends `FlutterFragmentActivity` as described in the Flutter documentation for plugins that require FragmentActivity.

```java
// In android/app/src/main/java/your/package/name/MainActivity.java
import io.flutter.embedding.android.FlutterFragmentActivity;

public class MainActivity extends FlutterFragmentActivity {
    // ...
}
```

## Issues and contributions

Please file issues and pull requests on the [repository](https://github.com/kelcyazef/kelcy_local_auth).
