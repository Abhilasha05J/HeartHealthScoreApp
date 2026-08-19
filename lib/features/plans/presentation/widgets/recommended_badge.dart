import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// The orange "RECOMMENDED" pill shown above a package card.
class RecommendedBadge extends StatelessWidget {
  const RecommendedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.planRecommendedBadgeBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'RECOMMENDED',
        style: TextStyle(
          color: AppColors.planRecommendedBadgeText,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
