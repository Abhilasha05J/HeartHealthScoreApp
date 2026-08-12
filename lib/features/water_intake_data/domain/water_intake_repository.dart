import 'water_intake_data.dart';

/// Contract the Water Intake screen depends on — same swap-one-file
/// pattern as every other feature in this app (Auth/Onboarding/
/// Dashboard). Presentation/state layers never talk to storage or the
/// notifications system directly.
abstract class WaterIntakeRepository {
  Future<WaterIntakeData> fetchWaterIntake();

  /// Logs a new entry and returns the updated totals/log list.
  Future<WaterIntakeData> logWater({required int amountMl, required String sourceLabel});

  /// Persists reminder settings.
  ///
  /// TODO(notifications-integration): once wired up, this should also
  /// call into the existing notifications module (the one with
  /// `NotificationRepository`/`NotificationRouting` from an earlier
  /// session) to actually schedule/cancel the local reminder — this
  /// repository only persists the settings values themselves. I don't
  /// have that module's API in this conversation, so this is a clean
  /// integration point rather than a guess at its method signatures.
  Future<ReminderSettings> updateReminderSettings(ReminderSettings settings);
}
