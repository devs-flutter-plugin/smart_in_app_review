
import 'dart:async';

import 'package:smart_in_app_review/smart_in_app_review_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Smart In-App Review Plugin
/// 
/// This plugin provides intelligent in-app review prompts that only show
/// after customizable conditions are met, improving user experience
/// and review quality.
class SmartInAppReview with WidgetsBindingObserver {
  static const MethodChannel _channel = MethodChannel('smart_in_app_review');
  final SmartInAppReviewManager _manager = SmartInAppReviewManager();

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Start monitoring conditions to decide whether a review attempt is made
  /// 
  /// This should be called in your app's initState() or main() function
  void monitor() {
    _manager.monitor();
    _startObserver();
  }

  /// Set minimum number of app launches before showing review dialog
  /// 
  /// [launchTimes] - Number of times the app needs to be opened (default: 3)
  SmartInAppReview setMinLaunchTimes(int launchTimes) {
    _manager.setMinLaunchTimes(launchTimes);
    return this;
  }

  /// Set minimum days after install before showing review dialog
  /// 
  /// [days] - Number of days to wait after installation (default: 3)
  SmartInAppReview setMinDaysAfterInstall(int days) {
    _manager.setMinDaysAfterInstall(days);
    return this;
  }

  /// Set minimum days between review prompts
  /// 
  /// [days] - Days to wait before showing another review prompt (default: 7)
  SmartInAppReview setMinDaysBeforeRemind(int days) {
    _manager.setMinDaysBeforeRemind(days);
    return this;
  }

  /// Set delay before showing review dialog after conditions are met
  /// 
  /// [seconds] - Seconds to wait before showing dialog (default: 2)
  SmartInAppReview setMinSecondsBeforeShowDialog(int seconds) {
    _manager.setMinSecondsBeforeShowDialog(seconds);
    return this;
  }

  /// Set minimum session duration before review can be shown
  /// 
  /// [minutes] - Minimum minutes user should spend in current session
  SmartInAppReview setMinSessionDuration(int minutes) {
    _manager.setMinSessionDuration(minutes);
    return this;
  }

  /// Enable debug mode for testing
  /// 
  /// [enabled] - Whether to enable debug logging and force show dialogs
  SmartInAppReview setDebugMode(bool enabled) {
    _manager.setDebugMode(enabled);
    return this;
  }

  /// Manually trigger review dialog (bypasses all conditions)
  /// 
  /// Use this for testing or when you want to force show the review
  Future<bool> forceShow() async {
    return await _manager.forceShowReview();
  }

  /// Reset all stored data (useful for testing)
  Future<void> reset() async {
    await _manager.reset();
  }

  /// Check if review dialog would be shown based on current conditions
  Future<bool> canShow() async {
    return await _manager.shouldShowRateDialog();
  }

  void _startObserver() {
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
    _afterLaunch();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _manager.onAppResumed();
        _afterLaunch();
        break;
      case AppLifecycleState.paused:
        _manager.onAppPaused();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _afterLaunch() {
    _manager.applicationWasLaunched();
    _manager.showRateDialogIfMeetsConditions();
  }

  /// This allows a value of type T or T?
  /// to be treated as a value of type T?.
  ///
  /// We use this so that APIs that have become
  /// non-nullable can still be used with `!` and `?`
  /// to support older versions of the API as well.
  T? _ambiguate<T>(T? value) => value;
}
