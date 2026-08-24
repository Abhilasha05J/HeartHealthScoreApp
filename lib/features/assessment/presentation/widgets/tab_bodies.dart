// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:heart_health_score/core/theme/app_colors.dart';
// import 'package:heart_health_score/core/theme/app_text_styles.dart';
// import '../../application/assessment_providers.dart';
// import '../../domain/assessment_models.dart';
// import 'assessment_widgets.dart';
//
// // -------- Lipids --
//
// class LipidsTabBody extends ConsumerStatefulWidget {
//   const LipidsTabBody({super.key});
//   @override
//   ConsumerState<LipidsTabBody> createState() => _LipidsTabBodyState();
// }
//
// class _LipidsTabBodyState extends ConsumerState<LipidsTabBody> {
//   final _ldl = TextEditingController();
//   final _hdl = TextEditingController();
//   final _tc = TextEditingController();
//   final _tg = TextEditingController();
//   final _apoB = TextEditingController();
//   final _lpA = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     final p = ref.read(assessmentControllerProvider).value?.lipids ?? const LipidProfile();
//     _ldl.text = p.ldlC?.toString() ?? '';
//     _hdl.text = p.hdlC?.toString() ?? '';
//     _tc.text = p.totalCholesterol?.toString() ?? '';
//     _tg.text = p.triglycerides?.toString() ?? '';
//     _apoB.text = p.apoB?.toString() ?? '';
//     _lpA.text = p.lpA?.toString() ?? '';
//   }
//
//   @override
//   void dispose() {
//     for (final c in [_ldl, _hdl, _tc, _tg, _apoB, _lpA]) {
//       c.dispose();
//     }
//     super.dispose();
//   }
//
//   void _update() => ref.read(assessmentControllerProvider.notifier).updateLipids(
//         (p) => p.copyWith(
//       ldlC: double.tryParse(_ldl.text),
//       hdlC: double.tryParse(_hdl.text),
//       totalCholesterol: double.tryParse(_tc.text),
//       triglycerides: double.tryParse(_tg.text),
//       apoB: double.tryParse(_apoB.text),
//       lpA: double.tryParse(_lpA.text),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     final ratio = ref.watch(assessmentControllerProvider).value?.lipids.tcHdlRatio;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AssessmentTextField(
//             label: 'LDL-C', subtitle: 'Primary atherogenic target', controller: _ldl, unit: 'mg/dL', onChanged: (_) => _update()),
//         AssessmentTextField(
//             label: 'HDL-C', subtitle: 'High-Density Lipoprotein', controller: _hdl, unit: 'mg/dL', onChanged: (_) => _update()),
//         AssessmentTextField(label: 'TC (Total Cholesterol)', controller: _tc, unit: 'mg/dL', onChanged: (_) => _update()),
//         AssessmentTextField(label: 'TG (Triglycerides)', controller: _tg, unit: 'mg/dL', onChanged: (_) => _update()),
//         AssessmentTextField(label: 'ApoB  (Apolipoprotein B)', controller: _apoB, unit: 'mg/dL', onChanged: (_) => _update()),
//         AssessmentTextField(
//             label: 'Lp(a)', subtitle: 'Independent genetic risk factor', controller: _lpA, unit: 'mg/dL', onChanged: (_) => _update()),
//         AssessmentTextField(
//           label: 'TC/HDL Ratio',
//           subtitle: 'Risk indicator ratio',
//           controller: TextEditingController(text: ratio?.toStringAsFixed(2) ?? ''),
//           unit: 'Unitless',
//           hintText: 'Auto-calculated',
//           readOnly: true,
//         ),
//       ],
//     );
//   }
// }
//
// // --------------------------------------------------------------- Pressure --
//
// class PressureTabBody extends ConsumerStatefulWidget {
//   const PressureTabBody({super.key});
//   @override
//   ConsumerState<PressureTabBody> createState() => _PressureTabBodyState();
// }
//
// class _PressureTabBodyState extends ConsumerState<PressureTabBody> {
//   final _systolic = TextEditingController();
//   final _diastolic = TextEditingController();
//   final _pulse = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     final p = ref.read(assessmentControllerProvider).value?.pressure ?? const PressureProfile();
//     _systolic.text = p.systolicBp?.toString() ?? '';
//     _diastolic.text = p.diastolicBp?.toString() ?? '';
//
//   }
//
//   @override
//   void dispose() {
//     for (final c in [_systolic, _diastolic, _pulse]) {
//       c.dispose();
//     }
//     super.dispose();
//   }
//
//   void _update() => ref.read(assessmentControllerProvider.notifier).updatePressure(
//         (p) => p.copyWith(
//       systolicBp: double.tryParse(_systolic.text),
//       diastolicBp: double.tryParse(_diastolic.text),
//
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionIconHeader(
//             iconAsset: 'assets/icons/assessment/header_pressure.png', title: 'Blood Pressure / Hemodynamic'),
//         AssessmentTextField(label: 'Systolic BP', controller: _systolic, unit: 'mmHg', onChanged: (_) => _update()),
//         AssessmentTextField(label: 'Diastolic BP', controller: _diastolic, unit: 'mmHg', onChanged: (_) => _update()),
//         AssessmentTextField(label: 'Pulse Pressure', controller: _pulse, unit: 'mmHg', onChanged: (_) => _update()),
//       ],
//     );
//   }
// }
//
// // ---------------------------------------------------------------- Glucose --
//
// class GlucoseTabBody extends ConsumerStatefulWidget {
//   const GlucoseTabBody({super.key});
//   @override
//   ConsumerState<GlucoseTabBody> createState() => _GlucoseTabBodyState();
// }
//
// class _GlucoseTabBodyState extends ConsumerState<GlucoseTabBody> {
//   final _hba1c = TextEditingController();
//   final _fasting = TextEditingController();
//   final _homaIr = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     final p = ref.read(assessmentControllerProvider).value?.glucose ?? const GlucoseProfile();
//     _hba1c.text = p.hba1c?.toString() ?? '';
//     _fasting.text = p.fastingGlucose?.toString() ?? '';
//
//   }
//
//   @override
//   void dispose() {
//     for (final c in [_hba1c, _fasting, _homaIr]) {
//       c.dispose();
//     }
//     super.dispose();
//   }
//
//   void _update({DiabetesStatus? status}) =>
//       ref.read(assessmentControllerProvider.notifier).updateGlucose(
//             (p) => p.copyWith(
//           diabetesStatus: status ?? p.diabetesStatus,
//           hba1c: double.tryParse(_hba1c.text),
//           fastingGlucose: double.tryParse(_fasting.text),
//
//         ),
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     final status = ref.watch(assessmentControllerProvider).value?.glucose.diabetesStatus;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionIconHeader(
//             iconAsset: 'assets/icons/assessment/header_glucose.png', title: 'Glucose / Diabetes'),
//         AssessmentDropdownField<DiabetesStatus>(
//           label: 'Diabetes Status',
//           value: status,
//           items: DiabetesStatus.values,
//           itemLabel: (s) => s.label,
//           onChanged: (s) => _update(status: s),
//         ),
//         AssessmentTextField(label: 'HbA1c', controller: _hba1c, unit: '%', hintText: 'e.g. 90', onChanged: (_) => _update()),
//         AssessmentTextField(label: 'Fasting Glucose', controller: _fasting, unit: 'mg/dL', hintText: 'e.g. 90', onChanged: (_) => _update()),
//         AssessmentTextField(label: 'HOMA-IR', controller: _homaIr, unit: 'Index', hintText: 'e.g. 1.2', onChanged: (_) => _update()),
//       ],
//     );
//   }
// }
//
// // ----------------------------------------------------------------- Kidney --
//
// class KidneyTabBody extends ConsumerStatefulWidget {
//   const KidneyTabBody({super.key});
//   @override
//   ConsumerState<KidneyTabBody> createState() => _KidneyTabBodyState();
// }
//
// class _KidneyTabBodyState extends ConsumerState<KidneyTabBody> {
//   final _egfr = TextEditingController();
//   final _creatinine = TextEditingController();
//   final _uacr = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     final p = ref.read(assessmentControllerProvider).value?.kidney ?? const KidneyProfile();
//     _egfr.text = p.eGfr?.toString() ?? '';
//     _creatinine.text = p.creatinine?.toString() ?? '';
//     _uacr.text = p.uacr?.toString() ?? '';
//   }
//
//   @override
//   void dispose() {
//     for (final c in [_egfr, _creatinine, _uacr]) {
//       c.dispose();
//     }
//     super.dispose();
//   }
//
//   void _update() => ref.read(assessmentControllerProvider.notifier).updateKidney(
//         (p) => p.copyWith(
//       eGfr: double.tryParse(_egfr.text),
//       creatinine: double.tryParse(_creatinine.text),
//       uacr: double.tryParse(_uacr.text),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SectionIconHeader(
//             iconAsset: 'assets/icons/assessment/header_kidney.png', title: 'Kidney / Vascular Damage'),
//         AssessmentTextField(
//             label: 'eGFR', controller: _egfr, unit: 'mL/min/1.73m²', hintText: 'Estimated Glomeru', onChanged: (_) => _update()),
//         AssessmentTextField(label: 'Creatinine', controller: _creatinine, unit: 'mg/dL', hintText: '0.00', onChanged: (_) => _update()),
//         AssessmentTextField(
//             label: 'UACR / Microalbuminuria', controller: _uacr, unit: 'mg/g', onChanged: (_) => _update()),
//       ],
//     );
//   }
// }
//
// // --------------------------------------------------------------- Behavior --
//
// class LifestyleFitnessTabBody extends ConsumerStatefulWidget {
//   const LifestyleFitnessTabBody({super.key});
//   @override
//   ConsumerState<LifestyleFitnessTabBody> createState() => _LifestyleFitnessTabBodyState();
// }
//
// class _LifestyleFitnessTabBodyState extends ConsumerState<LifestyleFitnessTabBody> {
//   final _bmi = TextEditingController();
//   final _waist = TextEditingController();
//   final _waistHip = TextEditingController();
//   final _weeklyActivity = TextEditingController();
//   final _structuredActivity = TextEditingController();
//   final _geneticScore = TextEditingController();
//   final _moderateVigorous = TextEditingController(text: '120');
//   final _dietScore = TextEditingController();
//   final _alcohol = TextEditingController();
//   final _sleep = TextEditingController();
//   final _stressScore = TextEditingController();
//   final _restingHr = TextEditingController();
//   final _vo2Max = TextEditingController();
//   final _hrRecovery = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     final b = ref.read(assessmentControllerProvider).value?.lifestyle ?? const LifestyleFitnessProfile();
//     _bmi.text = b.bmi?.toString() ?? '';
//     _waist.text = b.waistCircumference?.toString() ?? '';
//     _waistHip.text = b.waistHipRatio?.toString() ?? '';
//     _weeklyActivity.text = b.weeklyActivityMinutes?.toString() ?? '';
//     _structuredActivity.text = b.structuredActivityScore?.toString() ?? '';
//     _geneticScore.text = b.geneticRiskScorePercent?.toString() ?? '';
//     _moderateVigorous.text = b.moderateVigorousActivityMinutes.toString();
//     _dietScore.text = b.dietQualityScore?.toString() ?? '';
//     _alcohol.text = b.alcoholDrinksPerWeek?.toString() ?? '';
//     _sleep.text = b.sleepHoursPerNight?.toString() ?? '';
//     _stressScore.text = b.stressIndexScore?.toString() ?? '';
//     _restingHr.text = b.restingHeartRate?.toString() ?? '';
//     _vo2Max.text = b.vo2Max?.toString() ?? '';
//     _hrRecovery.text = b.heartRateRecoveryBpm?.toString() ?? '';
//   }
//
//   @override
//   void dispose() {
//     for (final c in [
//       _bmi, _waist, _waistHip, _weeklyActivity, _structuredActivity,
//       _geneticScore, _moderateVigorous, _dietScore, _alcohol, _sleep, _stressScore,_restingHr, _vo2Max, _hrRecovery,
//     ]) {
//       c.dispose();
//     }
//     super.dispose();
//   }
//
//   void _patch(LifestyleFitnessProfile Function(LifestyleFitnessProfile) f) =>
//       ref.read(assessmentControllerProvider.notifier).updateLifestyle(f); // was: updateBehavior
//
//   void _updateNumericFields() => _patch((b) => b.copyWith(
//     bmi: double.tryParse(_bmi.text),
//     waistCircumference: double.tryParse(_waist.text),
//     waistHipRatio: double.tryParse(_waistHip.text),
//     weeklyActivityMinutes: double.tryParse(_weeklyActivity.text),
//     structuredActivityScore: double.tryParse(_structuredActivity.text),
//     geneticRiskScorePercent: double.tryParse(_geneticScore.text),
//     moderateVigorousActivityMinutes: double.tryParse(_moderateVigorous.text) ?? 0,
//     dietQualityScore: double.tryParse(_dietScore.text),
//     alcoholDrinksPerWeek: double.tryParse(_alcohol.text),
//     sleepHoursPerNight: double.tryParse(_sleep.text),
//     stressIndexScore: double.tryParse(_stressScore.text),
//     restingHeartRate: double.tryParse(_restingHr.text),
//     vo2Max: double.tryParse(_vo2Max.text),
//     heartRateRecoveryBpm: double.tryParse(_hrRecovery.text),
//   ));
//
//   @override
//   Widget build(BuildContext context) {
//     final b = ref.watch(assessmentControllerProvider).value?.lifestyle ?? const LifestyleFitnessProfile();
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // -- Adiposity --------------------------------------------------
//         const SectionIconHeader(
//             iconAsset: 'assets/icons/assessment/header_adiposity.png', title: 'Adiposity'),
//         AssessmentTextField(label: 'BMI', controller: _bmi, unit: 'kg/m²', hintText: 'e.g. 24.5', onChanged: (_) => _updateNumericFields()),
//         Row(
//           children: [
//             Expanded(
//               child: AssessmentTextField(
//                   label: 'Waist Circumference', controller: _waist, unit: 'cm', hintText: '00.0', onChanged: (_) => _updateNumericFields()),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: AssessmentTextField(
//                   label: 'Waist-Hip Ratio', controller: _waistHip, hintText: 'Ratio (e.g. 0.85)', onChanged: (_) => _updateNumericFields()),
//             ),
//           ],
//         ),
//
//         // -- Physical Activity -------------------------------------------
//         const SectionIconHeader(
//             iconAsset: 'assets/icons/assessment/header_physical_activity.png', title: 'Physical Activity'),
//         AssessmentTextField(
//             label: 'Weekly Activity', controller: _weeklyActivity, unit: 'Min/Week', hintText: 'Total Duration', onChanged: (_) => _updateNumericFields()),
//         AssessmentTextField(
//             label: 'Structured Activity Score', controller: _structuredActivity, unit: 'Points / Index Score', onChanged: (_) => _updateNumericFields()),
//
//         // -- Inherited Risk -----------------------------------------------
//         const SectionIconHeader(
//             iconAsset: 'assets/icons/assessment/header_inherited_risk.png', title: 'Inherited Risk'),
//         AssessmentToggleSelector<bool>(
//           label: 'Family History of Premature CVD',
//           value: b.familyHistoryPrematureCvd,
//           options: const [true, false],
//           optionLabel: (v) => v ? 'Yes' : 'No',
//           onChanged: (v) => _patch((p) => p.copyWith(familyHistoryPrematureCvd: v)),
//         ),
//         AssessmentToggleSelector<RiskLevel>(
//           label: 'Genetic Risk',
//           value: b.geneticRisk,
//           options: RiskLevel.values,
//           optionLabel: (v) => v.label,
//           onChanged: (v) => _patch((p) => p.copyWith(geneticRisk: v)),
//         ),
//         AssessmentTextField(label: 'Score', controller: _geneticScore, unit: '%', onChanged: (_) => _updateNumericFields()),
//
//         // -- Tobacco Use ----------------------------------------------------
//         const SectionIconHeader(
//             iconAsset: 'assets/icons/assessment/header_tobacco.png', title: 'Tobacco Use'),
//         AssessmentDropdownField<SmokingStatus>(
//           label: 'Smoking Status',
//           value: b.smokingStatus,
//           items: SmokingStatus.values,
//           itemLabel: (s) => s.label,
//           onChanged: (s) => _patch((p) => p.copyWith(smokingStatus: s)),
//         ),
//         // ASSUMPTION: mockup shows these as dropdown-styled chevron fields
//         // with no visible numeric entry — implemented as bounded pickers
//         // (0-60 pack-years, 0-40 quit-years). Confirm the intended range/UX
//         // with the designer; swap for a plain numeric field if that's closer
//         // to what's wanted.
//         AssessmentDropdownField<int>(
//           label: 'Pack-Years',
//           value: b.packYears,
//           items: List.generate(61, (i) => i),
//           itemLabel: (y) => '$y',
//           hintText: 'Years',
//           onChanged: (y) => _patch((p) => p.copyWith(packYears: y)),
//         ),
//         AssessmentDropdownField<int>(
//           label: 'Quit Duration',
//           value: b.quitDurationYears,
//           items: List.generate(41, (i) => i),
//           itemLabel: (y) => '$y',
//           hintText: 'Month/Years',
//           onChanged: (y) => _patch((p) => p.copyWith(quitDurationYears: y)),
//         ),
//
//         // -- Activity (target-tracked) --------------------------------------
//         const SectionIconHeader(
//             iconAsset: 'assets/icons/assessment/header_physical_activity.png', title: 'Activity'),
//         AssessmentTargetProgressField(
//           label: 'Moderate/Vigorous Activity',
//           controller: _moderateVigorous,
//           unit: 'min/week',
//           target: 150,
//           onChanged: (_) => setState(_updateNumericFields),
//         ),
//
//         // -- Diet / Nutrition -------------------------------------------------
//         const SectionIconHeader(
//             iconAsset: 'assets/icons/assessment/header_diet.png', title: 'Diet / Nutrition'),
//         AssessmentTextField(
//             label: 'Diet Quality Score', controller: _dietScore, unit: 'Points / Index Score', hintText: '0-100', onChanged: (_) => _updateNumericFields()),
//
//         // -- Alcohol -----------------------------------------------------------
//         const SectionIconHeader(
//             iconAsset: 'assets/icons/assessment/header_alcohol.png', title: 'Alcohol'),
//         AssessmentTextField(
//             label: 'Average Consumption', controller: _alcohol, unit: 'Drinks/week', hintText: 'e.g. 4', onChanged: (_) => _updateNumericFields()),
//
//         // -- Sleep --------------------------------------------------------------
//         const SectionIconHeader(
//             iconAsset: 'assets/icons/assessment/header_sleep.png', title: 'Sleep'),
//         AssessmentTextField(
//             label: 'Average Duration', controller: _sleep, unit: 'Hours/night', hintText: 'e.g. 7.5', onChanged: (_) => _updateNumericFields()),
//
//         // -- Stress / Psychosocial -------------------------------------------
//         const SectionIconHeader(
//             iconAsset: 'assets/icons/assessment/header_stress.png', title: 'Stress / Psychosocial'),
//         AssessmentDropdownField<StressLevel>(
//           label: 'Categorical Assessment',
//           value: b.stressLevel,
//           items: StressLevel.values,
//           itemLabel: (s) => s.label,
//           onChanged: (s) => _patch((p) => p.copyWith(stressLevel: s)),
//         ),
//         AssessmentTextField(
//           label: 'Standardized Index Score (Optional)',
//           controller: _stressScore,
//           hintText: 'Score',
//           onChanged: (_) => _updateNumericFields(),
//         ),
//         // -- Cardiorespiratory Fitness (NEW) ------------------------------
//         const SectionIconHeader(iconData: Icons.monitor_heart_outlined, title: 'Cardiorespiratory Fitness'),
//         AssessmentTextField(label: 'Resting Heart Rate', controller: _restingHr, unit: 'bpm', onChanged: (_) => _updateNumericFields()),
//         AssessmentTextField(label: 'VO₂max / Cardiorespiratory Fitness', controller: _vo2Max, unit: 'mL/kg/min', onChanged: (_) => _updateNumericFields()),
//         AssessmentTextField(label: 'Heart Rate Recovery', subtitle: 'bpm drop after 1 minute', controller: _hrRecovery, unit: 'bpm', onChanged: (_) => _updateNumericFields()),
//       ],
//     );
//   }
// }
//
// // ------------------------------------------------------------- Heart Tests --
//
// class HeartTestsTabBody extends ConsumerStatefulWidget {
//   const HeartTestsTabBody({super.key});
//   @override
//   ConsumerState<HeartTestsTabBody> createState() => _HeartTestsTabBodyState();
// }
//
// class _HeartTestsTabBodyState extends ConsumerState<HeartTestsTabBody> {
//   final _hsCrp = TextEditingController();
//   final _bnp = TextEditingController();
//   final _troponin = TextEditingController();
//   final _cacScore = TextEditingController();
//   final _stenosis = TextEditingController();
//   final _abiLeft = TextEditingController();
//   final _abiRight = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     final h = ref.read(assessmentControllerProvider).value?.heartTests ?? const HeartTestsProfile();
//     _hsCrp.text = h.hsCrp?.toString() ?? '';
//     _bnp.text = h.bnpNtProBnp?.toString() ?? '';
//     _troponin.text = h.hsTroponin?.toString() ?? '';
//     _cacScore.text = h.cacScore?.toString() ?? '';
//     _stenosis.text = h.carotidStenosisPercent?.toString() ?? '';
//     _abiLeft.text = h.abiLeft?.toString() ?? '';
//     _abiRight.text = h.abiRight?.toString() ?? '';
//   }
//
//   @override
//   void dispose() {
//     for (final c in [_hsCrp, _bnp, _troponin, _cacScore, _stenosis, _abiLeft, _abiRight]) {
//       c.dispose();
//     }
//     super.dispose();
//   }
//
//   void _patch(HeartTestsProfile Function(HeartTestsProfile) f) =>
//       ref.read(assessmentControllerProvider.notifier).updateHeartTests(f);
//
//   void _updateNumericFields() => _patch((h) => h.copyWith(
//     hsCrp: double.tryParse(_hsCrp.text),
//     bnpNtProBnp: double.tryParse(_bnp.text),
//     hsTroponin: double.tryParse(_troponin.text),
//     cacScore: double.tryParse(_cacScore.text),
//     carotidStenosisPercent: double.tryParse(_stenosis.text),
//     abiLeft: double.tryParse(_abiLeft.text),
//     abiRight: double.tryParse(_abiRight.text),
//   ));
//
//   Future<void> _pickEcg() async {
//     // Single unified picker (PDF or photo of a printed strip) — simpler than
//     // ReportUploadBox's 3-way sheet since ECG only needs one file, not a list.
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
//     );
//     final picked = result?.files.single;
//     if (picked?.path == null) return;
//     _patch((h) => h.copyWith(ecgLocalPath: picked!.path!, ecgFileName: picked.name, ecgAnalysisResult: null));
//   }
//
//   Future<void> _analyzeEcg(String path, String name) async {
//     ref.read(ecgAnalyzingProvider.notifier).state = true;
//     try {
//       await ref.read(assessmentControllerProvider.notifier).analyzeEcg(path, name);
//     } catch (_) {
//       if (mounted) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text("Couldn't analyze that ECG. Please try again.")));
//       }
//     } finally {
//       ref.read(ecgAnalyzingProvider.notifier).state = false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final h = ref.watch(assessmentControllerProvider).value?.heartTests ?? const HeartTestsProfile();
//     final analyzing = ref.watch(ecgAnalyzingProvider);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // -- Structural & Imaging --------------------------------------
//         const SectionIconHeader(iconData: Icons.favorite_border, title: 'Structural & Imaging'),
//         AssessmentToggleSelector<bool>(
//           label: 'LVH',
//           value: h.lvh,
//           options: const [true, false],
//           optionLabel: (v) => v ? 'Yes' : 'No',
//           onChanged: (v) => _patch((p) => p.copyWith(lvh: v)),
//         ),
//         AssessmentTextField(label: 'CAC Score', controller: _cacScore, onChanged: (_) => _updateNumericFields()),
//         AssessmentToggleSelector<bool>(
//           label: 'Carotid Plaque',
//           value: h.carotidPlaque,
//           options: const [true, false],
//           optionLabel: (v) => v ? 'Yes' : 'No',
//           onChanged: (v) => _patch((p) => p.copyWith(carotidPlaque: v)),
//         ),
//         AssessmentTextField(
//             label: 'Carotid Stenosis %', subtitle: 'Optional', controller: _stenosis, unit: '%', onChanged: (_) => _updateNumericFields()),
//         Row(
//           children: [
//             Expanded(child: AssessmentTextField(label: 'ABI Left', controller: _abiLeft, hintText: 'e.g. 1.1', onChanged: (_) => _updateNumericFields())),
//             const SizedBox(width: 12),
//             Expanded(child: AssessmentTextField(label: 'ABI Right', controller: _abiRight, hintText: 'e.g. 1.1', onChanged: (_) => _updateNumericFields())),
//           ],
//         ),
//
//         // -- Biomarkers ---------------------------------------------------
//         const SectionIconHeader(iconData: Icons.biotech_outlined, title: 'Biomarkers'),
//         AssessmentTextField(label: 'hs-CRP', controller: _hsCrp, unit: 'mg/L', onChanged: (_) => _updateNumericFields()),
//         AssessmentTextField(label: 'BNP / NT-proBNP', controller: _bnp, unit: 'pg/mL', onChanged: (_) => _updateNumericFields()),
//         AssessmentTextField(label: 'hs-Troponin', controller: _troponin, unit: 'ng/L', onChanged: (_) => _updateNumericFields()),
//
//         // -- ECG -------------------------------------------------------------
//         const SectionIconHeader(iconData: Icons.monitor_heart_outlined, title: 'ECG'),
//         if (h.ecgFileName == null)
//           SizedBox(
//             width: double.infinity,
//             child: OutlinedButton.icon(
//               onPressed: _pickEcg,
//               icon: const Icon(Icons.upload_file_outlined, color: AppColors.assessmentGreen),
//               label: const Text('Upload ECG'),
//               style: OutlinedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 side: const BorderSide(color: AppColors.assessmentFieldBorder),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//               ),
//             ),
//           )
//         else ...[
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: AppColors.assessmentFieldBackground,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: AppColors.assessmentFieldBorder),
//             ),
//             child: Row(
//               children: [
//                 const Icon(Icons.insert_drive_file_outlined, color: AppColors.assessmentGreen),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(h.ecgFileName!,
//                       maxLines: 1, overflow: TextOverflow.ellipsis,
//                       style: AppTextStyles.chipLabel.copyWith(fontSize: 13, color: AppColors.inputText)),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close, size: 18, color: AppColors.assessmentMutedText),
//                   onPressed: () => _patch((p) => const HeartTestsProfile().copyWith(
//                     lvh: p.lvh, hsCrp: p.hsCrp, bnpNtProBnp: p.bnpNtProBnp, hsTroponin: p.hsTroponin,
//                     cacScore: p.cacScore, carotidPlaque: p.carotidPlaque,
//                     carotidStenosisPercent: p.carotidStenosisPercent, abiLeft: p.abiLeft, abiRight: p.abiRight,
//                   )), // clears only the ECG fields, keeps the rest of the section
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: analyzing ? null : () => _analyzeEcg(h.ecgLocalPath!, h.ecgFileName!),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.assessmentGreen,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//               ),
//               child: analyzing
//                   ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//                   : const Text('Analyze'),
//             ),
//           ),
//           if (h.ecgAnalysisResult != null) ...[
//             const SizedBox(height: 12),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: AppColors.assessmentFieldBackground,
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Text(h.ecgAnalysisResult!,
//                   style: AppTextStyles.chipLabel.copyWith(fontSize: 13, color: AppColors.inputText)),
//             ),
//           ],
//         ],
//         const SizedBox(height: 20),
//       ],
//     );
//   }
// }
// Example: How to refactor tab_bodies.dart to use the new field widgets
// with auto-prefill + freshness display
//
// This shows the pattern to apply to all tab bodies (lipids, pressure, glucose, etc.)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/assessment_providers.dart';
import '../../domain/assessment_models.dart';
import 'assessment_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────
// AFTER (new approach — AssessmentTextField with freshness + prefill)
// ─────────────────────────────────────────────────────────────────────────

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
              showFreshness: true, // ← Shows "2 months ago" if > 0 months old
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
            AssessmentChipSelector<DiabetesStatus>(
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
            ),
            const SizedBox(height: 16),
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

class LifestyleFitnessTabBody extends ConsumerWidget {
  const LifestyleFitnessTabBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftAsync = ref.watch(assessmentControllerProvider);

    return draftAsync.when(
      data: (draft) {
        return SingleChildScrollView(
          child: Column(
            children: [
              // Adiposity Section
          const SectionIconHeader(
            iconAsset: 'assets/icons/assessment/header_adiposity.png', title: 'Adiposity'),
              const SizedBox(height: 12),
              AssessmentTextField(
                label: 'Body Mass Index (BMI)',
                value: draft.lifestyle.bmi,
                hintText: '18–40 kg/m²',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  ref
                      .read(assessmentControllerProvider.notifier)
                      .updateLifestyle(
                        (l) => l.copyWith(
                      bmi: l.bmi.copyWith(value: double.tryParse(val)),
                    ),
                  );
                },
                showFreshness: true,
              ),
              const SizedBox(height: 16),
              AssessmentTextField(
                label: 'Waist Circumference (cm)',
                value: draft.lifestyle.waistCircumference,
                hintText: '60–150 cm',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  ref
                      .read(assessmentControllerProvider.notifier)
                      .updateLifestyle(
                        (l) => l.copyWith(
                      waistCircumference: l.waistCircumference
                          .copyWith(value: double.tryParse(val)),
                    ),
                  );
                },
                showFreshness: true,
              ),
              const SizedBox(height: 30),

              // Tobacco Section
          const SectionIconHeader(
             iconAsset: 'assets/icons/assessment/header_tobacco.png', title: 'Tobacco Use'),

              const SizedBox(height: 12),
              AssessmentChipSelector<SmokingStatus>(
                label: 'Smoking Status',
                value: draft.lifestyle.smokingStatus,
                options: SmokingStatus.values,
                optionLabel: (status) => status.label,
                onChanged: (status) {
                  ref
                      .read(assessmentControllerProvider.notifier)
                      .updateLifestyle(
                        (l) => l.copyWith(
                      smokingStatus:
                      l.smokingStatus.copyWith(value: status),
                    ),
                  );
                },
                showFreshness: true,
              ),
              const SizedBox(height: 16),
              AssessmentTextField(
                label: 'Pack Years',
                value: draft.lifestyle.packYears,
                hintText: '0–80',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  ref
                      .read(assessmentControllerProvider.notifier)
                      .updateLifestyle(
                        (l) => l.copyWith(
                      packYears:
                      l.packYears.copyWith(value: int.tryParse(val)),
                    ),
                  );
                },
                showFreshness: true,
              ),
              const SizedBox(height: 30),
          const SectionIconHeader(
             iconAsset: 'assets/icons/assessment/header_diet.png', title: 'Diet / Nutrition'),

              AssessmentTextField(
                label: 'Diet Quality Score',
                value: draft.lifestyle.dietQualityScore,
                hintText: '0–100',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  ref
                      .read(assessmentControllerProvider.notifier)
                      .updateLifestyle(
                        (l) => l.copyWith(
                      dietQualityScore: l.dietQualityScore
                          .copyWith(value: double.tryParse(val)),
                    ),
                  );
                },
                showFreshness: true,
              ),
              const SizedBox(height: 30),
          const SectionIconHeader(
             iconAsset: 'assets/icons/assessment/header_sleep.png', title: 'Sleep'),
              AssessmentTextField(
                label: 'Sleep Hours per Night',
                value: draft.lifestyle.sleepHoursPerNight,
                hintText: '4–12 hours',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  ref
                      .read(assessmentControllerProvider.notifier)
                      .updateLifestyle(
                        (l) => l.copyWith(
                      sleepHoursPerNight: l.sleepHoursPerNight
                          .copyWith(value: double.tryParse(val)),
                    ),
                  );
                },
                showFreshness: true,
              ),
              const SizedBox(height: 30),
          const SectionIconHeader(
        iconAsset: 'assets/icons/assessment/header_alcohol.png', title: 'Alcohol'),

              AssessmentTextField(
                label: 'Alcohol AUDIT Score',
                value: draft.lifestyle.alcoholAudit,
                hintText: '0–40',
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  ref
                      .read(assessmentControllerProvider.notifier)
                      .updateLifestyle(
                        (l) => l.copyWith(
                      alcoholAudit:
                      l.alcoholAudit.copyWith(value: double.tryParse(val)),
                    ),
                  );
                },
                showFreshness: true,
              ),
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

class HeartTestsTabBody extends ConsumerWidget {
  const HeartTestsTabBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftAsync = ref.watch(assessmentControllerProvider);

    return draftAsync.when(
      data: (draft) {
        return Column(
          children: [
            const SectionIconHeader(
                iconAsset: 'assets/icons/assessment/tab_hearttest.png', title: 'Heart Tests'),
            AssessmentTextField(
              label: 'High-Sensitivity CRP (mg/L)',
              value: draft.heartTests.hsCrp,
              hintText: '0–10 mg/L',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                ref
                    .read(assessmentControllerProvider.notifier)
                    .updateHeartTests(
                      (h) => h.copyWith(
                    hsCrp: h.hsCrp.copyWith(value: double.tryParse(val)),
                  ),
                );
              },
              showFreshness: true,
            ),
            const SizedBox(height: 16),
            AssessmentTextField(
              label: 'Coronary Artery Calcium Score',
              value: draft.heartTests.cacScore,
              hintText: '0–2500+',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                ref
                    .read(assessmentControllerProvider.notifier)
                    .updateHeartTests(
                      (h) => h.copyWith(
                    cacScore:
                    h.cacScore.copyWith(value: double.tryParse(val)),
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