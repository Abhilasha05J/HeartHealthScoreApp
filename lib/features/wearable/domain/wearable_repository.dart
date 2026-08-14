import 'package:heart_health_score/features/wearable/domain/wearable_models.dart';

/// Abstract contract for the "Connect Wearable" feature. Screens and controllers
/// depend ONLY on this interface — never on `Health`, `HealthDataType`, or any
/// other type from the `health` package directly (same dependency-inversion rule
/// as AuthRepository / OnboardingRepository).
///
/// v1 scope: Health Connect (Android) + HealthKit (iOS) only, via the `health`
/// pub.dev package. No direct BLE, no vendor SDKs — see HealthWearableRepository.
abstract class WearableRepository {
  /// Whether the platform's health data store is usable on this device.
  /// - iOS: effectively always true (HealthKit ships with the OS).
  /// - Android: false if the Health Connect app isn't installed (only relevant
  ///   on Android 13; it's built into the OS on Android 14+).
  Future<bool> isPlatformStoreAvailable();

  /// Opens the OS permission dialog for all four metrics. Returns true if the
  /// user granted at least one permission. Health Connect/HealthKit allow
  /// PARTIAL grants — never assume all-or-nothing here; fetchLatestSnapshot()
  /// is what determines which metrics actually came back with data.
  Future<bool> requestPermissions();

  /// Fetches the latest value for each of the four metrics independently.
  /// A metric with no permission or no recorded data comes back null on the
  /// snapshot — this method must never throw because ONE metric is missing.
  Future<WearableSnapshot> fetchLatestSnapshot();

  /// Android only: sends the user to install/update the Health Connect app.
  /// Returns false (no-op) on iOS since HealthKit has no separate install step.
  Future<bool> openPlatformStoreInstallPage();
}
