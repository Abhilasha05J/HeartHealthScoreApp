import 'package:flutter/material.dart';

import '../../../../core/theme/fitness_palette.dart';
import '../../domain/workout_data.dart';

/// The row of three cards: Steps / Active time / Calories, each with a
/// colored heading, big value, hairline progress rule, and "/target" caption.
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
            color: FitnessPalette.statStepsColor,
            value: '${summary.steps}',
            target: '/${summary.stepsTarget}',
            progress: summary.stepsProgress,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatMiniCard(
            label: 'Active time',
            color: FitnessPalette.statActiveTimeColor,
            value: '${summary.activeMinutes}',
            unit: 'm',
            target: '/${summary.activeMinutesTarget}',
            progress: summary.activeMinutesProgress,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatMiniCard(
            label: 'Calories',
            color: FitnessPalette.statCaloriesColor,
            value: '${summary.calories}',
            target: '/${summary.caloriesTarget}',
            progress: summary.caloriesProgress,
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
    required this.progress,
    this.unit,
  });

  final String label;
  final Color color;
  final String value;
  final String? unit;
  final String target;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: FitnessPalette.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
       // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: FitnessPalette.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
                if (unit != null)
                  TextSpan(
                    text: unit,
                    style: const TextStyle(
                      color: FitnessPalette.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 1,
              backgroundColor: FitnessPalette.divider,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            target,
            style: const TextStyle(color: FitnessPalette.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
