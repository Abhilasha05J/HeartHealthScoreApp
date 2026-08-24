import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/assessment_providers.dart';
import '../domain/assessment_models.dart';
import 'widgets/report_upload_box.dart';
import 'widgets/assessment_widgets.dart';
import 'widgets/tab_bodies.dart';

class AssessmentScreen extends ConsumerWidget {
  const AssessmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftAsync = ref.watch(assessmentControllerProvider);
    final activeTab = ref.watch(activeAssessmentTabProvider);

    return Scaffold(
      backgroundColor: Colors.white, // AppColors.scaffoldBackground
      body: SafeArea(
        child: draftAsync.when(
          // ─────────────────────────────────────────────────────────────
          // LOADING STATE (auto-fetch prefill on first open)
          // ─────────────────────────────────────────────────────────────
          loading: () => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading your previous assessment...'),
              ],
            ),
          ),

          // ─────────────────────────────────────────────────────────────
          // ERROR STATE (network failure, etc.)
          // ─────────────────────────────────────────────────────────────
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load assessment',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    // Retry loading
                    ref
                        .read(assessmentControllerProvider.notifier)
                        .load();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          ),

          // ─────────────────────────────────────────────────────────────
          // DATA LOADED (render form)
          // ─────────────────────────────────────────────────────────────
          data: (draft) => CustomScrollView(
            slivers: [
              // Header with title + refresh button
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Heart Health Assessment',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey[900],
                            ),
                          ),
                        ),
                        // Refresh button — manual reload prefill
                        IconButton(
                          onPressed: () {
                            ref
                                .read(
                                assessmentControllerProvider.notifier)
                                .refresh();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reloading previous data...'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Reload previous assessment data',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Info banner if any fields are stale (> 3 months)
                    // if (_hasStaleData(draft))
                    //   Container(
                    //     width: double.infinity,
                    //     padding: const EdgeInsets.all(12),
                    //     decoration: BoxDecoration(
                    //       color: Colors.orange[50],
                    //       borderRadius: BorderRadius.circular(8),
                    //       border: Border.all(color: Colors.orange[200]!),
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         Icon(
                    //           Icons.info_outline,
                    //           size: 18,
                    //           color: Colors.orange[700],
                    //         ),
                    //         const SizedBox(width: 8),
                    //         Expanded(
                    //           child: Text(
                    //             'Some data is older than 3 months. Please review and update.',
                    //             style: TextStyle(
                    //               fontSize: 12,
                    //               color: Colors.orange[700],
                    //               fontWeight: FontWeight.w500,
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // const SizedBox(height: 20),

                    // Report upload box (shared across all tabs)
                    ReportUploadBox(reports: draft.reports),
                    const SizedBox(height: 20),

                    // Tab bar for navigation
                    AssessmentTabBar(
                      active: activeTab,
                      onChanged: (tab) {
                        ref
                            .read(activeAssessmentTabProvider.notifier)
                            .state = tab;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Tab-specific progress indicator
                    AssessmentProgressHeader(
                      tab: activeTab,
                      completion: draft.completionFor(activeTab),
                    ),
                    const SizedBox(height: 30),

                    // Dynamic tab content
                    _TabBody(tab: activeTab),
                    const SizedBox(height: 24),

                    // Bottom action buttons (Save/Next/Submit)
                    _BottomActions(tab: activeTab),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Check if any field is > 3 months old
  bool _hasStaleData(AssessmentDraft draft) {
    final allFields = [
      draft.pressure.systolicBp,
      draft.pressure.diastolicBp,
      draft.glucose.hba1c,
      draft.lipids.ldlC,
      draft.lipids.hdlC,
      draft.kidney.eGfr,
      draft.lifestyle.bmi,
      draft.lifestyle.dietQualityScore,
    ];
    return allFields.any((f) => f.monthsOld != null && f.monthsOld! > 3);
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Tab Body Selector
// ─────────────────────────────────────────────────────────────────────────

class _TabBody extends StatelessWidget {
  const _TabBody({required this.tab});
  final AssessmentTab tab;

  @override
  Widget build(BuildContext context) {
    return switch (tab) {
      AssessmentTab.lipids => const LipidsTabBody(),
      AssessmentTab.pressure => const PressureTabBody(),
      AssessmentTab.glucose => const GlucoseTabBody(),
      AssessmentTab.kidney => const KidneyTabBody(),
      AssessmentTab.lifestyle => const LifestyleFitnessTabBody(),
      AssessmentTab.heartTests => const HeartTestsTabBody(),
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Bottom Action Buttons (Save Draft / Next / Submit)
// ─────────────────────────────────────────────────────────────────────────

class _BottomActions extends ConsumerWidget {
  const _BottomActions({required this.tab});
  final AssessmentTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Save Draft Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () async {
              try {
                await ref
                    .read(assessmentControllerProvider.notifier)
                    .saveDraft();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Draft saved locally'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to save: $e'),
                      backgroundColor: Colors.red[400],
                    ),
                  );
                }
              }
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.grey[50],
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              'Save Draft',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Next / Submit Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              try {
                final next = tab.next;
                if (next != null) {
                  // Move to next tab
                  ref.read(activeAssessmentTabProvider.notifier).state =
                      next;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Moving to ${next.label}...'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                } else {
                  // Last tab — submit
                  await ref
                      .read(assessmentControllerProvider.notifier)
                      .submit();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Assessment submitted! Calculating your health score...',
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );
                    // Optional: navigate to results screen
                    // Future.delayed(Duration(seconds: 1), () {
                    //   context.go('/assessment/results');
                    // });
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red[400],
                    ),
                  );
                }
              }
            },
            icon: Icon(
              tab.next != null ? Icons.arrow_forward : Icons.save_outlined,
              color: Colors.white,
            ),
            label: Text(tab.nextLabel),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
