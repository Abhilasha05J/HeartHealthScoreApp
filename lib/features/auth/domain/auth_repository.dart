
import 'app_user.dart';

/// Contract the Auth feature depends on. Presentation/state layers never
/// talk to Dio/HTTP directly — they depend on this interface, so swapping
/// [ApiAuthRepository] back for a mock (e.g. to develop without backend
/// access) is a one-line provider override, nothing else changes.
///
/// CHANGED from the mock-era version: the backend has no phone/OTP
/// signup endpoint and no Google OAuth endpoint (confirmed against the
/// live OpenAPI spec — only email+password `/auth/register` exists).
/// `sendOtp`/`verifyOtp`/`loginWithGoogle` are removed rather than kept
/// as unimplemented stubs, since a stale interface method is worse than
/// no method — it invites someone to wire up a button against it later
/// without noticing there's no backend behind it.
abstract class AuthRepository {
  /// Email + password login. Throws [AuthException] with a
  /// user-presentable message on failure (wrong credentials, deactivated
  /// account, network error, etc).
  Future<AppUser> login({required String email, required String password});

  /// Self-serve patient registration. The backend returns a signed-in
  /// session directly (no separate login call needed after this
  /// succeeds). Throws [AuthException] on failure (e.g. email already
  /// registered, password too short).
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  });

  /// Revokes the current session. Best-effort against the backend —
  /// always clears the local session even if the network call fails, so
  /// the user is never stuck "logged in" locally after tapping logout.
  Future<void> logout();

  /// Restores a persisted session on app start, if any. Returns null if
  /// there's no stored session, or if the stored session is no longer
  /// valid (refresh token expired/revoked).
  Future<AppUser?> restoreSession();
}
