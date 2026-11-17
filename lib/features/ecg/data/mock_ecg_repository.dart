import 'dart:async';

import 'package:heart_health_score/features/ecg/domain/ecg_entities.dart';
import 'package:heart_health_score/features/ecg/domain/ecg_repository.dart';

/// Simulated [EcgRepository] for testing the 12-lead ECG flow without a
/// physical Spandan USB device attached.
///
/// To enable in `ecgRepositoryProvider`:
/// ```dart
/// const _useMockEcg = bool.fromEnvironment('USE_MOCK_ECG', defaultValue: true);
///
/// final ecgRepositoryProvider = Provider<EcgRepository>((ref) {
///   if (_useMockEcg) return MockEcgRepository();
///   if (defaultTargetPlatform == TargetPlatform.android) {
///     return SpandanEcgRepository();
///   }
///   return const UnsupportedEcgRepository();
/// });
/// ```
class MockEcgRepository implements EcgRepository {
  MockEcgRepository({
    this.simulatedTestDuration = const Duration(seconds: 2),
    this.simulateReportFailure = false,
  });

  /// Delay between `startTest()` completing (UI "launched") and the simulated
  /// report arriving on [reportEvents].
  final Duration simulatedTestDuration;

  /// Set to `true` to test the [EcgReportFailed] error state in `EcgController`.
  final bool simulateReportFailure;

  final _statusCtrl = StreamController<EcgDeviceStatus>.broadcast();
  final _reportCtrl = StreamController<EcgReportEvent>.broadcast();
  final _undelivered = <EcgReportEvent>[];

  EcgDeviceStatus _currentStatus = const EcgDeviceStatus(
    sdkState: EcgSdkState.ready,
    connection: EcgConnectionState.connected,
    sdkMessage: null,
    deviceVariant: 'SPANDAN_PRO',
    deviceId: 'SPN-MOCK-12L-001',
    firmwareVersion: '2.2.6-mock',
  );

  @override
  bool get isSupported => true;

  @override
  Future<EcgDeviceStatus> getStatus() async => _currentStatus;

  @override
  Stream<EcgDeviceStatus> watchStatus() async* {
    yield _currentStatus;
    yield* _statusCtrl.stream;
  }

  @override
  Future<void> retryInitialization() async {
    _currentStatus = const EcgDeviceStatus(
      sdkState: EcgSdkState.ready,
      connection: EcgConnectionState.connected,
      sdkMessage: null,
      deviceVariant: 'SPANDAN_PRO',
      deviceId: 'SPN-MOCK-12L-001',
      firmwareVersion: '2.2.6-mock',
    );
    _statusCtrl.add(_currentStatus);
  }

  @override
  Stream<EcgReportEvent> get reportEvents async* {
    while (_undelivered.isNotEmpty) {
      yield _undelivered.removeAt(0);
    }
    yield* _reportCtrl.stream;
  }

  @override
  Future<void> startTest({
    required EcgTestType type,
    required EcgPatientData patient,
  }) async {
    if (_currentStatus.sdkState != EcgSdkState.ready) {
      throw const EcgException(EcgFailure.sdkNotInitialised);
    }
    if (_currentStatus.connection != EcgConnectionState.connected) {
      throw const EcgException(EcgFailure.deviceNotConnected);
    }

    // Matches SpandanEcgRepository contract: startTest completes once the SDK UI
    // launches, while the final ECG report arrives asynchronously on reportEvents.
    await Future<void>.delayed(const Duration(milliseconds: 250));

    Timer(simulatedTestDuration, () {
      if (simulateReportFailure) {
        _emitReport(
          const EcgReportFailed('Simulated report generation failure.'),
        );
        return;
      }

      final nowMs = DateTime.now().millisecondsSinceEpoch;
      final report = EcgReport(
        reportId: 'MOCK-RPT-$nowMs',
        pdfReportUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        characteristics: const EcgCharacteristics(
          pr: 156,
          qrs: 88,
          qt: 384,
          qtc: 412.5,
          rr: 833,
          heartRate: 72,
        ),
        conclusions: EcgConclusions(
          anomalies: 'No significant ST-T segment or conduction abnormalities detected.',
          detection: 'Normal Sinus Rhythm',
          ecgType: type.wireName,
          recommendation:
          'ECG intervals for ${patient.firstName} are within normal limits. Continue routine monitoring.',
          risk: 'Low',
        ),
        deviceVariant: _currentStatus.deviceVariant,
        deviceId: _currentStatus.deviceId,
        firmwareVersion: _currentStatus.firmwareVersion,
      );

      _emitReport(EcgReportReady(report));
    });
  }

  void _emitReport(EcgReportEvent event) {
    if (_reportCtrl.hasListener) {
      _reportCtrl.add(event);
    } else {
      _undelivered.add(event);
    }
  }
}