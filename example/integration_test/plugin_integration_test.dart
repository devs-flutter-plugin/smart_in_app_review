// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing


import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:smart_in_app_review/smart_in_app_review.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getPlatformVersion test', (WidgetTester tester) async {
    final String? version = await SmartInAppReview.platformVersion;
    // The version string depends on the host platform running the test, so
    // just assert that some non-empty string is returned.
    expect(version?.isNotEmpty, true);
  });

  testWidgets('canShow test', (WidgetTester tester) async {
    final SmartInAppReview plugin = SmartInAppReview();
    
    // Reset data first
    await plugin.reset();
    
    // Check initial state (should be false for new install)
    bool canShow = await plugin.canShow();
    expect(canShow, false);
    
    // Enable debug mode to bypass conditions
    plugin.setDebugMode(true);
    canShow = await plugin.canShow();
    expect(canShow, true);
  });

  testWidgets('force show test', (WidgetTester tester) async {
    final SmartInAppReview plugin = SmartInAppReview();
    
    // This should always return true if the platform supports it
    bool result = await plugin.forceShow();
    expect(result, isA<bool>());
  });
}
