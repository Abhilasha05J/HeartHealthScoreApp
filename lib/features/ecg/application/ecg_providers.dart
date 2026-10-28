import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heart_health_score/features/ecg/data/spandan_ecg_repository.dart';
import 'package:heart_health_score/features/ecg/data/unsupported_ecg_repository.dart';
import 'package:heart_health_score/features/ecg/domain/ecg_entities.dart';
import 'package:heart_health_score/features/ecg/domain/ecg_repository.dart';

/// The single swap point: Spandan on Android, unsupported stub elsewhere.
final ecgRepositoryProvider = Provider<EcgRepository>((ref) {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return SpandanEcgRepository();
  }
  return const UnsupportedEcgRepository();
});

final ecgSupportedProvider = Provider<bool>(
      (ref) => ref.watch(ecgRepositoryProvider).isSupported,
);

/// Live SDK + USB device status (for enabling/disabling the ECG button).
final ecgDeviceStatusProvider = StreamProvider<EcgDeviceStatus>(
      (ref) => ref.watch(ecgRepositoryProvider).watchStatus(),
);

class EcgState {
  const EcgState({this.isLaunching = false, this.lastReport, this.error});

  /// True only while the SDK UI is being launched (not for the whole test).
  final bool isLaunching;
  final EcgReport? lastReport;
  final String? error;

  EcgState copyWith({
    bool? isLaunching,
    EcgReport? lastReport,
    String? error,
    bool clearError = false,
  }) =>
      EcgState(
        isLaunching: isLaunching ?? this.isLaunching,
        lastReport: lastReport ?? this.lastReport,
        error: clearError ? null : (error ?? this.error),
      );
}

class EcgController extends StateNotifier<EcgState> {
  EcgController(this._repo) : super(const EcgState()) {
    _repo.reportEvents.listen(_onReportEvent);
  }

  final EcgRepository _repo;

  Future<void> startTest(EcgPatientData patient) async {
    if (state.isLaunching) return;
    state = state.copyWith(isLaunching: true, clearError: true);
    try {
      // Only the 12-lead test is enabled on the UAT account.
      await _repo.startTest(type: EcgTestType.twelveLead, patient: patient);
    } on EcgException catch (e) {
      state = state.copyWith(error: e.userMessage);
    } finally {
      if (mounted) state = state.copyWith(isLaunching: false);
    }
  }

  void clearError() => state = state.copyWith(clearError: true);

  void _onReportEvent(EcgReportEvent event) {
    switch (event) {
      case EcgReportReady(:final report):
      // TODO(backend-integration): persist/upload the report (pdfReportUrl +
      // characteristics + conclusions) and refresh the dashboard. No endpoint yet.
        state = state.copyWith(lastReport: report, clearError: true);
      case EcgReportFailed(:final message):
        if (kDebugMode) debugPrint('ECG report failed: $message');
        state = state.copyWith(error: 'Could not generate the ECG report. Please retry.');
    }
  }
}

final ecgControllerProvider = StateNotifierProvider<EcgController, EcgState>(
      (ref) => EcgController(ref.watch(ecgRepositoryProvider)),
);