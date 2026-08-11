import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Text field with the 3-stop gradient background (#334D35 67% -> #D8DFE3
/// -> #FFFFFF) used for every input across Auth / Profile Setup / Vitals.
class GradientTextField extends StatelessWidget {
  const GradientTextField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.prefixText,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.maxLength,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final String? prefixText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLength;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    // Wrapping in FormField<String> (instead of relying on TextFormField's
    // own built-in error rendering) is deliberate: TextFormField draws its
    // error text *inside* its own layout box, so a gradient Container
    // wrapping the whole TextFormField stretches to cover the error row
    // too — the warning ends up sitting on the field's gradient instead of
    // the plain card background. By using FormField directly, we control
    // exactly where the error text renders: below and OUTSIDE the gradient
    // box, on the surrounding (plain) background.
    return FormField<String>(
      initialValue: controller?.text,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.fieldGradient,
                borderRadius: BorderRadius.circular(14),
                border: field.hasError
                    ? Border.all(color: AppColors.redAccent, width: 1.4)
                    : null,
              ),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                obscureText: obscureText,
                inputFormatters: inputFormatters,
                textAlign: textAlign,
                readOnly: readOnly,
                onTap: onTap,
                maxLength: maxLength,
                autofocus: autofocus,
                style: AppTextStyles.inputValue,
                cursorColor: AppColors.headingColor,
                onChanged: (value) {
                  field.didChange(value);
                  onChanged?.call(value);
                },
                decoration: InputDecoration(
                  counterText: '',
                  hintText: hintText,
                  hintStyle: AppTextStyles.hint,
                  prefixIcon: prefixIcon,
                  prefixText: prefixText,
                  prefixStyle: AppTextStyles.inputValue,
                  suffixIcon: suffixIcon,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                ),
              ),
            ),
            if (field.hasError) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(color: AppColors.redAccent, fontSize: 12),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Labeled wrapper: SECTION LABEL (uppercase) + GradientTextField.
/// Matches "FULL NAME", "AGE", "WEIGHT" etc. in the Profile Setup screen.
class LabeledGradientField extends StatelessWidget {
  const LabeledGradientField({
    super.key,
    required this.label,
    this.trailingLabel,
    this.child,
  });

  final String label;
  final String? trailingLabel;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label.toUpperCase(), style: AppTextStyles.sectionLabel),
            if (trailingLabel != null)
              Text(
                trailingLabel!,
                style: AppTextStyles.sectionLabel.copyWith(color: AppColors.redAccent),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (child != null) child!,
      ],
    );
  }
}