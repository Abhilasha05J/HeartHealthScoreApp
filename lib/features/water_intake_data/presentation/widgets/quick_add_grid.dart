import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 2x2 grid of "+250 / +500 / +750 / +1L" quick-add buttons.
class QuickAddGrid extends StatelessWidget {
  const QuickAddGrid({super.key, required this.onQuickAdd});

  /// Called with the amount in ml (250, 500, 750, or 1000).
  final ValueChanged<int> onQuickAdd;

  static const _amounts = [250, 500, 750, 1000];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: _amounts.map((ml) {
        final label = ml >= 1000 ? '+1L' : '+$ml';
        return _QuickAddButton(label: label, onTap: () => onQuickAdd(ml));
      }).toList(),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  const _QuickAddButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.conditionTintBlue,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.water_drop_outlined, color: AppColors.accentColor, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.chipLabel.copyWith(
                color: AppColors.accentColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
