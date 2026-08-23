import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the auth token pair in secure storage (Keychain on iOS,
/// EncryptedSharedPreferences on Android) — never `shared_preferences`,
/// per SKILL.md 6.6.
///
/// This is the ONLY place that reads/writes tokens. Repositories and
/// interceptors go through this class; nothing else should touch
/// flutter_secure_storage directly.
class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'hhs_access_token';
  static const _refreshTokenKey = 'hhs_refresh_token';
  static const _expiresAtKey = 'hhs_expires_at';

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) async {
    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
      _storage.write(key: _expiresAtKey, value: expiresAt.toIso8601String()),
    ]);
  }

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  /// Not currently used for proactive refresh — the mail from the backend
  /// dev specifically says "refresh on a 401", so [ApiAuthInterceptor]
  /// refreshes reactively. Kept here so a future proactive-refresh pass
  /// (refresh a few seconds before expiry, avoiding a guaranteed failed
  /// request on every session) doesn't need a storage-layer change.
  Future<DateTime?> readExpiresAt() async {
    final raw = await _storage.read(key: _expiresAtKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  Future<bool> hasSession() async => (await readRefreshToken()) != null;

  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _expiresAtKey),
    ]);
  }
}
