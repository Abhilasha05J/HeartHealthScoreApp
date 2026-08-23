import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heart_health_score/core/local/onboarding_status_store.dart';
import 'package:heart_health_score/core/network/api_client.dart';
import 'package:heart_health_score/core/network/token_storage.dart';
import 'package:heart_health_score/features/auth/data/api_auth_repository.dart';
import 'package:heart_health_score/features/auth/domain/app_user.dart';
import 'package:heart_health_score/features/auth/domain/auth_repository.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final dioProvider = Provider<Dio>((ref) {
  return ApiClient(ref.watch(tokenStorageProvider)).dio;
});

/// Repository provider — the ONLY line to change to develop offline
/// (swap `ApiAuthRepository(...)` for `MockAuthRepository()`).
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ApiAuthRepository(
    ref.watch(dioProvider),
    ref.watch(tokenStorageProvider),
    ref.watch(onboardingStatusStoreProvider),
  );
});

/// Holds the currently authenticated user (or null when signed out).
final currentUserProvider = StateProvider<AppUser?>((ref) => null);

enum AuthTab { login, signup }

/// Which tab (Login / Sign Up) is active on the Auth screen.
/// CHANGED default from `signup` to `login`: with the OTP flow gone,
/// "signup by default" no longer serves a demo purpose — most opens of
/// this screen are an existing user signing back in. Flag if you'd
/// rather keep signup as the default tab.
final authTabProvider = StateProvider<AuthTab>((ref) => AuthTab.login);

/// Drives the email/password + name sign-up form's submitting/error
/// state. Replaces the old OTP-based `OtpSignupState`/`OtpSignupController`
/// — the backend has no phone/OTP endpoint, only `/auth/register`.
class SignupState {
  const SignupState({this.isSubmitting = false, this.errorMessage});

  final bool isSubmitting;
  final String? errorMessage;

  SignupState copyWith({bool? isSubmitting, String? errorMessage}) {
    return SignupState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

class SignupController extends StateNotifier<SignupState> {
  SignupController(this._repository) : super(const SignupState());

  final AuthRepository _repository;

  Future<AppUser?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final user = await _repository.register(name: name, email: email, password: password);
      state = state.copyWith(isSubmitting: false);
      return user;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return null;
    }
  }
}

final signupControllerProvider = StateNotifierProvider<SignupController, SignupState>((ref) {
  return SignupController(ref.watch(authRepositoryProvider));
});

/// Drives the email/password login flow's submitting/error state.
/// CHANGED: `loginWithGoogle` removed — no OAuth endpoint exists on the
/// backend (confirmed against the live OpenAPI spec).
class LoginState {
  const LoginState({this.isSubmitting = false, this.errorMessage});

  final bool isSubmitting;
  final String? errorMessage;

  LoginState copyWith({bool? isSubmitting, String? errorMessage}) {
    return LoginState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

class LoginController extends StateNotifier<LoginState> {
  LoginController(this._repository) : super(const LoginState());

  final AuthRepository _repository;

  Future<AppUser?> login(String email, String password) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final user = await _repository.login(email: email, password: password);
      state = state.copyWith(isSubmitting: false);
      return user;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return null;
    }
  }
}

final loginControllerProvider = StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController(ref.watch(authRepositoryProvider));
});
