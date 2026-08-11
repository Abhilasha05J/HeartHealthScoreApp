import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_onboarding_repository.dart';
import '../domain/onboarding_data.dart';
import '../domain/onboarding_repository.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return MockOnboardingRepository();
});

/// Tracks whether the final "Complete Setup" submission is in flight,
/// kept separate from [OnboardingData] since it's transient UI state,
/// not part of the draft payload.
final onboardingSubmittingProvider = StateProvider<bool>((ref) => false);

/// Single StateNotifier holds the in-progress onboarding draft across
/// all three screens (Profile Setup -> Daily Activity -> Basic Vitals)
/// so nothing is lost when the user navigates back and forth.
class OnboardingController extends StateNotifier<OnboardingData> {
  OnboardingController(this._ref, this._repository) : super(const OnboardingData());

  final Ref _ref;
  final OnboardingRepository _repository;

  void updateProfile({
    String? fullName,
    BiologicalSex? sex,
    int? age,
    double? weightKg,
    double? heightCm,
  }) {
    state = state.copyWith(
      fullName: fullName,
      sex: sex,
      age: age,
      weightKg: weightKg,
      heightCm: heightCm,
    );
  }

  void updateDailyActivity({
    SleepBand? sleepBand,
    double? customSleepHours,
    ActivityBand? activityBand,
    double? customActivityHours,
  }) {
    state = state.copyWith(
      sleepBand: sleepBand,
      customSleepHours: customSleepHours,
      activityBand: activityBand,
      customActivityHours: customActivityHours,
    );
  }

  void updateVitals({int? systolic, int? diastolic, int? restingHeartRate}) {
    state = state.copyWith(
      systolic: systolic,
      diastolic: diastolic,
      restingHeartRate: restingHeartRate,
    );
  }

  Future<bool> completeSetup() async {
    _ref.read(onboardingSubmittingProvider.notifier).state = true;
    try {
      await _repository.submitOnboarding(state);
      return true;
    } finally {
      _ref.read(onboardingSubmittingProvider.notifier).state = false;
    }
  }

  void reset() => state = const OnboardingData();
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingData>((ref) {
  return OnboardingController(ref, ref.watch(onboardingRepositoryProvider));
});
