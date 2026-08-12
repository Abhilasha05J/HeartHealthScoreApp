import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Circular progress ring showing current/goal liters — "2.5 LITERS"
/// centered inside a blue ring that fills proportionally to
/// [fraction] (0.0–1.0). Built on Flutter's own CircularProgressIndicator
/// rather than a custom painter — no need for the extra complexity here.
class WaterProgressRing extends StatelessWidget {
  const WaterProgressRing({
    super.key,
    required this.currentLiters,
    required this.fraction,
    this.size = 180,
  });

  final double currentLiters;
  final double fraction;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: fraction,
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              backgroundColor: AppColors.accentColor.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation(AppColors.accentColor),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentLiters.toStringAsFixed(1),
                style: AppTextStyles.pageHeading.copyWith(fontSize: 32, color: AppColors.inputText),
              ),
              Text(
                'LITERS',
                style: AppTextStyles.sectionLabel.copyWith(
                  color: AppColors.inputText.withOpacity(0.5),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
