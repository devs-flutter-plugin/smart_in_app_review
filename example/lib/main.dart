import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:smart_in_app_review/smart_in_app_review.dart';
import 'configuration_examples.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _canShowReview = false;
  final SmartInAppReview _smartInAppReview = SmartInAppReview();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    setupSmartReview();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await SmartInAppReview.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void setupSmartReview() {
    // Configure and start monitoring
    _smartInAppReview
        .setMinLaunchTimes(2) // Show after 2 launches
        .setMinDaysAfterInstall(1) // Show after 1 day of installation
        .setMinDaysBeforeRemind(3) // Wait 3 days between reminders
        .setMinSecondsBeforeShowDialog(2) // Wait 2 seconds before showing
        .setMinSessionDuration(1) // Require at least 1 minute in session
        .setDebugMode(true) // Enable for testing
        .monitor();

    // Check if can show review
    _checkCanShowReview();
  }

  Future<void> _checkCanShowReview() async {
    bool canShow = await _smartInAppReview.canShow();
    setState(() {
      _canShowReview = canShow;
    });
  }

  Future<void> _forceShowReview() async {
    bool result = await _smartInAppReview.forceShow();
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result ? 'Review dialog shown!' : 'Review not available'),
      ),
    );
  }

  Future<void> _resetData() async {
    await _smartInAppReview.reset();
    await _checkCanShowReview();
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data reset!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Smart In-App Review Example'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Platform Version',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(_platformVersion),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Review Status',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            _canShowReview ? Icons.check_circle : Icons.cancel,
                            color: _canShowReview ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _canShowReview 
                                ? 'Ready to show review' 
                                : 'Conditions not met',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _forceShowReview,
                icon: const Icon(Icons.rate_review),
                label: const Text('Force Show Review'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _checkCanShowReview,
                icon: const Icon(Icons.refresh),
                label: const Text('Check Status'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _resetData,
                icon: const Icon(Icons.delete),
                label: const Text('Reset Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ConfigurationExample(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
                label: const Text('Configuration Examples'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Configuration',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('• Min launches: 2'),
                      const Text('• Min days after install: 1'),
                      const Text('• Min days before remind: 3'),
                      const Text('• Min session duration: 1 minute'),
                      const Text('• Debug mode: Enabled'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
