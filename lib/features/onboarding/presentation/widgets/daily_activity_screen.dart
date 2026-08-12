import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:heart_health_score/core/constants/app_assets.dart';
import 'package:heart_health_score/core/router/app_router.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/core/widgets/gradient_card.dart';
import 'package:heart_health_score/core/widgets/gradient_text_field.dart';
import 'package:heart_health_score/core/widgets/primary_button.dart';
import 'package:heart_health_score/core/widgets/selectable_chip.dart';
import 'package:heart_health_score/features/onboarding/application/onboarding_providers.dart';
import 'package:heart_health_score/features/onboarding/domain/onboarding_data.dart';
import 'package:heart_health_score/features/onboarding/presentation/onboarding_scaffold.dart';

class DailyActivityScreen extends ConsumerStatefulWidget {
  const DailyActivityScreen({super.key});

  @override
  ConsumerState<DailyActivityScreen> createState() => _DailyActivityScreenState();
}

class _DailyActivityScreenState extends ConsumerState<DailyActivityScreen> {
  SleepBand? _sleepBand;
  ActivityBand? _activityBand;
  final _customSleepController = TextEditingController();
  final _customActivityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingControllerProvider);
    _sleepBand = draft.sleepBand;
    _activityBand = draft.activityBand;
    if (draft.customSleepHours != null) {
      _customSleepController.text = draft.customSleepHours.toString();
    }
    if (draft.customActivityHours != null) {
      _customActivityController.text = draft.customActivityHours.toString();
    }
  }

  @override
  void dispose() {
    _customSleepController.dispose();
    _customActivityController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    ref.read(onboardingControllerProvider.notifier).updateDailyActivity(
      sleepBand: _sleepBand,
      customSleepHours: double.tryParse(_customSleepController.text.trim()),
      activityBand: _activityBand,
      customActivityHours: double.tryParse(_customActivityController.text.trim()),
    );
    context.push(AppRoutes.basicVitals);
  }

  void _handleSkip() => context.push(AppRoutes.basicVitals);

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      heading: 'Daily Activity',
      subtitle: 'Tell us about your routine to personalize your vital baseline.',
      onSkip: _handleSkip,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GradientCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CardHeader(iconAsset: AppAssets.sleep, title: 'How many hours do you sleep daily?'),
                const SizedBox(height: 18),
                _BandGrid(
                  crossAxisCount: 2,
                  items: const {
                    SleepBand.lessThan6: 'Less than 6h',
                    SleepBand.sixToEight: '6 - 8 hours',
                    SleepBand.eightToTen: '8 - 10 hours',
                    SleepBand.moreThan10: 'More than 10h',
                  },
                  selected: _sleepBand,
                  onSelected: (band) => setState(() {
                    _sleepBand = band;
                    _customSleepController.clear();
                  }),
                ),
                const SizedBox(height: 16),
                Text('Or enter specific hours:', style: AppTextStyles.chipLabel),
                const SizedBox(height: 10),
                GradientTextField(
                  controller: _customSleepController,
                  hintText: 'e.g. 7.5',
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Align(widthFactor: 1, child: Text('hrs')),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}\.?\d{0,1}'))],
                  onChanged: (value) {
                    if (value.isNotEmpty) setState(() => _sleepBand = SleepBand.custom);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GradientCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CardHeader(
                  iconAsset: AppAssets.physicalActivity,
                  title: 'How active are you?',
                ),
                const SizedBox(height: 18),
                _BandGrid(
                  crossAxisCount: 2,
                  items: const {
                    ActivityBand.mostlySitting: 'Mostly Sitting',
                    ActivityBand.oftenStanding: 'Often Standing',
                    ActivityBand.regularlyWalking: 'Regularly Walking',
                    ActivityBand.physicallyIntense: 'Physically Intense Work',
                  },
                  selected: _activityBand,
                  onSelected: (band) => setState(() {
                    _activityBand = band;
                    _customActivityController.clear();
                  }),
                ),
                const SizedBox(height: 16),
                Text('Or enter specific hours:', style: AppTextStyles.chipLabel),
                const SizedBox(height: 10),
                GradientTextField(
                  controller: _customActivityController,
                  hintText: 'e.g. 4',
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Align(widthFactor: 1, child: Text('hrs')),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}\.?\d{0,1}'))],
                  onChanged: (value) {
                    if (value.isNotEmpty) setState(() => _activityBand = ActivityBand.custom);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomButton: PrimaryButton(label: 'Continue', onPressed: _handleContinue),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.iconAsset, required this.title});

  final String iconAsset;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
         child: Image.asset(
            iconAsset,
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.circle, color: AppColors.buttonPrimary, size: 18),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.cardTitle.copyWith(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _BandGrid<T> extends StatelessWidget {
  const _BandGrid({
    required this.crossAxisCount,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final int crossAxisCount;
  final Map<T, String> items;
  final T? selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.6,
      children: items.entries.map((entry) {
        return SelectableChip(
          label: entry.value,
          selected: selected == entry.key,
          onTap: () => onSelected(entry.key),
        );
      }).toList(),
    );
  }
}