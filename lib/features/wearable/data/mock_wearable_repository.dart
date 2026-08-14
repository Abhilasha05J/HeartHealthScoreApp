import 'package:heart_health_score/features/wearable/domain/wearable_models.dart';
import 'package:heart_health_score/features/wearable/domain/wearable_repository.dart';

/// Mock implementation, used until you've done real on-device testing against
/// Health Connect / HealthKit (simulators/emulators don't reliably have real
/// health data, so you'll want this for UI work regardless).
///
/// Deliberately returns no blood-pressure reading, matching the realistic case
/// discussed: most wearables don't write BP, so the "only show cards with data"
/// screen should render 3 cards (steps, resting HR, sleep), not 4, by default.
/// Flip [seedBloodPressure] to true locally if you want to eyeball the BP card
/// layout without waiting for a real Omron/Withings-linked test account.
class MockWearableRepository implements WearableRepository {
  MockWearableRepository({this.seedBloodPressure = false});

  final bool seedBloodPressure;
  bool _permissionsGranted = false;

  @override
  Future<bool> isPlatformStoreAvailable() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Future<bool> requestPermissions() async {
    await Future.delayed(const Duration(milliseconds: 600));
    _permissionsGranted = true;
    return true;
  }

  @override
  Future<WearableSnapshot> fetchLatestSnapshot() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();

    if (!_permissionsGranted) {
      return WearableSnapshot.empty(now);
    }

    return WearableSnapshot(
      fetchedAt: now,
      stepCount: WearableMetricReading(
        value: 5321,
        recordedAt: now.subtract(const Duration(minutes: 12)),
        sourceApp: 'Health Connect',
      ),
      restingHeartRate: WearableMetricReading(
        value: 68,
        recordedAt: now.subtract(const Duration(hours: 2)),
        sourceApp: 'Fitbit',
      ),
      sleepDuration: WearableMetricReading(
        value: const Duration(hours: 7, minutes: 20),
        recordedAt: now.subtract(const Duration(hours: 8)),
        sourceApp: 'Fitbit',
      ),
      bloodPressure: seedBloodPressure
          ? WearableMetricReading(
              value: const BloodPressureValue(systolic: 118, diastolic: 76),
              recordedAt: now.subtract(const Duration(days: 1)),
              sourceApp: 'Omron Connect',
            )
          : null,
    );
  }

  @override
  Future<bool> openPlatformStoreInstallPage() async => true;
}
