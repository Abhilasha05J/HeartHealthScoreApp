import 'package:flutter/material.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';

/// Shared layout for Profile Setup / Daily Activity / Basic Vitals:
/// optional top bar (title + Skip), heading, subtitle, scrollable body,
/// and a pinned bottom CTA button.
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.heading,
    required this.subtitle,
    required this.body,
    required this.bottomButton,
    this.topBarTitle,
    this.onSkip,
  });

  final String heading;
  final String subtitle;
  final Widget body;
  final Widget bottomButton;
  final String? topBarTitle;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            if (topBarTitle != null || onSkip != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (topBarTitle != null)
                      Text(
                        topBarTitle!,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: AppColors.greenText,
                          fontSize: 20,
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    if (onSkip != null)
                      TextButton(
                        onPressed: onSkip,
                        child: Text('Skip', style: AppTextStyles.linkText),
                      ),
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(heading, style: AppTextStyles.pageHeading),
                    const SizedBox(height: 8),
                    Text(subtitle, style: AppTextStyles.pageSubtitle),
                    const SizedBox(height: 24),
                    body,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: bottomButton,
            ),
          ],
        ),
      ),
    );
  }
}
