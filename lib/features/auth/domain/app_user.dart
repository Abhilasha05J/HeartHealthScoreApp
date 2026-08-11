import 'package:equatable/equatable.dart';

/// Authenticated user entity. Kept intentionally minimal — extend once
/// the backend's user profile contract is known.
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.accessToken,
    this.onboardingComplete = false,
  });

  final String id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? accessToken;
  final bool onboardingComplete;

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? accessToken,
    bool? onboardingComplete,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      accessToken: accessToken ?? this.accessToken,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phoneNumber, accessToken, onboardingComplete];
}
