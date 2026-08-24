import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import '../../application/assessment_providers.dart';
import '../../domain/assessment_models.dart';
import 'assessment_widgets.dart';

class PressureTabBody extends ConsumerWidget {
  const PressureTabBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftAsync = ref.watch(assessmentControllerProvider);

    return draftAsync.when(
      data: (draft) {
        return Column(
          children: [
        const SectionIconHeader(
          iconAsset: 'assets/icons/assessment/header_pressure.png', title: 'Blood Pressure / Hemodynamic'),
            AssessmentTextField(
              label: 'Systolic Blood Pressure (SBP)',
              value: draft.pressure.systolicBp,
              hintText: '90–180 mmHg',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                ref.read(assessmentControllerProvider.notifier).updatePressure(
                      (p) => p.copyWith(
                    systolicBp:
                    p.systolicBp.copyWith(value: double.tryParse(val)),
                  ),
                );
              },
              showFreshness: true,
            ),
            const SizedBox(height: 16),
            AssessmentTextField(
              label: 'Diastolic Blood Pressure (DBP)',
              value: draft.pressure.diastolicBp,
              hintText: '60–110 mmHg',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                ref.read(assessmentControllerProvider.notifier).updatePressure(
                      (p) => p.copyWith(
                    diastolicBp:
                    p.diastolicBp.copyWith(value: double.tryParse(val)),
                  ),
                );
              },
              showFreshness: true,
            ),
            const SizedBox(height: 16),
            AssessmentTextField(
              label: 'Resting Heart Rate',
              value: draft.pressure.restingHeartRate,
              hintText: '60–100 bpm',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                ref.read(assessmentControllerProvider.notifier).updatePressure(
                      (p) => p.copyWith(
                    restingHeartRate: p.restingHeartRate
                        .copyWith(value: double.tryParse(val)),
                  ),
                );
              },
              showFreshness: true,
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// GLUCOSE TAB BODY (example with enum selector)
// ─────────────────────────────────────────────────────────────────────────

class GlucoseTabBody extends ConsumerWidget {
  const GlucoseTabBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftAsync = ref.watch(assessmentControllerProvider);

    return draftAsync.when(
      data: (draft) {
        return Column(
          children: [
        const SectionIconHeader(
             iconAsset: 'assets/icons/assessment/header_glucose.png', title: 'Glucose / Diabetes'),
            AssessmentDropdown<DiabetesStatus>(
              label: 'Diabetes Status',
              value: draft.glucose.diabetesStatus,
              options: DiabetesStatus.values,
              optionLabel: (status) => status.label,
              onChanged: (status) {
                ref.read(assessmentControllerProvider.notifier).updateGlucose(
                      (g) => g.copyWith(
                    diabetesStatus: g.diabetesStatus.copyWith(value: status),
                  ),
                );
              },
              showFreshness: true,
            ), const SizedBox(height: 16),
            AssessmentTextField(
              label: 'HbA1c (%)',
              value: draft.glucose.hba1c,
              hintText: '4–15%',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                ref.read(assessmentControllerProvider.notifier).updateGlucose(
                      (g) => g.copyWith(
                    hba1c: g.hba1c.copyWith(value: double.tryParse(val)),
                  ),
                );
              },
              showFreshness: true,
            ),
            const SizedBox(height: 16),
            AssessmentTextField(
              label: 'Fasting Glucose (mg/dL)',
              value: draft.glucose.fastingGlucose,
              hintText: '70–150 mg/dL',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                ref.read(assessmentControllerProvider.notifier).updateGlucose(
                      (g) => g.copyWith(
                    fastingGlucose:
                    g.fastingGlucose.copyWith(value: double.tryParse(val)),
                  ),
                );
              },
              showFreshness: true,
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// LIPIDS TAB BODY (example with auto-calculated field)
// ─────────────────────────────────────────────────────────────────────────

class LipidsTabBody extends ConsumerWidget {
  const LipidsTabBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftAsync = ref.watch(assessmentControllerProvider);

    return draftAsync.when(
      data: (draft) {
        return Column(
          children: [
            const SectionIconHeader(
                iconAsset: 'assets/icons/assessment/lipids.png', title: 'Lipids'),
            AssessmentTextField(
              label: 'LDL Cholesterol (mg/dL)',
              value: draft.lipids.ldlC,
              hintText: '0–300 mg/dL',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                ref.read(assessmentControllerProvider.notifier).updateLipids(
                      (l) => l.copyWith(
                    ldlC: l.ldlC.copyWith(value: double.tryParse(val)),
                  ),
                );
              },
              showFreshness: true,
            ),
            const SizedBox(height: 16),
            AssessmentTextField(
              label: 'HDL Cholesterol (mg/dL)',
              value: draft.lipids.hdlC,
              hintText: '25–100 mg/dL',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                ref.read(assessmentControllerProvider.notifier).updateLipids(
                      (l) => l.copyWith(
                    hdlC: l.hdlC.copyWith(value: double.tryParse(val)),
                  ),
                );
              },
              showFreshness: true,
            ),
            const SizedBox(height: 16),
            // Read-only calculated field
            _ReadOnlyField(
              label: 'TC/HDL Ratio (auto-calculated)',
              value: draft.lipids.tcHdlRatio?.toStringAsFixed(2) ?? '—',
            ),
            const SizedBox(height: 16),
            AssessmentTextField(
              label: 'Triglycerides (mg/dL)',
              value: draft.lipids.triglycerides,
              hintText: '0–500 mg/dL',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                ref.read(assessmentControllerProvider.notifier).updateLipids(
                      (l) => l.copyWith(
                    triglycerides:
                    l.triglycerides.copyWith(value: double.tryParse(val)),
                  ),
                );
              },
              showFreshness: true,
            ),
            const SizedBox(height: 16),
            AssessmentTextField(
              label: 'ApoB (mg/dL)',
              value: draft.lipids.apoB,
              hintText: '50–150 mg/dL',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                ref.read(assessmentControllerProvider.notifier).updateLipids(
                      (l) => l.copyWith(
                    apoB: l.apoB.copyWith(value: double.tryParse(val)),
                  ),
                );
              },
              showFreshness: true,
            ),
            const SizedBox(height: 16),
            AssessmentTextField(
              label: 'Lipoprotein(a) (${draft.lpaUnit})',
              value: draft.lipids.lpA,
              hintText: '0–200',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                ref.read(assessmentControllerProvider.notifier).updateLipids(
                      (l) => l.copyWith(
                    lpA: l.lpA.copyWith(value: double.tryParse(val)),
                  ),
                );
              },
              showFreshness: true,
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// LIFESTYLE TAB BODY (example with multiple field types)
// ─────────────────────────────────────────────────────────────────────────

// class LifestyleFitnessTabBody extends ConsumerWidget {
//   const LifestyleFitnessTabBody();
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final draftAsync = ref.watch(assessmentControllerProvider);
//
//     return draftAsync.when(
//       data: (draft) {
//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               // Adiposity Section
//              const SectionIconHeader(
//               iconAsset: 'assets/icons/assessment/header_adiposity.png', title: 'Adiposity'),
//               const SizedBox(height: 12),
//               AssessmentTextField(
//                 label: 'Body Mass Index (BMI)',
//                 value: draft.lifestyle.bmi,
//                 hintText: '18–40 kg/m²',
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) {
//                   ref
//                       .read(assessmentControllerProvider.notifier)
//                       .updateLifestyle(
//                         (l) => l.copyWith(
//                       bmi: l.bmi.copyWith(value: double.tryParse(val)),
//                     ),
//                   );
//                 },
//                 showFreshness: true,
//               ),
//               const SizedBox(height: 16),
//               AssessmentTextField(
//                 label: 'Waist Circumference (cm)',
//                 value: draft.lifestyle.waistCircumference,
//                 hintText: '60–150 cm',
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) {
//                   ref
//                       .read(assessmentControllerProvider.notifier)
//                       .updateLifestyle(
//                         (l) => l.copyWith(
//                       waistCircumference: l.waistCircumference
//                           .copyWith(value: double.tryParse(val)),
//                     ),
//                   );
//                 },
//                 showFreshness: true,
//               ),
//               const SizedBox(height: 30),
//
//
//               //PHYSICAL ACTIVITY
//               const SectionIconHeader(
//                   iconAsset: 'assets/icons/assessment/header_physical_activity.png', title: 'Physical Activity'),
//               const SizedBox(height: 12),
//               AssessmentTextField(
//                 label: 'Body Mass Index (BMI)',
//                 value: draft.lifestyle.bmi,
//                 hintText: '18–40 kg/m²',
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) {
//                   ref
//                       .read(assessmentControllerProvider.notifier)
//                       .updateLifestyle(
//                         (l) => l.copyWith(
//                       bmi: l.bmi.copyWith(value: double.tryParse(val)),
//                     ),
//                   );
//                 },
//                 showFreshness: true,
//               ),
//               const SizedBox(height: 16),
//               AssessmentTextField(
//                 label: 'Waist Circumference (cm)',
//                 value: draft.lifestyle.waistCircumference,
//                 hintText: '60–150 cm',
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) {
//                   ref
//                       .read(assessmentControllerProvider.notifier)
//                       .updateLifestyle(
//                         (l) => l.copyWith(
//                       waistCircumference: l.waistCircumference
//                           .copyWith(value: double.tryParse(val)),
//                     ),
//                   );
//                 },
//                 showFreshness: true,
//               ),
//               const SizedBox(height: 30),
//
//
//               //INHERITED RISK
//               // Adiposity Section
//               const SectionIconHeader(
//                   iconAsset: 'assets/icons/assessment/header_inherited_risk.png', title: 'Inherited Risk'),
//               const SizedBox(height: 12),
//               AssessmentTextField(
//                 label: 'Body Mass Index (BMI)',
//                 value: draft.lifestyle.bmi,
//                 hintText: '18–40 kg/m²',
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) {
//                   ref
//                       .read(assessmentControllerProvider.notifier)
//                       .updateLifestyle(
//                         (l) => l.copyWith(
//                       bmi: l.bmi.copyWith(value: double.tryParse(val)),
//                     ),
//                   );
//                 },
//                 showFreshness: true,
//               ),
//               const SizedBox(height: 16),
//               AssessmentTextField(
//                 label: 'Waist Circumference (cm)',
//                 value: draft.lifestyle.waistCircumference,
//                 hintText: '60–150 cm',
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) {
//                   ref
//                       .read(assessmentControllerProvider.notifier)
//                       .updateLifestyle(
//                         (l) => l.copyWith(
//                       waistCircumference: l.waistCircumference
//                           .copyWith(value: double.tryParse(val)),
//                     ),
//                   );
//                 },
//                 showFreshness: true,
//               ),
//               const SizedBox(height: 30),
//
//               // Tobacco Section
//              const SectionIconHeader(
//              iconAsset: 'assets/icons/assessment/header_tobacco.png', title: 'Tobacco Use'),
//               const SizedBox(height: 12),
//               AssessmentChipSelector<SmokingStatus>(
//                 label: 'Smoking Status',
//                 value: draft.lifestyle.smokingStatus,
//                 options: SmokingStatus.values,
//                 optionLabel: (status) => status.label,
//                 onChanged: (status) {
//                   ref
//                       .read(assessmentControllerProvider.notifier)
//                       .updateLifestyle(
//                         (l) => l.copyWith(
//                       smokingStatus:
//                       l.smokingStatus.copyWith(value: status),
//                     ),
//                   );
//                 },
//                 showFreshness: true,
//               ),
//               const SizedBox(height: 16),
//               AssessmentTextField(
//                 label: 'Pack Years',
//                 value: draft.lifestyle.packYears,
//                 hintText: '0–80',
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) {
//                   ref
//                       .read(assessmentControllerProvider.notifier)
//                       .updateLifestyle(
//                         (l) => l.copyWith(
//                       packYears:
//                       l.packYears.copyWith(value: int.tryParse(val)),
//                     ),
//                   );
//                 },
//                 showFreshness: true,
//               ),
//
//               //ACTIVITY
//               const SizedBox(height: 30),
//               const SectionIconHeader(
//                   iconAsset: 'assets/icons/assessment/header_physical_activity.png', title: 'Activity'),
//               const SizedBox(height: 12),
//               AssessmentTextField(
//                 label: 'Body Mass Index (BMI)',
//                 value: draft.lifestyle.bmi,
//                 hintText: '18–40 kg/m²',
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) {
//                   ref
//                       .read(assessmentControllerProvider.notifier)
//                       .updateLifestyle(
//                         (l) => l.copyWith(
//                       bmi: l.bmi.copyWith(value: double.tryParse(val)),
//                     ),
//                   );
//                 },
//                 showFreshness: true,
//               ),
//               const SizedBox(height: 16),
//               AssessmentTextField(
//                 label: 'Waist Circumference (cm)',
//                 value: draft.lifestyle.waistCircumference,
//                 hintText: '60–150 cm',
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) {
//                   ref
//                       .read(assessmentControllerProvider.notifier)
//                       .updateLifestyle(
//                         (l) => l.copyWith(
//                       waistCircumference: l.waistCircumference
//                           .copyWith(value: double.tryParse(val)),
//                     ),
//                   );
//                 },
//                 showFreshness: true,
//               ),
//               const SizedBox(height: 30),
// //DIET
//               const SectionIconHeader(
//              iconAsset: 'assets/icons/assessment/header_diet.png', title: 'Diet / Nutrition'),
//
//               AssessmentTextField(
//                 label: 'Diet Quality Score',
//                 value: draft.lifestyle.dietQualityScore,
//                 hintText: '0–100',
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) {
//                   ref
//                       .read(assessmentControllerProvider.notifier)
//                       .updateLifestyle(
//                         (l) => l.copyWith(
//                       dietQualityScore: l.dietQualityScore
//                           .copyWith(value: double.tryParse(val)),
//                     ),
//                   );
//                 },
//                 showFreshness: true,
//               ),
//               const SizedBox(height: 30),
//           const SectionIconHeader(
//              iconAsset: 'assets/icons/assessment/header_sleep.png', title: 'Sleep'),
//               AssessmentTextField(
//                 label: 'Sleep Hours per Night',
//                 value: draft.lifestyle.sleepHoursPerNight,
//                 hintText: '4–12 hours',
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) {
//                   ref
//                       .read(assessmentControllerProvider.notifier)
//                       .updateLifestyle(
//                         (l) => l.copyWith(
//                       sleepHoursPerNight: l.sleepHoursPerNight
//                           .copyWith(value: double.tryParse(val)),
//                     ),
//                   );
//                 },
//                 showFreshness: true,
//               ),
//               const SizedBox(height: 30),
//           const SectionIconHeader(
//           iconAsset: 'assets/icons/assessment/header_alcohol.png', title: 'Alcohol'),
//
//               AssessmentTextField(
//                 label: 'Alcohol AUDIT Score',
//                 value: draft.lifestyle.alcoholAudit,
//                 hintText: '0–40',
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) {
//                   ref
//                       .read(assessmentControllerProvider.notifier)
//                       .updateLifestyle(
//                         (l) => l.copyWith(
//                       alcoholAudit:
//                       l.alcoholAudit.copyWith(value: double.tryParse(val)),
//                     ),
//                   );
//                 },
//                 showFreshness: true,
//               ),
//               const SizedBox(height: 30),
//               //stress
//               const SectionIconHeader(
//                   iconAsset: 'assets/icons/assessment/header_stress.png', title: 'Stress / Psychosocial'),
//
//               AssessmentTextField(
//                 label: 'Alcohol AUDIT Score',
//                 value: draft.lifestyle.alcoholAudit,
//                 hintText: '0–40',
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) {
//                   ref
//                       .read(assessmentControllerProvider.notifier)
//                       .updateLifestyle(
//                         (l) => l.copyWith(
//                       alcoholAudit:
//                       l.alcoholAudit.copyWith(value: double.tryParse(val)),
//                     ),
//                   );
//                 },
//                 showFreshness: true,
//               ),
//             ],
//           ),
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (e, st) => Center(child: Text('Error: $e')),
//     );
//   }
// }
class LifestyleFitnessTabBody extends ConsumerWidget {
  const LifestyleFitnessTabBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftAsync = ref.watch(assessmentControllerProvider);

    return draftAsync.when(
      data: (draft) {
        final lifestyle = draft.lifestyle;
        final controller =
        ref.read(assessmentControllerProvider.notifier);

        return SingleChildScrollView(
          child: Column(
            children: [
              // ============================================================
              // ADIPOSITY
              // ============================================================

              const SectionIconHeader(
                iconAsset:
                'assets/icons/assessment/header_adiposity.png',
                title: 'Adiposity',
              ),

              const SizedBox(height: 12),

              AssessmentTextField(
                label: 'Body Mass Index (BMI)',
                value: lifestyle.bmi,
                hintText: '18–40 kg/m²',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  controller.updateLifestyle(
                        (l) => l.copyWith(
                      bmi: l.bmi.copyWith(
                        value: double.tryParse(val),
                      ),
                    ),
                  );
                },
                showFreshness: true,
              ),

              const SizedBox(height: 16),

              AssessmentTextField(
                label: 'Waist Circumference (cm)',
                value: lifestyle.waistCircumference,
                hintText: '60–150 cm',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  controller.updateLifestyle(
                        (l) => l.copyWith(
                      waistCircumference:
                      l.waistCircumference.copyWith(
                        value: double.tryParse(val),
                      ),
                    ),
                  );
                },
                showFreshness: true,
              ),

              const SizedBox(height: 16),

              AssessmentTextField(
                label: 'Waist-Hip Ratio',
                value: lifestyle.waistHipRatio,
                hintText: '0.5–1.5',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  controller.updateLifestyle(
                        (l) => l.copyWith(
                      waistHipRatio:
                      l.waistHipRatio.copyWith(
                        value: double.tryParse(val),
                      ),
                    ),
                  );
                },
                showFreshness: true,
              ),

              const SizedBox(height: 30),

              // ============================================================
              // PHYSICAL ACTIVITY
              // ============================================================

              const SectionIconHeader(
                iconAsset:
                'assets/icons/assessment/header_physical_activity.png',
                title: 'Physical Activity',
              ),

              const SizedBox(height: 12),

              AssessmentTextField(
                label: 'Weekly Activity Minutes',
                value: lifestyle.weeklyActivityMinutes,
                hintText: '0–2000 min/week',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  controller.updateLifestyle(
                        (l) => l.copyWith(
                      weeklyActivityMinutes:
                      l.weeklyActivityMinutes.copyWith(
                        value: double.tryParse(val),
                      ),
                    ),
                  );
                },
                showFreshness: true,
              ),

              const SizedBox(height: 16),

              AssessmentTextField(
                label: 'Structured Activity Score',
                value: lifestyle.structuredActivityScore,
                hintText: '0–100',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  controller.updateLifestyle(
                        (l) => l.copyWith(
                      structuredActivityScore:
                      l.structuredActivityScore.copyWith(
                        value: double.tryParse(val),
                      ),
                    ),
                  );
                },
                showFreshness: true,
              ),

              const SizedBox(height: 30),
// ============================================================
// INHERITED RISK
// ============================================================

              const SectionIconHeader(
                iconAsset:
                'assets/icons/assessment/header_inherited_risk.png',
                title: 'Inherited Risk',
              ),

              const SizedBox(height: 12),

// Family History
              AssessmentToggleSelector<String>(
                label: 'Family History of Premature CVD',
                value: lifestyle.familyHistory.value,
                options: const [
                  'Yes',
                  'No',
                ],
                optionLabel: (option) => option,
                onChanged: (value) {
                  controller.updateLifestyle(
                        (l) => l.copyWith(
                      familyHistory: l.familyHistory.copyWith(
                        value: value,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 4),

// Genetic Mutation
              AssessmentToggleSelector<String>(
                label: 'Genetic Mutation',
                value: lifestyle.geneticMutation.value,
                options: const [
                  'Low',
                  'Medium',
                  'High',
                ],
                optionLabel: (option) => option,
                onChanged: (value) {
                  controller.updateLifestyle(
                        (l) => l.copyWith(
                      geneticMutation: l.geneticMutation.copyWith(
                        value: value,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 4),

// Genetic Risk Score
              AssessmentTextField(
                label: 'Genetic Risk Score Percentile',
                value: lifestyle.geneticRiskScorePercent,
                hintText: '0–100%',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  controller.updateLifestyle(
                        (l) => l.copyWith(
                      geneticRiskScorePercent:
                      l.geneticRiskScorePercent.copyWith(
                        value: double.tryParse(val),
                      ),
                    ),
                  );
                },
                showFreshness: true,
              ),

              const SizedBox(height: 30),
              // ============================================================
              // TOBACCO USE
              // ============================================================

              const SectionIconHeader(
                iconAsset:
                'assets/icons/assessment/header_tobacco.png',
                title: 'Tobacco Use',
              ),

              const SizedBox(height: 12),
              AssessmentDropdown<SmokingStatus>(
                label: 'Smoking Status',
                value: draft.lifestyle.smokingStatus,
                options: SmokingStatus.values,
                optionLabel: (status) => status.label,
                onChanged: (status) {
                  if (status != null) {
                    ref.read(assessmentControllerProvider.notifier).updateLifestyle(
                          (l) => l.copyWith(
                        smokingStatus: l.smokingStatus.copyWith(value: status),
                      ),
                    );
                  }
                },
                showFreshness: true,
              ),
              const SizedBox(height: 16),

              AssessmentTextField(
                label: 'Pack Years',
                value: lifestyle.packYears,
                hintText: '0–80',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  controller.updateLifestyle(
                        (l) => l.copyWith(
                      packYears:
                      l.packYears.copyWith(
                        value: int.tryParse(val),
                      ),
                    ),
                  );
                },
                showFreshness: true,
              ),

              const SizedBox(height: 16),

              AssessmentTextField(
                label: 'Years Since Quit',
                value: lifestyle.quitDurationYears,
                hintText: '0–50 years',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  controller.updateLifestyle(
                        (l) => l.copyWith(
                      quitDurationYears:
                      l.quitDurationYears.copyWith(
                        value: int.tryParse(val),
                      ),
                    ),
                  );
                },
                showFreshness: true,
              ),

              const SizedBox(height: 16),

              AssessmentChipSelector<bool>(
                label: 'Smokeless Tobacco',
                value: lifestyle.smokelessTobacco,
                options: const [true, false],
                optionLabel: (value) =>
                value ? 'Yes' : 'No',
                onChanged: (value) {
                  controller.updateLifestyle(
                        (l) => l.copyWith(
                      smokelessTobacco:
                      l.smokelessTobacco.copyWith(
                        value: value,
                      ),
                    ),
                  );
                },
                showFreshness: true,
              ),

              const SizedBox(height: 30),

              // ============================================================
              // ACTIVITY
              // ============================================================

              const SectionIconHeader(
                iconAsset:
                'assets/icons/assessment/header_physical_activity.png',
                title: 'Activity',
              ),

              const SizedBox(height: 12),

              AssessmentTextField(
                label:
                'Moderate–Vigorous Activity Minutes',
                value: FieldValue<double>(
                  value:
                  lifestyle.moderateVigorousActivityMinutes,
                ),
                hintText: '0–2000 min/week',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  controller.updateLifestyle(
                        (l) => l.copyWith(
                      moderateVigorousActivityMinutes:
                      double.tryParse(val) ?? 0,
                    ),
                  );
                },
                showFreshness: false,
              ),

              const SizedBox(height: 30),

              // ============================================================
              // DIET / NUTRITION
              // ============================================================

              const SectionIconHeader(
                iconAsset:
                'assets/icons/assessment/header_diet.png',
                title: 'Diet / Nutrition',
              ),

              const SizedBox(height: 12),

              AssessmentTextField(
                label: 'Diet Quality Score',
                value: lifestyle.dietQualityScore,
                hintText: '0–100',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  controller.updateLifestyle(
                        (l) => l.copyWith(
                      dietQualityScore:
                      l.dietQualityScore.copyWith(
                        value: double.tryParse(val),
                      ),
                    ),
                  );
                },
                showFreshness: true,
              ),

              const SizedBox(height: 30),

              // ============================================================
              // SLEEP
              // ============================================================

              const SectionIconHeader(
                iconAsset:
                'assets/icons/assessment/header_sleep.png',
                title: 'Sleep',
              ),

              const SizedBox(height: 12),

              AssessmentTextField(
                label: 'Sleep Hours per Night',
                value: lifestyle.sleepHoursPerNight,
                hintText: '4–12 hours',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  controller.updateLifestyle(
                        (l) => l.copyWith(
                      sleepHoursPerNight:
                      l.sleepHoursPerNight.copyWith(
                        value: double.tryParse(val),
                      ),
                    ),
                  );
                },
                showFreshness: true,
              ),

              const SizedBox(height: 30),

              // ============================================================
              // ALCOHOL
              // ============================================================

              const SectionIconHeader(
                iconAsset:
                'assets/icons/assessment/header_alcohol.png',
                title: 'Alcohol',
              ),

              const SizedBox(height: 12),

              AssessmentTextField(
                label: 'Alcohol AUDIT Score',
                value: lifestyle.alcoholAudit,
                hintText: '0–40',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  controller.updateLifestyle(
                        (l) => l.copyWith(
                      alcoholAudit:
                      l.alcoholAudit.copyWith(
                        value: double.tryParse(val),
                      ),
                    ),
                  );
                },
                showFreshness: true,
              ),

              const SizedBox(height: 30),

              // ============================================================
              // STRESS / PSYCHOSOCIAL
              // ============================================================

              const SectionIconHeader(
                iconAsset:
                'assets/icons/assessment/header_stress.png',
                title: 'Stress / Psychosocial',
              ),

              const SizedBox(height: 12),

              AssessmentTextField(
                label: 'Stress Score',
                value: lifestyle.stressScore,
                hintText: '0–100',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  controller.updateLifestyle(
                        (l) => l.copyWith(
                      stressScore:
                      l.stressScore.copyWith(
                        value: double.tryParse(val),
                      ),
                    ),
                  );
                },
                showFreshness: true,
              ),

              const SizedBox(height: 30),
            ],
          ),
        );
      },

      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),

      error: (e, st) => Center(
        child: Text('Error: $e'),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// KIDNEY TAB BODY
// ─────────────────────────────────────────────────────────────────────────

class KidneyTabBody extends ConsumerWidget {
  const KidneyTabBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftAsync = ref.watch(assessmentControllerProvider);

    return draftAsync.when(
      data: (draft) {
        return Column(
          children: [
        const SectionIconHeader(
             iconAsset: 'assets/icons/assessment/header_kidney.png', title: 'Kidney / Vascular Damage'),
            AssessmentTextField(
              label: 'eGFR (mL/min/1.73m²)',
              value: draft.kidney.eGfr,
              hintText: '15–90',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                ref.read(assessmentControllerProvider.notifier).updateKidney(
                      (k) => k.copyWith(
                    eGfr: k.eGfr.copyWith(value: double.tryParse(val)),
                  ),
                );
              },
              showFreshness: true,
            ),
            const SizedBox(height: 16),
            AssessmentTextField(
              label: 'Creatinine (mg/dL)',
              value: draft.kidney.creatinine,
              hintText: '0.6–1.2 mg/dL',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                ref.read(assessmentControllerProvider.notifier).updateKidney(
                      (k) => k.copyWith(
                    creatinine:
                    k.creatinine.copyWith(value: double.tryParse(val)),
                  ),
                );
              },
              showFreshness: true,
            ),
            const SizedBox(height: 16),
            AssessmentTextField(
              label: 'UACR (mg/g)',
              value: draft.kidney.uacr,
              hintText: '0–30 mg/g',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                ref.read(assessmentControllerProvider.notifier).updateKidney(
                      (k) => k.copyWith(
                    uacr: k.uacr.copyWith(value: double.tryParse(val)),
                  ),
                );
              },
              showFreshness: true,
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// HEART TESTS TAB BODY
// ─────────────────────────────────────────────────────────────────────────

// class HeartTestsTabBody extends ConsumerWidget {
//   const HeartTestsTabBody();
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final draftAsync = ref.watch(assessmentControllerProvider);
//
//     return draftAsync.when(
//       data: (draft) {
//         return Column(
//           children: [
//             const SectionIconHeader(
//                 iconAsset: 'assets/icons/assessment/tab_hearttest.png', title: 'Heart Tests'),
//             AssessmentTextField(
//               label: 'High-Sensitivity CRP (mg/L)',
//               value: draft.heartTests.hsCrp,
//               hintText: '0–10 mg/L',
//               keyboardType: TextInputType.number,
//               onChanged: (val) {
//                 ref
//                     .read(assessmentControllerProvider.notifier)
//                     .updateHeartTests(
//                       (h) => h.copyWith(
//                     hsCrp: h.hsCrp.copyWith(value: double.tryParse(val)),
//                   ),
//                 );
//               },
//               showFreshness: true,
//             ),
//             const SizedBox(height: 16),
//             AssessmentTextField(
//               label: 'Coronary Artery Calcium Score',
//               value: draft.heartTests.cacScore,
//               hintText: '0–2500+',
//               keyboardType: TextInputType.number,
//               onChanged: (val) {
//                 ref
//                     .read(assessmentControllerProvider.notifier)
//                     .updateHeartTests(
//                       (h) => h.copyWith(
//                     cacScore:
//                     h.cacScore.copyWith(value: double.tryParse(val)),
//                   ),
//                 );
//               },
//               showFreshness: true,
//             ),
//           ],
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (e, st) => Center(child: Text('Error: $e')),
//     );
//   }
// }

class HeartTestsTabBody extends ConsumerWidget {
  const HeartTestsTabBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftAsync = ref.watch(assessmentControllerProvider);
    final ecgAnalyzing = ref.watch(ecgAnalyzingProvider);

    return draftAsync.when(
      data: (draft) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const SectionIconHeader(
                iconAsset: 'assets/icons/assessment/tab_hearttest.png',
                title: 'Heart Tests',
              ),

              // ─── LVH ───
              AssessmentToggleSelector<bool>(
                label: 'Left Ventricular Hypertrophy (LVH)',
                value: draft.heartTests.lvh.value,
                options: const [
                  true,
                  false,
                ],
                optionLabel: (value) => value ? 'Yes' : 'No',
                onChanged: (value) {
                  ref
                      .read(assessmentControllerProvider.notifier)
                      .updateHeartTests(
                        (h) => h.copyWith(
                      lvh: h.lvh.copyWith(value: value),
                    ),
                  );
                },
              ),

              // ─── hs-CRP ───
              AssessmentTextField(
                label: 'High-Sensitivity CRP (mg/L)',
                value: draft.heartTests.hsCrp,
                hintText: '0–10 mg/L',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  ref.read(assessmentControllerProvider.notifier).updateHeartTests(
                        (h) => h.copyWith(
                      hsCrp: h.hsCrp.copyWith(value: double.tryParse(val)),
                    ),
                  );
                },
                showFreshness: true,
              ),
              const SizedBox(height: 16),

              // ─── BNP / NT-proBNP ───
              AssessmentTextField(
                label: 'BNP / NT-proBNP (pg/mL)',
                value: draft.heartTests.bnpNtProBnp,
                hintText: '0–500 pg/mL',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  ref.read(assessmentControllerProvider.notifier).updateHeartTests(
                        (h) => h.copyWith(
                      bnpNtProBnp: h.bnpNtProBnp.copyWith(value: double.tryParse(val)),
                    ),
                  );
                },
                showFreshness: true,
              ),
              const SizedBox(height: 16),

              // ─── hs-Troponin ───
              AssessmentTextField(
                label: 'High-Sensitivity Troponin (pg/mL)',
                value: draft.heartTests.hsTroponin,
                hintText: '0–50 pg/mL',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  ref.read(assessmentControllerProvider.notifier).updateHeartTests(
                        (h) => h.copyWith(
                      hsTroponin: h.hsTroponin.copyWith(value: double.tryParse(val)),
                    ),
                  );
                },
                showFreshness: true,
              ),
              const SizedBox(height: 16),

              // ─── CAC Score ───
              AssessmentTextField(
                label: 'Coronary Artery Calcium (CAC) Score',
                value: draft.heartTests.cacScore,
                hintText: '0–2500+',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  ref.read(assessmentControllerProvider.notifier).updateHeartTests(
                        (h) => h.copyWith(
                      cacScore: h.cacScore.copyWith(value: double.tryParse(val)),
                    ),
                  );
                },
                showFreshness: true,
              ),
              const SizedBox(height: 16),

              // ─── Carotid Plaque ───
              AssessmentToggleSelector<bool>(
                label: 'Carotid Plaque',
                value: draft.heartTests.carotidPlaque.value,
                options: const [
                  true,
                  false,
                ],
                optionLabel: (value) => value ? 'Yes' : 'No',
                onChanged: (value) {
                  ref
                      .read(assessmentControllerProvider.notifier)
                      .updateHeartTests(
                        (h) => h.copyWith(
                      carotidPlaque:
                      h.carotidPlaque.copyWith(value: value),
                    ),
                  );
                },
              ),

              // ─── Carotid Stenosis % ───
              AssessmentTextField(
                label: 'Carotid Stenosis (%)',
                value: draft.heartTests.carotidStenosisPercent,
                hintText: '0–100% (optional)',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  ref.read(assessmentControllerProvider.notifier).updateHeartTests(
                        (h) => h.copyWith(
                      carotidStenosisPercent: h.carotidStenosisPercent.copyWith(value: double.tryParse(val)),
                    ),
                  );
                },
                showFreshness: true,
              ),
              const SizedBox(height: 16),

              // ─── ABI Left ───
              AssessmentTextField(
                label: 'Ankle-Brachial Index (ABI) - Left',
                value: draft.heartTests.abiLeft,
                hintText: '0.9–1.3',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  ref.read(assessmentControllerProvider.notifier).updateHeartTests(
                        (h) => h.copyWith(
                      abiLeft: h.abiLeft.copyWith(value: double.tryParse(val)),
                    ),
                  );
                },
                showFreshness: true,
              ),
              const SizedBox(height: 16),

              // ─── ABI Right ───
              AssessmentTextField(
                label: 'Ankle-Brachial Index (ABI) - Right',
                value: draft.heartTests.abiRight,
                hintText: '0.9–1.3',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  ref.read(assessmentControllerProvider.notifier).updateHeartTests(
                        (h) => h.copyWith(
                      abiRight: h.abiRight.copyWith(value: double.tryParse(val)),
                    ),
                  );
                },
                showFreshness: true,
              ),
              const SizedBox(height: 24),

              // ─── ECG Upload Section ───
              const _SectionHeader(label: 'ECG Analysis'),
              const SizedBox(height: 12),
              if (draft.heartTests.ecgFileName != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '✓ ${draft.heartTests.ecgFileName}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
                      if (draft.heartTests.ecgAnalysisResult != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          draft.heartTests.ecgAnalysisResult!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: ecgAnalyzing
                      ? null
                      : () {
                    // TODO: implement ECG file picker & upload
                    // ref.read(assessmentControllerProvider.notifier)
                    //     .analyzeEcg(localPath, fileName);
                  },
                  icon: ecgAnalyzing
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                      : const Icon(
                    Icons.upload_file,
                    size: 17,
                  ),
                  label: Text(
                    ecgAnalyzing ? 'Analyzing...' : 'Upload & Analyze ECG',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navActive,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 30,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              SizedBox(height: 10,)
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF222222),
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFDDDDDD)),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ),
      ],
    );
  }
}