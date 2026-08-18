import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/features/water_intake_data/application/water_intake_providers.dart';
import 'widgets/quick_add_grid.dart';
import 'widgets/reminder_settings_card.dart';
import 'widgets/water_log_list.dart';
import 'widgets/water_progress_ring.dart';

/// Nested under the Home branch of the app's persistent shell (see
/// app_router.dart's StatefulShellRoute) — this is what keeps the bottom
/// nav bar and the expandable "+" FAB visible on this screen too, both
/// supplied by `HomeShell`, not duplicated here.
class WaterIntakeScreen extends ConsumerStatefulWidget {
  const WaterIntakeScreen({super.key});

  @override
  ConsumerState<WaterIntakeScreen> createState() => _WaterIntakeScreenState();
}

class _WaterIntakeScreenState extends ConsumerState<WaterIntakeScreen> {
  final _manualAmountController = TextEditingController(text: '0.5');

  @override
  void dispose() {
    _manualAmountController.dispose();
    super.dispose();
  }

  void _logManualEntry() {
    final liters = double.tryParse(_manualAmountController.text.trim());
    if (liters == null || liters <= 0) return;
    ref.read(waterIntakeControllerProvider.notifier).logWater(
      amountMl: (liters * 1000).round(),
      sourceLabel: 'Manual',
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(waterIntakeControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      // No `appBar:` here on purpose — see _TopBar below. Using a real
      // Scaffold.appBar paints its color behind the status bar by
      // default, which is what caused the dark bar to bleed into/behind
      // the system status bar. _TopBar instead wraps SafeArea AROUND the
      // colored Container (not inside it), so the actual status-bar
      // strip stays on the Scaffold's default white background —
      // untouched, matching every other screen in the app — and the
      // dark bar only starts right below it.
      body: Column(
        children: [
          const _TopBar(title: 'Water Intake'),
          Expanded(
            child: asyncData.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: TextButton(
                  onPressed: () => ref.read(waterIntakeControllerProvider.notifier).refresh(),
                  child: const Text('Couldn\'t load — tap to retry'),
                ),
              ),
              data: (data) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Goal: ${data.goalLiters.toStringAsFixed(1)}L',
                                style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                              ),
                              const SizedBox(height: 12),
                              WaterProgressRing(
                                currentLiters: data.currentLiters,
                                fraction: data.progressFraction,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quick Add', style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
                              const SizedBox(height: 12),
                              QuickAddGrid(
                                onQuickAdd: (ml) => ref
                                    .read(waterIntakeControllerProvider.notifier)
                                    .logWater(amountMl: ml, sourceLabel: 'Quick Add'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text('Manual Entry', style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
                    const SizedBox(height: 14),
                    Text('Amount (Liters)', style: AppTextStyles.hint),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightGreyFill,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _manualAmountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: AppTextStyles.inputValue,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _logManualEntry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.add, color: AppColors.white),
                        label: Text('Log Water', style: AppTextStyles.buttonLabel),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text("Today's Logs", style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
                    const SizedBox(height: 14),
                    WaterLogList(entries: data.todaysLogs),
                    const SizedBox(height: 28),
                    ReminderSettingsCard(
                      settings: data.reminderSettings,
                      onChanged: (settings) => ref
                          .read(waterIntakeControllerProvider.notifier)
                          .updateReminderSettings(settings),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dark title bar with a back button, deliberately built by hand instead
/// of using `Scaffold.appBar` — see the comment on `WaterIntakeScreen.body`
/// above for why.
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