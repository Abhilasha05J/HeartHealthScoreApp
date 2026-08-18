import '../domain/workout_data.dart';
import '../domain/workout_repository.dart';

/// TODO(backend-integration): replace with `ApiWorkoutRepository` once the
/// backend exposes a daily-activity + workout-log endpoint. Values below are
/// seeded from the "Today, 12 Aug" mockup so the UI matches pixel-for-pixel
/// while the real data pipeline is built.
class MockWorkoutRepository implements WorkoutRepository {
  @override
  Future<DailyActivitySummary> fetchDailyActivity(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DailyActivitySummary(
      date: date,
      steps: 5234,
      stepsTarget: 6000,
      activeMinutes: 42,
      activeMinutesTarget: 90,
      calories: 320,
      caloriesTarget: 500,
      totalBurntCalories: 1840,
      distanceActiveKm: 4.2,
      weeklyStepsTarget: 6000,
      workoutSessionsThisWeek: 4,
      weeklySteps: const [
        WeeklyStepsPoint(dayLabel: 'M', steps: 3400),
        WeeklyStepsPoint(dayLabel: 'T', steps: 5100),
        WeeklyStepsPoint(dayLabel: 'W', steps: 7600, isToday: false),
        WeeklyStepsPoint(dayLabel: 'T', steps: 2900),
        WeeklyStepsPoint(dayLabel: 'F', steps: 3600),
        WeeklyStepsPoint(dayLabel: 'S', steps: 6800),
        WeeklyStepsPoint(dayLabel: 'S', steps: 7900),
      ],
    );
  }

  @override
  Future<void> logNewWorkout({
    required DateTime date,
    required String type,
    required int durationMinutes,
    required int caloriesBurned,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // ignore: avoid_print
    print('MockWorkoutRepository: logged $type ($durationMinutes min, $caloriesBurned kcal) on $date');
  }
}
