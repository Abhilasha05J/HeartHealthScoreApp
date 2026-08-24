import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heart_health_score/features/assessment/domain/assessment_models.dart';
import 'package:heart_health_score/features/assessment/data/mock_assessment_repository.dart';

final assessmentRepositoryProvider =
Provider<AssessmentRepository>((ref) => MockAssessmentRepository());

/// Transient UI-only state (active tab) — separate from the data notifier
/// so switching tabs doesn't rebuild the whole form.
final activeAssessmentTabProvider =
StateProvider<AssessmentTab>((ref) => AssessmentTab.lipids);

final assessmentUploadingProvider = StateProvider<bool>((ref) => false);
final ecgAnalyzingProvider = StateProvider<bool>((ref) => false); // NEW
final assessmentControllerProvider =
StateNotifierProvider<AssessmentController, AsyncValue<AssessmentDraft>>(
      (ref) => AssessmentController(ref.watch(assessmentRepositoryProvider))..load(),
);

class AssessmentController extends StateNotifier<AsyncValue<AssessmentDraft>> {
  AssessmentController(this._repository) : super(const AsyncValue.loading());

  final AssessmentRepository _repository;

  Future<void> load() async {
    try {
      state = AsyncValue.data(await _repository.loadDraft());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  AssessmentDraft get _current => state.value ?? const AssessmentDraft();

  void updateLipids(LipidProfile Function(LipidProfile) update) =>
      state = AsyncValue.data(_current.copyWith(lipids: update(_current.lipids)));

  void updatePressure(PressureProfile Function(PressureProfile) update) =>
      state = AsyncValue.data(_current.copyWith(pressure: update(_current.pressure)));

  void updateGlucose(GlucoseProfile Function(GlucoseProfile) update) =>
      state = AsyncValue.data(_current.copyWith(glucose: update(_current.glucose)));

  void updateKidney(KidneyProfile Function(KidneyProfile) update) =>
      state = AsyncValue.data(_current.copyWith(kidney: update(_current.kidney)));

  void updateLifestyle(LifestyleFitnessProfile Function(LifestyleFitnessProfile) update) =>
      state = AsyncValue.data(_current.copyWith(lifestyle: update(_current.lifestyle)));

  void updateHeartTests(HeartTestsProfile Function(HeartTestsProfile) update) =>
      state = AsyncValue.data(_current.copyWith(heartTests: update(_current.heartTests)));

  Future<void> analyzeEcg(String localPath, String fileName) async {
    state = AsyncValue.data(_current.copyWith(
      heartTests: _current.heartTests.copyWith(ecgLocalPath: localPath, ecgFileName: fileName, ecgAnalysisResult: null),
    ));
    final result = await _repository.analyzeEcg(localPath);
    state = AsyncValue.data(_current.copyWith(
      heartTests: _current.heartTests.copyWith(ecgAnalysisResult: result),
    ));
  }
  // TODO(backend-integration): surface failures via a separate
  // isSavingProvider once a real repository can actually throw.
  Future<void> saveDraft() => _repository.saveDraft(_current);

  Future<void> submit() => _repository.submitAssessment(_current);

  Future<void> uploadReport({
    required String localPath,
    required String fileName,
    required ReportFileType type,
  }) async {
    final report = await _repository.uploadReport(localPath: localPath, fileName: fileName, type: type);
    state = AsyncValue.data(_current.copyWith(reports: [..._current.reports, report]));
  }

  Future<void> deleteReport(String reportId) async {
    await _repository.deleteReport(reportId);
    state = AsyncValue.data(
      _current.copyWith(reports: _current.reports.where((r) => r.id != reportId).toList()),
    );
  }
}