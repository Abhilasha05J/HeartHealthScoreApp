import 'dart:math';
import 'package:flutter/material.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/features/dashboard/domain/dashboard_data.dart';

class HealthScoreCard extends StatelessWidget {
  const HealthScoreCard({
    super.key,
    required this.data,
    required this.onConnectWearable,
    this.isSyncing = false,
    this.isConnected = false,
  });

  final DashboardData data;
  final VoidCallback onConnectWearable;
  final bool isSyncing;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        // Card background now comes from the designer's asset, not a coded
        // gradient — swap the filename below if "scorbg.png" is actually a
        // typo for "scorebg.png" in your assets folder; using exactly what
        // was given.
        image: const DecorationImage(
          image: AssetImage('assets/images/scorebg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: _ScoreRing(
              score: data.healthyHeartScore,
              maxScore: data.maxScore,
              fraction: data.scoreFraction,
            ),
          ),
          const SizedBox(height: 8),
          const _HeartbeatDivider(),
          const SizedBox(height: 8),
          Center(
            child: _ConfidenceBadge(
              percent: data.confidencePercent,
              label: data.confidenceLabel,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: isSyncing ? null : onConnectWearable,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                elevation: 0,
              ),
              icon: isSyncing
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2.2, color: AppColors.white),
              )
                  : Icon(
                isConnected ? Icons.sync_rounded : Icons.watch_outlined,
                color: AppColors.white,
                size: 20,
              ),
              label: Text(_label, style: AppTextStyles.buttonLabel),
            ),
          ),
        ],
      ),
    );
  }

  String get _label {
    if (isSyncing) return 'Syncing...';
    if (isConnected) return 'Synced · Tap to Refresh';
    return 'Connect Wearable';
  }
}

/// Gradient ring gauge. Per the real screenshot, this is a full static ring
/// (not a partial arc tied to score fraction) — green at the top blending to
/// yellow at the bottom. The [fraction] param is no longer used for the
/// ring's shape; kept on the constructor in case a future design wants the
/// fill to reflect the score again, but the painter always draws the full
/// circle now.
class _ScoreRing extends StatelessWidget {
  const _ScoreRing({
    required this.score,
    required this.maxScore,
    required this.fraction,
  });

  final double score;
  final double maxScore;
  final double fraction;

  static const double _diameter = 190;
  static const double _strokeWidth = 16;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _diameter,
      height: _diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(_diameter, _diameter),
            painter: _ScoreRingPainter(
              strokeWidth: _strokeWidth,
              // ASSUMPTION: not yet tokenized in AppColors — see the
              // app_colors_CHANGES.md note for the exact three hex values
              // to add there (scoreRingGreenDark / scoreRingGreenLight /
              // scoreRingYellow), ordered top-to-bottom this time.
              gradientColors: const [
                Color(0xFF10B981), // top — darker green
                Color(0xFF34D399), // mid — lighter green
                Color(0xFFFDE047), // bottom — yellow
              ],
            ),
          ),
          // No inner fill here — the ring's interior is intentionally
          // transparent so the card's own background (scorbg.png) shows
          // through, matching the real screenshot. Do not add a white
          // Container circle back in.
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'HEART SCORE',
                style: AppTextStyles.sectionLabel.copyWith(
                  fontSize: 11,
                  color: AppColors.inputText.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: score.toStringAsFixed(1),
                      style: AppTextStyles.pageHeading.copyWith(
                        fontSize: 40,
                        color: AppColors.inputText,
                      ),
                    ),
                    TextSpan(
                      text: '/${maxScore.toStringAsFixed(0)}',
                      style: AppTextStyles.hint.copyWith(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  _ScoreRingPainter({
    required this.strokeWidth,
    required this.gradientColors,
  });

  final double strokeWidth;
  final List<Color> gradientColors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: gradientColors,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) =>
      oldDelegate.strokeWidth != strokeWidth ||
          oldDelegate.gradientColors != gradientColors;
}

/// The faint heartbeat/ECG squiggle graphic spanning the card width, per the
/// designer's scoring.png asset. Rendered at low opacity as a divider
/// between the ring and the confidence badge.
class _HeartbeatDivider extends StatelessWidget {
  const _HeartbeatDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      width: double.infinity,
      child: Opacity(
        opacity: 0.35,
        child: Image.asset(
          'assets/images/scoring.png',
          fit: BoxFit.fitWidth,
          // If the asset isn't registered in pubspec.yaml's flutter/assets
          // section yet, this fails silently to an empty box rather than
          // crashing the card — remove this errorBuilder once you've
          // confirmed the asset path/registration.
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}


class _ConfidenceBadge extends StatelessWidget {
  const _ConfidenceBadge({required this.percent, required this.label});

  final int percent;
  final String label;

  Color get _dotColor {
    switch (label.toLowerCase()) {
      case 'high':
        return AppColors.successGreen;
      case 'moderate':
        return AppColors.chipSelectedOrange;
      default:
        return AppColors.errorColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CONFIDENCE',
                  style: AppTextStyles.sectionLabel.copyWith(
                    fontSize: 10,
                    color: AppColors.inputText.withOpacity(0.55),
                  ),
                ),
                Text(
                  '$percent%',
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Container(width: 1, color: AppColors.cardBorder),
            const SizedBox(width: 16),
            SizedBox(
              width: 16,
              height: 16,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Soft outer glow — faded version of the same color,
                  // larger and low-opacity, sitting behind the solid dot.
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _dotColor.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: _dotColor, shape: BoxShape.circle),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.chipLabel.copyWith(
                color: AppColors.successGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}