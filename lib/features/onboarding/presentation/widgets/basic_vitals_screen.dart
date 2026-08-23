// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
//
// import 'package:heart_health_score/core/constants/app_assets.dart';
// import 'package:heart_health_score/core/local/onboarding_status_store.dart';
// import 'package:heart_health_score/core/router/app_router.dart';
// import 'package:heart_health_score/core/theme/app_colors.dart';
// import 'package:heart_health_score/core/theme/app_text_styles.dart';
// import 'package:heart_health_score/core/widgets/gradient_card.dart';
// import 'package:heart_health_score/core/widgets/primary_button.dart';
// import 'package:heart_health_score/core/widgets/stepper_field.dart';
// import 'package:heart_health_score/features/auth/application/auth_providers.dart';
// import 'package:heart_health_score/features/onboarding/application/onboarding_providers.dart';
// import 'package:heart_health_score/features/onboarding/presentation/onboarding_scaffold.dart';
//
// class BasicVitalsScreen extends ConsumerStatefulWidget {
//   const BasicVitalsScreen({super.key});
//
//   @override
//   ConsumerState<BasicVitalsScreen> createState() => _BasicVitalsScreenState();
// }
//
// class _BasicVitalsScreenState extends ConsumerState<BasicVitalsScreen> {
//   late int _systolic;
//   late int _diastolic;
//   late double _restingHr;
//   bool _isSubmitting = false;
//
//   static const double _hrMin = 40;
//   static const double _hrMax = 180;
//
//   @override
//   void initState() {
//     super.initState();
//     final draft = ref.read(onboardingControllerProvider);
//     _systolic = draft.systolic;
//     _diastolic = draft.diastolic;
//     _restingHr = draft.restingHeartRate.toDouble().clamp(_hrMin, _hrMax);
//   }
//
//   Future<void> _handleCompleteSetup() async {
//     setState(() => _isSubmitting = true);
//     final controller = ref.read(onboardingControllerProvider.notifier);
//     controller.updateVitals(
//       systolic: _systolic,
//       diastolic: _diastolic,
//       restingHeartRate: _restingHr.round(),
//     );
//
//     // TODO(backend-integration): once wired up, completeSetup() will POST
//     // the full OnboardingData payload to the backend and trigger the ML
//     // health-score calculation. For now it just simulates success.
//     final success = await controller.completeSetup();
//     if (!mounted) return;
//     setState(() => _isSubmitting = false);
//
//     if (success) {
//       context.go(AppRoutes.home);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Something went wrong. Please try again.')),
//       );
//     }
//   }
//
//   Future<void> _handleSkip() async {
//     // Skip still exits onboarding for good (this is the last onboarding
//     // screen), so it needs the same local "onboarding complete" flag as
//     // Complete Setup — otherwise a skipped session looks identical to an
//     // incomplete one on the next restoreSession(), and you're routed
//     // straight back into Profile Setup on every app reopen. See the
//     // fuller explanation on OnboardingStatusStore / completeSetup().
//     await ref.read(onboardingStatusStoreProvider).markComplete();
//     final currentUser = ref.read(currentUserProvider);
//     if (currentUser != null) {
//       ref.read(currentUserProvider.notifier).state =
//           currentUser.copyWith(onboardingComplete: true);
//     }
//     if (mounted) context.go(AppRoutes.home);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return OnboardingScaffold(
//       heading: 'Basic Parameters',
//       subtitle: "Let's record your current vitals for an accurate health snapshot.",
//       topBarTitle: 'Vitals',
//       onSkip: _handleSkip,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           GradientCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Row(
//                   children: [
//                     _IconBadge(iconAsset: AppAssets.bloodPressure),
//                     const SizedBox(width: 14),
//                     Text('BLOOD PRESSURE', style: AppTextStyles.sectionLabel.copyWith(fontSize: 15)),
//                   ],
//                 ),
//                 const SizedBox(height: 18),
//                 Text('Normal range', style: AppTextStyles.hint),
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: StepperField(
//                         label: 'Systolic',
//                         value: _systolic,
//                         unit: 'mmHg',
//                         min: 70,
//                         max: 220,
//                         onChanged: (value) => setState(() => _systolic = value),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: StepperField(
//                         label: 'Diastolic',
//                         value: _diastolic,
//                         unit: 'mmHg',
//                         min: 40,
//                         max: 140,
//                         onChanged: (value) => setState(() => _diastolic = value),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           GradientCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Row(
//                   children: [
//                     _IconBadge(iconAsset: AppAssets.restingHeartRate),
//                     const SizedBox(width: 14),
//                     Text('RESTING HEART RATE', style: AppTextStyles.sectionLabel.copyWith(fontSize: 15)),
//                     const Spacer(),
//                     Text(
//                       '${_restingHr.round()} ',
//                       style: AppTextStyles.statValue,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4),
//                       child: Text('BPM', style: AppTextStyles.chipLabel.copyWith(color: AppColors.accentColor)),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 SliderTheme(
//                   data: SliderTheme.of(context).copyWith(
//                     activeTrackColor: AppColors.divider,
//                     inactiveTrackColor: AppColors.divider.withOpacity(0.25),
//                     thumbColor: Color(0xFF3B3B3B),
//                     overlayColor: AppColors.accentColor.withOpacity(0.15),
//                     trackHeight: 4,
//                     thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
//                   ),
//                   child: Slider(
//                     value: _restingHr,
//                     min: _hrMin,
//                     max: _hrMax,
//                     onChanged: (value) => setState(() => _restingHr = value),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('40', style: AppTextStyles.hint),
//                     Text('110', style: AppTextStyles.hint),
//                     Text('180', style: AppTextStyles.hint),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomButton: PrimaryButton(
//         label: 'Complete Setup',
//         isLoading: _isSubmitting,
//         onPressed: _handleCompleteSetup,
//       ),
//     );
//   }
// }
//
// class _IconBadge extends StatelessWidget {
//   const _IconBadge({required this.iconAsset});
//
//   final String iconAsset;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 45,
//       height: 45,
//       child: Image.asset(
//         iconAsset,
//         errorBuilder: (context, error, stackTrace) =>
//             const Icon(Icons.favorite, color: AppColors.accentColor, size: 18),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:heart_health_score/core/constants/app_assets.dart';
import 'package:heart_health_score/core/local/onboarding_status_store.dart';
import 'package:heart_health_score/core/router/app_router.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/core/widgets/gradient_card.dart';
import 'package:heart_health_score/core/widgets/primary_button.dart';
import 'package:heart_health_score/core/widgets/stepper_field.dart';
import 'package:heart_health_score/features/auth/application/auth_providers.dart';
import 'package:heart_health_score/features/onboarding/application/onboarding_providers.dart';
import 'package:heart_health_score/features/onboarding/presentation/onboarding_scaffold.dart';

class BasicVitalsScreen extends ConsumerStatefulWidget {
  const BasicVitalsScreen({super.key});

  @override
  ConsumerState<BasicVitalsScreen> createState() => _BasicVitalsScreenState();
}

class _BasicVitalsScreenState extends ConsumerState<BasicVitalsScreen> {
  late int _systolic;
  late int _diastolic;
  late double _restingHr;
  bool _isSubmitting = false;

  static const double _hrMin = 40;
  static const double _hrMax = 180;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingControllerProvider);
    _systolic = draft.systolic;
    _diastolic = draft.diastolic;
    _restingHr = draft.restingHeartRate.toDouble().clamp(_hrMin, _hrMax);
  }

  Future<void> _handleCompleteSetup() async {
    setState(() => _isSubmitting = true);
    final controller = ref.read(onboardingControllerProvider.notifier);
    controller.updateVitals(
      systolic: _systolic,
      diastolic: _diastolic,
      restingHeartRate: _restingHr.round(),
    );

    // TODO(backend-integration): once wired up, completeSetup() will POST
    // the full OnboardingData payload to the backend and trigger the ML
    // health-score calculation. For now it just simulates success.
    final success = await controller.completeSetup();
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      context.go(AppRoutes.home);
    } else {
      final message = ref.read(onboardingErrorProvider) ??
          'Something went wrong. Please try again.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _handleSkip() async {
    // Skip still exits onboarding for good (this is the last onboarding
    // screen), so it needs the same local "onboarding complete" flag as
    // Complete Setup — otherwise a skipped session looks identical to an
    // incomplete one on the next restoreSession(), and you're routed
    // straight back into Profile Setup on every app reopen. See the
    // fuller explanation on OnboardingStatusStore / completeSetup().
    await ref.read(onboardingStatusStoreProvider).markComplete();
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      ref.read(currentUserProvider.notifier).state =
          currentUser.copyWith(onboardingComplete: true);
    }
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      heading: 'Basic Parameters',
      subtitle: "Let's record your current vitals for an accurate health snapshot.",
      topBarTitle: 'Vitals',
      onSkip: _handleSkip,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GradientCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _IconBadge(iconAsset: AppAssets.bloodPressure),
                    const SizedBox(width: 14),
                    Text('BLOOD PRESSURE', style: AppTextStyles.sectionLabel.copyWith(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 18),
                Text('Normal range', style: AppTextStyles.hint),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: StepperField(
                        label: 'Systolic',
                        value: _systolic,
                        unit: 'mmHg',
                        min: 70,
                        max: 220,
                        onChanged: (value) => setState(() => _systolic = value),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StepperField(
                        label: 'Diastolic',
                        value: _diastolic,
                        unit: 'mmHg',
                        min: 40,
                        max: 140,
                        onChanged: (value) => setState(() => _diastolic = value),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GradientCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _IconBadge(iconAsset: AppAssets.restingHeartRate),
                    const SizedBox(width: 14),
                    Text('RESTING HEART RATE', style: AppTextStyles.sectionLabel.copyWith(fontSize: 15)),
                    const Spacer(),
                    Text(
                      '${_restingHr.round()} ',
                      style: AppTextStyles.statValue,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('BPM', style: AppTextStyles.chipLabel.copyWith(color: AppColors.accentColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.divider,
                    inactiveTrackColor: AppColors.divider.withOpacity(0.25),
                    thumbColor: Color(0xFF3B3B3B),
                    overlayColor: AppColors.accentColor.withOpacity(0.15),
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                  ),
                  child: Slider(
                    value: _restingHr,
                    min: _hrMin,
                    max: _hrMax,
                    onChanged: (value) => setState(() => _restingHr = value),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('40', style: AppTextStyles.hint),
                    Text('110', style: AppTextStyles.hint),
                    Text('180', style: AppTextStyles.hint),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomButton: PrimaryButton(
        label: 'Complete Setup',
        isLoading: _isSubmitting,
        onPressed: _handleCompleteSetup,
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.iconAsset});

  final String iconAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      child: Image.asset(
        iconAsset,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.favorite, color: AppColors.accentColor, size: 18),
      ),
    );
  }
}