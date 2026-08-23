import 'package:dio/dio.dart';

import 'package:heart_health_score/core/local/onboarding_status_store.dart';
import 'package:heart_health_score/core/network/token_storage.dart';
import 'package:heart_health_score/features/auth/domain/app_user.dart';
import 'package:heart_health_score/features/auth/domain/auth_exception.dart';
import 'package:heart_health_score/features/auth/domain/auth_repository.dart';

/// Real backend implementation, talking to `/api/v1/auth/*`.
///
/// Confirmed against the live Swagger + real request/response pairs run
/// against the dev server (not guessed from the schema placeholders):
///   POST /auth/login    {email, password} -> {access_token, refresh_token,
///                        token_type, expires_in, user: {...}}
///   POST /auth/register {name, email, password} -> same shape as login
///                        (name assumed from the field appearing verbatim
///                        in the register response — the raw request
///                        schema itself wasn't pasted, only the response)
///   GET  /auth/me        -> {user: {...}}
///   POST /auth/logout    -> revokes one session; the docs say it
///                        "succeeds even for an unknown token", so this
///                        is safe to call defensively
///
/// Token refresh on 401 is handled centrally by the Dio interceptor in
/// `core/network/api_client.dart`, not here — this repository only
/// issues/persists the *initial* session.
class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._dio, this._tokenStorage, this._onboardingStatusStore);

  final Dio _dio;
  final TokenStorage _tokenStorage;
  final OnboardingStatusStore _onboardingStatusStore;

  @override
  Future<AppUser> login({required String email, required String password}) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return _handleSession(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapError(e, fallback: 'Unable to sign in. Please try again.');
    }
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      return _handleSession(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapError(e, fallback: 'Unable to create your account. Please try again.');
    }
  }

  @override
  Future<void> logout() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    try {
      if (refreshToken != null) {
        // ASSUMPTION: body shape {"refresh_token": "..."}, matching the
        // pattern of /auth/refresh. Not independently confirmed. Wrapped
        // in try/catch below regardless, so a wrong shape here degrades
        // to "server-side session lingers until it expires" rather than
        // blocking local logout.
        await _dio.post('/auth/logout', data: {'refresh_token': refreshToken});
      }
    } catch (_) {
      // Best-effort per the interface contract — always clear locally.
    } finally {
      await _tokenStorage.clear();
      // Clearing this on logout matters: without it, a second person
      // signing in on the same device would inherit the previous
      // account's "onboarding complete" flag (see the class doc on
      // OnboardingStatusStore for the full limitation).
      await _onboardingStatusStore.clear();
    }
  }

  @override
  Future<AppUser?> restoreSession() async {
    if (!await _tokenStorage.hasSession()) return null;
    try {
      final response = await _dio.get('/auth/me');
      final data = response.data as Map<String, dynamic>;
      final user = AppUser.fromJson(data['user'] as Map<String, dynamic>);
      if (user.role != UserRole.patient) {
        await _tokenStorage.clear();
        return null;
      }
      // Bridges the gap until the backend exposes real onboarding
      // status — see OnboardingStatusStore's doc comment.
      final onboardingComplete = await _onboardingStatusStore.isComplete();
      return user.copyWith(onboardingComplete: onboardingComplete);
    } catch (_) {
      // Covers: refresh token also expired/revoked (interceptor already
      // cleared storage in that case), or /auth/me itself failing for
      // some other reason. Either way, no valid session to restore.
      await _tokenStorage.clear();
      return null;
    }
  }

  Future<AppUser> _handleSession(Map<String, dynamic> data) async {
    final user = AppUser.fromJson(data['user'] as Map<String, dynamic>);

    // This client is patient-only. Roles table (Swagger) shows
    // admin/clinician/staff exist and can authenticate, but they belong
    // on the web dashboard, not this app — reject before persisting any
    // token for them.
    // ASSUMPTION (flagged for confirmation): this app should refuse
    // non-patient logins outright rather than showing a degraded UI.
    if (user.role != UserRole.patient) {
      throw const AuthException(
        'This app is for patient accounts. Please use the clinical web dashboard to sign in.',
      );
    }

    await _tokenStorage.saveSession(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
      expiresIn: data['expires_in'] as int,
    );
    return user;
  }

  /// Maps the backend's error shape to a user-presentable [AuthException].
  ///
  /// The `detail` field is inconsistent between validation errors (a List
  /// of {loc, msg, type, ...}) and some other errors (a plain String) —
  /// confirmed by observing both shapes from the live server. Handling
  /// both defensively rather than assuming one.
  AuthException _mapError(DioException e, {required String fallback}) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    String? detailMessage;
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      if (detail is String) {
        detailMessage = detail;
      } else if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map<String, dynamic> && first['msg'] is String) {
          detailMessage = first['msg'] as String;
        }
      }
    }

    switch (status) {
      case 401:
        return AuthException(detailMessage ?? 'Incorrect email or password.');
      case 403:
        return AuthException(detailMessage ?? 'This account has been deactivated.');
      case 409:
        return AuthException(detailMessage ?? 'An account already exists for that email.');
      case 422:
        return AuthException(detailMessage ?? 'Please check the details you entered.');
      default:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionError) {
          return const AuthException(
            'Cannot reach the server. Check your connection and try again.',
          );
        }
        return AuthException(detailMessage ?? fallback);
    }
  }
}
