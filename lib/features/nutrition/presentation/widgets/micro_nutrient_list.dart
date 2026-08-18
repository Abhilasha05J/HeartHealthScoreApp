import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/nutrition_data.dart';

/// Collapsible "MICRO NUTRIENTS" section — a header with a chevron
/// toggle, then one tappable row per nutrient (tapping opens a small
/// numeric-entry dialog via [onEditNutrient]).
class MicroNutrientList extends StatelessWidget {
  const MicroNutrientList({
    super.key,
    required this.values,
    required this.expanded,
    required this.onToggleExpanded,
    required this.onEditNutrient,
  });

  final Map<String, double> values;
  final bool expanded;
  final VoidCallback onToggleExpanded;
  final ValueChanged<String> onEditNutrient;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggleExpanded,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('MICRO NUTRIENTS', style: AppTextStyles.sectionLabel),
                AnimatedRotation(
                  turns: expanded ? 0 : -0.25,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.inputText),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Column(
            children: kMicroNutrientOrder.map((nutrient) {
              final value = values[nutrient] ?? 0;
              return InkWell(
                onTap: () => onEditNutrient(nutrient),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(nutrient, style: AppTextStyles.inputValue.copyWith(fontSize: 15)),
                          Text(
                            value == value.roundToDouble() ? value.toInt().toString() : value.toString(),
                            style: AppTextStyles.hint.copyWith(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: AppColors.inputText.withOpacity(0.08), height: 1),
                  ],
                ),
              );
            }).toList(),
          ),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }
}
