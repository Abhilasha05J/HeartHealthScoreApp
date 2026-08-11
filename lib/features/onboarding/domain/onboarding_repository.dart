import 'onboarding_data.dart';

/// Contract for submitting the completed onboarding payload to the
/// backend (which will forward relevant fields to the ML scoring model).
abstract class OnboardingRepository {
  Future<void> submitOnboarding(OnboardingData data);
}
