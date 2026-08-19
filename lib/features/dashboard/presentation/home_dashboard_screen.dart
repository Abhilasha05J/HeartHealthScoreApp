import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heart_health_score/features/dashboard/presentation/widgets/domain_summary_card.dart';

import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/features/dashboard/application/dashboard_providers.dart';
import 'package:heart_health_score/features/dashboard/presentation/widgets/rewards_milestone_section.dart';
import 'package:heart_health_score/features/dashboard/presentation/widgets/weekly_achievements_section.dart';
import 'package:heart_health_score/features/wearable/application/wearable_providers.dart';
import 'package:heart_health_score/features/wearable/domain/wearable_models.dart' show WearableConnectionStatus;
import 'widgets/burden_breakdown_chart.dart';
import 'widgets/condition_card.dart';
import 'widgets/health_score_card.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final dashboardAsync = ref.watch(dashboardDataProvider);
    final dashboardAsync = ref.watch(mergedDashboardDataProvider);
    final wearableState = ref.watch(wearableControllerProvider);

    ref.listen(wearableControllerProvider, (previous, next) {
      if (previous?.status == next.status && previous?.errorMessage == next.errorMessage) return;

      switch (next.status) {
        case WearableConnectionStatus.storeUnavailable:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Health Connect isn\'t installed on this device.'),
              action: SnackBarAction(
                label: 'Install',
                onPressed: () => ref.read(wearableControllerProvider.notifier).openStoreInstallPage(),
              ),
            ),
          );
          break;
        case WearableConnectionStatus.permissionDenied:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permission wasn\'t granted. Tap Connect Wearable to try again.')),
          );
          break;
        case WearableConnectionStatus.error:
          if (next.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
          }
          break;
        default:
          break;
      }
    });

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
                    isSyncing: wearableState.isSyncing,
                    isConnected: wearableState.status == WearableConnectionStatus.connected,
                    onConnectWearable: () => ref.read(wearableControllerProvider.notifier).connectOrRefresh(),
                    onViewHistory: () {
                      // TODO(score-history): swap for context.push('/home/score-history')
                      // once that screen + route exist. Snackbar is a safe
                      // placeholder in the meantime, same pattern as the
                      // wearable error states above.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Score history is coming soon.')),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text('YOUR CONDITION', style: AppTextStyles.dashboardcardheading.copyWith(fontSize: 18)),
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
                  Text('WEEKLY ACHIEVEMENTS', style: AppTextStyles.dashboardcardheading.copyWith(fontSize: 18)),
                  const SizedBox(height: 14),
                  WeeklyAchievementsSection(achievements: data.weeklyAchievements),
                  const SizedBox(height: 28),
                  RewardsMilestoneCard(progress: data.rewardsProgress),
                  const SizedBox(height: 18),
                  Text('UNLOCKED REWARDS', style: AppTextStyles.dashboardcardheading.copyWith(fontSize: 18)),
                  const SizedBox(height: 14),
                  UnlockedRewardsSection(unlocked: data.rewardsProgress.unlockedBadges),
                  const SizedBox(height: 28),
                  Text('BURDEN BREAKDOWN', style: AppTextStyles.dashboardcardheading.copyWith(fontSize: 18)),
                  const SizedBox(height: 18),
                  BurdenBreakdownChart(items: data.burdenBreakdown),
                  const SizedBox(height: 28),
                  Text('DOMAIN SUMMARY', style: AppTextStyles.dashboardcardheading.copyWith(fontSize: 18)),
                  const SizedBox(height: 18),
                  DomainSummarySection(items: data.domainSummary),
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
