import 'package:flutter/material.dart';
import 'package:smart_in_app_review/smart_in_app_review.dart';

/// Different configuration examples for various app types
class SmartReviewExamples {
  
  /// Configuration for quick entertainment apps (games, social media)
  static void setupForEntertainmentApp() {
    SmartInAppReview()
        .setMinLaunchTimes(2)          // Show after just 2 launches
        .setMinDaysAfterInstall(1)     // Show after 1 day
        .setMinSessionDuration(1)      // Require 1 minute session
        .setMinDaysBeforeRemind(3)     // Wait 3 days between prompts
        .setMinSecondsBeforeShowDialog(2)
        .monitor();
  }

  /// Configuration for productivity apps (work tools, utilities)
  static void setupForProductivityApp() {
    SmartInAppReview()
        .setMinLaunchTimes(5)          // Wait for more usage
        .setMinDaysAfterInstall(7)     // Give users time to integrate
        .setMinSessionDuration(10)     // Require substantial usage
        .setMinDaysBeforeRemind(30)    // Don't bother frequently
        .setMinSecondsBeforeShowDialog(3)
        .monitor();
  }

  /// Configuration for e-commerce apps
  static void setupForECommerceApp() {
    SmartInAppReview()
        .setMinLaunchTimes(3)          // After browsing a few times
        .setMinDaysAfterInstall(3)     // Give time for first purchase
        .setMinSessionDuration(3)      // Meaningful browsing session
        .setMinDaysBeforeRemind(14)    // Reasonable reminder interval
        .setMinSecondsBeforeShowDialog(2)
        .monitor();
  }

  /// Configuration for learning apps
  static void setupForLearningApp() {
    SmartInAppReview()
        .setMinLaunchTimes(4)          // After several learning sessions
        .setMinDaysAfterInstall(5)     // Give time to see progress
        .setMinSessionDuration(8)      // Require meaningful study time
        .setMinDaysBeforeRemind(21)    // Don't interrupt learning flow
        .setMinSecondsBeforeShowDialog(3)
        .monitor();
  }

  /// Development/testing configuration
  static void setupForTesting() {
    SmartInAppReview()
        .setMinLaunchTimes(1)
        .setMinDaysAfterInstall(0)
        .setMinSessionDuration(0)
        .setMinDaysBeforeRemind(0)
        .setMinSecondsBeforeShowDialog(1)
        .setDebugMode(true)            // Enable debug logging
        .monitor();
  }
}

class ConfigurationExample extends StatelessWidget {
  const ConfigurationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Review Configurations'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildConfigCard(
              context,
              'Entertainment Apps',
              'Games, Social Media, Quick Fun Apps',
              'Quick engagement, frequent usage',
              Icons.games,
              Colors.orange,
              () => SmartReviewExamples.setupForEntertainmentApp(),
            ),
            const SizedBox(height: 16),
            _buildConfigCard(
              context,
              'Productivity Apps',
              'Work Tools, Utilities, Business Apps',
              'Professional use, less frequent prompts',
              Icons.work,
              Colors.blue,
              () => SmartReviewExamples.setupForProductivityApp(),
            ),
            const SizedBox(height: 16),
            _buildConfigCard(
              context,
              'E-Commerce Apps',
              'Shopping, Marketplace, Retail Apps',
              'Purchase-focused, moderate engagement',
              Icons.shopping_cart,
              Colors.green,
              () => SmartReviewExamples.setupForECommerceApp(),
            ),
            const SizedBox(height: 16),
            _buildConfigCard(
              context,
              'Learning Apps',
              'Education, Courses, Skill Building',
              'Long sessions, progress-based timing',
              Icons.school,
              Colors.indigo,
              () => SmartReviewExamples.setupForLearningApp(),
            ),
            const SizedBox(height: 16),
            _buildConfigCard(
              context,
              'Testing Configuration',
              'Development and QA Testing',
              'Immediate feedback, debug enabled',
              Icons.bug_report,
              Colors.red,
              () => SmartReviewExamples.setupForTesting(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigCard(
    BuildContext context,
    String title,
    String subtitle,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          onTap();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title configuration applied!'),
              backgroundColor: color,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
