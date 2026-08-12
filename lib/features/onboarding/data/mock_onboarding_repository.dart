import 'package:heart_health_score/features/onboarding/domain/onboarding_data.dart';
import 'package:heart_health_score/features/onboarding/domain/onboarding_repository.dart';

/// TEMPORARY mock — always succeeds after a simulated network delay.
///
/// TODO(backend-integration): Replace with an implementation that POSTs
/// `data.toJson()` to the onboarding/profile endpoint, e.g.:
///
///   class ApiOnboardingRepository implements OnboardingRepository {
///     ApiOnboardingRepository(this._dio);
///     final Dio _dio;
///
///     @override
///     Future<void> submitOnboarding(OnboardingData data) async {
///       await _dio.post('/users/me/profile', data: data.toJson());
///     }
///   }
class MockOnboardingRepository implements OnboardingRepository {
  @override
  Future<void> submitOnboarding(OnboardingData data) async {
    await Future.delayed(const Duration(milliseconds: 900));
    // ignore: avoid_print
    print('[MOCK] Onboarding submitted: ${data.toJson()}');
  }
}
