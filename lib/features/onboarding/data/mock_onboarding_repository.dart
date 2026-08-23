import 'package:heart_health_score/features/onboarding/domain/onboarding_data.dart';
import 'package:heart_health_score/features/onboarding/domain/onboarding_repository.dart';

/// Kept for local development without a network connection / widget
/// tests — not used by default anymore. `onboarding_providers.dart` now
/// points [onboardingRepositoryProvider] at `ApiOnboardingRepository`,
/// which posts to the real `POST /me/encounters`. Swap back here
/// temporarily if the backend is unreachable and you need to keep
/// working on unrelated screens.
class MockOnboardingRepository implements OnboardingRepository {
  @override
  Future<void> submitOnboarding(OnboardingData data) async {
    await Future.delayed(const Duration(milliseconds: 900));
    // ignore: avoid_print
    print('[MOCK] Onboarding submitted: ${data.toSubmissionJson()}');
  }
}