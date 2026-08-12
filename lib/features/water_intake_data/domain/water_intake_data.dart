import 'package:equatable/equatable.dart';

/// One entry in "Today's Logs".
class WaterLogEntry extends Equatable {
  const WaterLogEntry({
    required this.amountMl,
    required this.sourceLabel, // "Quick Add" or "Manual"
    required this.loggedAt,
  });

  final int amountMl;
  final String sourceLabel;
  final DateTime loggedAt;

  /// Formats amount the way the mockup does: "500 ml" under 1L, "1.0 L" at
  /// or above 1L.
  String get amountLabel {
    if (amountMl < 1000) return '$amountMl ml';
    return '${(amountMl / 1000).toStringAsFixed(1)} L';
  }

  /// 12-hour clock label ("2:30 PM") without pulling in the `intl`
  /// package for just this one formatting need.
  String get timeLabel {
    final hour24 = loggedAt.hour;
    final period = hour24 >= 12 ? 'PM' : 'AM';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final minute = loggedAt.minute.toString().padLeft(2, '0');
    return '$hour12:$minute $period';
  }

  @override
  List<Object?> get props => [amountMl, sourceLabel, loggedAt];
}

/// ASSUMPTION (flagged in the skill file too): the mockup shows both
/// "Remind me every [N hours]" AND "Specific Days of Week" as selected
/// (filled) at the same time, which doesn't work as a single mutually
/// exclusive radio group. Modeled here as two independent settings
/// instead: [remindEveryEnabled]+[remindEveryHours] control the repeat
/// interval, and [daySelectionMode]+[selectedDaysOfWeek] control which
/// days it's active on. Confirm this reading with the designer/PM.
enum DaySelectionMode { everyday, specificDaysOfWeek, specificDaysOfMonth, someDaysPerPeriod }

enum Weekday { mon, tue, wed, thu, fri, sat, sun }

class ReminderSettings extends Equatable {
  const ReminderSettings({
    required this.enabled,
    required this.time,
    required this.remindEveryEnabled,
    required this.remindEveryHours,
    required this.daySelectionMode,
    required this.selectedDaysOfWeek,
  });

  final bool enabled;
  final DateTime time; // only hour/minute are meaningful
  final bool remindEveryEnabled;
  final int remindEveryHours; // 1, 2, 3, or 4
  final DaySelectionMode daySelectionMode;
  final Set<Weekday> selectedDaysOfWeek;

  String get timeLabel {
    final hour24 = time.hour;
    final period = hour24 >= 12 ? 'PM' : 'AM';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour12:$minute $period';
  }

  ReminderSettings copyWith({
    bool? enabled,
    DateTime? time,
    bool? remindEveryEnabled,
    int? remindEveryHours,
    DaySelectionMode? daySelectionMode,
    Set<Weekday>? selectedDaysOfWeek,
  }) {
    return ReminderSettings(
      enabled: enabled ?? this.enabled,
      time: time ?? this.time,
      remindEveryEnabled: remindEveryEnabled ?? this.remindEveryEnabled,
      remindEveryHours: remindEveryHours ?? this.remindEveryHours,
      daySelectionMode: daySelectionMode ?? this.daySelectionMode,
      selectedDaysOfWeek: selectedDaysOfWeek ?? this.selectedDaysOfWeek,
    );
  }

  @override
  List<Object?> get props => [
        enabled,
        time,
        remindEveryEnabled,
        remindEveryHours,
        daySelectionMode,
        selectedDaysOfWeek,
      ];
}

class WaterIntakeData extends Equatable {
  const WaterIntakeData({
    required this.goalLiters,
    required this.currentLiters,
    required this.todaysLogs,
    required this.reminderSettings,
  });

  final double goalLiters;
  final double currentLiters;
  final List<WaterLogEntry> todaysLogs;
  final ReminderSettings reminderSettings;

  double get progressFraction => (currentLiters / goalLiters).clamp(0.0, 1.0);

  WaterIntakeData copyWith({
    double? goalLiters,
    double? currentLiters,
    List<WaterLogEntry>? todaysLogs,
    ReminderSettings? reminderSettings,
  }) {
    return WaterIntakeData(
      goalLiters: goalLiters ?? this.goalLiters,
      currentLiters: currentLiters ?? this.currentLiters,
      todaysLogs: todaysLogs ?? this.todaysLogs,
      reminderSettings: reminderSettings ?? this.reminderSettings,
    );
  }

  @override
  List<Object?> get props => [goalLiters, currentLiters, todaysLogs, reminderSettings];
}
