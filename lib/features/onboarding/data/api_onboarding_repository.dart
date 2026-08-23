import 'package:dio/dio.dart';

import 'package:heart_health_score/features/onboarding/domain/onboarding_data.dart';
import 'package:heart_health_score/features/onboarding/domain/onboarding_exception.dart';
import 'package:heart_health_score/features/onboarding/domain/onboarding_repository.dart';

/// Real backend implementation — `POST /api/v1/me/encounters`.
///
/// Confirmed against the live `/intake/schema` response and a real 200
/// submission (not guessed): the endpoint "scores and saves" synchronously,
/// returning `{status, patient_id, visit_id, encounter_id, timestamp,
/// assessment: {...}}` in one call. This repository currently discards
/// that response and just reports success/failure — see the TODO below for
/// the natural follow-up.
class ApiOnboardingRepository implements OnboardingRepository {
  ApiOnboardingRepository(this._dio, {required this.userEmail});

  final Dio _dio;

  /// The signed-in user's email, threaded in from `AppUser` (via the
  /// provider) since `OnboardingData` itself has no concept of the
  /// account — only what the wizard collected.
  final String? Function() userEmail;

  @override
  Future<void> submitOnboarding(OnboardingData data) async {
    try {
      // TODO(dashboard-integration): the response here is the SAME
      // assessment shape /me/dashboard returns (hhs, category, burden,
      // domain_rows, ...) — once Home's dashboard repository exists for
      // real, consider changing this method to return that assessment
      // directly so the app can show the just-computed score right after
      // "Complete Setup" instead of a separate fetch. Deliberately not
      // doing that now — it's a Home/dashboard-feature decision, not an
      // onboarding one.
      await _dio.post(
        '/me/encounters',
        data: data.toSubmissionJson(email: userEmail()),
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  OnboardingException _mapError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    String? detailMessage;
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      if (detail is String) {
        detailMessage = detail;
      } else if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map<String, dynamic> && first['msg'] is String) {
          detailMessage = first['msg'] as String;
        }
      }
    }

    switch (status) {
      case 422:
        return OnboardingException(
          detailMessage ?? 'Some of the entered values look invalid. Please check and try again.',
        );
      case 409:
        // Same-day resubmission without allow_duplicate_visit:true — see
        // the note on OnboardingData.toSubmissionJson.
        return const OnboardingException(
          "You've already recorded an entry today. Please try again tomorrow.",
        );
      default:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionError) {
          return const OnboardingException(
            'Cannot reach the server. Check your connection and try again.',
          );
        }
        return OnboardingException(detailMessage ?? 'Something went wrong. Please try again.');
    }
  }
}
