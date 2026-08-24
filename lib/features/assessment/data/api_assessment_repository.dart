import 'dart:io';
import 'package:dio/dio.dart';

import '../domain/assessment_models.dart';
/// Real implementation of AssessmentRepository — calls backend APIs.
///
/// Handles three workflows:
/// 1. loadPrefill() → GET /me/intake/prefill (auto-prefill form with previous values)
/// 2. submitAssessment() → POST /ml/score + POST /me/encounters
/// 3. uploadReport() → multipart POST (not shown; reuse existing logic)
class ApiAssessmentRepository implements AssessmentRepository {
  ApiAssessmentRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  /// Fetch prefilled form data from the backend.
  ///
  /// Maps backend response (with status/value/months_old per field) into
  /// FieldValue objects so the UI can show freshness ("4 months old") inline.
  @override
  Future<AssessmentDraft> loadPrefill() async {
    try {
      final response = await _dio.get('/me/intake/prefill');
      final data = response.data as Map<String, dynamic>;

      // Extract visit and patient data (if present)
      final prefillData = data['prefill'] as Map<String, dynamic>? ?? {};
      final visitData = prefillData['visit'] as Map<String, dynamic>? ?? {};
      final fieldsData = prefillData['fields'] as Map<String, dynamic>? ?? {};

      // Reconstruct visit profile
      final visit = VisitProfile(
        patientId: data['patient_id'] as String?,
        visitId: visitData['from_visit_id'] as String?,
        age: visitData['age'] as int?,
        biologicalSex: visitData['biological_sex'] as String?,
        regionProfile: visitData['region_profile'] as String? ?? '',
        clinicalSetting: visitData['clinical_setting'] as String? ?? 'Self-reported (patient)',
      );

      // Lipids
      final lipidProfile = LipidProfile(
        ldlC: _parseFieldValue<double>(fieldsData['ldl']),
        hdlC: _parseFieldValue<double>(fieldsData['hdl']),
        totalCholesterol: _parseFieldValue<double>(fieldsData['total_cholesterol']),
        triglycerides: _parseFieldValue<double>(fieldsData['triglycerides']),
        apoB: _parseFieldValue<double>(fieldsData['apob']),
        lpA: _parseFieldValue<double>(fieldsData['lpa']),
      );

      // Pressure
      final pressureProfile = PressureProfile(
        systolicBp: _parseFieldValue<double>(fieldsData['sbp']),
        diastolicBp: _parseFieldValue<double>(fieldsData['dbp']),
        restingHeartRate: _parseFieldValue<double>(fieldsData['resting_hr']),
        lvh: _parseFieldValue<bool>(fieldsData['lvh']),
      );

      // Glucose
      final glucoseProfile = GlucoseProfile(
        diabetesStatus: _parseFieldValue<DiabetesStatus>(
          fieldsData['diabetes'],
          parser: (val) => DiabetesStatus.values.firstWhere(
            (e) => e.name == val,
            orElse: () => DiabetesStatus.none,
          ),
        ),
        hba1c: _parseFieldValue<double>(fieldsData['hba1c']),
        fastingGlucose: _parseFieldValue<double>(fieldsData['fasting_glucose']),
      );

      // Kidney
      final kidneyProfile = KidneyProfile(
        eGfr: _parseFieldValue<double>(fieldsData['egfr']),
        creatinine: _parseFieldValue<double>(fieldsData['creatinine']),
        uacr: _parseFieldValue<double>(fieldsData['uacr']),
        ckd: _parseFieldValue<bool>(fieldsData['ckd']),
      );

      // Lifestyle
      final lifestyleProfile = LifestyleFitnessProfile(
        bmi: _parseFieldValue<double>(fieldsData['bmi']),
        waistCircumference: _parseFieldValue<double>(fieldsData['waist']),
        waistHipRatio: _parseFieldValue<double>(fieldsData['whr']),
        weeklyActivityMinutes: _parseFieldValue<double>(fieldsData['physical_activity']),
        structuredActivityScore: _parseFieldValue<double>(fieldsData['structured_activity_score']),
        familyHistory: _parseFieldValue<String>(fieldsData['family_history']),
        geneticMutation: _parseFieldValue<String>(fieldsData['genetic_mutation']),
        geneticRiskScorePercent: _parseFieldValue<double>(fieldsData['prs_percentile']),
        smokingStatus: _parseFieldValue<SmokingStatus>(
          fieldsData['smoking_status'],
          parser: (val) => SmokingStatus.values.firstWhere(
            (e) => e.name == val,
            orElse: () => SmokingStatus.never,
          ),
        ),
        packYears: _parseFieldValue<int>(fieldsData['pack_years']),
        quitDurationYears: _parseFieldValue<int>(fieldsData['years_since_quit']),
        smokelessTobacco: _parseFieldValue<bool>(fieldsData['smokeless_tobacco']),
        dietQualityScore: _parseFieldValue<double>(fieldsData['diet_score']),
        alcoholAudit: _parseFieldValue<double>(fieldsData['alcohol_audit']),
        sleepHoursPerNight: _parseFieldValue<double>(fieldsData['sleep_hours']),
        stressScore: _parseFieldValue<double>(fieldsData['stress_score']),
      );

      // Heart Tests
      final heartTestsProfile = HeartTestsProfile(
        lvh: _parseFieldValue<bool>(fieldsData['lvh']),
        hsCrp: _parseFieldValue<double>(fieldsData['hscrp']),
        cacScore: _parseFieldValue<double>(fieldsData['cac']),
      );

      return AssessmentDraft(
        visit: visit,
        lipids: lipidProfile,
        pressure: pressureProfile,
        glucose: glucoseProfile,
        kidney: kidneyProfile,
        lifestyle: lifestyleProfile,
        heartTests: heartTestsProfile,
        lpaUnit: prefillData['lpa_unit'] as String? ?? 'mg/dL',
      );
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to load prefilled data');
    }
  }

  /// Persist draft locally (no backend call yet).
  ///
  /// TODO: integrate with local storage/SharedPreferences for offline support.
  @override
  Future<void> saveDraft(AssessmentDraft draft) async {
    // Placeholder: in production, save to local DB or shared prefs.
    await Future.delayed(const Duration(milliseconds: 200));
  }

  /// Submit assessment: hit ML scoring endpoint first, then POST to /me/encounters.
  ///
  /// Workflow:
  /// 1. POST /ml/score with form data → returns HHS score + analysis
  /// 2. POST /me/encounters with full SubmissionIn + score details
  // @override
  // Future<void> submitAssessment(AssessmentDraft draft) async {
  //   try {
  //     // Step 1: Get ML score
  //     final mlPayload = draft.toSubmissionJson();
  //     final scoreResponse = await _dio.post(
  //       '/ml/score',
  //       data: mlPayload,
  //     );
  //
  //     final scoreData = scoreResponse.data as Map<String, dynamic>;
  //     final hhs = scoreData['hhs'] as double?;
  //     final category = scoreData['category'] as String?;
  //
  //     // Step 2: POST to /me/encounters with score embedded
  //     final submissionPayload = mlPayload;
  //     submissionPayload['hhs_score'] = hhs;
  //     submissionPayload['risk_category'] = category;
  //
  //     await _dio.post(
  //       '/me/encounters',
  //       data: submissionPayload,
  //     );
  //   } on DioException catch (e) {
  //     throw _handleDioError(e, 'Failed to submit assessment');
  //   }
  // }
  @override
  Future<void> submitAssessment(AssessmentDraft draft) async {
    try {
      final submissionPayload = draft.toSubmissionJson();

      await _dio.post(
        '/me/encounters',
        data: submissionPayload,
      );
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to submit assessment');
    }
  }
  /// Upload a report file (image or PDF).
  ///
  /// Uses multipart form data — already implemented in existing code.
  /// This is a stub that delegates to your existing upload logic.
  @override
  Future<UploadedReport> uploadReport({
    required String localPath,
    required String fileName,
    required ReportFileType type,
  }) async {
    // TODO: implement actual multipart upload to backend
    // For now, return a mock to keep the code compiling.
    await Future.delayed(const Duration(milliseconds: 600));
    final file = File(localPath);
    return UploadedReport(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      fileName: fileName,
      localPath: localPath,
      type: type,
      sizeBytes: await file.exists() ? await file.length() : 0,
      uploadedAt: DateTime.now(),
    );
  }

  /// Analyze ECG file via backend ML endpoint.
  @override
  Future<String> analyzeEcg(String localPath) async {
    try {
      // Send ECG file as multipart to backend
      final file = File(localPath);
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(localPath),
      });

      final response = await _dio.post('/ml/ecg-analyze', data: formData);
      final data = response.data as Map<String, dynamic>;
      return data['result'] as String? ?? 'Analysis complete';
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to analyze ECG');
    }
  }

  /// Delete a report (from backend storage).
  @override
  Future<void> deleteReport(String reportId) async {
    try {
      await _dio.delete('/me/reports/$reportId');
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to delete report');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Parse a backend field response {status, value, months_old} into a FieldValue.
  ///
  /// Backend format:
  /// ```json
  /// {
  ///   "status": "Available",
  ///   "value": 120,
  ///   "months_old": 0
  /// }
  /// ```
  FieldValue<T> _parseFieldValue<T>(
    dynamic fieldData, {
    T Function(dynamic)? parser,
  }) {
    if (fieldData == null) return const FieldValue();

    final field = fieldData as Map<String, dynamic>;
    final status = field['status'] as String? ?? 'Unknown';
    final rawValue = field['value'];
    final monthsOld = (field['months_old'] as num?)?.toInt();

    if (status != 'Available' || rawValue == null) {
      return const FieldValue();
    }

    // Parse value (handle type conversion)
    T? value;
    try {
      if (T == double) {
        value = (rawValue is double ? rawValue : (rawValue as num).toDouble()) as T;
      } else if (T == int) {
        value = (rawValue is int ? rawValue : (rawValue as num).toInt()) as T;
      } else if (T == bool) {
        value = (rawValue is bool ? rawValue : (rawValue as String).toLowerCase() == 'true') as T;
      } else if (T == String) {
        value = rawValue.toString() as T;
      } else if (parser != null) {
        value = parser(rawValue);
      }
    } catch (_) {
      // Parse failed — return empty
      return const FieldValue();
    }

    return FieldValue(
      value: value,
      monthsOld: monthsOld,
      available: true,
    );
  }

  /// Format DioException into a user-friendly error message.
  String _handleDioError(DioException e, String context) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final data = e.response!.data;
      String? message;
      if (data is Map) {
        message = data['message'] as String? ??
            data['detail']?.toString();
      }
      return '$context (HTTP $statusCode): ${message ?? data?.toString() ?? e.message}';
    }
    return '$context: ${e.message}';
  }
}
