import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/fitness_palette.dart';

/// "< Today, 12 Aug >" pill with prev/next chevrons for paging the
/// selected activity date.
class DateNavHeader extends StatelessWidget {
  const DateNavHeader({
    super.key,
    required this.date,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime date;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  bool get _isToday {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final label = _isToday ? 'Today, ${DateFormat('d MMM').format(date)}' : DateFormat('EEE, d MMM').format(date);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NavChevron(icon: Icons.chevron_left, onTap: onPrevious),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: FitnessPalette.cardBackground,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: FitnessPalette.textPrimary),
          ),
        ),
        const SizedBox(width: 12),
        _NavChevron(icon: Icons.chevron_right, onTap: onNext),
      ],
    );
  }
}

class _NavChevron extends StatelessWidget {
  const _NavChevron({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(color: FitnessPalette.cardBackground, shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: FitnessPalette.textPrimary),
      ),
    );
  }
}
