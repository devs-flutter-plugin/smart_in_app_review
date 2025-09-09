# Smart In-App Review

![Pub Version](https://img.shields.io/pub/v/smart_in_app_review)
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

A smart Flutter plugin that intelligently prompts users for app reviews at the optimal time, leading to higher quality reviews and better app store ratings.

## 🌟 Features

- **Smart Timing**: Only shows review prompts when multiple conditions are met
- **Highly Configurable**: Customize all timing parameters to fit your app
- **Session Awareness**: Tracks user session duration for better timing
- **Debug Support**: Built-in debug mode for testing
- **Cross-Platform**: Works on both iOS and Android
- **Modern Architecture**: Built with latest Flutter and Dart standards
- **Zero Interruption**: Never interrupts critical user flows

## 🚀 Why Smart In-App Review?

The average user only writes a review when something is wrong with your app, leading to unfairly negative ratings. Smart In-App Review solves this by:

1. **Waiting for the right moment**: Only prompting satisfied users
2. **Respecting user experience**: Never interrupting important tasks
3. **Learning from usage**: Tracking meaningful engagement metrics
4. **Following best practices**: Implementing platform-specific guidelines

## 📱 Platform Support

| Platform | Support | Native API |
|----------|---------|------------|
| Android | ✅ | [Play In-App Review](https://developer.android.com/guide/playcore/in-app-review) |
| iOS | ✅ | [SKStoreReviewController](https://developer.apple.com/documentation/storekit/skstorereviewcontroller) |

### Requirements

- **Android**: API level 21+ (Android 5.0+) with Google Play Store
- **iOS**: iOS 10.3+
- **Flutter**: 3.22.0+
- **Dart**: 3.9.0+

## 🛠 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  smart_in_app_review: ^1.0.0
```

Then run:

```bash
flutter pub get
```

### Android Setup

Add the following to your app's `android/app/build.gradle`:

```gradle
dependencies {
    implementation 'com.google.android.play:review:2.0.1'
    implementation 'com.google.android.play:review-ktx:2.0.1'
}
```

## 📖 Usage

### Basic Setup

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
    
    // Simple one-line setup with smart defaults
    SmartInAppReview()
        .setMinLaunchTimes(3)
        .setMinDaysAfterInstall(2)
        .setMinDaysBeforeRemind(7)
        .setMinSessionDuration(2)
        .monitor();
  }
  
  // ... rest of your app
}
```

### Advanced Configuration

```dart
SmartInAppReview smartReview = SmartInAppReview();

// Configure all parameters
smartReview
    .setMinLaunchTimes(5)              // Wait for 5 app launches
    .setMinDaysAfterInstall(3)         // Wait 3 days after installation
    .setMinDaysBeforeRemind(14)        // Wait 14 days between prompts
    .setMinSecondsBeforeShowDialog(3)  // Delay 3 seconds before showing
    .setMinSessionDuration(5)          // Require 5+ minutes in session
    .setDebugMode(false)               // Disable debug mode
    .monitor();

// Check if conditions are met
bool canShow = await smartReview.canShow();

// Force show for testing
await smartReview.forceShow();

// Reset all data
await smartReview.reset();
```

### Manual Triggering

```dart
// For premium features, achievements, or positive interactions
void onUserAccomplishment() async {
  SmartInAppReview smartReview = SmartInAppReview();
  
  if (await smartReview.canShow()) {
    // Conditions are met, will show after configured delay
  }
}

// Force show (bypasses all conditions)
ElevatedButton(
  onPressed: () => SmartInAppReview().forceShow(),
  child: Text('Rate App'),
);
```

## ⚙️ Configuration Options

| Method | Description | Default | Range |
|--------|-------------|---------|-------|
| `setMinLaunchTimes(int)` | Minimum app launches required | 3 | 1-100 |
| `setMinDaysAfterInstall(int)` | Days to wait after installation | 3 | 0-365 |
| `setMinDaysBeforeRemind(int)` | Days between review prompts | 7 | 1-365 |
| `setMinSecondsBeforeShowDialog(int)` | Delay before showing dialog | 2 | 0-60 |
| `setMinSessionDuration(int)` | Required session length (minutes) | 2 | 0-60 |
| `setDebugMode(bool)` | Enable debug logging | false | - |

## 🧪 Testing

### Debug Mode

Enable debug mode to see detailed logs and bypass timing conditions:

```dart
SmartInAppReview()
    .setDebugMode(true)
    .monitor();
```

### Force Show

Use `forceShow()` to test the review dialog immediately:

```dart
// In a test button
ElevatedButton(
  onPressed: () async {
    bool shown = await SmartInAppReview().forceShow();
    print('Review dialog shown: $shown');
  },
  child: Text('Test Review'),
);
```

### Reset Data

Clear all stored data for fresh testing:

```dart
await SmartInAppReview().reset();
```

## 📊 Best Practices

### ✅ Do's

- **Configure based on your app's usage patterns**
- **Test thoroughly with debug mode**
- **Prompt after positive user interactions**
- **Respect the user's choice (don't spam)**
- **Use longer delays for productivity apps**

### ❌ Don'ts

- **Don't show immediately on app launch**
- **Don't interrupt critical user flows**
- **Don't show after errors or crashes**
- **Don't ask too frequently**
- **Don't bypass platform guidelines**

### Recommended Configurations

#### Quick Entertainment Apps
```dart
SmartInAppReview()
    .setMinLaunchTimes(2)
    .setMinDaysAfterInstall(1)
    .setMinSessionDuration(1)
    .monitor();
```

#### Productivity Apps
```dart
SmartInAppReview()
    .setMinLaunchTimes(5)
    .setMinDaysAfterInstall(7)
    .setMinSessionDuration(10)
    .setMinDaysBeforeRemind(30)
    .monitor();
```

#### Gaming Apps
```dart
SmartInAppReview()
    .setMinLaunchTimes(3)
    .setMinDaysAfterInstall(2)
    .setMinSessionDuration(5)
    .monitor();
```

## 🔍 API Reference

### Methods

#### Configuration Methods
- `setMinLaunchTimes(int launchTimes)` → `SmartInAppReview`
- `setMinDaysAfterInstall(int days)` → `SmartInAppReview`
- `setMinDaysBeforeRemind(int days)` → `SmartInAppReview`
- `setMinSecondsBeforeShowDialog(int seconds)` → `SmartInAppReview`
- `setMinSessionDuration(int minutes)` → `SmartInAppReview`
- `setDebugMode(bool enabled)` → `SmartInAppReview`

#### Control Methods
- `monitor()` → `void` - Start monitoring conditions
- `canShow()` → `Future<bool>` - Check if conditions are met
- `forceShow()` → `Future<bool>` - Force show review dialog
- `reset()` → `Future<void>` - Reset all stored data

#### Static Methods
- `SmartInAppReview.platformVersion` → `Future<String?>` - Get platform version

## 🐛 Troubleshooting

### Review Dialog Not Showing

1. **Check platform requirements** (Android 5.0+, iOS 10.3+)
2. **Verify Google Play Store is installed** (Android)
3. **Review not available in debug mode** (Android limitation)
4. **Enable debug mode** to see condition status
5. **Use `canShow()` method** to check conditions

### Debug Information

```dart
SmartInAppReview smartReview = SmartInAppReview()
    .setDebugMode(true);

bool canShow = await smartReview.canShow();
print('Can show review: $canShow');

// Check individual conditions in logs
```

## 📄 Platform Notes

### Android

- Review dialogs may not appear in debug builds
- Google Play Store must be installed
- System decides whether to show the dialog
- Testing requires release builds or internal testing

### iOS

- System limits frequency of review prompts
- User can disable review prompts in Settings
- Testing works in debug mode

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by [advanced_in_app_review](https://github.com/eeoom/advanced_in_app_review)
- Built on [in_app_review](https://pub.dev/packages/in_app_review)
- Uses [shared_preferences](https://pub.dev/packages/shared_preferences)

---

**Made with ❤️ for the Flutter community**_review

A new Flutter plugin project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/to/develop-plugins),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

