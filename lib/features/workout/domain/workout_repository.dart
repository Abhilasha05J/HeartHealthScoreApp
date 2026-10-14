import 'workout_data.dart';

/// Abstract boundary — screens/providers depend only on this, never on a
/// concrete implementation. Swap `workoutRepositoryProvider` in
/// `workout_providers.dart` to point at a real API repository once the
abstract class WorkoutRepository {
  Future<DailyActivitySummary> fetchDailyActivity(DateTime date);

  Future<void> logNewWorkout({
    required DateTime date,
    required String type,
    required int durationMinutes,
    required int caloriesBurned,
  });
}
