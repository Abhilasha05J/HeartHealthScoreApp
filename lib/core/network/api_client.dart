import 'package:dio/dio.dart';

import 'api_config.dart';
import 'token_storage.dart';

/// Builds the single shared [Dio] instance for the app.
///
/// Only files under `lib/features/*/data/` and this file should ever
/// import `dio` — see SKILL.md section 7. Screens/controllers depend on
/// repository interfaces, never on Dio directly.
class ApiClient {
  ApiClient(TokenStorage tokenStorage)
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: ApiConfig.connectTimeout,
            receiveTimeout: ApiConfig.receiveTimeout,
            contentType: 'application/json',
          ),
        ) {
    dio.interceptors.add(_AuthInterceptor(dio, tokenStorage));
  }

  final Dio dio;
}

/// Attaches the bearer access token to every request except the
/// unauthenticated auth endpoints, and transparently refreshes on a 401
/// per the backend contract: "Access tokens are short-lived (30 min
/// default). When one expires the API returns 401; exchange the refresh
/// token at POST /auth/refresh for a new pair. Refresh tokens rotate —
/// redeeming one revokes it."
///
/// ASSUMPTION (unconfirmed): the refresh request body is
/// `{"refresh_token": "..."}`. This was not shown in the pasted Swagger
/// schema (only the Example Value placeholder was visible). If the real
/// field name differs, /auth/refresh will 422 and [_doRefresh] will
/// return false, which correctly signs the user out rather than looping
/// — but confirm the real field name against Swagger's Schema tab to
/// avoid unnecessary forced sign-outs once real users hit token expiry.
class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._dio, this._tokenStorage);

  final Dio _dio;
  final TokenStorage _tokenStorage;

  // In-flight refresh, shared across concurrent 401s so simultaneous
  // requests don't each try to redeem the (single-use, rotating) refresh
  // token and race each other into invalidating it.
  Future<bool>? _refreshFuture;

  static const _unauthenticatedPaths = [
    '/auth/login',
    '/auth/register',
    '/auth/refresh',
  ];

  bool _isUnauthenticatedPath(String path) =>
      _unauthenticatedPaths.any((p) => path.contains(p));

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isUnauthenticatedPath(options.path)) {
      final token = await _tokenStorage.readAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isAuthCall = _isUnauthenticatedPath(err.requestOptions.path);

    if (err.response?.statusCode == 401 && !isAuthCall) {
      final refreshed = await _refresh();
      if (refreshed) {
        try {
          final newToken = await _tokenStorage.readAccessToken();
          final retryOptions = err.requestOptions
            ..headers['Authorization'] = 'Bearer $newToken';
          final response = await _dio.fetch(retryOptions);
          return handler.resolve(response);
        } catch (_) {
          // Retry itself failed — fall through and surface the original
          // error rather than masking it with a second failure.
        }
      } else {
        // Refresh token invalid/expired/already used — session is dead.
        // Clearing storage here (rather than only in the repository)
        // means ANY authenticated call failing this way ends the
        // session, not just ones that happen to go through
        // ApiAuthRepository.
        await _tokenStorage.clear();
      }
    }
    handler.next(err);
  }

  Future<bool> _refresh() {
    // Reuse an in-flight refresh instead of starting a second one.
    return _refreshFuture ??= _doRefresh().whenComplete(() {
      _refreshFuture = null;
    });
  }

  Future<bool> _doRefresh() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null) return false;

    try {
      // Deliberately a bare Dio call, not `_dio` — going through `_dio`
      // would re-enter this same interceptor.
      final response = await Dio(
        BaseOptions(baseUrl: ApiConfig.baseUrl),
      ).post('/auth/refresh', data: {'refresh_token': refreshToken});

      final data = response.data as Map<String, dynamic>;
      await _tokenStorage.saveSession(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
        expiresIn: data['expires_in'] as int,
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
