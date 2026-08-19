import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/workout_data.dart';
import 'animated_gradient_divider.dart';

class StatMiniCardRow extends StatelessWidget {
  const StatMiniCardRow({super.key, required this.summary});

  final DailyActivitySummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatMiniCard(
            label: 'Steps',
            color: AppColors.ringGreen,
            value: '${summary.steps}',
            target: '/${summary.stepsTarget}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatMiniCard(
            label: 'Active time',
            color: AppColors.accentColor,
            value: '${summary.activeMinutes}',
            unit: 'm',
            target: '/${summary.activeMinutesTarget}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatMiniCard(
            label: 'Calories',
            color: AppColors.ringPurple,
            value: '${summary.calories}',
            target: '/${summary.caloriesTarget}',
          ),
        ),
      ],
    );
  }
}

class _StatMiniCard extends StatelessWidget {
  const _StatMiniCard({
    required this.label,
    required this.color,
    required this.value,
    required this.target,
    this.unit,
  });

  final String label;
  final Color color;
  final String value;
  final String? unit;
  final String target;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.workoutCardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: AppColors.inputText,
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
                if (unit != null)
                  TextSpan(
                    text: unit,
                    style: const TextStyle(
                      color: AppColors.inputText,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GradientDivider(color: color),
          const SizedBox(height: 6),
          Text(
            target,
            style: const TextStyle(color: AppColors.hintText, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
