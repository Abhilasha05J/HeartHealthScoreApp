import '../domain/water_intake_data.dart';
import '../domain/water_intake_repository.dart';

/// TEMPORARY mock — in-memory only, seeded with the exact sample values
/// from the mockup (goal 4.0L, current 2.5L, 3 log entries, reminder
/// enabled at 9:00 PM / every 2 hours / Mon-Fri).
///
/// TODO(backend-integration): replace with an implementation backed by
/// local persistence (today's logs reset daily) and/or a real API, e.g.:
///
///   class ApiWaterIntakeRepository implements WaterIntakeRepository {
///     ApiWaterIntakeRepository(this._dio);
///     final Dio _dio;
///     ...
///   }
class MockWaterIntakeRepository implements WaterIntakeRepository {
  WaterIntakeData _state = WaterIntakeData(
    goalLiters: 4.0,
    currentLiters: 2.5,
    todaysLogs: [
      WaterLogEntry(
        amountMl: 500,
        sourceLabel: 'Quick Add',
        loggedAt: DateTime(2026, 1, 1, 14, 30),
      ),
      WaterLogEntry(
        amountMl: 1000,
        sourceLabel: 'Manual',
        loggedAt: DateTime(2026, 1, 1, 10, 15),
      ),
      WaterLogEntry(
        amountMl: 1000,
        sourceLabel: 'Quick Add',
        loggedAt: DateTime(2026, 1, 1, 7, 0),
      ),
    ],
    reminderSettings: ReminderSettings(
      enabled: true,
      time: DateTime(2026, 1, 1, 21, 0), // 9:00 PM
      remindEveryEnabled: true,
      remindEveryHours: 2,
      daySelectionMode: DaySelectionMode.specificDaysOfWeek,
      selectedDaysOfWeek: const {
        Weekday.mon,
        Weekday.tue,
        Weekday.wed,
        Weekday.thu,
        Weekday.fri,
      },
    ),
  );

  @override
  Future<WaterIntakeData> fetchWaterIntake() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _state;
  }

  @override
  Future<WaterIntakeData> logWater({required int amountMl, required String sourceLabel}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final entry = WaterLogEntry(amountMl: amountMl, sourceLabel: sourceLabel, loggedAt: DateTime.now());
    _state = _state.copyWith(
      currentLiters: _state.currentLiters + (amountMl / 1000),
      todaysLogs: [entry, ..._state.todaysLogs],
    );
    return _state;
  }

  @override
  Future<ReminderSettings> updateReminderSettings(ReminderSettings settings) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _state = _state.copyWith(reminderSettings: settings);
    return settings;
  }
}
