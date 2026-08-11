import 'app_user.dart';

/// Contract the Auth feature depends on. Presentation/state layers never
/// talk to Dio/HTTP directly — they depend on this interface, which keeps
/// the UI fully decoupled from *how* auth is implemented (OOP:
/// dependency inversion). Swap [MockAuthRepository] for a real
/// [ApiAuthRepository] once backend endpoints are available — nothing
/// above this layer needs to change.
abstract class AuthRepository {
  /// Sends an OTP to [phoneNumber] (E.164 or local number, country code
  /// handled separately). Returns a requestId/session token some backends
  /// require to verify the OTP later.
  Future<String> sendOtp({required String phoneNumber});

  /// Verifies the OTP for a previously requested [phoneNumber]/[requestId].
  /// Returns the authenticated user on success.
  Future<AppUser> verifyOtp({
    required String phoneNumber,
    required String otp,
    String? requestId,
  });

  /// Email/mobile + password login.
  Future<AppUser> loginWithPassword({
    required String identifier, // email or mobile number
    required String password,
  });

  /// Google OAuth sign-in. [idToken] is the token obtained from the
  /// google_sign_in package once it's wired up.
  Future<AppUser> loginWithGoogle({required String idToken});

  Future<void> logout();

  /// Restores a persisted session on app start, if any.
  Future<AppUser?> restoreSession();
}
