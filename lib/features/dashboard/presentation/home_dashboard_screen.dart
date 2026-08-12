import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heart_health_score/features/dashboard/presentation/widgets/domain_summary_card.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../application/dashboard_providers.dart';
import 'widgets/burden_breakdown_chart.dart';
import 'widgets/condition_card.dart';
import 'widgets/health_score_card.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        bottom: false,
        child: dashboardAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _ErrorState(
            onRetry: () => ref.invalidate(dashboardDataProvider),
          ),
          data: (data) => RefreshIndicator(
            onRefresh: () async => ref.invalidate(dashboardDataProvider),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Color(0xFFE0E0E0),
                        child: Icon(Icons.person, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.profileName.toUpperCase(),
                            style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 2),
                          Text('Age : ${data.age}', style: AppTextStyles.hint),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  HealthScoreCard(
                    data: data,
                    onConnectWearable: () {
                      // TODO: wire up Health Connect / HealthKit once that
                      // integration starts — deferred per project scope.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Wearable integration coming soon')),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text('Your Condition', style: AppTextStyles.pageHeading.copyWith(fontSize: 18)),
                  const SizedBox(height: 14),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.3,
                    children: [
                      ConditionCard(
                        value: '${data.restingHeartRateBpm} bpm',
                        label: 'Resting Heart Rate',
                        imagePath: 'assets/icons/heartrate.png',
                        tintColor: AppColors.conditionTintRed,
                        iconColor: AppColors.errorColor,
                      ),
                      ConditionCard(
                        value: data.sleepDurationLabel,
                        label: 'Sleep Duration',
                        imagePath: 'assets/icons/sleep.png',
                        tintColor: AppColors.conditionTintBlue,
                        iconColor: AppColors.accentColor,
                      ),
                      ConditionCard(
                        value: data.bloodPressureLabel,
                        label: 'Blood Pressure',
                        imagePath: 'assets/icons/bpr.png',
                        tintColor: AppColors.conditionTintBlue,
                        iconColor: AppColors.accentColor,
                      ),
                      ConditionCard(
                        value: '${data.stepCount}',
                        label: 'Step Count',
                        imagePath: 'assets/icons/stepcount.png',
                        tintColor: AppColors.conditionTintPurple,
                        iconColor: const Color(0xFF8B7BD8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text('Burden Breakdown', style: AppTextStyles.pageHeading.copyWith(fontSize: 18)),
                  const SizedBox(height: 18),
                  BurdenBreakdownChart(items: data.burdenBreakdown),
                  const SizedBox(height: 28),
                  Text('Domain Summary', style: AppTextStyles.pageHeading.copyWith(fontSize: 18)),
                  const SizedBox(height: 18),
                  DomainSummarySection(items: data.domainSummary)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: AppColors.errorColor),
            const SizedBox(height: 12),
            Text(
              'Couldn\'t load your health score. Please try again.',
              textAlign: TextAlign.center,
              style: AppTextStyles.hint,
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
