
import 'package:heart_health_score/features/auth/domain/app_user.dart';
import 'package:heart_health_score/features/auth/domain/auth_exception.dart';
import 'package:heart_health_score/features/auth/domain/auth_repository.dart';

/// Kept alive (updated to the new email/password interface) for local
/// development without a network connection, and for widget tests that
/// shouldn't depend on a live server. Not used by default anymore —
/// `auth_providers.dart` now points [authRepositoryProvider] at
/// [ApiAuthRepository]. Swap it back here temporarily if the backend is
/// unreachable and you need to keep working on unrelated screens.
class MockAuthRepository implements AuthRepository {
  AppUser? _session;

  @override
  Future<AppUser> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (password.length < 8) {
      throw const AuthException('Incorrect email or password.');
    }
    final user = AppUser(
      id: 'mock-user-$email',
      email: email,
      name: 'Mock User',
      role: UserRole.patient,
      patientId: 'HHS-MOCK-0001',
    );
    _session = user;
    return user;
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (password.length < 8) {
      throw const AuthException('String should have at least 8 characters');
    }
    final user = AppUser(
      id: 'mock-user-$email',
      email: email,
      name: name,
      role: UserRole.patient,
      patientId: 'HHS-MOCK-0001',
    );
    _session = user;
    return user;
  }

  @override
  Future<void> logout() async {
    _session = null;
  }

  @override
  Future<AppUser?> restoreSession() async => _session;
}
