// /// Personal-details form state for "Your Profile".
// class UserProfile {
//   const UserProfile({
//     required this.fullName,
//     required this.email,
//     required this.heightCm,
//     required this.weightKg,
//     this.dailyCalories,
//     this.proteinTargetG,
//   });
//
//   final String fullName;
//   final String email;
//   final int heightCm;
//   final int weightKg;
//
//   /// Null shows the field as an empty hint-text placeholder (e.g. "2200"),
//   /// matching the mockup where these two fields aren't filled in yet.
//   final int? dailyCalories;
//   final int? proteinTargetG;
//
//   /// Single initial used for the round avatar badge.
//   String get initial => fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
//
//   UserProfile copyWith({
//     String? fullName,
//     String? email,
//     int? heightCm,
//     int? weightKg,
//     int? dailyCalories,
//     int? proteinTargetG,
//   }) {
//     return UserProfile(
//       fullName: fullName ?? this.fullName,
//       email: email ?? this.email,
//       heightCm: heightCm ?? this.heightCm,
//       weightKg: weightKg ?? this.weightKg,
//       dailyCalories: dailyCalories ?? this.dailyCalories,
//       proteinTargetG: proteinTargetG ?? this.proteinTargetG,
//     );
//   }
// }
/// Personal-details form state for "Your Profile".
///
/// [fullName]/[email] are REAL — sourced from the authenticated account
/// (`/auth/me`). Everything else on this class ([heightCm], [weightKg],
/// [dailyCalories], [proteinTargetG]) is stored locally on-device only —
/// see `ProfileLocalStore`'s doc comment for why (short version: none of
/// these have a backend field to live in yet).
///
/// CHANGED from the mock-era version: [heightCm]/[weightKg] are now
/// nullable. They used to default to 172/68 because the mock always had
/// *something* to show; now that there's a real "we genuinely don't know
/// yet" state (nothing saved on this device, and the backend has no
/// value either), null is the honest representation rather than a fake
/// default.
class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.email,
    this.heightCm,
    this.weightKg,
    this.dailyCalories,
    this.proteinTargetG,
  });

  final String fullName;
  final String email;
  final int? heightCm;
  final int? weightKg;
  final int? dailyCalories;
  final int? proteinTargetG;

  /// Single initial used for the round avatar badge.
  String get initial => fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';

  UserProfile copyWith({
    String? fullName,
    String? email,
    int? heightCm,
    int? weightKg,
    int? dailyCalories,
    int? proteinTargetG,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      dailyCalories: dailyCalories ?? this.dailyCalories,
      proteinTargetG: proteinTargetG ?? this.proteinTargetG,
    );
  }
}