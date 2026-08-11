import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_auth_repository.dart';
import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

/// Repository provider — the ONLY line to change when the backend is
/// ready (swap MockAuthRepository() for ApiAuthRepository(dio)).
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});

/// Holds the currently authenticated user (or null when signed out).
final currentUserProvider = StateProvider<AppUser?>((ref) => null);

enum AuthTab { login, signup }

/// Which tab (Login / Sign Up) is active on the Auth screen.
final authTabProvider = StateProvider<AuthTab>((ref) => AuthTab.signup);

/// Drives the OTP sign-up flow's UI state (has OTP been sent yet?).
class OtpSignupState {
  const OtpSignupState({
    this.otpSent = false,
    this.isSubmitting = false,
    this.requestId,
    this.errorMessage,
  });

  final bool otpSent;
  final bool isSubmitting;
  final String? requestId;
  final String? errorMessage;

  OtpSignupState copyWith({
    bool? otpSent,
    bool? isSubmitting,
    String? requestId,
    String? errorMessage,
  }) {
    return OtpSignupState(
      otpSent: otpSent ?? this.otpSent,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      requestId: requestId ?? this.requestId,
      errorMessage: errorMessage,
    );
  }
}

class OtpSignupController extends StateNotifier<OtpSignupState> {
  OtpSignupController(this._repository) : super(const OtpSignupState());

  final AuthRepository _repository;

  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final requestId = await _repository.sendOtp(phoneNumber: phoneNumber);
      state = state.copyWith(isSubmitting: false, otpSent: true, requestId: requestId);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
    }
  }

  Future<AppUser?> verifyOtp(String phoneNumber, String otp) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final user = await _repository.verifyOtp(
        phoneNumber: phoneNumber,
        otp: otp,
        requestId: state.requestId,
      );
      state = state.copyWith(isSubmitting: false);
      return user;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return null;
    }
  }

  void reset() => state = const OtpSignupState();
}

final otpSignupControllerProvider =
    StateNotifierProvider<OtpSignupController, OtpSignupState>((ref) {
  return OtpSignupController(ref.watch(authRepositoryProvider));
});

/// Drives the email/password + Google login flow's submitting/error state.
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

  Future<AppUser?> loginWithPassword(String identifier, String password) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final user = await _repository.loginWithPassword(
        identifier: identifier,
        password: password,
      );
      state = state.copyWith(isSubmitting: false);
      return user;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return null;
    }
  }

  Future<AppUser?> loginWithGoogle() async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      // TODO(backend-integration): obtain a real idToken via the
      // google_sign_in package, then pass it through here.
      final user = await _repository.loginWithGoogle(idToken: 'mock-id-token');
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
