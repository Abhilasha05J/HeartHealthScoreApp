
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/auth_providers.dart';
import '../data/api_assessment_repository.dart';
import '../domain/assessment_models.dart';

// ─────────────────────────────────────────────────────────────────────────
// Repository & API Client (wire these up with your actual dependencies)
// ─────────────────────────────────────────────────────────────────────────
final assessmentRepositoryProvider =
Provider<AssessmentRepository>((ref) {
  return ApiAssessmentRepository(
    dio: ref.watch(dioProvider),
  );
});

// ─────────────────────────────────────────────────────────────────────────
// UI State Providers
// ─────────────────────────────────────────────────────────────────────────

/// Active tab selection — separate from form data to avoid rebuilds.
final activeAssessmentTabProvider =
StateProvider<AssessmentTab>((ref) => AssessmentTab.lipids);

/// File upload progress indicator.
final assessmentUploadingProvider = StateProvider<bool>((ref) => false);

/// ECG analysis in progress.
final ecgAnalyzingProvider = StateProvider<bool>((ref) => false);

// ─────────────────────────────────────────────────────────────────────────
// Main Assessment Controller (form state + submit workflow)
// ─────────────────────────────────────────────────────────────────────────

final assessmentControllerProvider =
StateNotifierProvider<AssessmentController, AsyncValue<AssessmentDraft>>(
      (ref) => AssessmentController(
    ref.watch(assessmentRepositoryProvider),
  )..load(), // Auto-load on init
);

class AssessmentController extends StateNotifier<AsyncValue<AssessmentDraft>> {
  AssessmentController(this._repository) : super(const AsyncValue.loading());

  final AssessmentRepository _repository;

  /// Load prefilled form data from backend (auto-called on init).
  Future<void> load() async {
    try {
      state = AsyncValue.data(await _repository.loadPrefill());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Refresh prefilled data (manual user action).
  Future<void> refresh() async {
    try {
      state = AsyncValue.data(await _repository.loadPrefill());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Get current draft (safe access).
  AssessmentDraft get _current => state.value ?? const AssessmentDraft();

  // ─────────────────────────────────────────────────────────────────────
  // Field Updaters (per-profile)
  // ─────────────────────────────────────────────────────────────────────

  void updateLipids(LipidProfile Function(LipidProfile) update) =>
      state = AsyncValue.data(_current.copyWith(lipids: update(_current.lipids)));

  void updatePressure(PressureProfile Function(PressureProfile) update) =>
      state = AsyncValue.data(_current.copyWith(pressure: update(_current.pressure)));

  void updateGlucose(GlucoseProfile Function(GlucoseProfile) update) =>
      state = AsyncValue.data(_current.copyWith(glucose: update(_current.glucose)));

  void updateKidney(KidneyProfile Function(KidneyProfile) update) =>
      state = AsyncValue.data(_current.copyWith(kidney: update(_current.kidney)));

  void updateLifestyle(LifestyleFitnessProfile Function(LifestyleFitnessProfile) update) =>
      state = AsyncValue.data(
          _current.copyWith(lifestyle: update(_current.lifestyle)));

  void updateHeartTests(HeartTestsProfile Function(HeartTestsProfile) update) =>
      state = AsyncValue.data(
          _current.copyWith(heartTests: update(_current.heartTests)));

  void updateVisit(VisitProfile Function(VisitProfile) update) =>
      state = AsyncValue.data(_current.copyWith(visit: update(_current.visit)));

  void updatePatientProfile(PatientProfile Function(PatientProfile) update) =>
      state = AsyncValue.data(
          _current.copyWith(patientProfile: update(_current.patientProfile)));

  // ─────────────────────────────────────────────────────────────────────
  // ECG Analysis
  // ─────────────────────────────────────────────────────────────────────

  Future<void> analyzeEcg(String localPath, String fileName) async {
    state = AsyncValue.data(_current.copyWith(
      heartTests: _current.heartTests.copyWith(
        ecgLocalPath: localPath,
        ecgFileName: fileName,
        ecgAnalysisResult: null,
      ),
    ));
    final result = await _repository.analyzeEcg(localPath);
    state = AsyncValue.data(_current.copyWith(
      heartTests:
      _current.heartTests.copyWith(ecgAnalysisResult: result),
    ));
  }

  // ─────────────────────────────────────────────────────────────────────
  // Report Management
  // ─────────────────────────────────────────────────────────────────────

  Future<void> uploadReport({
    required String localPath,
    required String fileName,
    required ReportFileType type,
  }) async {
    final report = await _repository.uploadReport(
      localPath: localPath,
      fileName: fileName,
      type: type,
    );
    state = AsyncValue.data(
        _current.copyWith(reports: [..._current.reports, report]));
  }

  Future<void> deleteReport(String reportId) async {
    await _repository.deleteReport(reportId);
    state = AsyncValue.data(
      _current.copyWith(
        reports: _current.reports
            .where((r) => r.id != reportId)
            .toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // Draft & Submission
  // ─────────────────────────────────────────────────────────────────────

  // Future<void> saveDraft() => _repository.saveDraft(_current);
  //
  // Future<void> submit() => _repository.submitAssessment(_current);
  Future<void> saveDraft() => _repository.saveDraft(_current);

  /// Guards against submitting a draft whose visit demographics never
  /// loaded — `_current` falls back to `const AssessmentDraft()` (age/sex
  /// both null) whenever `state` isn't `AsyncValue.data(...)` yet, i.e.
  /// prefill is still loading or previously failed. AppUser carries no
  /// age/biologicalSex to fall back to (confirmed against /auth/me), so
  /// the only correct recovery is re-fetching prefill before submitting,
  /// not guessing/defaulting the values.
  Future<void> submit() async {
    var draft = state.value;

    if (draft == null || draft.visit.age == null || draft.visit.biologicalSex == null) {
      try {
        draft = await _repository.loadPrefill();
        state = AsyncValue.data(draft);
      } catch (e) {
        throw 'Could not load your profile details. Please check your connection and try again.';
      }

      if (draft.visit.age == null || draft.visit.biologicalSex == null) {
        throw 'Your age and biological sex weren\'t found on your profile. Please complete onboarding first.';
      }
    }

    return _repository.submitAssessment(draft);
  }
}
