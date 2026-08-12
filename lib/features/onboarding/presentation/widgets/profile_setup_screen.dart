import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:heart_health_score/core/router/app_router.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/widgets/gradient_card.dart';
import 'package:heart_health_score/core/widgets/gradient_text_field.dart';
import 'package:heart_health_score/core/widgets/primary_button.dart';
import 'package:heart_health_score/core/widgets/selectable_chip.dart';
import 'package:heart_health_score/features/onboarding/application/onboarding_providers.dart';
import 'package:heart_health_score/features/onboarding/domain/onboarding_data.dart';
import 'package:heart_health_score/features/onboarding/presentation/onboarding_scaffold.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  BiologicalSex _sex = BiologicalSex.female;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingControllerProvider);
    _nameController.text = draft.fullName ?? '';
    _ageController.text = draft.age?.toString() ?? '';
    _weightController.text = draft.weightKg?.toString() ?? '';
    _heightController.text = draft.heightCm?.toString() ?? '';
    _sex = draft.sex ?? BiologicalSex.female;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    ref.read(onboardingControllerProvider.notifier).updateProfile(
          fullName: _nameController.text.trim(),
          sex: _sex,
          age: int.tryParse(_ageController.text.trim()),
          weightKg: double.tryParse(_weightController.text.trim()),
          heightCm: double.tryParse(_heightController.text.trim()),
        );
    context.push(AppRoutes.dailyActivity);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      heading: 'Profile Setup',
      subtitle: 'Configure your baselines for accurate health insights.',
      topBarTitle: 'Create Profile',
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GradientCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LabeledGradientField(
                    label: 'Full Name',
                    child: GradientTextField(
                      controller: _nameController,
                      hintText: 'Enter full name',
                      validator: (value) =>
                          (value == null || value.trim().isEmpty) ? 'Enter your full name' : null,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text('BIOLOGICAL SEX', style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: AppColors.inputText,
                  )),
                  const SizedBox(height: 10),
                  SegmentedSelector(
                    leftLabel: 'Female',
                    rightLabel: 'Male',
                    leftIcon: Icons.female,
                    rightIcon: Icons.male,
                    isLeftSelected: _sex == BiologicalSex.female,
                    onChanged: (isFemale) => setState(() {
                      _sex = isFemale ? BiologicalSex.female : BiologicalSex.male;
                    }),
                  ),
                  const SizedBox(height: 22),
                  LabeledGradientField(
                    label: 'Age',
                    child: GradientTextField(
                      controller: _ageController,
                      hintText: '00',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Enter your age';
                        final age = int.tryParse(value.trim());
                        if (age == null || age <= 0 || age > 120) return 'Enter a valid age';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: LabeledGradientField(
                      label: 'Weight',
                      trailingLabel: 'KG',
                      child: GradientTextField(
                        controller: _weightController,
                        hintText: '00',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}\.?\d{0,1}')),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Required';
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: LabeledGradientField(
                      label: 'Height',
                      trailingLabel: 'CM',
                      child: GradientTextField(
                        controller: _heightController,
                        hintText: '00',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}\.?\d{0,1}')),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Required';
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomButton: PrimaryButton(label: 'Create Profile', onPressed: _handleContinue),
    );
  }
}
