import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A tappable row: label on the left, a trailing value/action word on the
/// right (e.g. "Meal type ... Select", "Food item ... Add"), with a thin
/// divider underneath. Used for the "Today's Meals" entry rows.
class EntryRow extends StatelessWidget {
  const EntryRow({
    super.key,
    required this.label,
    required this.trailing,
    required this.onTap,
    this.trailingColor,
    this.showDivider = true,
  });

  final String label;
  final String trailing;
  final VoidCallback onTap;
  final Color? trailingColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: AppTextStyles.chipLabel.copyWith(fontSize: 15)),
                Text(
                  trailing,
                  style: AppTextStyles.chipLabel.copyWith(
                    fontSize: 15,
                    color: trailingColor ?? AppColors.inputText.withOpacity(0.45),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (showDivider) Divider(color: AppColors.inputText.withOpacity(0.08), height: 1),
        ],
      ),
    );
  }
}
