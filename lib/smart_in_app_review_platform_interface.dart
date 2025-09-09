import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'smart_in_app_review_method_channel.dart';

abstract class SmartInAppReviewPlatform extends PlatformInterface {
  /// Constructs a SmartInAppReviewPlatform.
  SmartInAppReviewPlatform() : super(token: _token);

  static final Object _token = Object();

  static SmartInAppReviewPlatform _instance = MethodChannelSmartInAppReview();

  /// The default instance of [SmartInAppReviewPlatform] to use.
  ///
  /// Defaults to [MethodChannelSmartInAppReview].
  static SmartInAppReviewPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SmartInAppReviewPlatform] when
  /// they register themselves.
  static set instance(SmartInAppReviewPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
