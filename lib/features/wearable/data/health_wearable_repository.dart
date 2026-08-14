// import 'dart:io' show Platform;
//
// import 'package:health/health.dart';
//
// import 'package:heart_health_score/features/wearable/domain/wearable_models.dart';
// import 'package:heart_health_score/features/wearable/domain/wearable_repository.dart';
//
// /// Real implementation backed by the `health` pub.dev package, which wraps
// /// Apple HealthKit (iOS) and Google Health Connect (Android) behind one API.
// ///
// /// TODO(backend-integration): none — this talks to the OS directly, no backend
// /// endpoint involved. Nothing here needs to change once your API is live.
// ///
// /// Setup required before this compiles/runs (not done by this file):
// /// 1. `flutter pub add health`
// /// 2. Android: minSdkVersion 26 (already required per skill 6.8), add the
// ///    Health Connect permissions + <queries> block to AndroidManifest.xml
// ///    (commented-out scaffolding already sits there per skill section 8).
// /// 3. iOS: add HealthKit capability in Xcode, and the usage-description keys
// ///    to Info.plist (NSHealthShareUsageDescription at minimum for read-only).
// class HealthWearableRepository implements WearableRepository {
//   final Health _health = Health();
//
//   static const List<HealthDataType> _types = [
//     HealthDataType.STEPS,
//     HealthDataType.RESTING_HEART_RATE,
//     HealthDataType.SLEEP_ASLEEP,
//     HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
//     HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
//   ];
//
//   static final List<HealthDataAccess> _permissions =
//       _types.map((_) => HealthDataAccess.READ).toList();
//
//   @override
//   Future<bool> isPlatformStoreAvailable() async {
//     if (Platform.isAndroid) {
//       final status = await _health.getHealthConnectSdkStatus();
//       return status == HealthConnectSdkStatus.sdkAvailable;
//     }
//     // HealthKit ships with iOS itself; per-type access is handled by
//     // requestPermissions(), not by an install step.
//     return true;
//   }
//
//   @override
//   Future<bool> requestPermissions() async {
//     final alreadyGranted =
//         await _health.hasPermissions(_types, permissions: _permissions) ??
//             false;
//     if (alreadyGranted) return true;
//
//     try {
//       return await _health.requestAuthorization(_types,
//           permissions: _permissions);
//     } catch (_) {
//       // User dismissed the dialog, or the OS refused it (e.g. device policy).
//       return false;
//     }
//   }
//
//   @override
//   Future<WearableSnapshot> fetchLatestSnapshot() async {
//     final now = DateTime.now();
//     final lookback = now.subtract(const Duration(days: 2));
//
//     // Each metric is fetched and parsed independently, wrapped in its own
//     // try/catch, so one type failing (denied permission, no data, a plugin
//     // hiccup on a specific OEM skin) never takes the other three down with it.
//     final results = await Future.wait([
//       _fetchLatestNumeric(HealthDataType.STEPS, lookback, now, sumInsteadOfLatest: true),
//       _fetchLatestNumeric(HealthDataType.RESTING_HEART_RATE, lookback, now),
//       _fetchSleepDuration(lookback, now),
//       _fetchBloodPressure(lookback, now),
//     ]);
//
//     final steps = results[0] as WearableMetricReading<int>?;
//     final restingHr = results[1] as WearableMetricReading<int>?;
//     final sleep = results[2] as WearableMetricReading<Duration>?;
//     final bp = results[3] as WearableMetricReading<BloodPressureValue>?;
//
//     return WearableSnapshot(
//       fetchedAt: now,
//       stepCount: steps,
//       restingHeartRate: restingHr,
//       sleepDuration: sleep,
//       bloodPressure: bp,
//     );
//   }
//
//   @override
//   Future<bool> openPlatformStoreInstallPage() async {
//     if (!Platform.isAndroid) return false;
//     try {
//       await _health.installHealthConnect();
//       return true;
//     } catch (_) {
//       return false;
//     }
//   }
//
//   // ---- private helpers -----------------------------------------------------
//
//   /// Steps: sum every point in the window (today's running total).
//   /// Resting HR: take the most recent single point (it's a point-in-time stat,
//   /// not something you'd sum) — controlled by [sumInsteadOfLatest].
//   Future<WearableMetricReading<int>?> _fetchLatestNumeric(
//     HealthDataType type,
//     DateTime from,
//     DateTime to, {
//     bool sumInsteadOfLatest = false,
//   }) async {
//     try {
//       final points = await _health.getHealthDataFromTypes(
//         types: [type],
//         startTime: from,
//         endTime: to,
//       );
//       if (points.isEmpty) return null;
//
//       if (sumInsteadOfLatest) {
//         final total = points.fold<num>(
//           0,
//           (sum, p) => sum + ((p.value as NumericHealthValue).numericValue),
//         );
//         return WearableMetricReading(
//           value: total.round(),
//           recordedAt: to,
//           sourceApp: points.last.sourceName,
//         );
//       }
//
//       points.sort((a, b) => b.dateTo.compareTo(a.dateTo));
//       final latest = points.first;
//       return WearableMetricReading(
//         value: (latest.value as NumericHealthValue).numericValue.round(),
//         recordedAt: latest.dateTo,
//         sourceApp: latest.sourceName,
//       );
//     } catch (_) {
//       return null;
//     }
//   }
//
//   Future<WearableMetricReading<Duration>?> _fetchSleepDuration(
//     DateTime from,
//     DateTime to,
//   ) async {
//     try {
//       final points = await _health.getHealthDataFromTypes(
//         types: [HealthDataType.SLEEP_ASLEEP],
//         startTime: from,
//         endTime: to,
//       );
//       if (points.isEmpty) return null;
//
//       final total = points.fold<Duration>(
//         Duration.zero,
//         (sum, p) => sum + p.dateTo.difference(p.dateFrom),
//       );
//       points.sort((a, b) => b.dateTo.compareTo(a.dateTo));
//       return WearableMetricReading(
//         value: total,
//         recordedAt: points.first.dateTo,
//         sourceApp: points.first.sourceName,
//       );
//     } catch (_) {
//       return null;
//     }
//   }
//
//   /// Systolic and diastolic are two separate HealthDataTypes in Health Connect
//   /// and HealthKit alike. They're written together by the source app, so pair
//   /// the latest systolic point with the diastolic point closest to its
//   /// timestamp rather than just taking each type's latest independently
//   /// (a stale unmatched pair would silently show the wrong reading).
//   Future<WearableMetricReading<BloodPressureValue>?> _fetchBloodPressure(
//     DateTime from,
//     DateTime to,
//   ) async {
//     try {
//       final systolicPoints = await _health.getHealthDataFromTypes(
//         types: [HealthDataType.BLOOD_PRESSURE_SYSTOLIC],
//         startTime: from,
//         endTime: to,
//       );
//       final diastolicPoints = await _health.getHealthDataFromTypes(
//         types: [HealthDataType.BLOOD_PRESSURE_DIASTOLIC],
//         startTime: from,
//         endTime: to,
//       );
//       if (systolicPoints.isEmpty || diastolicPoints.isEmpty) return null;
//
//       systolicPoints.sort((a, b) => b.dateTo.compareTo(a.dateTo));
//       final latestSystolic = systolicPoints.first;
//
//       final matchingDiastolic = diastolicPoints.reduce((a, b) {
//         final aDiff =
//             (a.dateFrom.difference(latestSystolic.dateFrom)).abs();
//         final bDiff =
//             (b.dateFrom.difference(latestSystolic.dateFrom)).abs();
//         return aDiff < bDiff ? a : b;
//       });
//
//       // If the closest diastolic point is more than 5 minutes away from the
//       // systolic point, they're not actually the same reading — treat as
//       // "no valid pair" rather than showing a mismatched BP.
//       final gap = matchingDiastolic.dateFrom
//           .difference(latestSystolic.dateFrom)
//           .abs();
//       if (gap > const Duration(minutes: 5)) return null;
//
//       return WearableMetricReading(
//         value: BloodPressureValue(
//           systolic:
//               (latestSystolic.value as NumericHealthValue).numericValue.round(),
//           diastolic: (matchingDiastolic.value as NumericHealthValue)
//               .numericValue
//               .round(),
//         ),
//         recordedAt: latestSystolic.dateTo,
//         sourceApp: latestSystolic.sourceName,
//       );
//     } catch (_) {
//       return null;
//     }
//   }
// }
import 'dart:io' show Platform;

import 'package:health/health.dart';

import 'package:heart_health_score/features/wearable/domain/wearable_models.dart';
import 'package:heart_health_score/features/wearable/domain/wearable_repository.dart';

/// Real implementation backed by the `health` pub.dev package, which wraps
/// Apple HealthKit (iOS) and Google Health Connect (Android) behind one API.
///
/// TODO(backend-integration): none — this talks to the OS directly, no backend
/// endpoint involved. Nothing here needs to change once your API is live.
///
/// Setup required before this compiles/runs (not done by this file):
/// 1. `flutter pub add health`
/// 2. Android: minSdkVersion 26, Health Connect permissions + <queries> block
///    in AndroidManifest.xml, MainActivity extends FlutterFragmentActivity.
/// 3. iOS: add HealthKit capability in Xcode, and the usage-description keys
///    to Info.plist (NSHealthShareUsageDescription at minimum for read-only).
class HealthWearableRepository implements WearableRepository {
  final Health _health = Health();

  /// Includes both the "ideal" record types (RESTING_HEART_RATE, SLEEP_ASLEEP)
  /// AND the broader fallback types (HEART_RATE, SLEEP_SESSION), because in
  /// practice most fitness apps only write the broader ones — see the
  /// fallback logic in _fetchRestingHeartRate / _fetchSleepDuration below.
  static const List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  ];

  static final List<HealthDataAccess> _permissions =
  _types.map((_) => HealthDataAccess.READ).toList();

  @override
  Future<bool> isPlatformStoreAvailable() async {
    if (Platform.isAndroid) {
      final status = await _health.getHealthConnectSdkStatus();
      return status == HealthConnectSdkStatus.sdkAvailable;
    }
    // HealthKit ships with iOS itself; per-type access is handled by
    // requestPermissions(), not by an install step.
    return true;
  }

  @override
  Future<bool> requestPermissions() async {
    final alreadyGranted =
        await _health.hasPermissions(_types, permissions: _permissions) ??
            false;
    if (alreadyGranted) return true;

    try {
      return await _health.requestAuthorization(_types,
          permissions: _permissions);
    } catch (_) {
      // User dismissed the dialog, or the OS refused it (e.g. device policy).
      return false;
    }
  }

  @override
  Future<WearableSnapshot> fetchLatestSnapshot() async {
    final now = DateTime.now();
    // Step count should be "today so far," not a rolling multi-day sum —
    // summing over a 2-day window would silently double-count once there's
    // more than a day of history in Health Connect.
    final startOfToday = DateTime(now.year, now.month, now.day);
    // Resting HR / sleep / BP look back further since they're point-in-time
    // or session-based, not a running daily total — e.g. "last night's
    // sleep" needs to reach back past midnight.
    final lookback = now.subtract(const Duration(days: 2));

    // Each metric is fetched and parsed independently, wrapped in its own
    // try/catch, so one type failing (denied permission, no data, a plugin
    // hiccup on a specific OEM skin) never takes the other three down with it.
    final results = await Future.wait([
      _fetchStepCount(startOfToday, now),
      _fetchRestingHeartRate(lookback, now),
      _fetchSleepDuration(lookback, now),
      _fetchBloodPressure(lookback, now),
    ]);

    final steps = results[0] as WearableMetricReading<int>?;
    final restingHr = results[1] as WearableMetricReading<int>?;
    final sleep = results[2] as WearableMetricReading<Duration>?;
    final bp = results[3] as WearableMetricReading<BloodPressureValue>?;

    return WearableSnapshot(
      fetchedAt: now,
      stepCount: steps,
      restingHeartRate: restingHr,
      sleepDuration: sleep,
      bloodPressure: bp,
    );
  }

  @override
  Future<bool> openPlatformStoreInstallPage() async {
    if (!Platform.isAndroid) return false;
    try {
      await _health.installHealthConnect();
      return true;
    } catch (_) {
      return false;
    }
  }

  // ---- private helpers -----------------------------------------------------

  Future<WearableMetricReading<int>?> _fetchStepCount(
      DateTime from,
      DateTime to,
      ) async {
    try {
      final points = await _health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: from,
        endTime: to,
      );
      if (points.isEmpty) return null;

      final total = points.fold<num>(
        0,
            (sum, p) => sum + ((p.value as NumericHealthValue).numericValue),
      );
      return WearableMetricReading(
        value: total.round(),
        recordedAt: to,
        sourceApp: points.last.sourceName,
      );
    } catch (_) {
      return null;
    }
  }

  /// Prefers a real RESTING_HEART_RATE record if the source app writes one.
  /// Most apps (confirmed in your case) only log continuous HEART_RATE
  /// samples with no dedicated resting-HR record — in that case, this falls
  /// back to the lowest reading in the window as an approximation. That's a
  /// standard proxy for devices without dedicated resting-HR detection, but
  /// it IS an approximation, not a clinical resting heart rate — worth
  /// flagging since this feeds a health-scoring model. If that distinction
  /// matters for your ML pipeline, consider passing a flag alongside this
  /// value upstream (e.g. `isApproximated: true`) rather than treating it
  /// identically to a true resting-HR record.
  Future<WearableMetricReading<int>?> _fetchRestingHeartRate(
      DateTime from,
      DateTime to,
      ) async {
    try {
      final restingPoints = await _health.getHealthDataFromTypes(
        types: [HealthDataType.RESTING_HEART_RATE],
        startTime: from,
        endTime: to,
      );
      if (restingPoints.isNotEmpty) {
        restingPoints.sort((a, b) => b.dateTo.compareTo(a.dateTo));
        final latest = restingPoints.first;
        return WearableMetricReading(
          value: (latest.value as NumericHealthValue).numericValue.round(),
          recordedAt: latest.dateTo,
          sourceApp: latest.sourceName,
        );
      }

      // Fallback: approximate from the lowest general HEART_RATE sample.
      final rawPoints = await _health.getHealthDataFromTypes(
        types: [HealthDataType.HEART_RATE],
        startTime: from,
        endTime: to,
      );
      if (rawPoints.isEmpty) return null;

      HealthDataPoint lowest = rawPoints.first;
      num lowestValue = (lowest.value as NumericHealthValue).numericValue;
      for (final p in rawPoints.skip(1)) {
        final v = (p.value as NumericHealthValue).numericValue;
        if (v < lowestValue) {
          lowestValue = v;
          lowest = p;
        }
      }
      return WearableMetricReading(
        value: lowestValue.round(),
        recordedAt: lowest.dateTo,
        sourceApp: lowest.sourceName,
      );
    } catch (_) {
      return null;
    }
  }

  /// Prefers stage-level SLEEP_ASLEEP records (more precise — excludes awake
  /// periods within a sleep session). Falls back to SLEEP_SESSION records
  /// (session start-to-end, no stage detail) since most apps only write
  /// those. Never mixes both in the same total — that would double count
  /// whichever session-vs-stage overlap exists.
  Future<WearableMetricReading<Duration>?> _fetchSleepDuration(
      DateTime from,
      DateTime to,
      ) async {
    try {
      final stagePoints = await _health.getHealthDataFromTypes(
        types: [HealthDataType.SLEEP_ASLEEP],
        startTime: from,
        endTime: to,
      );
      if (stagePoints.isNotEmpty) {
        return _sumSleepPoints(stagePoints);
      }

      final sessionPoints = await _health.getHealthDataFromTypes(
        types: [HealthDataType.SLEEP_SESSION],
        startTime: from,
        endTime: to,
      );
      if (sessionPoints.isEmpty) return null;
      return _sumSleepPoints(sessionPoints);
    } catch (_) {
      return null;
    }
  }

  WearableMetricReading<Duration> _sumSleepPoints(List<HealthDataPoint> points) {
    final total = points.fold<Duration>(
      Duration.zero,
          (sum, p) => sum + p.dateTo.difference(p.dateFrom),
    );
    points.sort((a, b) => b.dateTo.compareTo(a.dateTo));
    return WearableMetricReading(
      value: total,
      recordedAt: points.first.dateTo,
      sourceApp: points.first.sourceName,
    );
  }

  /// Systolic and diastolic are two separate HealthDataTypes in Health Connect
  /// and HealthKit alike. They're written together by the source app, so pair
  /// the latest systolic point with the diastolic point closest to its
  /// timestamp rather than just taking each type's latest independently
  /// (a stale unmatched pair would silently show the wrong reading).
  Future<WearableMetricReading<BloodPressureValue>?> _fetchBloodPressure(
      DateTime from,
      DateTime to,
      ) async {
    try {
      final systolicPoints = await _health.getHealthDataFromTypes(
        types: [HealthDataType.BLOOD_PRESSURE_SYSTOLIC],
        startTime: from,
        endTime: to,
      );
      final diastolicPoints = await _health.getHealthDataFromTypes(
        types: [HealthDataType.BLOOD_PRESSURE_DIASTOLIC],
        startTime: from,
        endTime: to,
      );
      if (systolicPoints.isEmpty || diastolicPoints.isEmpty) return null;

      systolicPoints.sort((a, b) => b.dateTo.compareTo(a.dateTo));
      final latestSystolic = systolicPoints.first;

      final matchingDiastolic = diastolicPoints.reduce((a, b) {
        final aDiff =
        (a.dateFrom.difference(latestSystolic.dateFrom)).abs();
        final bDiff =
        (b.dateFrom.difference(latestSystolic.dateFrom)).abs();
        return aDiff < bDiff ? a : b;
      });

      // If the closest diastolic point is more than 5 minutes away from the
      // systolic point, they're not actually the same reading — treat as
      // "no valid pair" rather than showing a mismatched BP.
      final gap = matchingDiastolic.dateFrom
          .difference(latestSystolic.dateFrom)
          .abs();
      if (gap > const Duration(minutes: 5)) return null;

      return WearableMetricReading(
        value: BloodPressureValue(
          systolic:
          (latestSystolic.value as NumericHealthValue).numericValue.round(),
          diastolic: (matchingDiastolic.value as NumericHealthValue)
              .numericValue
              .round(),
        ),
        recordedAt: latestSystolic.dateTo,
        sourceApp: latestSystolic.sourceName,
      );
    } catch (_) {
      return null;
    }
  }
}