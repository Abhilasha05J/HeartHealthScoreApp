import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// The mint "+ New Workout" / "+ Add Exercise" pill pair.
class ActionPillButtons extends StatelessWidget {
  const ActionPillButtons({super.key, required this.onNewWorkout, required this.onAddExercise});

  final VoidCallback onNewWorkout;
  final VoidCallback onAddExercise;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Pill(icon: Icons.add_circle_outline, label: 'New Workout', onTap: onNewWorkout),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _Pill(icon: Icons.add, label: 'Add Exercise', onTap: onAddExercise),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.mintChipBg,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.mintChipText, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.mintChipText,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
