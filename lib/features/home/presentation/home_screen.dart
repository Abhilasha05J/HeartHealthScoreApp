import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/gradient_card.dart';
import '../../notifications/application/notification_providers.dart';

/// Placeholder dashboard — no mockup was provided for this screen yet.
///
/// TODO(design): replace with the real Home/Dashboard mockup once
/// available. TODO(backend-integration): once the ML scoring endpoint
/// is live, fetch and display the actual Heart Health Score here.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        // SafeArea takes exactly one `child` — the temporary token display
        // and the existing Padding both need to live inside that single
        // child, not as two separate arguments to SafeArea itself.
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TEMPORARY — remove once FCM push is verified end-to-end.
              Consumer(
                builder: (context, ref, _) {
                  final tokenAsync = ref.watch(fcmTokenProvider);
                  return tokenAsync.when(
                    data: (token) => SelectableText(
                      'FCM TOKEN:\n${token ?? "null — check permission was granted"}',
                      style: const TextStyle(fontSize: 10),
                    ),
                    loading: () => const Text('Fetching FCM token...'),
                    error: (e, _) => Text('Token error: $e'),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text('Dashboard', style: AppTextStyles.pageHeading),
              const SizedBox(height: 8),
              Text(
                'Your heart health score will appear here once the backend is connected.',
                style: AppTextStyles.pageSubtitle,
              ),
              const SizedBox(height: 24),
              GradientCard(
                child: Column(
                  children: [
                    const Icon(Icons.favorite, size: 48, color: AppColors.redAccent),
                    const SizedBox(height: 16),
                    Text('Heart Health Score', style: AppTextStyles.cardTitle),
                    const SizedBox(height: 8),
                    Text('-- / 100', style: AppTextStyles.pageHeading),
                    const SizedBox(height: 8),
                    Text(
                      'Waiting on backend integration',
                      style: AppTextStyles.hint,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}