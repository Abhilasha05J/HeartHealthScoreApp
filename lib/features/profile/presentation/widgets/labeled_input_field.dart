import 'package:flutter/material.dart';

import '../../../../core/theme/fitness_palette.dart';

/// A "Label" + rounded outlined text field, matching the Personal Details
/// form on the profile screen. Distinct from the app's existing
/// `GradientTextField` (horizontal-gradient fill) — this screen uses a flat
/// pale-grey field with a hairline border instead, per the mockup.
class LabeledInputField extends StatelessWidget {
  const LabeledInputField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.hintText,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: FitnessPalette.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: FitnessPalette.textPrimary),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: FitnessPalette.textSecondary, fontWeight: FontWeight.w500),
            filled: true,
            fillColor: FitnessPalette.inputFieldBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: FitnessPalette.inputFieldBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: FitnessPalette.inputFieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: FitnessPalette.navActive, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
