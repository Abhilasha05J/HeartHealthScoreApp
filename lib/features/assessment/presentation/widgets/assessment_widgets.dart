import 'package:flutter/material.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/features/assessment/domain/assessment_models.dart';


class AssessmentTabBar extends StatelessWidget {
  const AssessmentTabBar({super.key, required this.active, required this.onChanged});

  final AssessmentTab active;
  final ValueChanged<AssessmentTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Row(
        children: AssessmentTab.values.map((tab) {
          final selected = tab == active;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? AppColors.accentColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    tab.tabIcon != null
                        ? Image.asset(tab.tabIcon!, width: 22, height: 22,
                        color: selected ? Colors.white : AppColors.inputText.withOpacity(0.6))
                        : Icon(tab.tabIconFallback, size: 22,
                        color: selected ? Colors.white : AppColors.inputText.withOpacity(0.6)),
                    const SizedBox(height: 4),
                    Text(
                      tab.label,
                      style: AppTextStyles.chipLabel.copyWith(
                        fontSize: 11,
                        color: selected ? Colors.white : AppColors.inputText.withOpacity(0.6),
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SectionIconHeader extends StatelessWidget {
  const SectionIconHeader({super.key, this.iconAsset, this.iconData, required this.title})
      : assert(iconAsset != null || iconData != null);

  final String? iconAsset;
  final IconData? iconData;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (iconAsset != null)
              Image.asset(iconAsset!, width: 40, height: 40)
            else
              Container(
                width: 40, height: 40,
                decoration: const BoxDecoration(color: AppColors.assessmentFieldBackground, shape: BoxShape.circle),
                child: Icon(iconData, size: 20, color: AppColors.assessmentGreen),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title,
                  style: AppTextStyles.chipLabel
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.headingColor)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: AppColors.darkSurface),
        const SizedBox(height: 16),
      ],
    );
  }
}

class AssessmentProgressHeader extends StatelessWidget {
  const AssessmentProgressHeader({super.key, required this.tab, required this.completion});

  final AssessmentTab tab;
  final double completion;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: completion,
            minHeight: 6,
            backgroundColor: AppColors.divider,
            valueColor: const AlwaysStoppedAnimation(AppColors.assessmentGreen),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Current: ${tab.profileLabel}',
                style: AppTextStyles.chipLabel.copyWith(fontSize: 13, color: AppColors.inputText)),
            Text('${(completion * 100).round()}% Complete',
                style: AppTextStyles.chipLabel
                    .copyWith(fontSize: 13, color: AppColors.inputText.withOpacity(0.6))),
          ],
        ),
      ],
    );
  }
}

//
// class AssessmentTextField extends StatelessWidget {
//   const AssessmentTextField({
//     super.key,
//     required this.label,
//     required this.value,
//     required this.onChanged,
//     this.hintText,
//     this.keyboardType = TextInputType.number,
//     this.showFreshness = true,
//   });
//
//   final String label;
//   final FieldValue value;
//   final Function(String) onChanged;
//   final String? hintText;
//   final TextInputType keyboardType;
//   final bool showFreshness;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF333333),
//                 ),
//               ),
//             ),
//             if (showFreshness && value.shouldShowFreshness)
//               Text(
//                 value.freshnessLabel,
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey[600],
//                 ),
//               ),
//           ],
//         ),
//         const SizedBox(height: 6),
//         TextField(
//           controller: TextEditingController(text: value.value?.toString() ?? ''),
//           keyboardType: keyboardType,
//           onChanged: onChanged,
//           decoration: InputDecoration(
//             hintText: hintText,
//             isDense: true,
//             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: AppColors.assessmentFieldBorder, width: 0.5),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: AppColors.assessmentFieldBorder, width: 0.5),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: AppColors.assessmentFieldBorder, width: 2),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
class AssessmentTextField extends StatefulWidget {
  const AssessmentTextField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.hintText,
    this.keyboardType = TextInputType.number,
    this.showFreshness = true,
  });

  final String label;
  final FieldValue value;
  final Function(String) onChanged;
  final String? hintText;
  final TextInputType keyboardType;
  final bool showFreshness;

  @override
  State<AssessmentTextField> createState() => _AssessmentTextFieldState();
}

class _AssessmentTextFieldState extends State<AssessmentTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatValue(widget.value.value));
  }

  @override
  void didUpdateWidget(covariant AssessmentTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only overwrite the field if the underlying value actually changed
    // from somewhere OTHER than this field's own typing (e.g. a refresh/prefill).
    final newText = _formatValue(widget.value.value);
    if (_controller.text != newText &&
        double.tryParse(_controller.text) != widget.value.value) {
      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }

  String _formatValue(dynamic v) {
    if (v == null) return '';
    if (v is double) {
      // Drop trailing ".0" for whole numbers
      return v == v.roundToDouble() ? v.toInt().toString() : v.toString();
    }
    return v.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            if (widget.showFreshness && widget.value.shouldShowFreshness)
              Text(
                widget.value.freshnessLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _controller,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.assessmentFieldBorder, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.assessmentFieldBorder, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.assessmentFieldBorder, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
class AssessmentDropdown<T extends Enum> extends StatelessWidget {
  const AssessmentDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.optionLabel,
    required this.onChanged,
    this.showFreshness = true,
  });

  final String label;
  final FieldValue<T> value;
  final List<T> options;
  final String Function(T) optionLabel;
  final Function(T?) onChanged;
  final bool showFreshness;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            if (showFreshness && value.shouldShowFreshness)
              Text(
                value.freshnessLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          value: value.value,
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('Select...'),
            ),
            ...options.map(
                  (option) => DropdownMenuItem(
                value: option,
                child: Text(optionLabel(option)),
              ),
            ),
          ],
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
              const BorderSide(color: Color(0xFF007AFF), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
class AssessmentCheckbox extends StatelessWidget {
  const AssessmentCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.showFreshness = true,
  });

  final String label;
  final FieldValue<bool> value;
  final Function(bool?) onChanged;
  final bool showFreshness;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                    value: value.value ?? false,
                    onChanged: onChanged,
                  ),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showFreshness && value.shouldShowFreshness)
              Text(
                value.freshnessLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ],
    );
  }
}


class AssessmentChipSelector<T> extends StatelessWidget {
  const AssessmentChipSelector({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.optionLabel,
    required this.onChanged,
    this.showFreshness = true,
  });

  final String label;
  final FieldValue<T> value;
  final List<T> options;
  final String Function(T) optionLabel;
  final Function(T) onChanged;
  final bool showFreshness;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            if (showFreshness && value.shouldShowFreshness)
              Text(
                value.freshnessLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 2,
          children: [
            for (final option in options)
              FilterChip(
                label: Text(optionLabel(option)),
                selected: value.value == option,
                onSelected: (_) => onChanged(option),
                backgroundColor: Colors.grey[100],
                selectedColor: AppColors.navActive,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: value.value == option
                      ? Colors.white
                      : const Color(0xFF333333),
                ),
              ),
          ],
        ),
      ],
    );
  }
}


class FreshnessBadge extends StatelessWidget {
  const FreshnessBadge({
    super.key,
    required this.value,
  });

  final FieldValue value;

  @override
  Widget build(BuildContext context) {
    if (!value.shouldShowFreshness) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value.freshnessLabel,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.orange[800],
        ),
      ),
    );
  }
}

class AssessmentToggleSelector<T> extends StatelessWidget {
  const AssessmentToggleSelector({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.optionLabel,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final List<T> options;
  final String Function(T) optionLabel;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.chipLabel
                .copyWith(fontSize: 15, color: AppColors.inputText, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Row(
          children: options.map((opt) {
            final selected = opt == value;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: opt != options.last ? 8 : 0),
                child: GestureDetector(
                  onTap: () => onChanged(opt),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.assessmentGreen : AppColors.assessmentFieldBackground,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      optionLabel(opt),
                      style: AppTextStyles.chipLabel.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : AppColors.inputText.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}


class AssessmentTargetProgressField extends StatelessWidget {
  const AssessmentTargetProgressField({
    super.key,
    required this.label,
    required this.controller,
    required this.unit,
    required this.target,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String unit;
  final double target;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.chipLabel
                .copyWith(fontSize: 15, color: AppColors.inputText, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.assessmentFieldBorder),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: onChanged,
                  style: AppTextStyles.chipLabel.copyWith(fontSize: 15, color: AppColors.inputText),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              Text(unit,
                  style: AppTextStyles.chipLabel
                      .copyWith(fontSize: 14, color: AppColors.assessmentMutedText)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final value = double.tryParse(controller.text) ?? 0;
            final fraction = (value / target).clamp(0.0, 1.0);
            return ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 6,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation(AppColors.assessmentGreen),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0', style: AppTextStyles.chipLabel.copyWith(fontSize: 11, color: AppColors.assessmentMutedText)),
            Text('Target: ${target.toInt()}+',
                style: AppTextStyles.chipLabel.copyWith(fontSize: 11, color: AppColors.assessmentMutedText)),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}