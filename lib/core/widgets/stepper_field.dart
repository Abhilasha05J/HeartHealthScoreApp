import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Numeric value + up/down chevrons + unit label, matching the
/// Systolic / Diastolic "120 ↕ mmHg" control in Basic Vitals.
class StepperField extends StatelessWidget {
  const StepperField({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.onChanged,
    this.min = 0,
    this.max = 300,
    this.step = 1,
  });

  final String label;
  final int value;
  final String unit;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;

  void _increment() {
    if (value + step <= max) onChanged(value + step);
  }

  void _decrement() {
    if (value - step >= min) onChanged(value - step);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.inputText.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.chipLabel),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('$value', style: AppTextStyles.pageHeading.copyWith(fontSize: 22)),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: _increment,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.keyboard_arrow_up, size: 20, color: AppColors.headingColor),
                    ),
                  ),
                  InkWell(
                    onTap: _decrement,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.headingColor),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(unit, style: AppTextStyles.hint),
            ],
          ),
        ],
      ),
    );
  }
}
