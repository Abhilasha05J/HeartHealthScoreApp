import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/features/assessment/application/assessment_providers.dart';
import 'package:heart_health_score/features/assessment/domain/assessment_models.dart';
import 'package:heart_health_score/features/assessment/presentation/widgets/report_upload_box.dart' show ReportUploadBox;
import 'widgets/assessment_widgets.dart';
import 'widgets/tab_bodies.dart';

class AssessmentScreen extends ConsumerWidget {
  const AssessmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftAsync = ref.watch(assessmentControllerProvider);
    final activeTab = ref.watch(activeAssessmentTabProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: draftAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Something went wrong: $e')),
          data: (draft) => CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text('Heart Health Assessment',
                        style: AppTextStyles.chipLabel.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.headingColor,
                        )),
                    const SizedBox(height: 16),
                    ReportUploadBox(reports: draft.reports),
                    const SizedBox(height: 20),
                    AssessmentTabBar(
                      active: activeTab,
                      onChanged: (tab) => ref.read(activeAssessmentTabProvider.notifier).state = tab,
                    ),
                    const SizedBox(height: 20),
                    AssessmentProgressHeader(tab: activeTab, completion: draft.completionFor(activeTab)),
                    const SizedBox(height: 20),
                    _TabBody(tab: activeTab),
                    const SizedBox(height: 24),
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
}

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
      AssessmentTab.lifestyle => const LifestyleFitnessTabBody(), // was: AssessmentTab.behavior => BehaviorTabBody()
      AssessmentTab.heartTests => const HeartTestsTabBody(),      // NEW
    };
  }
}

class _BottomActions extends ConsumerWidget {
  const _BottomActions({required this.tab});
  final AssessmentTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => ref.read(assessmentControllerProvider.notifier).saveDraft(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.assessmentFieldBackground,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            child: Text('Save Draft',
                style: AppTextStyles.chipLabel.copyWith(color: AppColors.inputText.withOpacity(0.6))),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              final next = tab.next;
              if (next != null) {
                ref.read(activeAssessmentTabProvider.notifier).state = next;
              } else {
                await ref.read(assessmentControllerProvider.notifier).submit();
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Assessment saved')));
                }
              }
            },
            icon: Icon(tab.next != null ? Icons.arrow_forward : Icons.save_outlined, color: Colors.white),
            label: Text(tab.nextLabel),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.assessmentGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              textStyle: AppTextStyles.chipLabel.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}