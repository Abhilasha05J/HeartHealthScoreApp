// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:heart_health_score/core/local/onboarding_status_store.dart';
// import 'package:heart_health_score/features/auth/application/auth_providers.dart';
// import 'package:heart_health_score/features/onboarding/data/mock_onboarding_repository.dart';
// import 'package:heart_health_score/features/onboarding/domain/onboarding_data.dart';
// import 'package:heart_health_score/features/onboarding/domain/onboarding_repository.dart';
//
// final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
//   return MockOnboardingRepository();
// });
//
// /// Tracks whether the final "Complete Setup" submission is in flight,
// /// kept separate from [OnboardingData] since it's transient UI state,
// /// not part of the draft payload.
// final onboardingSubmittingProvider = StateProvider<bool>((ref) => false);
//
// /// Single StateNotifier holds the in-progress onboarding draft across
// /// all three screens (Profile Setup -> Daily Activity -> Basic Vitals)
// /// so nothing is lost when the user navigates back and forth.
// class OnboardingController extends StateNotifier<OnboardingData> {
//   OnboardingController(this._ref, this._repository) : super(const OnboardingData());
//
//   final Ref _ref;
//   final OnboardingRepository _repository;
//
//   void updateProfile({
//     String? fullName,
//     BiologicalSex? sex,
//     int? age,
//     double? weightKg,
//     double? heightCm,
//   }) {
//     state = state.copyWith(
//       fullName: fullName,
//       sex: sex,
//       age: age,
//       weightKg: weightKg,
//       heightCm: heightCm,
//     );
//   }
//
//   void updateDailyActivity({
//     SleepBand? sleepBand,
//     double? customSleepHours,
//     ActivityBand? activityBand,
//     double? customActivityHours,
//   }) {
//     state = state.copyWith(
//       sleepBand: sleepBand,
//       customSleepHours: customSleepHours,
//       activityBand: activityBand,
//       customActivityHours: customActivityHours,
//     );
//   }
//
//   void updateVitals({int? systolic, int? diastolic, int? restingHeartRate}) {
//     state = state.copyWith(
//       systolic: systolic,
//       diastolic: diastolic,
//       restingHeartRate: restingHeartRate,
//     );
//   }
//
//   Future<bool> completeSetup() async {
//     _ref.read(onboardingSubmittingProvider.notifier).state = true;
//     try {
//       await _repository.submitOnboarding(state);
//
//       // STOPGAP (see OnboardingStatusStore doc comment): the backend has
//       // no onboarding-status field yet, so this local flag is what
//       // restoreSession() checks on the next app launch. Without this
//       // line, completing setup would still send you back through
//       // Profile Setup every time you reopen the app — the exact bug
//       // this fixes.
//       await _ref.read(onboardingStatusStoreProvider).markComplete();
//       final currentUser = _ref.read(currentUserProvider);
//       if (currentUser != null) {
//         _ref.read(currentUserProvider.notifier).state =
//             currentUser.copyWith(onboardingComplete: true);
//       }
//
//       return true;
//     } finally {
//       _ref.read(onboardingSubmittingProvider.notifier).state = false;
//     }
//   }
//
//   void reset() => state = const OnboardingData();
// }
//
// final onboardingControllerProvider =
//     StateNotifierProvider<OnboardingController, OnboardingData>((ref) {
//   return OnboardingController(ref, ref.watch(onboardingRepositoryProvider));
// });
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heart_health_score/core/local/onboarding_status_store.dart';
import 'package:heart_health_score/features/auth/application/auth_providers.dart';
import 'package:heart_health_score/features/onboarding/data/api_onboarding_repository.dart';
import 'package:heart_health_score/features/onboarding/domain/onboarding_data.dart';
import 'package:heart_health_score/features/onboarding/domain/onboarding_repository.dart';

/// Repository provider — the ONLY line to change to develop offline
/// (swap for `MockOnboardingRepository()` from
/// `features/onboarding/data/mock_onboarding_repository.dart`).
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return ApiOnboardingRepository(
    ref.watch(dioProvider),
    userEmail: () => ref.read(currentUserProvider)?.email,
  );
});

/// Tracks whether the final "Complete Setup" submission is in flight,
/// kept separate from [OnboardingData] since it's transient UI state,
/// not part of the draft payload.
final onboardingSubmittingProvider = StateProvider<bool>((ref) => false);

/// Set when [OnboardingController.completeSetup] fails — holds a
/// user-presentable message (from [OnboardingException.toString], or a
/// generic fallback for anything unexpected). Null when there's no error
/// to show.
final onboardingErrorProvider = StateProvider<String?>((ref) => null);

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
    _ref.read(onboardingErrorProvider.notifier).state = null;
    try {
      await _repository.submitOnboarding(state);

      // STOPGAP (see OnboardingStatusStore doc comment): the backend has
      // no onboarding-status field yet, so this local flag is what
      // restoreSession() checks on the next app launch. Without this
      // line, completing setup would still send you back through
      // Profile Setup every time you reopen the app — the exact bug
      // this fixes.
      await _ref.read(onboardingStatusStoreProvider).markComplete();
      final currentUser = _ref.read(currentUserProvider);
      if (currentUser != null) {
        _ref.read(currentUserProvider.notifier).state =
            currentUser.copyWith(onboardingComplete: true);
      }

      return true;
    } catch (e) {
      // Previously uncaught — with the mock this path never ran (it never
      // throws), but ApiOnboardingRepository does (422 on invalid values,
      // 409 on same-day duplicate, network errors). Without this catch,
      // completeSetup() would throw instead of returning false, and the
      // screen's `if (success) {...} else {...}` branch would never run.
      _ref.read(onboardingErrorProvider.notifier).state = e.toString();
      return false;
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