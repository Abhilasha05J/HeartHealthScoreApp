import 'package:heart_health_score/features/wearable/domain/wearable_models.dart';

/// Shared formatters so a resting-HR/sleep/BP/step value renders identically
/// whether it's shown on the Connect Wearable screen or merged into Home's
/// condition grid. Keep formatting logic here, not duplicated in widgets.

String formatStepCount(int steps) {
  final s = steps.toString();
  if (s.length <= 3) return s;
  final buffer = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
    buffer.write(s[i]);
  }
  return buffer.toString();
}

String formatRestingHeartRate(int bpm) => '$bpm bpm';

String formatSleepDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes % 60;
  if (h == 0) return '${m}m';
  if (m == 0) return '${h}h';
  return '${h}h ${m}m';
}

String formatBloodPressure(BloodPressureValue bp) => '${bp.systolic}/${bp.diastolic} mmHg';
