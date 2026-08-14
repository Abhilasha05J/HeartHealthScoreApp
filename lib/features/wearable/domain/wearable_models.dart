/// Domain models for the "Connect Wearable" feature.
///
/// These are the ONLY types the presentation/application layers should ever touch.
/// The Health Connect / HealthKit response shapes (HealthDataPoint, etc.) must stay
/// inside the data-layer repository implementation — never let them leak up here.
/// (Same rule as OnboardingRepository / AuthRepository — see skill section 7.)

enum WearableMetricType {
  restingHeartRate,
  sleepDuration,
  bloodPressure,
  stepCount,
}

/// Systolic/diastolic pair. Modeled as one unit because a BP reading only makes
/// sense as a pair — never split into two independent WearableMetricReadings.
class BloodPressureValue {
  final int systolic;
  final int diastolic;

  const BloodPressureValue({required this.systolic, required this.diastolic});

  @override
  String toString() => '$systolic/$diastolic mmHg';
}

/// A single metric value plus the provenance info the UI shows in the card footer
/// (e.g. "Synced from Fitbit · 2h ago"). [sourceApp] is nullable because Health
/// Connect/HealthKit don't always report a source name for every data point.
class WearableMetricReading<T> {
  final T value;
  final DateTime recordedAt;
  final String? sourceApp;

  const WearableMetricReading({
    required this.value,
    required this.recordedAt,
    this.sourceApp,
  });
}

/// Result of one fetch from the platform store. Every field is independently
/// nullable — a missing field means "no permission, or no data was ever written
/// for this metric," NOT an error. The repository must never throw just because
/// one of the four metrics has no data; see HealthWearableRepository.
class WearableSnapshot {
  final WearableMetricReading<int>? restingHeartRate; // bpm
  final WearableMetricReading<Duration>? sleepDuration;
  final WearableMetricReading<BloodPressureValue>? bloodPressure;
  final WearableMetricReading<int>? stepCount;
  final DateTime fetchedAt;

  const WearableSnapshot({
    this.restingHeartRate,
    this.sleepDuration,
    this.bloodPressure,
    this.stepCount,
    required this.fetchedAt,
  });

  static WearableSnapshot empty(DateTime fetchedAt) =>
      WearableSnapshot(fetchedAt: fetchedAt);

  bool get hasAnyData =>
      restingHeartRate != null ||
          sleepDuration != null ||
          bloodPressure != null ||
          stepCount != null;

  /// Ordered the way the cards should render — steps and HR first (universally
  /// available), sleep next, BP last (least likely to have data). Screen should
  /// iterate this instead of hand-checking each field, so adding a 5th metric
  /// later only means editing this list.
  List<WearableMetricType> get availableMetrics => [
    if (stepCount != null) WearableMetricType.stepCount,
    if (restingHeartRate != null) WearableMetricType.restingHeartRate,
    if (sleepDuration != null) WearableMetricType.sleepDuration,
    if (bloodPressure != null) WearableMetricType.bloodPressure,
  ];
}

enum WearableConnectionStatus {
  notConnected,
  connecting,
  connected,
  // Android only: Health Connect app isn't installed on this device.
  storeUnavailable,
  // User denied the OS permission dialog (fully or partially).
  permissionDenied,
  error,
}

class WearableConnectionState {
  final WearableConnectionStatus status;
  final WearableSnapshot? snapshot;
  final String? errorMessage;
  final bool isRefreshing;

  const WearableConnectionState({
    this.status = WearableConnectionStatus.notConnected,
    this.snapshot,
    this.errorMessage,
    this.isRefreshing = false,
  });

  /// True while EITHER the first-time connect flow (permission + fetch) OR a
  /// re-sync of an already-connected wearable is in progress. The button/UI
  /// should show one unified "syncing" state for both.
  bool get isSyncing =>
      status == WearableConnectionStatus.connecting || isRefreshing;

  WearableConnectionState copyWith({
    WearableConnectionStatus? status,
    WearableSnapshot? snapshot,
    String? errorMessage,
    bool? isRefreshing,
  }) {
    return WearableConnectionState(
      status: status ?? this.status,
      snapshot: snapshot ?? this.snapshot,
      errorMessage: errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}