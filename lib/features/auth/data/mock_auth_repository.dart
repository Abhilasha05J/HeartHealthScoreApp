import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

/// TEMPORARY mock implementation used while the backend is not yet wired
/// up (per project status: "no backend access yet").
///
/// Every call simulates network latency and always succeeds so the full
/// UI flow (Auth -> Onboarding -> Home) can be exercised end-to-end.
///
/// --------------------------------------------------------------------
/// TODO(backend-integration): Replace with `ApiAuthRepository` that
/// calls the real endpoints via Dio, e.g.:
///
///   class ApiAuthRepository implements AuthRepository {
///     ApiAuthRepository(this._dio);
///     final Dio _dio;
///
///     @override
///     Future<String> sendOtp({required String phoneNumber}) async {
///       final res = await _dio.post('/auth/otp/send', data: {
///         'phoneNumber': phoneNumber,
///       });
///       return res.data['requestId'] as String;
///     }
///     ...
///   }
///
/// Then flip the provider override in `auth_providers.dart` from
/// `MockAuthRepository()` to `ApiAuthRepository(dio)`. No other file
/// needs to change because every consumer depends on [AuthRepository].
/// --------------------------------------------------------------------
class MockAuthRepository implements AuthRepository {
  AppUser? _session;

  @override
  Future<String> sendOtp({required String phoneNumber}) async {
    await Future.delayed(const Duration(milliseconds: 900));
    // TODO(backend-integration): return real requestId from backend.
    return 'mock-request-id';
  }

  @override
  Future<AppUser> verifyOtp({
    required String phoneNumber,
    required String otp,
    String? requestId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final user = AppUser(
      id: 'mock-user-$phoneNumber',
      phoneNumber: phoneNumber,
      accessToken: 'mock-access-token',
    );
    _session = user;
    return user;
  }

  @override
  Future<AppUser> loginWithPassword({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final user = AppUser(
      id: 'mock-user-$identifier',
      email: identifier.contains('@') ? identifier : null,
      phoneNumber: identifier.contains('@') ? null : identifier,
      accessToken: 'mock-access-token',
    );
    _session = user;
    return user;
  }

  @override
  Future<AppUser> loginWithGoogle({required String idToken}) async {
    await Future.delayed(const Duration(milliseconds: 900));
    final user = AppUser(
      id: 'mock-google-user',
      email: 'user@gmail.com',
      accessToken: 'mock-access-token',
    );
    _session = user;
    return user;
  }

  @override
  Future<void> logout() async {
    _session = null;
  }

  @override
  Future<AppUser?> restoreSession() async {
    // TODO(backend-integration): read persisted token from
    // shared_preferences / secure storage and validate/refresh it.
    return null;
  }
}
