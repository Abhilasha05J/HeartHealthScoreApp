import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';

/// "< Today, 12 Aug >" pill with prev/next chevrons for paging the
/// selected activity date by one day, PLUS the date label itself is now
/// tappable — opens a calendar (`showDatePicker`) so the user can jump
/// straight to any date instead of only stepping day-by-day.
class DateNavHeader extends StatelessWidget {
  const DateNavHeader({
    super.key,
    required this.date,
    required this.onPrevious,
    required this.onNext,
    required this.onDateSelected,
  });

  final DateTime date;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  /// Called with the date chosen from the calendar picker.
  final ValueChanged<DateTime> onDateSelected;

  bool get _isToday {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  Future<void> _openCalendar(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      // Restyles the default Material date picker to match the app's
      // accent color instead of Flutter's default purple.
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.accentColor,
              onPrimary: AppColors.white,
              onSurface: AppColors.inputText,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onDateSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    final label = _isToday ? 'Today, ${DateFormat('d MMM').format(date)}' : DateFormat('EEE, d MMM').format(date);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NavChevron(icon: Icons.chevron_left, onTap: onPrevious),
        const SizedBox(width: 12),
        InkWell(
          onTap: () => _openCalendar(context),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.workoutCardBg,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.inputText),
                ),
                const SizedBox(width: 6),
              ],
            ),
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
        decoration: const BoxDecoration(color: AppColors.workoutCardBg, shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: AppColors.inputText),
      ),
    );
  }
}