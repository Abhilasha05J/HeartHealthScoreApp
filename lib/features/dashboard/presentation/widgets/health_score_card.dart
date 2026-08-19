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
    required this.onViewHistory,
    this.isSyncing = false,
    this.isConnected = false,
  });

  final DashboardData data;
  final VoidCallback onConnectWearable;
  final VoidCallback onViewHistory;
  final bool isSyncing;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.scoreCardGradientTop,
            Colors.white,
            AppColors.scoreCardGradientTop,
          ],
          stops: [
            0.0,
            0.5,
            1.0,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Text(
                'HEART HEALTH SCORE',
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionLabel.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.inputText,
                ),
              ),
              Positioned(
                right: 0,
                child: InkWell(
                  onTap: onViewHistory,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    // FIX (1): the asset has no explicit size here before,
                    // so it rendered at its native pixel dimensions and
                    // got hard-clipped by the Stack. Constraining
                    // width/height + BoxFit.contain scales it down to fit
                    // instead of clipping it.
                    child: Image.asset(
                      'assets/icons/history.png',
                      width: 22,
                      height: 22,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: _GaugeGeometry.boxHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: _LastScoreLabel(previousScore: data.previousScore),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: -20,
                  right: -20,
                  child: CustomPaint(
                    painter: _GaugePainter(fraction: data.scoreFraction),
                  ),
                ),
                // CURRENT + big number only — the chip used to live inside
                // this Column too, which is why it floated wherever this
                // block happened to sit rather than on the heartbeat line.
                Positioned(
                  top: _GaugeGeometry.contentTop,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _CurrentScoreBlock(score: data.healthyHeartScore),
                  ),
                ),
                // FIX (4): positioned independently so its vertical CENTER
                // lands exactly on the heartbeat line's y (same y the
                // painter uses for the flat middle segment of the zigzag),
                // regardless of how tall the CURRENT/number block above is.
                Positioned(
                  top: _GaugeGeometry.baselineY - _GaugeGeometry.chipHalfHeight,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _ImprovementChip(delta: data.scoreDelta),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
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

class _LastScoreLabel extends StatelessWidget {
  const _LastScoreLabel({required this.previousScore});

  final double previousScore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'LAST',
          style: AppTextStyles.sectionLabel.copyWith(
            fontSize: 11,
            color: AppColors.inputText.withOpacity(0.55),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          previousScore.toStringAsFixed(1),
          style: AppTextStyles.pageHeading.copyWith(fontSize: 22, color: AppColors.inputText),
        ),
      ],
    );
  }
}

class _GaugeGeometry {
  static const double boxHeight = 210;
  static const double centerBottomInset = 16;
  static const double radiusOuter = 128;
  static const double tickLength = 16;
  static const double labelGap = 20;
  static const double pointerInset = 12;

  // FIX (2): was 58, pushed down — nudge further if still too high once
  // you see it on-device.
  static const double contentTop = 100;

  // The single source of truth for "where the heartbeat line sits" — used
  // by both the painter (to draw the line there instead of a separate
  // baseline) and the chip's Positioned offset (to center on it). This
  // IS the old baseline's y position, just re-purposed.
  static const double baselineY = boxHeight - centerBottomInset;

  // ASSUMPTION: half the chip's rendered height, so the chip's Positioned
  // top can be computed as baselineY - chipHalfHeight to center it on the
  // line. Actual chip height (padding 8v + ~18 text) is close to this;
  // nudge if it looks off-center once rendered.
  static const double chipHalfHeight = 17;
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({required this.fraction});

  final double fraction;

  static const int _tickCount = 56;
  static const List<double> _labelStops = [0, 20, 40, 60, 80, 100];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - _GaugeGeometry.centerBottomInset);

    // FIX (3): heartbeat line now IS the baseline — drawn at center.dy
    // (same y a straight baseline would have used) instead of floating
    // higher up behind the number. No separate _drawBaseline call.
    _drawHeartbeatLine(canvas, center, size);
    _drawTicks(canvas, center);
    _drawLabels(canvas, center);
    _drawPointer(canvas, center);
  }

  void _drawTicks(Canvas canvas, Offset center) {
    final paint = Paint()
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < _tickCount; i++) {
      final t = i / (_tickCount - 1);
      final angle = pi - (t * pi);
      final outer = Offset(
        center.dx + _GaugeGeometry.radiusOuter * cos(angle),
        center.dy - _GaugeGeometry.radiusOuter * sin(angle),
      );
      final inner = Offset(
        center.dx + (_GaugeGeometry.radiusOuter - _GaugeGeometry.tickLength) * cos(angle),
        center.dy - (_GaugeGeometry.radiusOuter - _GaugeGeometry.tickLength) * sin(angle),
      );
      paint.color = _gaugeColorAt(t);
      canvas.drawLine(inner, outer, paint);
    }
  }

  void _drawLabels(Canvas canvas, Offset center) {
    final labelRadius = _GaugeGeometry.radiusOuter + _GaugeGeometry.labelGap;

    for (final value in _labelStops) {
      final t = value / 100;
      final angle = pi - (t * pi);
      final pos = Offset(
        center.dx + labelRadius * cos(angle),
        center.dy - labelRadius * sin(angle),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: value.toInt().toString(),
          style: TextStyle(
            color: AppColors.scoreGaugeLabelGrey,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(pos.dx - textPainter.width / 2, pos.dy - textPainter.height / 2),
      );
    }
  }

  void _drawPointer(Canvas canvas, Offset center) {
    final t = fraction.clamp(0.0, 1.0);
    final angle = pi - (t * pi);
    final pointerRadius = _GaugeGeometry.radiusOuter - _GaugeGeometry.tickLength - _GaugeGeometry.pointerInset;
    final pos = Offset(
      center.dx + pointerRadius * cos(angle),
      center.dy - pointerRadius * sin(angle),
    );

    const double h = 11;
    const double w = 11;

    final path = Path()
      ..moveTo(-h, 0)
      ..lineTo(0, -w / 2)
      ..lineTo(0, w / 2)
      ..close();

    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(-angle);
    canvas.drawPath(path, Paint()..color = _gaugeColorAt(t));
    canvas.restore();
  }

  void _drawHeartbeatLine(
      Canvas canvas,
      Offset center,
      Size size,
      ) {
    final paint = Paint()
      ..color = AppColors.improvementChipBg.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final baseY = center.dy;

    Offset pt(double xFraction, double yOffset) => Offset(w * xFraction, baseY + yOffset);

    final path = Path()
      ..moveTo(0, baseY)
      ..lineTo(pt(0.382, 0).dx, baseY) // end of flat run-in
      ..lineTo(pt(0.407, -18).dx, pt(0.407, -18).dy) // small peak (P)
      ..lineTo(pt(0.443, 22).dx, pt(0.443, 22).dy) // dip below baseline
      ..lineTo(pt(0.479, -40).dx, pt(0.479, -40).dy) // tall peak (R) — highest point
      ..lineTo(pt(0.529, 52).dx, pt(0.529, 52).dy) // deep trough (S) — lowest point
      ..lineTo(pt(0.572, -15).dx, pt(0.572, -15).dy) // medium peak (T)
      ..lineTo(pt(0.608, 0).dx, baseY) // back to baseline
      ..lineTo(w, baseY); // flat run-out

    canvas.drawPath(path, paint);
  }
  Color _gaugeColorAt(double t) {
    const stops = [0.0, 0.25, 0.5, 0.75, 1.0];
    final colors = [
      AppColors.scoreGaugeRed,
      AppColors.scoreGaugeOrange,
      AppColors.scoreGaugeYellow,
      AppColors.scoreGaugeLightGreen,
      AppColors.scoreGaugeDarkGreen,
    ];
    for (int i = 0; i < stops.length - 1; i++) {
      if (t >= stops[i] && t <= stops[i + 1]) {
        final localT = (t - stops[i]) / (stops[i + 1] - stops[i]);
        return Color.lerp(colors[i], colors[i + 1], localT)!;
      }
    }
    return colors.last;
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) => oldDelegate.fraction != fraction;
}

/// "CURRENT / 62.2" only now — the chip moved out to its own
/// independently-positioned widget so it can center on the heartbeat line.
class _CurrentScoreBlock extends StatelessWidget {
  const _CurrentScoreBlock({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'CURRENT',
          style: AppTextStyles.sectionLabel.copyWith(
            fontSize: 11,
            color: AppColors.inputText.withOpacity(0.6),
          ),
        ),
        Text(
          score.toStringAsFixed(1),
          style: AppTextStyles.pageHeading.copyWith(fontSize: 40, color: AppColors.inputText),
        ),
      ],
    );
  }
}

class _ImprovementChip extends StatelessWidget {
  const _ImprovementChip({required this.delta});

  final double delta;

  @override
  Widget build(BuildContext context) {
    final isImprovement = delta >= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.improvementChipBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isImprovement ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            size: 16,
            color: AppColors.improvementChipText,
          ),
          const SizedBox(width: 6),
          Text(
            '${isImprovement ? '+' : ''}${delta.toStringAsFixed(1)} ${isImprovement ? 'improvement' : 'decline'}',
            style: AppTextStyles.hint.copyWith(
              color: AppColors.improvementChipText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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