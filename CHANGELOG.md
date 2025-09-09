# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-09-09

### Added

- 🎉 Initial release of Smart In-App Review plugin
- ⚙️ Configurable timing conditions for showing review dialogs
- 📱 Cross-platform support (iOS and Android)
- 🕐 Session duration tracking for better timing
- 🐛 Debug mode with detailed logging
- 🔄 Lifecycle-aware monitoring
- 🧪 Force show method for testing
- 🗑️ Reset functionality for testing
- 📊 Condition checking method
- 📚 Comprehensive documentation and examples

### Features

- **Smart Timing**: Multiple configurable conditions
  - Minimum launch times
  - Days after installation
  - Days between reminders
  - Session duration requirements
  - Configurable delays
- **Developer Experience**: Debug mode, force show, reset data
- **Modern Architecture**: Built with latest Flutter/Dart standards
- **Zero Dependencies**: Minimal external dependencies
- **Platform Integration**: Uses native review APIs

### Dependencies

- `flutter`: SDK
- `in_app_review`: ^2.0.9
- `shared_preferences`: ^2.3.2
- `plugin_platform_interface`: ^2.1.8

### Platform Support

- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 10.3+
- **Flutter**: 3.22.0+
- **Dart**: 3.9.0+
