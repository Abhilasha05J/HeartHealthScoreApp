import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SummaryRuleCard extends StatelessWidget {
  const SummaryRuleCard({
    super.key,
    required this.totalBurntCalories,
    required this.distanceActiveKm,
  });

  final int totalBurntCalories;
  final double distanceActiveKm;

  @override
  Widget build(BuildContext context) {
   return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.workoutCardBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 7,
                decoration: const BoxDecoration(
                  gradient: AppColors.weekBannerGradient,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      _Row(
                        label: 'Total burnt calories',
                        value: '$totalBurntCalories kcal',
                      ),
                      const SizedBox(height: 18),
                      _Row(
                        label: 'Distance while active',
                        value:
                        '${distanceActiveKm.toStringAsFixed(1)} km',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.inputText, fontSize: 15, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(color: AppColors.inputText, fontSize: 18, fontWeight: FontWeight.w800)),
      ],
    );
  }
}
