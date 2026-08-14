import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/features/dashboard/presentation/widgets/condition_card.dart';
import 'package:heart_health_score/features/wearable/application/wearable_providers.dart';
import 'package:heart_health_score/features/wearable/domain/wearable_formatters.dart';
import 'package:heart_health_score/features/wearable/domain/wearable_models.dart';

/// Pushed from Home's "Connect Wearable" CTA (HealthScoreCard.onConnectWearable)
/// — use context.push(), never go(), so back returns to Home per the
/// navigation rules. This screen never calls context.go() itself.
class ConnectWearableScreen extends ConsumerWidget {
  const ConnectWearableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wearableControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(canPop: context.canPop()),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(wearableControllerProvider.notifier).refresh(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  child: _Body(state: state),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.canPop});
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          if (canPop)
            IconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.arrow_back_rounded, color: AppColors.headingColor),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Connect Wearable', style: AppTextStyles.pageHeading.copyWith(fontSize: 22)),
                const SizedBox(height: 2),
                Text('Synced via Health Connect or Apple Health', style: AppTextStyles.pageSubtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.state});
  final WearableConnectionState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (state.status) {
      case WearableConnectionStatus.notConnected:
        return _ConnectPrompt(
          title: 'Connect your wearable',
          body: 'Pull in resting heart rate, sleep, step count, and blood pressure '
              '(when your device supports it) from Health Connect or Apple Health.',
          ctaLabel: 'Connect Wearable',
          isLoading: false,
          onPressed: () => ref.read(wearableControllerProvider.notifier).connect(),
        );

      case WearableConnectionStatus.connecting:
        return _ConnectPrompt(
          title: 'Connect your wearable',
          body: 'Pull in resting heart rate, sleep, step count, and blood pressure '
              '(when your device supports it) from Health Connect or Apple Health.',
          ctaLabel: 'Connect Wearable',
          isLoading: true,
          onPressed: () {},
        );

      case WearableConnectionStatus.storeUnavailable:
        return _ConnectPrompt(
          title: 'Health Connect not found',
          body: 'Install the Health Connect app to sync your health data on this device.',
          ctaLabel: 'Install Health Connect',
          isLoading: false,
          onPressed: () => ref.read(wearableControllerProvider.notifier).openStoreInstallPage(),
        );

      case WearableConnectionStatus.permissionDenied:
        return _ConnectPrompt(
          title: "Permission wasn't granted",
          body: 'We need at least one permission to show your data here. You can '
              'grant access in Settings, or try connecting again.',
          ctaLabel: 'Try Again',
          isLoading: false,
          onPressed: () => ref.read(wearableControllerProvider.notifier).connect(),
        );

      case WearableConnectionStatus.error:
        return _ConnectPrompt(
          title: 'Something went wrong',
          body: state.errorMessage ?? 'Please try again in a moment.',
          ctaLabel: 'Try Again',
          isLoading: false,
          onPressed: () => ref.read(wearableControllerProvider.notifier).connect(),
        );

      case WearableConnectionStatus.connected:
        final snapshot = state.snapshot;
        if (snapshot == null || !snapshot.hasAnyData) {
          return _ConnectPrompt(
            title: 'No data yet',
            body: "You're connected, but no data has synced yet. Open your wearable's "
                'app once, then pull down here to refresh.',
            ctaLabel: 'Refresh',
            isLoading: false,
            onPressed: () => ref.read(wearableControllerProvider.notifier).refresh(),
          );
        }
        return _MetricGrid(snapshot: snapshot);
    }
  }
}

/// Flat grey card + inline ElevatedButton — matches HealthScoreCard's actual
/// styling in your codebase (no shared GradientCard/PrimaryButton widget is
/// used there), so this stays visually consistent with what Home really does.
class _ConnectPrompt extends StatelessWidget {
  const _ConnectPrompt({
    required this.title,
    required this.body,
    required this.ctaLabel,
    required this.isLoading,
    required this.onPressed,
  });

  final String title;
  final String body;
  final String ctaLabel;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // ASSUMPTION: reusing AppColors.lightGreyFill (currently documented as
          // "manual-entry text field bg") as a generic light-fill card
          // background here, since HealthScoreCard's own card color
          // (Color(0xFFF5F5F5)) isn't a named token. Flag to confirm/tokenize.
          color: AppColors.lightGreyFill,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.watch_rounded, color: AppColors.accentColor, size: 26),
            ),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              body,
              style: AppTextStyles.hint.copyWith(color: AppColors.inputText.withOpacity(0.75)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.white),
                      )
                    : Text(ctaLabel, style: AppTextStyles.buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Same 2-column grid + ConditionCard combo Home uses for "Your Condition" —
/// only renders tiles for metrics actually present in the snapshot.
class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.snapshot});
  final WearableSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final metrics = snapshot.availableMetrics;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text('Synced Data', style: AppTextStyles.pageHeading.copyWith(fontSize: 18)),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.3,
          children: [for (final type in metrics) _cardFor(type, snapshot)],
        ),
      ],
    );
  }

  Widget _cardFor(WearableMetricType type, WearableSnapshot s) {
    switch (type) {
      case WearableMetricType.stepCount:
        final r = s.stepCount!;
        return ConditionCard(
          value: formatStepCount(r.value),
          label: 'Step Count',
          imagePath: 'assets/icons/stepcount.png',
          tintColor: AppColors.conditionTintPurple,
          iconColor: const Color(0xFF8B7BD8), // matches Home's exact steps color
        );
      case WearableMetricType.restingHeartRate:
        final r = s.restingHeartRate!;
        return ConditionCard(
          value: formatRestingHeartRate(r.value),
          label: 'Resting Heart Rate',
          imagePath: 'assets/icons/heartrate.png',
          tintColor: AppColors.conditionTintRed,
          iconColor: AppColors.errorColor,
        );
      case WearableMetricType.sleepDuration:
        final r = s.sleepDuration!;
        return ConditionCard(
          value: formatSleepDuration(r.value),
          label: 'Sleep Duration',
          imagePath: 'assets/icons/sleep.png',
          tintColor: AppColors.conditionTintBlue,
          iconColor: AppColors.accentColor,
        );
      case WearableMetricType.bloodPressure:
        final r = s.bloodPressure!;
        return ConditionCard(
          value: formatBloodPressure(r.value),
          label: 'Blood Pressure',
          imagePath: 'assets/icons/bpr.png',
          tintColor: AppColors.conditionTintBlue,
          iconColor: AppColors.accentColor,
        );
    }
  }
}
