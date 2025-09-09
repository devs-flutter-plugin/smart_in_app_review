import 'dart:developer' as developer;
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Smart In-App Review Manager
/// 
/// Handles all the logic for determining when to show review dialogs
/// based on various configurable conditions.
class SmartInAppReviewManager {
  static final SmartInAppReviewManager _singleton = SmartInAppReviewManager._internal();

  SmartInAppReviewManager._internal();

  // Shared Preferences Keys
  static const String _prefKeyInstallDate = "smart_in_app_review_install_date";
  static const String _prefKeyLaunchTimes = "smart_in_app_review_launch_times";
  static const String _prefKeyRemindInterval = "smart_in_app_review_remind_interval";
  static const String _prefKeySessionStart = "smart_in_app_review_session_start";
  static const String _prefKeyLastReviewShown = "smart_in_app_review_last_shown";

  // Default Configuration
  static int _minLaunchTimes = 3;
  static int _minDaysAfterInstall = 3;
  static int _minDaysBeforeRemind = 7;
  static int _minSecondsBeforeShowDialog = 2;
  static int _minSessionDurationMinutes = 2;
  static bool _debugMode = false;

  int? _sessionStartTime;

  factory SmartInAppReviewManager() {
    return _singleton;
  }

  /// Initialize monitoring
  void monitor() async {
    if (await _isFirstLaunch()) {
      _setInstallDate();
    }
    _startSession();
  }

  /// Called when app is launched
  void applicationWasLaunched() async {
    _setLaunchTimes(await _getLaunchTimes() + 1);
    _log('App launched. Total launches: ${await _getLaunchTimes()}');
  }

  /// Called when app is resumed
  void onAppResumed() {
    _startSession();
  }

  /// Called when app is paused
  void onAppPaused() {
    _endSession();
  }

  /// Show review dialog if all conditions are met
  Future<bool> showRateDialogIfMeetsConditions() async {
    bool shouldShow = await shouldShowRateDialog();
    if (shouldShow) {
      _log('All conditions met, showing review dialog in $_minSecondsBeforeShowDialog seconds');
      Future.delayed(Duration(seconds: _minSecondsBeforeShowDialog), () {
        _showDialog();
      });
    } else {
      _log('Conditions not met for showing review dialog');
    }
    return shouldShow;
  }

  /// Force show review dialog (bypass all conditions)
  Future<bool> forceShowReview() async {
    _log('Force showing review dialog');
    return await _showDialog();
  }

  /// Reset all stored data
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKeyInstallDate);
    await prefs.remove(_prefKeyLaunchTimes);
    await prefs.remove(_prefKeyRemindInterval);
    await prefs.remove(_prefKeySessionStart);
    await prefs.remove(_prefKeyLastReviewShown);
    _log('All data reset');
  }

  // Configuration Setters

  void setMinLaunchTimes(int times) {
    _minLaunchTimes = times;
    _log('Min launch times set to: $times');
  }

  void setMinDaysAfterInstall(int days) {
    _minDaysAfterInstall = days;
    _log('Min days after install set to: $days');
  }

  void setMinDaysBeforeRemind(int days) {
    _minDaysBeforeRemind = days;
    _log('Min days before remind set to: $days');
  }

  void setMinSecondsBeforeShowDialog(int seconds) {
    _minSecondsBeforeShowDialog = seconds;
    _log('Min seconds before show dialog set to: $seconds');
  }

  void setMinSessionDuration(int minutes) {
    _minSessionDurationMinutes = minutes;
    _log('Min session duration set to: $minutes minutes');
  }

  void setDebugMode(bool enabled) {
    _debugMode = enabled;
    _log('Debug mode ${enabled ? 'enabled' : 'disabled'}');
  }

  // Session Management

  void _startSession() {
    _sessionStartTime = DateTime.now().millisecondsSinceEpoch;
    _log('Session started');
  }

  void _endSession() {
    if (_sessionStartTime != null) {
      int sessionDuration = DateTime.now().millisecondsSinceEpoch - _sessionStartTime!;
      _log('Session ended. Duration: ${sessionDuration ~/ 1000} seconds');
    }
    _sessionStartTime = null;
  }

  int _getCurrentSessionDuration() {
    if (_sessionStartTime == null) return 0;
    return DateTime.now().millisecondsSinceEpoch - _sessionStartTime!;
  }

  // Dialog Display

  Future<bool> _showDialog() async {
    try {
      final InAppReview inAppReview = InAppReview.instance;
      
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
        await _setLastReviewShown();
        await _setRemindTimestamp();
        _log('Review dialog shown successfully');
        return true;
      } else {
        _log('In-app review not available');
        return false;
      }
    } catch (e) {
      _log('Error showing review dialog: $e');
      return false;
    }
  }

  // Condition Checkers

  /// Check if review dialog should be shown based on all conditions
  Future<bool> shouldShowRateDialog() async {
    if (_debugMode) {
      _log('Debug mode enabled - bypassing conditions');
      return true;
    }

    bool overLaunchTimes = await _isOverLaunchTimes();
    bool overInstallDate = await _isOverInstallDate();
    bool overRemindDate = await _isOverRemindDate();
    bool validSessionDuration = _isValidSessionDuration();

    _log('Condition check:');
    _log('- Launch times: $overLaunchTimes (${await _getLaunchTimes()}/$_minLaunchTimes)');
    _log('- Install date: $overInstallDate');
    _log('- Remind date: $overRemindDate');
    _log('- Session duration: $validSessionDuration');

    return overLaunchTimes && overInstallDate && overRemindDate && validSessionDuration;
  }

  Future<bool> _isOverLaunchTimes() async {
    return await _getLaunchTimes() >= _minLaunchTimes;
  }

  Future<bool> _isOverInstallDate() async {
    return _isOverDate(await _getInstallTimestamp(), _minDaysAfterInstall);
  }

  Future<bool> _isOverRemindDate() async {
    return _isOverDate(await _getRemindTimestamp(), _minDaysBeforeRemind);
  }

  bool _isValidSessionDuration() {
    int currentDuration = _getCurrentSessionDuration();
    int requiredDuration = _minSessionDurationMinutes * 60 * 1000; // Convert to milliseconds
    return currentDuration >= requiredDuration;
  }

  // Date Helpers

  bool _isOverDate(int targetDate, int thresholdDays) {
    if (targetDate == 0) return true; // No date set means condition is met
    int timeDiff = DateTime.now().millisecondsSinceEpoch - targetDate;
    int thresholdMs = thresholdDays * 24 * 60 * 60 * 1000;
    return timeDiff >= thresholdMs;
  }

  // SharedPreferences Helpers

  Future<bool> _isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return !prefs.containsKey(_prefKeyInstallDate);
  }

  Future<int> _getInstallTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_prefKeyInstallDate) ?? 0;
  }

  Future<void> _setInstallDate() async {
    final prefs = await SharedPreferences.getInstance();
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_prefKeyInstallDate, timestamp);
    _log('Install date set: ${DateTime.fromMillisecondsSinceEpoch(timestamp)}');
  }

  Future<int> _getLaunchTimes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_prefKeyLaunchTimes) ?? 0;
  }

  Future<void> _setLaunchTimes(int launchTimes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKeyLaunchTimes, launchTimes);
  }

  Future<int> _getRemindTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_prefKeyRemindInterval) ?? 0;
  }

  Future<void> _setRemindTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_prefKeyRemindInterval, timestamp);
    _log('Remind timestamp set: ${DateTime.fromMillisecondsSinceEpoch(timestamp)}');
  }

  Future<void> _setLastReviewShown() async {
    final prefs = await SharedPreferences.getInstance();
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_prefKeyLastReviewShown, timestamp);
    _log('Last review shown timestamp set: ${DateTime.fromMillisecondsSinceEpoch(timestamp)}');
  }

  // Logging

  void _log(String message) {
    if (_debugMode) {
      developer.log('[SmartInAppReview] $message');
    }
  }
}
