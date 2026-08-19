import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/workout_data.dart';

/// Three concentric progress rings (outer -> inner: steps green, active-time
/// blue, calories purple) with a flame icon centered, matching the workout
/// dashboard mockup.
class ActivityRings extends StatelessWidget {
  const ActivityRings({super.key, required this.summary, this.size = 300});

  final DailyActivitySummary summary;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingsPainter(
          stepsProgress: summary.stepsProgress,
          activeMinutesProgress: summary.activeMinutesProgress,
          caloriesProgress: summary.caloriesProgress,
        ),
        child: const Center(
          child: Icon(Icons.local_fire_department, color: AppColors.ringGreen, size: 40),
        ),
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  _RingsPainter({
    required this.stepsProgress,
    required this.activeMinutesProgress,
    required this.caloriesProgress,
  });

  final double stepsProgress;
  final double activeMinutesProgress;
  final double caloriesProgress;

  static const double _strokeWidth = 22;
  static const double _ringGap = 10;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outerRadius = (size.shortestSide - _strokeWidth) / 2;

    _drawRing(canvas, center, outerRadius, AppColors.ringGreen, stepsProgress);
    _drawRing(
      canvas,
      center,
      outerRadius - _strokeWidth - _ringGap,
      AppColors.accentColor,
      activeMinutesProgress,
    );
    _drawRing(
      canvas,
      center,
      outerRadius - (_strokeWidth + _ringGap) * 2,
      AppColors.ringPurple,
      caloriesProgress,
    );
  }

  void _drawRing(Canvas canvas, Offset center, double radius, Color color, double progress) {
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, 2 * math.pi, false, trackPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _RingsPainter oldDelegate) {
    return oldDelegate.stepsProgress != stepsProgress ||
        oldDelegate.activeMinutesProgress != activeMinutesProgress ||
        oldDelegate.caloriesProgress != caloriesProgress;
  }
}
