import 'package:equatable/equatable.dart';

enum BiologicalSex { female, male }

enum SleepBand { lessThan6, sixToEight, eightToTen, moreThan10, custom }

enum ActivityBand { none, oneToTwo, threeToFive, fivePlus, custom }

/// Aggregated onboarding payload — Profile Setup + Daily Activity +
/// Basic Vitals combined. This is exactly the shape the ML health-score
/// endpoint will eventually need; keep it in sync with the backend
/// contract once shared.
class OnboardingData extends Equatable {
  const OnboardingData({
    this.fullName,
    this.sex,
    this.age,
    this.weightKg,
    this.heightCm,
    this.sleepBand,
    this.customSleepHours,
    this.activityBand,
    this.customActivityHours,
    this.systolic = 120,
    this.diastolic = 80,
    this.restingHeartRate = 72,
  });

  final String? fullName;
  final BiologicalSex? sex;
  final int? age;
  final double? weightKg;
  final double? heightCm;

  final SleepBand? sleepBand;
  final double? customSleepHours;

  final ActivityBand? activityBand;
  final double? customActivityHours;

  final int systolic;
  final int diastolic;
  final int restingHeartRate;

  bool get isProfileComplete => fullName != null && fullName!.isNotEmpty && sex != null && age != null;

  OnboardingData copyWith({
    String? fullName,
    BiologicalSex? sex,
    int? age,
    double? weightKg,
    double? heightCm,
    SleepBand? sleepBand,
    double? customSleepHours,
    ActivityBand? activityBand,
    double? customActivityHours,
    int? systolic,
    int? diastolic,
    int? restingHeartRate,
  }) {
    return OnboardingData(
      fullName: fullName ?? this.fullName,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      sleepBand: sleepBand ?? this.sleepBand,
      customSleepHours: customSleepHours ?? this.customSleepHours,
      activityBand: activityBand ?? this.activityBand,
      customActivityHours: customActivityHours ?? this.customActivityHours,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      restingHeartRate: restingHeartRate ?? this.restingHeartRate,
    );
  }

  /// Maps to the JSON payload the (future) ML scoring endpoint expects.
  /// TODO(backend-integration): confirm exact field names/types with the
  /// backend team and adjust this mapping — this is a reasonable best
  /// guess based on the collected inputs, not a confirmed contract.
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'biologicalSex': sex?.name,
      'age': age,
      'weightKg': weightKg,
      'heightCm': heightCm,
      'sleepHoursPerDay': customSleepHours ?? _sleepBandMidpoint(),
      'activityHoursPerWeek': customActivityHours ?? _activityBandMidpoint(),
      'bloodPressure': {'systolic': systolic, 'diastolic': diastolic},
      'restingHeartRateBpm': restingHeartRate,
    };
  }

  double? _sleepBandMidpoint() {
    switch (sleepBand) {
      case SleepBand.lessThan6:
        return 5;
      case SleepBand.sixToEight:
        return 7;
      case SleepBand.eightToTen:
        return 9;
      case SleepBand.moreThan10:
        return 11;
      default:
        return null;
    }
  }

  double? _activityBandMidpoint() {
    switch (activityBand) {
      case ActivityBand.none:
        return 0;
      case ActivityBand.oneToTwo:
        return 1.5;
      case ActivityBand.threeToFive:
        return 4;
      case ActivityBand.fivePlus:
        return 6;
      default:
        return null;
    }
  }

  @override
  List<Object?> get props => [
        fullName,
        sex,
        age,
        weightKg,
        heightCm,
        sleepBand,
        customSleepHours,
        activityBand,
        customActivityHours,
        systolic,
        diastolic,
        restingHeartRate,
      ];
}
