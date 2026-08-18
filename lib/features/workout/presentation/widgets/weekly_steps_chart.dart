import 'package:flutter/material.dart';

import '../../../../core/theme/fitness_palette.dart';
import '../../domain/workout_data.dart';

/// "Steps over last 7 days" card: a "Target 6k" chip + dashed target line,
/// bars in grey (below target) or green (at/above target), day labels below.
class WeeklyStepsChart extends StatelessWidget {
  const WeeklyStepsChart({
    super.key,
    required this.points,
    required this.target,
    this.onSeeAll,
  });

  final List<WeeklyStepsPoint> points;
  final int target;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final maxSteps = points.map((p) => p.steps).fold<int>(target, (a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FitnessPalette.cardBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Steps over last 7 days', style: FitnessTextStyles.sectionHeading),
              if (onSeeAll != null)
                InkWell(
                  onTap: onSeeAll,
                  child: const Icon(Icons.chevron_right, color: FitnessPalette.textSecondary),
                ),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 180,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final targetLineY = constraints.maxHeight * (1 - (target / maxSteps));
                return Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: targetLineY,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: FitnessPalette.chipTargetBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Target ${(target / 1000).toStringAsFixed(0)}k',
                              style: const TextStyle(
                                color: FitnessPalette.ringSteps,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomPaint(
                              size: const Size(double.infinity, 1),
                              painter: _DashedLinePainter(color: FitnessPalette.ringSteps.withOpacity(0.5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      top: 24,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: points.map((p) {
                          final barHeight = (constraints.maxHeight - 24) * (p.steps / maxSteps);
                          final atTarget = p.steps >= target;
                          return _Bar(
                            height: barHeight.clamp(6, double.infinity),
                            color: atTarget ? FitnessPalette.ringSteps : FitnessPalette.trackGrey,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: points
                .map((p) => SizedBox(
                      width: 28,
                      child: Text(
                        p.dayLabel,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: p.steps >= target ? FitnessPalette.ringSteps : FitnessPalette.textSecondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.height, required this.color});

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(7)),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) => oldDelegate.color != color;
}
