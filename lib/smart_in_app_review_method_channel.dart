import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'smart_in_app_review_platform_interface.dart';

/// An implementation of [SmartInAppReviewPlatform] that uses method channels.
class MethodChannelSmartInAppReview extends SmartInAppReviewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('smart_in_app_review');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
