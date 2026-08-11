import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/gradient_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/stepper_field.dart';
import '../application/onboarding_providers.dart';
import 'widgets/onboarding_scaffold.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    }
  }

  void _handleSkip() => context.go(AppRoutes.home);

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
                      child: Text('BPM', style: AppTextStyles.chipLabel.copyWith(color: AppColors.redAccent)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.redAccent,
                    inactiveTrackColor: AppColors.redAccent.withOpacity(0.25),
                    thumbColor: AppColors.redAccent,
                    overlayColor: AppColors.redAccent.withOpacity(0.15),
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
            const Icon(Icons.favorite, color: AppColors.redAccent, size: 18),
      ),
    );
  }
}
