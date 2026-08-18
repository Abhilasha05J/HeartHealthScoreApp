import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_workout_repository.dart';
import '../domain/workout_data.dart';
import '../domain/workout_repository.dart';

/// Single override point for swapping in a real API repository later —
/// never import `MockWorkoutRepository` directly from a screen/controller.
final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return MockWorkoutRepository();
});

/// The date currently shown by the day-picker header ("< Today, 12 Aug >").
/// Transient UI-only state — kept separate from the fetched domain data so
/// paging the date doesn't force a full-screen rebuild before the new data
/// arrives.
final selectedActivityDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// Fetches the daily activity summary for whatever date is currently
/// selected. Re-fetches automatically when the date changes.
final dailyActivityProvider = FutureProvider<DailyActivitySummary>((ref) async {
  final repo = ref.watch(workoutRepositoryProvider);
  final date = ref.watch(selectedActivityDateProvider);
  return repo.fetchDailyActivity(date);
});
