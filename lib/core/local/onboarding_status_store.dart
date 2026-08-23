import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// TEMPORARY STOPGAP — not a substitute for a real backend signal.
///
/// The backend has no "has this patient completed onboarding" field
/// anywhere in its contract yet (confirmed against /auth/* and
/// /me/dashboard — nothing addresses it). Without *some* persisted
/// signal, every `restoreSession()` on app relaunch has no way to know
/// whether onboarding was already done, and Splash correctly (per its
/// own routing rule) sends the user back through Profile Setup every
/// single time — which is the bug you just hit.
///
/// This stores a plain local boolean via shared_preferences (not secure
/// storage — it's not sensitive, just a UI-routing hint) and is read by
/// [ApiAuthRepository.restoreSession] to populate [AppUser.onboardingComplete].
///
/// KNOWN LIMITATIONS, both acceptable for now, worth knowing about:
/// - It's device-local. Reinstall the app, or sign in on a second
///   device, and onboarding will show again even though the account
///   completed it elsewhere. Only a real backend field fixes this.
/// - It's cleared on logout (see ApiAuthRepository.logout), so switching
///   accounts on one device behaves correctly as long as logout is used.
///   A forced sign-out from a dead refresh token does NOT clear it —
///   deliberately, since that's still the same user, just needing to
///   log back in — but if that ever becomes a real multi-user-per-device
///   scenario, revisit this.
///
/// Replace this whole file's role once the backend adds a real signal
/// (e.g. a `profile_completed` field on `/auth/me`, or inferring it from
/// whether `/me/dashboard` returns data) — at that point,
/// `ApiAuthRepository.restoreSession` should read from there instead,
/// and this becomes unnecessary.
class OnboardingStatusStore {
  static const _key = 'hhs_onboarding_complete_local';

  Future<bool> isComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  Future<void> markComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

final onboardingStatusStoreProvider = Provider<OnboardingStatusStore>((ref) {
  return OnboardingStatusStore();
});
