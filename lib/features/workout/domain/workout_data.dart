/// One day's activity ring + stat data, shown on both the Home dashboard
/// (embedded, no AppBar) and the standalone Workout detail screen
/// (same content, pushed with an AppBar + back button).
class DailyActivitySummary {
  const DailyActivitySummary({
    required this.date,
    required this.steps,
    required this.stepsTarget,
    required this.activeMinutes,
    required this.activeMinutesTarget,
    required this.calories,
    required this.caloriesTarget,
    required this.totalBurntCalories,
    required this.distanceActiveKm,
    required this.weeklySteps,
    required this.weeklyStepsTarget,
    required this.workoutSessionsThisWeek,
  });

  final DateTime date;

  final int steps;
  final int stepsTarget;

  final int activeMinutes;
  final int activeMinutesTarget;

  final int calories;
  final int caloriesTarget;

  final int totalBurntCalories;
  final double distanceActiveKm;

  /// One entry per day of the current week, Monday first.
  final List<WeeklyStepsPoint> weeklySteps;
  final int weeklyStepsTarget;

  final int workoutSessionsThisWeek;

  double get stepsProgress => (steps / stepsTarget).clamp(0, 1);
  double get activeMinutesProgress => (activeMinutes / activeMinutesTarget).clamp(0, 1);
  double get caloriesProgress => (calories / caloriesTarget).clamp(0, 1);
}

/// A single bar in the "Steps over last 7 days" chart.
class WeeklyStepsPoint {
  const WeeklyStepsPoint({required this.dayLabel, required this.steps, this.isToday = false});

  final String dayLabel;
  final int steps;
  final bool isToday;
}
