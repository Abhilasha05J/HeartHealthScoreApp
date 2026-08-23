/// Onboarding-submission failure with a message already safe to show the
/// user. Same pattern as `features/auth/domain/auth_exception.dart`.
class OnboardingException implements Exception {
  const OnboardingException(this.message);

  final String message;

  @override
  String toString() => message;
}
