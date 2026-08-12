import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ConditionCard extends StatelessWidget {
  const ConditionCard({
    super.key,
    required this.value,
    required this.label,
    required this.imagePath,
    required this.tintColor,
    required this.iconColor,
  });

  final String value;
  final String label;
  final String imagePath;
  final Color tintColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tintColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),

       //   const Spacer(), // pushes the text to the bottom

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.pageHeading.copyWith(
              fontSize: 20,
              color: AppColors.inputText,
            ),
          ),

          const SizedBox(height: 4),

          Flexible(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.hint.copyWith(
                color: AppColors.inputText.withOpacity(0.65),
              ),
            ),
          ),
        ],
      ),
    );
  }
}