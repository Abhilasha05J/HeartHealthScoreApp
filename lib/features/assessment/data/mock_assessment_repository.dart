// import 'dart:io';
// import '../domain/assessment_models.dart';
//
// class MockAssessmentRepository implements AssessmentRepository {
//   AssessmentDraft _draft = const AssessmentDraft();
//
//   @override
//   Future<AssessmentDraft> loadDraft() async {
//     await Future.delayed(const Duration(milliseconds: 200));
//     return _draft;
//   }
//
//   @override
//   Future<void> saveDraft(AssessmentDraft draft) async {
//     await Future.delayed(const Duration(milliseconds: 200));
//     _draft = draft;
//   }
//
//   @override
//   Future<void> submitAssessment(AssessmentDraft draft) async {
//     await Future.delayed(const Duration(milliseconds: 400));
//     _draft = draft;
//     // TODO(backend-integration): POST to the ML scoring endpoint here.
//   }
//
//   @override
//   Future<UploadedReport> uploadReport({
//     required String localPath,
//     required String fileName,
//     required ReportFileType type,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 600)); // simulated upload latency
//     final file = File(localPath);
//     final report = UploadedReport(
//       id: DateTime.now().microsecondsSinceEpoch.toString(),
//       fileName: fileName,
//       localPath: localPath,
//       type: type,
//       sizeBytes: await file.exists() ? await file.length() : 0,
//       uploadedAt: DateTime.now(),
//     );
//     _draft = _draft.copyWith(reports: [..._draft.reports, report]);
//     return report;
//   }
//   @override
//   Future<String> analyzeEcg(String localPath) async {
//     await Future.delayed(const Duration(seconds: 2)); // simulated model inference
//     // TODO(backend-integration): replace with a real POST to the ECG model endpoint.
//     return 'No acute abnormalities detected. Normal sinus rhythm.';
//   }
//   @override
//   Future<void> deleteReport(String reportId) async {
//     await Future.delayed(const Duration(milliseconds: 150));
//     _draft = _draft.copyWith(reports: _draft.reports.where((r) => r.id != reportId).toList());
//   }
// }