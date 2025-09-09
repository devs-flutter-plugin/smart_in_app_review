# Smart In-App Review - Quick Start Guide

## 📋 Summary

**Smart In-App Review** is a modern Flutter plugin that intelligently shows app review prompts only when optimal conditions are met. Built with the latest Flutter standards and inspired by `advanced_in_app_review`, but with enhanced features and updated dependencies.

## 🚀 Key Improvements

### ✅ Updated Dependencies
- `in_app_review`: ^2.0.11 (latest)
- `shared_preferences`: ^2.5.3 (latest)
- `flutter_lints`: ^6.0.0 (latest)
- Flutter 3.22.0+ support
- Dart 3.9.0+ support

### ✅ Enhanced Features
- **Session Duration Tracking**: Monitor how long users spend in the app
- **Debug Mode**: Comprehensive logging and condition bypassing for testing
- **Lifecycle Awareness**: Proper handling of app resume/pause states
- **Modern API**: Clean, chainable configuration methods
- **Force Show**: Manual trigger for testing
- **Reset Functionality**: Clear all data for fresh testing
- **Condition Checking**: Verify if review would be shown

### ✅ Developer Experience
- Comprehensive documentation
- Multiple configuration examples
- Clean test suite
- Modern Dart/Flutter practices
- Type safety throughout

## 🛠 Basic Setup

### 1. Installation

```yaml
dependencies:
  smart_in_app_review: ^1.0.0
```

### 2. Android Configuration

Add to `android/app/build.gradle`:

```gradle
dependencies {
    implementation 'com.google.android.play:review:2.0.1'
    implementation 'com.google.android.play:review-ktx:2.0.1'
}
```

### 3. Basic Usage

```dart
import 'package:smart_in_app_review/smart_in_app_review.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    
    // Quick setup with smart defaults
    SmartInAppReview()
        .setMinLaunchTimes(3)          // After 3 app opens
        .setMinDaysAfterInstall(2)     // Wait 2 days after install
        .setMinDaysBeforeRemind(7)     // Wait 7 days between prompts
        .setMinSessionDuration(2)      // Require 2+ minutes in session
        .monitor();                    // Start monitoring
  }
  
  // Your app code...
}
```

## 📱 Configuration Examples

### Entertainment Apps (Games, Social)
```dart
SmartInAppReview()
    .setMinLaunchTimes(2)
    .setMinDaysAfterInstall(1)
    .setMinSessionDuration(1)
    .setMinDaysBeforeRemind(3)
    .monitor();
```

### Productivity Apps (Work Tools)
```dart
SmartInAppReview()
    .setMinLaunchTimes(5)
    .setMinDaysAfterInstall(7)
    .setMinSessionDuration(10)
    .setMinDaysBeforeRemind(30)
    .monitor();
```

### E-Commerce Apps
```dart
SmartInAppReview()
    .setMinLaunchTimes(3)
    .setMinDaysAfterInstall(3)
    .setMinSessionDuration(3)
    .setMinDaysBeforeRemind(14)
    .monitor();
```

## 🧪 Testing & Debug

### Enable Debug Mode
```dart
SmartInAppReview()
    .setDebugMode(true)  // Shows detailed logs, bypasses conditions
    .monitor();
```

### Force Show Review
```dart
// For testing or manual trigger
ElevatedButton(
  onPressed: () async {
    bool shown = await SmartInAppReview().forceShow();
    print('Review shown: $shown');
  },
  child: Text('Test Review'),
);
```

### Check Conditions
```dart
// See if review would be shown
bool canShow = await SmartInAppReview().canShow();
print('Ready for review: $canShow');
```

### Reset Data
```dart
// Clear all stored data for fresh testing
await SmartInAppReview().reset();
```

## 📊 Available Configuration Options

| Method | Description | Default | Recommended Range |
|--------|-------------|---------|-------------------|
| `setMinLaunchTimes(int)` | Minimum app launches | 3 | 1-10 |
| `setMinDaysAfterInstall(int)` | Days after installation | 3 | 1-14 |
| `setMinDaysBeforeRemind(int)` | Days between reminders | 7 | 3-30 |
| `setMinSecondsBeforeShowDialog(int)` | Delay before showing | 2 | 1-10 |
| `setMinSessionDuration(int)` | Session length (minutes) | 2 | 1-15 |
| `setDebugMode(bool)` | Enable debug features | false | - |

## 🎯 Best Practices

### ✅ Do's
- Configure based on your app's usage patterns
- Test thoroughly with debug mode enabled
- Prompt after positive user interactions
- Use longer delays for professional apps
- Monitor your app store ratings

### ❌ Don'ts
- Don't show on first launch
- Don't interrupt critical workflows
- Don't prompt after errors
- Don't spam users
- Don't ignore platform guidelines

## 🔧 Advanced Usage

### Manual Integration
```dart
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SmartInAppReview _reviewManager = SmartInAppReview();

  @override
  void initState() {
    super.initState();
    _setupReviewManager();
  }

  void _setupReviewManager() {
    _reviewManager
        .setMinLaunchTimes(3)
        .setMinDaysAfterInstall(2)
        .setMinSessionDuration(3)
        .setDebugMode(false)
        .monitor();
  }

  // Trigger after positive actions
  void _onUserAchievement() async {
    // User just completed something positive
    if (await _reviewManager.canShow()) {
      // Conditions are met, review will show automatically
      print('Review conditions met!');
    }
  }

  // Manual trigger for settings page
  void _onRateAppPressed() async {
    await _reviewManager.forceShow();
  }
}
```

## 📁 Project Structure

The plugin is organized as follows:

```
smart_in_app_review/
├── lib/
│   ├── smart_in_app_review.dart           # Main plugin class
│   └── smart_in_app_review_manager.dart   # Core logic and conditions
├── example/
│   ├── lib/
│   │   ├── main.dart                      # Complete example app
│   │   └── configuration_examples.dart    # Different config examples
├── test/
│   └── smart_in_app_review_test.dart     # Unit tests
├── android/                              # Android implementation
├── ios/                                  # iOS implementation
├── README.md                             # Full documentation
├── CHANGELOG.md                          # Version history
└── LICENSE                               # MIT License
```

## 🔍 Troubleshooting

### Common Issues

**Review not showing?**
1. Enable debug mode: `.setDebugMode(true)`
2. Check platform requirements (Android 5.0+, iOS 10.3+)
3. Verify Google Play Store is installed (Android)
4. Use `canShow()` to check conditions

**Testing problems?**
1. Use `forceShow()` for immediate testing
2. Use `reset()` to clear stored data
3. Enable debug mode for detailed logs
4. Android reviews don't show in debug builds

## 📚 Migration from advanced_in_app_review

If you're migrating from `advanced_in_app_review`:

### Old Code:
```dart
AdvancedInAppReview()
    .setMinDaysBeforeRemind(7)
    .setMinDaysAfterInstall(2)
    .setMinLaunchTimes(2)
    .setMinSecondsBeforeShowDialog(4)
    .monitor();
```

### New Code:
```dart
SmartInAppReview()
    .setMinLaunchTimes(2)
    .setMinDaysAfterInstall(2)
    .setMinDaysBeforeRemind(7)
    .setMinSecondsBeforeShowDialog(4)
    .setMinSessionDuration(2)  // New feature!
    .setDebugMode(false)       // New feature!
    .monitor();
```

### Key Changes:
- Import changed: `import 'package:smart_in_app_review/smart_in_app_review.dart';`
- Class name: `AdvancedInAppReview` → `SmartInAppReview`
- Added session duration tracking
- Added debug mode
- Added force show and reset methods
- Updated dependencies

## 🎉 That's It!

Your app now has intelligent review prompting that respects user experience while maximizing the chances of getting positive reviews. The plugin will automatically handle all the timing logic and only show reviews when conditions are optimal.

For more details, check the full README.md and example application.
