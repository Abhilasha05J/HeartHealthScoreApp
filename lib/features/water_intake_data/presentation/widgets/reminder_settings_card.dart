import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/water_intake_data.dart';

/// The "Set Reminder" card: enable toggle, time picker chip, and
/// frequency controls.
///
/// ASSUMPTION (see note on [ReminderSettings] in the domain model): the
/// mockup shows "Remind me every [N hrs]" and "Specific Days of Week"
/// both selected simultaneously, which isn't valid for a single radio
/// group. This widget treats them as two independent settings — an
/// interval toggle, and a separate day-scope selector — rather than one
/// mutually exclusive list. Confirm with the designer/PM.
class ReminderSettingsCard extends StatelessWidget {
  const ReminderSettingsCard({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  final ReminderSettings settings;
  final ValueChanged<ReminderSettings> onChanged;

  static const _hourOptions = [1, 2, 3, 4];
  static const _weekdayLabels = {
    Weekday.mon: 'Mo',
    Weekday.tue: 'Tu',
    Weekday.wed: 'We',
    Weekday.thu: 'Th',
    Weekday.fri: 'Fr',
    Weekday.sat: 'Sa',
    Weekday.sun: 'Su',
  };

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(settings.time),
    );
    if (picked == null) return;
    final now = settings.time;
    onChanged(settings.copyWith(
      time: DateTime(now.year, now.month, now.day, picked.hour, picked.minute),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Set Reminder', style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
              Switch(
                value: settings.enabled,
                activeColor: AppColors.accentColor,
                onChanged: (value) => onChanged(settings.copyWith(enabled: value)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Time', style: AppTextStyles.chipLabel),
              InkWell(
                onTap: () => _pickTime(context),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.accentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    settings.timeLabel,
                    style: AppTextStyles.chipLabel.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text('Frequency', style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
          const SizedBox(height: 12),

          // --- Remind-every-N-hours (independent toggle) ---
          _RadioRow(
            label: 'Remind me every',
            selected: settings.remindEveryEnabled,
            onTap: () => onChanged(settings.copyWith(remindEveryEnabled: !settings.remindEveryEnabled)),
          ),
          if (settings.remindEveryEnabled) ...[
            const SizedBox(height: 10),
            Row(
              children: _hourOptions.map((h) {
                final selected = settings.remindEveryHours == h;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _Chip(
                    label: '$h Hr${h > 1 ? 's' : ''}',
                    selected: selected,
                    onTap: () => onChanged(settings.copyWith(remindEveryHours: h)),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 14),

          // --- Day-scope selector ---
          _RadioRow(
            label: 'Everyday',
            selected: settings.daySelectionMode == DaySelectionMode.everyday,
            onTap: () => onChanged(settings.copyWith(daySelectionMode: DaySelectionMode.everyday)),
          ),
          const SizedBox(height: 10),
          _RadioRow(
            label: 'Specific Days of Week',
            selected: settings.daySelectionMode == DaySelectionMode.specificDaysOfWeek,
            onTap: () =>
                onChanged(settings.copyWith(daySelectionMode: DaySelectionMode.specificDaysOfWeek)),
          ),
          if (settings.daySelectionMode == DaySelectionMode.specificDaysOfWeek) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Weekday.values.map((day) {
                final selected = settings.selectedDaysOfWeek.contains(day);
                return _Chip(
                  label: _weekdayLabels[day]!,
                  selected: selected,
                  onTap: () {
                    final updated = Set<Weekday>.from(settings.selectedDaysOfWeek);
                    selected ? updated.remove(day) : updated.add(day);
                    onChanged(settings.copyWith(selectedDaysOfWeek: updated));
                  },
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 10),
          _RadioRow(
            label: 'Specific Days of Month',
            selected: settings.daySelectionMode == DaySelectionMode.specificDaysOfMonth,
            onTap: () =>
                onChanged(settings.copyWith(daySelectionMode: DaySelectionMode.specificDaysOfMonth)),
          ),
          const SizedBox(height: 10),
          _RadioRow(
            label: 'Some Days Per Period',
            selected: settings.daySelectionMode == DaySelectionMode.someDaysPerPeriod,
            onTap: () =>
                onChanged(settings.copyWith(daySelectionMode: DaySelectionMode.someDaysPerPeriod)),
          ),
        ],
      ),
    );
  }
}

class _RadioRow extends StatelessWidget {
  const _RadioRow({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? AppColors.accentColor : AppColors.inputText.withOpacity(0.35),
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(label, style: AppTextStyles.chipLabel),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.chipSelectedOrange : AppColors.chipUnselectedGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: AppTextStyles.chipLabel.copyWith(
            fontWeight: FontWeight.w700,
            color: selected ? AppColors.inputText : AppColors.inputText.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}
