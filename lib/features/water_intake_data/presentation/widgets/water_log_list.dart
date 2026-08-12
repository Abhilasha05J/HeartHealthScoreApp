import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/water_intake_data.dart';

/// "Today's Logs" list — each entry a light-blue rounded tile with a
/// droplet icon, the amount + source, and the time on the right.
class WaterLogList extends StatelessWidget {
  const WaterLogList({super.key, required this.entries});

  final List<WaterLogEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text('No entries yet today.', style: AppTextStyles.hint),
      );
    }

    return Column(
      children: [
        for (final entry in entries) ...[
          _LogTile(entry: entry),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.entry});

  final WaterLogEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.conditionTintBlue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.water_drop_outlined, color: AppColors.accentColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.amountLabel,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
                ),
                Text(entry.sourceLabel, style: AppTextStyles.hint),
              ],
            ),
          ),
          Text(entry.timeLabel, style: AppTextStyles.chipLabel),
        ],
      ),
    );
  }
}
