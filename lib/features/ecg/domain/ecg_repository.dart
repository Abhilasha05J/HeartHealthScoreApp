import 'package:heart_health_score/features/ecg/domain/ecg_entities.dart';

abstract class EcgRepository {
  /// False on platforms with no Spandan SDK (iOS, until Sunfox confirms one).
  bool get isSupported;

  Future<EcgDeviceStatus> getStatus();

  /// Emits the current status first, then every change (SDK init, device attach/detach).
  Stream<EcgDeviceStatus> watchStatus();

  /// Results of tests run in the SDK's own UI. Cancelling mid-test emits nothing.
  /// Reports that arrived while nobody was listening are replayed to the next listener.
  Stream<EcgReportEvent> get reportEvents;

  /// Launches the SDK's test UI. Completes as soon as the UI is on screen, NOT when the
  /// test finishes: results arrive on [reportEvents].
  /// Throws [EcgException].
  Future<void> startTest({
    required EcgTestType type,
    required EcgPatientData patient,
  });
}