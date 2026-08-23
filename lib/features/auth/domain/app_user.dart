
import 'package:equatable/equatable.dart';

/// Matches the `role` string returned by the backend
/// (admin / clinician / staff / patient — see Swagger's Roles table).
/// This client only ever expects [patient]; the others are handled as
/// an explicit rejection at the repository layer (see
/// ApiAuthRepository._handleSession).
enum UserRole { patient, clinician, admin, staff, unknown }

UserRole userRoleFromString(String? value) {
  switch (value) {
    case 'patient':
      return UserRole.patient;
    case 'clinician':
      return UserRole.clinician;
    case 'admin':
      return UserRole.admin;
    case 'staff':
      return UserRole.staff;
    default:
      return UserRole.unknown;
  }
}

/// Authenticated user entity, mapped from the `user` object returned by
/// `/auth/login`, `/auth/register`, `/auth/refresh`, and `/auth/me`.
///
/// Deliberately does NOT hold the access/refresh tokens — those live only
/// in [TokenStorage] (secure storage), never in app state or widget
/// memory, and are attached to requests by the Dio interceptor. Screens
/// never need the raw token.
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.patientId,
    this.active = true,
    this.createdAt,
    this.onboardingComplete = false,
  });

  final String id;
  final String email;
  final String name;
  final UserRole role;

  /// e.g. "HHS-TREND-0001". Present for patient accounts; the id used to
  /// call /me/* and /patients/{id}-shaped endpoints in other features.
  final String? patientId;

  final bool active;
  final DateTime? createdAt;

  /// NOT part of the backend response — the API has no onboarding-status
  /// field yet (confirmed: nothing in the /auth/* contract addresses it).
  /// This is a client-local flag the onboarding feature is responsible
  /// for setting once that integration happens. Until then, every
  /// restored session will default to `false` and route back through
  /// onboarding — see the note in the accompanying message.
  final bool onboardingComplete;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String? ?? '',
      role: userRoleFromString(json['role'] as String?),
      patientId: json['patient_id'] as String?,
      active: json['active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? patientId,
    bool? active,
    DateTime? createdAt,
    bool? onboardingComplete,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      patientId: patientId ?? this.patientId,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }

  @override
  List<Object?> get props =>
      [id, email, name, role, patientId, active, createdAt, onboardingComplete];
}
