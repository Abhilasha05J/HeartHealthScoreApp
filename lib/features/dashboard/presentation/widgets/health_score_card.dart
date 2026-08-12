import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/dashboard_data.dart';

/// The "Healthy Heart Score" card: score/100, confidence %, a two-tone
/// progress bar (green filled portion -> dark unfilled portion), and a
/// "Connect Wearable" CTA.
class HealthScoreCard extends StatelessWidget {
  const HealthScoreCard({
    super.key,
    required this.data,
    required this.onConnectWearable,
  });

  final DashboardData data;
  final VoidCallback onConnectWearable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'HEALTHY HEART SCORE',
                  style: AppTextStyles.sectionLabel.copyWith(
                    color: AppColors.inputText.withOpacity(0.7),
                  ),
                ),
              ),
              Text(
                'CONFIDENCE',
                style: AppTextStyles.sectionLabel.copyWith(
                  color: AppColors.inputText.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: data.healthyHeartScore.toStringAsFixed(1),
                        style: AppTextStyles.pageHeading.copyWith(
                          fontSize: 42,
                          color: AppColors.inputText,
                        ),
                      ),
                      TextSpan(
                        text: ' / ${data.maxScore.toStringAsFixed(0)}',
                        style: AppTextStyles.hint.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${data.confidencePercent}%',
                    style: AppTextStyles.pageHeading.copyWith(
                      fontSize: 24,
                      color: AppColors.inputText,
                    ),
                  ),
                  Text(
                    data.confidenceLabel,
                    style: AppTextStyles.chipLabel.copyWith(
                      color: AppColors.successGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ScoreBar(fraction: data.scoreFraction),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: onConnectWearable,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              icon: const Icon(Icons.watch_outlined, color: AppColors.white, size: 20),
              label: Text('Connect Wearable', style: AppTextStyles.buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({required this.fraction});

  final double fraction;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 8,
        child: Stack(
          children: [
            Container(color: AppColors.scoreTrackDark),
            FractionallySizedBox(
              widthFactor: fraction,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7ED957), AppColors.successGreen],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
