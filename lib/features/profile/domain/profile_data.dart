/// Personal-details form state for "Your Profile".
class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.email,
    required this.heightCm,
    required this.weightKg,
    this.dailyCalories,
    this.proteinTargetG,
  });

  final String fullName;
  final String email;
  final int heightCm;
  final int weightKg;

  /// Null shows the field as an empty hint-text placeholder (e.g. "2200"),
  /// matching the mockup where these two fields aren't filled in yet.
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
