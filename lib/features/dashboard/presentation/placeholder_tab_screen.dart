import 'package:flutter/material.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';

/// Generic "not built yet" screen for the Reminder / Plans / Settings
/// bottom-nav tabs. No mockups were provided for these — replace each
/// with its real screen once designed.
class PlaceholderTabScreen extends StatelessWidget {
  const PlaceholderTabScreen({super.key, required this.title, required this.path});

  final String title;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: 0.3,
                child: Image.asset(
                  path,
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported_outlined,
                    size: 40,
                    color: AppColors.inputText,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(title, style: AppTextStyles.pageHeading.copyWith(fontSize: 20)),
              const SizedBox(height: 6),
              Text('No mockup provided yet', style: AppTextStyles.hint),
            ],
          ),
        ),
      ),
    );
  }
}