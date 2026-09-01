import 'package:flutter/material.dart';
import 'package:heart_health_score/core/theme/app_colors.dart';
import 'package:heart_health_score/core/theme/app_text_styles.dart';

/// Displays the plain-English strings from `GET /me/monitoring`'s
/// `insights.positive_progress` / `insights.attention_required` —
/// pre-written by the backend, not computed here. Renders nothing if
/// both lists are empty (new patient, fewer than 2 visits, or the
/// monitoring call failed) rather than showing an empty section.
class DashboardInsightsSection extends StatelessWidget {
  const DashboardInsightsSection({
    super.key,
    required this.positiveProgress,
    required this.attentionRequired,
  });

  final List<String> positiveProgress;
  final List<String> attentionRequired;

  @override
  Widget build(BuildContext context) {
    if (positiveProgress.isEmpty && attentionRequired.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final text in positiveProgress)
          _InsightRow(
            icon: Icons.trending_up_rounded,
            color: AppColors.successGreen,
            text: text,
          ),
        for (final text in attentionRequired)
          _InsightRow(
            icon: Icons.warning_amber_rounded,
            color: AppColors.errorColor,
            text: text,
          ),
      ],
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.chipLabel.copyWith(fontSize: 13, color: AppColors.inputText),
            ),
          ),
        ],
      ),
    );
  }
}