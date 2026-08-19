import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// The "Select Plan" / "View Details" pill button. Both use the same
/// fill/shadow/text styling — per spec, text is black for every button
/// regardless of label. Width fills its parent (Figma: "Fill (268px)").
class PlanPillButton extends StatelessWidget {
  const PlanPillButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.planButtonBg.withOpacity(0.37),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.planButtonText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
