import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';

import '../../application/workout_providers.dart';
import '../../domain/workout_data.dart';
import 'action_pill_buttons.dart';
import 'activity_rings.dart';
import 'date_nav_header.dart';
import 'stat_mini_card.dart';
import 'summary_rule_card.dart';
import 'weekly_steps_chart.dart';
import 'workouts_week_banner.dart';

/// The full ring/stats/chart/banner content, identical whether it's embedded
/// under the Home tab (no AppBar) or pushed as the standalone "Workout"
/// screen (with AppBar + back button) — see workout_dashboard_screen.dart
/// and workout_detail_screen.dart.
class WorkoutDashboardBody extends ConsumerWidget {
  const WorkoutDashboardBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(dailyActivityProvider);
    final selectedDate = ref.watch(selectedActivityDateProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(dailyActivityProvider);
        await ref.read(dailyActivityProvider.future);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        children: [
          const _TopBar(title: 'Workout'),
          DateNavHeader(
            date: selectedDate,
            onPrevious: () => ref.read(selectedActivityDateProvider.notifier).state =
                selectedDate.subtract(const Duration(days: 1)),
            onNext: () => ref.read(selectedActivityDateProvider.notifier).state =
                selectedDate.add(const Duration(days: 1)),
          ),
          const SizedBox(height: 12),
          activityAsync.when(
            data: (summary) => _Content(summary: summary),
            loading: () => const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.only(top: 80),
              // User-facing copy is a placeholder — replace with a mapped,
              // human-readable message once real error codes exist
              // (see skill §6.1 Error handling & resilience).
              child: Center(child: Text('Could not load activity: $error')),
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.summary});

  final DailyActivitySummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Center(child: ActivityRings(summary: summary)),
        const SizedBox(height: 28),
        ActionPillButtons(
          onNewWorkout: () {},
          onAddExercise: () {},
        ),
        const SizedBox(height: 20),
        StatMiniCardRow(summary: summary),
        const SizedBox(height: 16),
        SummaryRuleCard(
          totalBurntCalories: summary.totalBurntCalories,
          distanceActiveKm: summary.distanceActiveKm,
        ),
        const SizedBox(height: 20),
        WeeklyStepsChart(points: summary.weeklySteps, target: summary.weeklyStepsTarget),
        const SizedBox(height: 20),
        WorkoutsWeekBanner(sessions: summary.workoutSessionsThisWeek),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: AppColors.darkSurface.withOpacity(0.11),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.black),
              onPressed: () => context.pop(),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.cardTitle.copyWith(color: AppColors.black, fontSize: 18),
              ),
            ),
            // Balances the back button's width so the title stays
            // visually centered instead of skewing right.
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
