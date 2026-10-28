import 'package:heart_health_score/features/ecg/domain/ecg_entities.dart';
import 'package:heart_health_score/features/ecg/domain/ecg_repository.dart';

/// Used where there is no Spandan SDK (iOS, until Sunfox confirms one exists).
/// The UI should hide the ECG button when [isSupported] is false.
class UnsupportedEcgRepository implements EcgRepository {
  const UnsupportedEcgRepository();

  static const _status = EcgDeviceStatus(sdkState: EcgSdkState.unsupported);

  @override
  bool get isSupported => false;

  @override
  Future<EcgDeviceStatus> getStatus() async => _status;

  @override
  Stream<EcgDeviceStatus> watchStatus() => Stream.value(_status);

  @override
  Stream<EcgReportEvent> get reportEvents => const Stream.empty();

  @override
  Future<void> startTest({
    required EcgTestType type,
    required EcgPatientData patient,
  }) async {
    throw const EcgException(EcgFailure.unsupportedPlatform);
  }
}