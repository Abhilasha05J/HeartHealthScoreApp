import 'package:flutter/material.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';
import 'package:heart_health_score/features/assessment/domain/assessment_models.dart';

/// "No reports yet / Upload Report" box — identical across all 5 tabs.
// class ReportUploadBox extends StatelessWidget {
//   const ReportUploadBox({super.key, required this.reportCount, required this.onUpload});
//
//   final int reportCount;
//   final VoidCallback onUpload;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.darkSurface, width: 1.4),
//       ),
//       child: Column(
//         children: [
//           Text(
//             reportCount == 0 ? 'No reports yet' : '$reportCount report(s) uploaded',
//             style: AppTextStyles.chipLabel.copyWith(color: AppColors.black),
//           ),
//           const SizedBox(height: 16),
//           Center(
//             child: ElevatedButton.icon(
//               onPressed: onUpload,
//               icon: const Icon(Icons.camera_alt_outlined, size: 17, color: Colors.white),
//               label: const Text('Upload Report'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.accentColor,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//                 minimumSize: Size.zero, // lets the button shrink below Material's default min tap target
//                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 textStyle: AppTextStyles.chipLabel.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

/// 5-pill tab bar (Lipids / Pressure / Glucose / Kidney / Behavior).
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

/// Icon-in-circle + title + divider — Pressure/Glucose/Kidney page headers
/// and each Behavior sub-section header. `iconAsset` is a pre-composed PNG
/// (icon baked onto its circle background already — no Container styling
/// needed on our end).
// class SectionIconHeader extends StatelessWidget {
//   const SectionIconHeader({super.key, required this.iconAsset, required this.title});
//
//   final String iconAsset;
//   final String title;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Image.asset(iconAsset, width: 40, height: 40),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: AppTextStyles.chipLabel.copyWith(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: AppColors.headingColor,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         const Divider(height: 1, color: AppColors.divider),
//         const SizedBox(height: 16),
//       ],
//     );
//   }
// }
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
        const Divider(height: 1, color: AppColors.divider),
        const SizedBox(height: 16),
      ],
    );
  }
}
/// Top-of-form progress row: thin bar + "Current: X Profile" / "N% Complete".
/// `completion` is computed live from filled fields in the active section
/// (ASSUMPTION: mockup's static 20%/0% values read as demo placeholders,
/// not a spec'd formula — flag if a different definition is intended).
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

/// Flat, light-grey-bordered numeric/text field — the style used throughout
/// this wizard. NOT `GradientTextField` (different design language here).
class AssessmentTextField extends StatelessWidget {
  const AssessmentTextField({
    super.key,
    required this.label,
    this.subtitle,
    required this.controller,
    this.unit,
    this.hintText,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
    this.readOnly = false,
    this.onChanged,
  });

  final String label;
  final String? subtitle;
  final TextEditingController controller;
  final String? unit;
  final String? hintText;
  final TextInputType keyboardType;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.chipLabel
                .copyWith(fontSize: 15, color: AppColors.inputText, fontWeight: FontWeight.w600)),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!,
              style: AppTextStyles.chipLabel
                  .copyWith(fontSize: 12, color: AppColors.inputText.withOpacity(0.5))),
        ],
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: readOnly ? AppColors.assessmentFieldBackground : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.assessmentFieldBorder),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  readOnly: readOnly,
                  onChanged: onChanged,
                  style: AppTextStyles.chipLabel.copyWith(fontSize: 15, color: AppColors.inputText),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    hintText: hintText ?? '0.0',
                    hintStyle: AppTextStyles.chipLabel
                        .copyWith(fontSize: 15, color: AppColors.assessmentMutedText),
                  ),
                ),
              ),
              if (unit != null)
                Text(unit!,
                    style: AppTextStyles.chipLabel
                        .copyWith(fontSize: 14, color: AppColors.assessmentMutedText)),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

/// Rounded dropdown field (Diabetes Status / Smoking Status / Stress level).
class AssessmentDropdownField<T> extends StatelessWidget {
  const AssessmentDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.hintText = 'Select Status',
  });

  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final String hintText;

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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              hint: Text(hintText,
                  style: AppTextStyles.chipLabel
                      .copyWith(fontSize: 15, color: AppColors.assessmentMutedText)),
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.assessmentMutedText),
              items:
              items.map((e) => DropdownMenuItem(value: e, child: Text(itemLabel(e)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

/// Filled-green segmented selector (Yes/No, Low/Med/High). Deliberately a
/// NEW widget rather than reusing the global `SegmentedSelector`: that one
/// is outlined per the v2 rebrand rule, but this screen's mockup shows a
/// filled-solid selected state. Scoped to this feature only so v2 styling
/// elsewhere is untouched.
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

/// Numeric field + target-progress bar underneath — Moderate/Vigorous
/// Activity (0 .. Target 150+ min/week). Wrapped in AnimatedBuilder so the
/// bar updates live as the user types, without the parent needing setState.
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