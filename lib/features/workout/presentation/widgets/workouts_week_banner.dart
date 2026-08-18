import 'package:flutter/material.dart';

import '../../../../core/theme/fitness_palette.dart';

/// Teal gradient banner: "Workouts this week / See your weekly workout
/// totals." + big session count, with a faint stopwatch watermark icon.
class WorkoutsWeekBanner extends StatelessWidget {
  const WorkoutsWeekBanner({super.key, required this.sessions, this.onTap});

  final int sessions;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: FitnessPalette.weekBannerGradient,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(Icons.timer_outlined, size: 110, color: Colors.white.withOpacity(0.12)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Workouts this week',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'See your weekly workout totals.',
                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 22),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$sessions ',
                          style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800),
                        ),
                        TextSpan(
                          text: 'SESSIONS',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
