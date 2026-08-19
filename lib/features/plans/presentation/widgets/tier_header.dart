import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/plan_data.dart';

/// Icon + "Moderate: Health Plus" + description, at the top of each tier's
/// notched wrapper card.
class TierHeader extends StatelessWidget {
  const TierHeader({super.key, required this.tier});

  final PlanTierData tier;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(tier.iconAssetPath, width: 26, height: 26),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                tier.titleLine,
                style: const TextStyle(color: AppColors.black, fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          tier.description,
          style: const TextStyle(color: AppColors.black, fontSize: 15, fontWeight: FontWeight.w500, height: 1.4),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
