import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/plan_data.dart';
import 'plan_pill_button.dart';
import 'recommended_badge.dart';

/// One package card. Content is either a green-checkmark bullet list or a
/// single paragraph — driven by `package.cardBullets` /
/// `package.cardParagraph`, matching whichever the source screenshots used
/// for that specific package (this is real content variation, not a rule
/// tied to tier or recommended-status).
class PackageCard extends StatelessWidget {
  const PackageCard({
    super.key,
    required this.package,
    required this.cardBackground,
    required this.onButtonTap,
  });

  final PackageOption package;
  final Color cardBackground;
  final VoidCallback onButtonTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, package.isRecommended ? 30 : 20, 20, 20),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  package.cardTitle,
                  style: const TextStyle(color: AppColors.black, fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                '₹${package.priceRupees}',
                style: const TextStyle(color: AppColors.accentColor, fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            package.provider,
            style: const TextStyle(color: AppColors.black, fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          if (package.cardBullets != null)
            for (final bullet in package.cardBullets!)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/icons/correct.png', width: 20, height: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        bullet,
                        style: const TextStyle(color: AppColors.black, fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              )
          else
            Text(
              package.cardParagraph!,
              style: const TextStyle(color: AppColors.black, fontSize: 15, fontWeight: FontWeight.w500, height: 1.4),
            ),
          const SizedBox(height: 20),
          PlanPillButton(
            label: 'View Details',
            onTap: onButtonTap,
          ),
        ],
      ),
    );

    if (!package.isRecommended) return card;

    // Stack (not Column) so paint order puts the badge ON TOP of the card
    // where they overlap — a Column would paint the card second, covering
    // the badge's bottom edge, which was the bug in the previous version.
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          card,
          const Positioned(
            left: 20,
            top: -20,
            child: RecommendedBadge(),
          ),
        ],
      ),
    );
  }
}