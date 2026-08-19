import 'package:flutter/material.dart';

import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/features/dashboard/domain/dashboard_data.dart';
import 'ring_progress_indicator.dart';

class RewardsMilestoneCard extends StatelessWidget {
  const RewardsMilestoneCard({super.key, required this.progress, this.onRedeem});

  final RewardsProgress progress;
  final VoidCallback? onRedeem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'REWARDS & MILESTONES',
              style: AppTextStyles.dashboardcardheading.copyWith(fontSize: 18),
            ),
            GestureDetector(
              onTap: onRedeem,
              child: Text(
                'Redeem',
                style: AppTextStyles.hint.copyWith(
                  color: AppColors.redeemLink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.rewardsCardGlow,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    RingProgressIndicator(
                      progress: progress.progressPercent / 100,
                      trackColor: AppColors.rewardsRingProgress.withOpacity(0.15),
                      progressColor: AppColors.rewardsRingProgress,
                      strokeWidth: 6.4,
                      size: 72,
                      child: Text(
                        '${progress.progressPercent}%',
                        style: AppTextStyles.cardTitle.copyWith(
                          fontSize: 15,
                          color: AppColors.rewardsRingProgress,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Next: ${progress.nextTierName}',
                            style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            progress.description,
                            style: AppTextStyles.hint,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: List.generate(progress.segmentsTotal, (i) {
                              final filled = i < progress.segmentsCompleted;
                              final isLast = i == progress.segmentsTotal - 1;
                              return Expanded(
                                child: Container(
                                  height: 5,
                                  margin: EdgeInsets.only(right: isLast ? 0 : 4),
                                  decoration: BoxDecoration(
                                    color: filled
                                        ? AppColors.rewardsSegmentFill
                                        : AppColors.rewardsSegmentTrack,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Decorative soft glow, top-right corner. Color given
              // (#D1FAE5); exact size/blur wasn't specified — ASSUMPTION,
              // tweak radius/opacity to taste.
              Positioned(
                top: -60,
                right: -60,
                child: IgnorePointer(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.rewardsCardGlow.withOpacity(0.7),
                          AppColors.rewardsCardGlow.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RewardBadgeVisual {
  const _RewardBadgeVisual({
    required this.label,
    required this.iconAsset,
    required this.borderColor,
  });

  final String label;
  final String iconAsset;
  final Color borderColor;
}

const Map<RewardBadgeType, _RewardBadgeVisual> _badgeVisuals = {
  RewardBadgeType.hydrationHero: _RewardBadgeVisual(
    label: 'Hydration Hero',
    iconAsset: 'assets/icons/hydrationhero.png',
    borderColor: AppColors.badgeHydrationBorder,
  ),
  RewardBadgeType.deepSleeper: _RewardBadgeVisual(
    label: 'Deep Sleeper',
    iconAsset: 'assets/icons/deepsleeper.png',
    borderColor: AppColors.badgeSleepBorder,
  ),
  RewardBadgeType.activeStreak: _RewardBadgeVisual(
    label: 'Active Streak',
    iconAsset: 'assets/icons/activestreak.png',
    borderColor: AppColors.badgeStreakBorder,
  ),
};

class RewardBadge extends StatelessWidget {
  const RewardBadge({super.key, required this.type});

  final RewardBadgeType type;

  @override
  Widget build(BuildContext context) {
    final visual = _badgeVisuals[type]!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: visual.borderColor, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(visual.iconAsset, width: 60, height: 60),
              ],
            ),
          ),
          Text(
            visual.label,
            textAlign: TextAlign.center,
            style: AppTextStyles.hint.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class UnlockedRewardsSection extends StatelessWidget {
  const UnlockedRewardsSection({super.key, required this.unlocked});

  final List<RewardBadgeType> unlocked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final type in unlocked) ...[
          Expanded(child: RewardBadge(type: type)),
          if (type != unlocked.last) const SizedBox(width: 12),
        ],
      ],
    );
  }
}