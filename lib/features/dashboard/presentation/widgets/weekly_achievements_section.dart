import 'package:flutter/material.dart';

import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/features/dashboard/domain/dashboard_data.dart';
import 'ring_progress_indicator.dart';

class WeeklyAchievementsSection extends StatelessWidget {
  const WeeklyAchievementsSection({super.key, required this.achievements});

  final WeeklyAchievements achievements;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.1,
      children: [
        _AchievementCardShell(
          iconAsset: 'assets/icons/hydration_drop.png',
          title: 'Hydration Master',
          content: _HydrationBarChart(last7DaysMl: achievements.hydrationLast7DaysMl),
          caption: 'Last 7 Days',
        ),
        _AchievementCardShell(
          iconAsset: 'assets/icons/workout_dumbbell.png',
          title: 'Daily Activity',
          content: RingProgressIndicator(
            progress: achievements.dailyActivityConsistencyPercent / 100,
            trackColor: AppColors.activityRingTrack,
            progressColor: AppColors.activityRingProgress,
            strokeWidth: 4,
            size: 64,
            child: Text(
              '${achievements.dailyActivityConsistencyPercent}%',
              style: AppTextStyles.cardTitle.copyWith(
                fontSize: 14,
                color: AppColors.activityRingText,
              ),
            ),
          ),
          caption: 'Consistency: ${achievements.dailyActivityConsistencyLabel}',
        ),
        _AchievementCardShell(
          iconAsset: 'assets/icons/moon_purple.png',
          title: 'Sleep Quality',
          content: _SleepQualityBar(score: achievements.sleepQualityScore),
          caption: 'Restorative',
        ),
        _AchievementCardShell(
          iconAsset: 'assets/icons/trend_up_green.png',
          title: 'Vitals Stability',
          content: SizedBox(
            width: double.infinity,
            height: 40,
            child: CustomPaint(
              painter: _SparklinePainter(
                color: AppColors.vitalsStableBorder,
                strokeWidth: 1.6,
              ),
            ),
          ),
          caption: achievements.vitalsStable ? 'STABLE' : 'MONITOR',
          captionColor: AppColors.vitalsStableText,
        ),
      ],
    );
  }
}

class _AchievementCardShell extends StatelessWidget {
  const _AchievementCardShell({
    required this.iconAsset,
    required this.title,
    required this.content,
    required this.caption,
    this.captionColor,
  });

  final String iconAsset;
  final String title;
  final Widget content;
  final String caption;
  final Color? captionColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(iconAsset, width: 18, height: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.hint.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.headingColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(child: Center(child: content)),
          const SizedBox(height: 6),
          Center(
            child: Text(
              caption,
              style: AppTextStyles.hint.copyWith(
                fontSize: 11,
                fontWeight: captionColor != null ? FontWeight.w700 : FontWeight.w400,
                color: captionColor ?? AppTextStyles.hint.color,
                letterSpacing: captionColor != null ? 0.5 : 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HydrationBarChart extends StatelessWidget {
  const _HydrationBarChart({required this.last7DaysMl});

  final List<double> last7DaysMl;

  @override
  Widget build(BuildContext context) {
    final maxVal = last7DaysMl.reduce((a, b) => a > b ? a : b).clamp(1, double.infinity);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(last7DaysMl.length, (i) {
        final isLast = i == last7DaysMl.length - 1;
        final fraction = (last7DaysMl[i] / maxVal).clamp(0.15, 1.0);
        return Container(
          width: 8,
          height: 48 * fraction,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: isLast ? AppColors.hydrationBarFill : AppColors.hydrationBarTrack,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _SleepQualityBar extends StatelessWidget {
  const _SleepQualityBar({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$score',
                style: AppTextStyles.cardTitle.copyWith(
                  fontSize: 22,
                  color: AppColors.sleepQualityValue,
                ),
              ),
              TextSpan(
                text: '/100',
                style: AppTextStyles.hint.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 6,
            width: 90,
            child: Stack(
              children: [
                Container(color: AppColors.sleepQualityBarTrack),
                FractionallySizedBox(
                  widthFactor: (score / 100).clamp(0.0, 1.0),
                  child: Container(color: AppColors.sleepQualityBarFill),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(0, h * 0.55)
      ..cubicTo(w * 0.12, h * 0.1, w * 0.22, h * 0.1, w * 0.32, h * 0.55)
      ..cubicTo(w * 0.42, h * 0.95, w * 0.52, h * 0.95, w * 0.62, h * 0.35)
      ..cubicTo(w * 0.72, h * 0.02, w * 0.82, h * 0.02, w * 0.92, h * 0.4)
      ..lineTo(w, h * 0.35);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}