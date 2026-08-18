import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// One of the 4 "CALORIES / PROTEIN / CARBS / FAT" cards — icon + colored
/// uppercase label, then a big bold value with a small unit suffix.
/// All 4 cards share the same light-grey background per the mockup (only
/// the label/icon color differs per macro).
class MacroStatCard extends StatelessWidget {
  const MacroStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGreyFill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: accentColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.sectionLabel.copyWith(color: accentColor, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: AppTextStyles.pageHeading.copyWith(fontSize: 26, color: AppColors.inputText),
                ),
                TextSpan(text: ' $unit', style: AppTextStyles.hint.copyWith(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
