// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelcy_local_auth/auth_strings.dart';
import 'package:kelcy_local_auth/local_auth.dart';
import 'package:platform/platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalAuth', () {
    const MethodChannel channel = MethodChannel(
      'plugins.flutter.io/local_auth',
    );

    final List<MethodCall> log = <MethodCall>[];
    late LocalAuthentication localAuthentication;

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) {
        log.add(methodCall);
        return Future<dynamic>.value(true);
      });
      localAuthentication = LocalAuthentication();
      log.clear();
    });

    group("With device auth fail over", () {
      test('authenticate with no args on Android.', () async {
        setMockPathProviderPlatform(FakePlatform(operatingSystem: 'android'));
        await localAuthentication.authenticate(
          localizedReason: 'Needs secure',
          biometricOnly: true,
        );
        expect(
          log,
          <Matcher>[
            isMethodCall('authenticate',
                arguments: <String, dynamic>{
                  'localizedReason': 'Needs secure',
                  'useErrorDialogs': true,
                  'stickyAuth': false,
                  'sensitiveTransaction': true,
                  'biometricOnly': true,
                  'strongAuthenticatorsOnly': false,
                }..addAll(const AndroidAuthMessages().args)),
          ],
        );
      });

      test('authenticate with no sensitive transaction.', () async {
        setMockPathProviderPlatform(FakePlatform(operatingSystem: 'android'));
        await localAuthentication.authenticate(
          localizedReason: 'Insecure',
          sensitiveTransaction: false,
          useErrorDialogs: false,
          biometricOnly: true,
        );
        expect(
          log,
          <Matcher>[
            isMethodCall('authenticate',
                arguments: <String, dynamic>{
                  'localizedReason': 'Insecure',
                  'useErrorDialogs': false,
                  'stickyAuth': false,
                  'sensitiveTransaction': false,
                  'biometricOnly': true,
                  'strongAuthenticatorsOnly': false,
                }..addAll(const AndroidAuthMessages().args)),
          ],
        );
      });
    });

    group("With biometrics only", () {
      test('authenticate with no args on Android.', () async {
        setMockPathProviderPlatform(FakePlatform(operatingSystem: 'android'));
        await localAuthentication.authenticate(
          localizedReason: 'Needs secure',
        );
        expect(
          log,
          <Matcher>[
            isMethodCall('authenticate',
                arguments: <String, dynamic>{
                  'localizedReason': 'Needs secure',
                  'useErrorDialogs': true,
                  'stickyAuth': false,
                  'sensitiveTransaction': true,
                  'biometricOnly': false,
                  'strongAuthenticatorsOnly': false,
                }..addAll(const AndroidAuthMessages().args)),
          ],
        );
      });

      test('authenticate with no sensitive transaction.', () async {
        setMockPathProviderPlatform(FakePlatform(operatingSystem: 'android'));
        await localAuthentication.authenticate(
          localizedReason: 'Insecure',
          sensitiveTransaction: false,
          useErrorDialogs: false,
        );
        expect(
          log,
          <Matcher>[
            isMethodCall('authenticate',
                arguments: <String, dynamic>{
                  'localizedReason': 'Insecure',
                  'useErrorDialogs': false,
                  'stickyAuth': false,
                  'sensitiveTransaction': false,
                  'biometricOnly': false,
                  'strongAuthenticatorsOnly': false,
                }..addAll(const AndroidAuthMessages().args)),
          ],
        );
      });

      test('authenticate with strong authenticators.', () async {
        setMockPathProviderPlatform(FakePlatform(operatingSystem: 'android'));
        await localAuthentication.authenticate(
          localizedReason: 'Insecure',
          sensitiveTransaction: false,
          useErrorDialogs: false,
          strongAuthenticatorsOnly: true,
        );
        expect(
          log,
          <Matcher>[
            isMethodCall('authenticate',
                arguments: <String, dynamic>{
                  'localizedReason': 'Insecure',
                  'useErrorDialogs': false,
                  'stickyAuth': false,
                  'sensitiveTransaction': false,
                  'biometricOnly': false,
                  'strongAuthenticatorsOnly': true,
                }..addAll(const AndroidAuthMessages().args)),
          ],
        );
      });
    });
  });
}
