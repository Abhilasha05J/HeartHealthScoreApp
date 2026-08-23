import 'package:heart_health_score/features/auth/domain/app_user.dart';
import 'package:heart_health_score/features/profile/domain/profile_data.dart';
import 'package:heart_health_score/features/profile/domain/profile_repository.dart';
import 'package:heart_health_score/core/local/profile_local_store.dart';

/// "Real" in the sense that [fullName]/[email] are genuinely sourced from
/// the signed-in account rather than mock data — but [updateProfile] can
/// only persist the fields the backend actually has a home for, which
/// right now is none of them. See `ProfileLocalStore`'s doc comment.
///
/// [currentUser] is a getter (not a one-time value) so this always reads
/// the latest cached `AppUser`, the same pattern used by
/// `ApiOnboardingRepository.userEmail`.
class ApiProfileRepository implements ProfileRepository {
  ApiProfileRepository(this._localStore, {required this.currentUser});

  final ProfileLocalStore _localStore;
  final AppUser? Function() currentUser;

  @override
  Future<UserProfile> fetchProfile() async {
    final user = currentUser();
    final local = await _localStore.load();

    return UserProfile(
      fullName: user?.name ?? '',
      email: user?.email ?? '',
      heightCm: local['heightCm'] as int?,
      weightKg: local['weightKg'] as int?,
      dailyCalories: local['dailyCalories'] as int?,
      proteinTargetG: local['proteinTargetG'] as int?,
    );
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    // Deliberately does NOT attempt to persist fullName/email anywhere —
    // there is no PATCH /me (or equivalent) endpoint for a patient to
    // edit their own account. Whatever the form fields currently show
    // for name/email is discarded here; only the locally-backed fields
    // are saved. The screen keeps those two fields disabled so this
    // isn't a surprise to the user (see profile_screen.dart).
    await _localStore.save(
      heightCm: profile.heightCm,
      weightKg: profile.weightKg,
      dailyCalories: profile.dailyCalories,
      proteinTargetG: profile.proteinTargetG,
    );
    // Re-fetch rather than trust the passed-in `profile` for name/email,
    // so the return value can't drift from the actual account.
    return fetchProfile();
  }
}
