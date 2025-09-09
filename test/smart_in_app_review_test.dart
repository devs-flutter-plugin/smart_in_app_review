import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:smart_in_app_review/smart_in_app_review.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SmartInAppReview', () {
    late SmartInAppReview smartInAppReview;

    setUp(() {
      smartInAppReview = SmartInAppReview();
    });

    test('should be instantiated', () {
      expect(smartInAppReview, isNotNull);
    });

    test('should allow method chaining for configuration', () {
      final configured = smartInAppReview
          .setMinLaunchTimes(5)
          .setMinDaysAfterInstall(7)
          .setMinDaysBeforeRemind(14)
          .setMinSessionDuration(10)
          .setDebugMode(true);

      expect(configured, isA<SmartInAppReview>());
      expect(configured, equals(smartInAppReview));
    });

    test('should call monitor method without throwing', () {
      // This should not throw an exception during configuration
      expect(() => smartInAppReview.monitor(), returnsNormally);
    });

    test('configuration methods should return SmartInAppReview instance', () {
      expect(smartInAppReview.setMinLaunchTimes(5), isA<SmartInAppReview>());
      expect(smartInAppReview.setMinDaysAfterInstall(3), isA<SmartInAppReview>());
      expect(smartInAppReview.setMinDaysBeforeRemind(7), isA<SmartInAppReview>());
      expect(smartInAppReview.setMinSessionDuration(2), isA<SmartInAppReview>());
      expect(smartInAppReview.setDebugMode(true), isA<SmartInAppReview>());
    });
  });

  group('SmartInAppReview Static Methods', () {
    test('platformVersion should handle method channel calls', () async {
      // Mock the platform channel
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('smart_in_app_review'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'getPlatformVersion') {
            return 'Android 12';
          }
          return null;
        },
      );

      final version = await SmartInAppReview.platformVersion;
      expect(version, equals('Android 12'));
    });

    test('platformVersion should handle null response', () async {
      // Mock the platform channel to return null
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('smart_in_app_review'),
        (MethodCall methodCall) async {
          return null;
        },
      );

      final version = await SmartInAppReview.platformVersion;
      expect(version, isNull);
    });
  });
}
