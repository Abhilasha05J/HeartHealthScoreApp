// import 'package:equatable/equatable.dart';
//
// enum BiologicalSex { female, male }
//
// enum SleepBand { lessThan6, sixToEight, eightToTen, moreThan10, custom }
//
// /// Renamed from hour-range buckets (none/oneToTwo/threeToFive/fivePlus) to
// /// lifestyle-type buckets per the v2 mockup ("How active are you?" instead
// /// of "Hours of physical activity per week?"). See ASSUMPTION note on
// /// [_activityBandMidpoint] below — the hour-per-week mapping is an estimate
// /// since the exact PAL->hours conversion wasn't specified by the designer.
// enum ActivityBand { mostlySitting, oftenStanding, regularlyWalking, physicallyIntense, custom }
//
// /// Aggregated onboarding payload — Profile Setup + Daily Activity +
// /// Basic Vitals combined. This is exactly the shape the ML health-score
// /// endpoint will eventually need; keep it in sync with the backend
// /// contract once shared.
// class OnboardingData extends Equatable {
//   const OnboardingData({
//     this.fullName,
//     this.sex,
//     this.age,
//     this.weightKg,
//     this.heightCm,
//     this.sleepBand,
//     this.customSleepHours,
//     this.activityBand,
//     this.customActivityHours,
//     this.systolic = 120,
//     this.diastolic = 80,
//     this.restingHeartRate = 72,
//   });
//
//   final String? fullName;
//   final BiologicalSex? sex;
//   final int? age;
//   final double? weightKg;
//   final double? heightCm;
//
//   final SleepBand? sleepBand;
//   final double? customSleepHours;
//
//   final ActivityBand? activityBand;
//   final double? customActivityHours;
//
//   final int systolic;
//   final int diastolic;
//   final int restingHeartRate;
//
//   bool get isProfileComplete => fullName != null && fullName!.isNotEmpty && sex != null && age != null;
//
//   OnboardingData copyWith({
//     String? fullName,
//     BiologicalSex? sex,
//     int? age,
//     double? weightKg,
//     double? heightCm,
//     SleepBand? sleepBand,
//     double? customSleepHours,
//     ActivityBand? activityBand,
//     double? customActivityHours,
//     int? systolic,
//     int? diastolic,
//     int? restingHeartRate,
//   }) {
//     return OnboardingData(
//       fullName: fullName ?? this.fullName,
//       sex: sex ?? this.sex,
//       age: age ?? this.age,
//       weightKg: weightKg ?? this.weightKg,
//       heightCm: heightCm ?? this.heightCm,
//       sleepBand: sleepBand ?? this.sleepBand,
//       customSleepHours: customSleepHours ?? this.customSleepHours,
//       activityBand: activityBand ?? this.activityBand,
//       customActivityHours: customActivityHours ?? this.customActivityHours,
//       systolic: systolic ?? this.systolic,
//       diastolic: diastolic ?? this.diastolic,
//       restingHeartRate: restingHeartRate ?? this.restingHeartRate,
//     );
//   }
//
//   /// Maps to the JSON payload the (future) ML scoring endpoint expects.
//   /// TODO(backend-integration): confirm exact field names/types with the
//   /// backend team and adjust this mapping — this is a reasonable best
//   /// guess based on the collected inputs, not a confirmed contract.
//   Map<String, dynamic> toJson() {
//     return {
//       'fullName': fullName,
//       'biologicalSex': sex?.name,
//       'age': age,
//       'weightKg': weightKg,
//       'heightCm': heightCm,
//       'sleepHoursPerDay': customSleepHours ?? _sleepBandMidpoint(),
//       // Sending both the categorical lifestyle level AND an estimated
//       // hours/week figure, since the ML contract isn't confirmed yet and
//       // the custom-hours field still lets the user override with an exact
//       // number regardless of which preset they picked.
//       'activityLevel': activityBand?.name,
//       'activityHoursPerWeek': customActivityHours ?? _activityBandMidpoint(),
//       'bloodPressure': {'systolic': systolic, 'diastolic': diastolic},
//       'restingHeartRateBpm': restingHeartRate,
//     };
//   }
//
//   double? _sleepBandMidpoint() {
//     switch (sleepBand) {
//       case SleepBand.lessThan6:
//         return 5;
//       case SleepBand.sixToEight:
//         return 7;
//       case SleepBand.eightToTen:
//         return 9;
//       case SleepBand.moreThan10:
//         return 11;
//       default:
//         return null;
//     }
//   }
//
//   /// ASSUMPTION: the designer's chip labels are lifestyle descriptions, not
//   /// hour ranges, so there's no exact hours/week given for each bucket.
//   /// These are reasonable estimates carried over from the original
//   /// hour-range buckets they replaced — confirm with the backend/ML team
//   /// before relying on this mapping.
//   double? _activityBandMidpoint() {
//     switch (activityBand) {
//       case ActivityBand.mostlySitting:
//         return 1;
//       case ActivityBand.oftenStanding:
//         return 3;
//       case ActivityBand.regularlyWalking:
//         return 5;
//       case ActivityBand.physicallyIntense:
//         return 8;
//       default:
//         return null;
//     }
//   }
//
//   @override
//   List<Object?> get props => [
//     fullName,
//     sex,
//     age,
//     weightKg,
//     heightCm,
//     sleepBand,
//     customSleepHours,
//     activityBand,
//     customActivityHours,
//     systolic,
//     diastolic,
//     restingHeartRate,
//   ];
// }
import 'package:equatable/equatable.dart';

enum BiologicalSex { female, male }

enum SleepBand { lessThan6, sixToEight, eightToTen, moreThan10, custom }

/// Renamed from hour-range buckets (none/oneToTwo/threeToFive/fivePlus) to
/// lifestyle-type buckets per the v2 mockup ("How active are you?" instead
/// of "Hours of physical activity per week?"). See ASSUMPTION note on
/// [_activityBandMidpoint] below — the hour-per-week mapping is an estimate
/// since the exact PAL->hours conversion wasn't specified by the designer.
enum ActivityBand { mostlySitting, oftenStanding, regularlyWalking, physicallyIntense, custom }

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

  /// CONFIRMED against the real `/intake/schema`: there is no weight/height
  /// field anywhere in the submission contract — only `bmi` (Adiposity
  /// domain, kg/m², range 10–60). So weight/height collected on Profile
  /// Setup are UI-only inputs used to derive this; they are never sent to
  /// the backend directly. Null if either input is missing or height is 0
  /// (can't divide by zero) — a null BMI simply means the `bmi` field is
  /// omitted from the submission rather than sending a bad value.
  double? get bmi {
    if (weightKg == null || heightCm == null || heightCm == 0) return null;
    final heightM = heightCm! / 100;
    return double.parse((weightKg! / (heightM * heightM)).toStringAsFixed(1));
  }

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

  /// Maps to the real `SubmissionIn` body for `POST /me/encounters`,
  /// confirmed field-by-field against the live `/intake/schema` response
  /// (not a guess — every key below is a real field key from that schema).
  ///
  /// [email] is passed in rather than stored on this class — it comes from
  /// the authenticated `AppUser`, not from anything onboarding collects.
  ///
  /// Deliberately omits every schema field this wizard doesn't ask about
  /// (lipids, kidney markers, tobacco, etc.) — `fields` only needs to
  /// contain the keys you actually have values for; unlisted keys are
  /// simply not scored for this encounter, per the schema's "Additional
  /// properties allowed" design. Parameters (the full Assessment tab) is
  /// what eventually fills in the rest.
  Map<String, dynamic> toSubmissionJson({String? email}) {
    final fields = <String, dynamic>{};

    void addField(String key, num? value) {
      if (value == null) return;
      fields[key] = {'status': 'Available', 'value': value, 'months_old': 0};
    }

    addField('sbp', systolic);
    addField('dbp', diastolic);
    addField('resting_hr', restingHeartRate);
    addField('bmi', bmi);
    addField('sleep_hours', customSleepHours ?? _sleepBandMidpoint());
    // Schema unit is min/week; our bands/custom-entry are in hours — the
    // one unit conversion this mapping actually needs.
    final activityHours = customActivityHours ?? _activityBandMidpoint();
    addField('physical_activity', activityHours != null ? activityHours * 60 : null);

    return {
      'visit': {
        // patient_id/visit_id are explicitly ignored by the server per the
        // endpoint docs ("the id comes from the token and the visit id is
        // generated") — sent as empty strings since the field is required
        // by the schema but the value itself doesn't matter.
        'patient_id': '',
        'visit_id': '',
        'visit_date': DateTime.now().toIso8601String().split('T').first,
        'age': age,
        'biological_sex': sex == BiologicalSex.female ? 'Female' : 'Male',
        'region_profile': '',
        'clinical_setting': '',
        'reviewed_by': '',
      },
      'patient_profile': {
        'name': fullName ?? '',
        'contact': {'email': email ?? '', 'phone': ''},
        'notification_preferences': {'email': true, 'push': true},
        'emergency_contact': {
          'name': '',
          'relation': '',
          'contact': {'email': '', 'phone': ''},
        },
      },
      'fields': fields,
      'clinician_note': '',
      'lpa_unit': 'mg/dL',
      // ASSUMPTION: false (schema default). If onboarding is ever
      // resubmitted same-day in testing, this will 422 as a duplicate
      // visit — that's expected, not a bug.
      'allow_duplicate_visit': false,
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

  /// ASSUMPTION: the designer's chip labels are lifestyle descriptions, not
  /// hour ranges, so there's no exact hours/week given for each bucket.
  /// These are reasonable estimates carried over from the original
  /// hour-range buckets they replaced — confirm with the backend/ML team
  /// before relying on this mapping.
  double? _activityBandMidpoint() {
    switch (activityBand) {
      case ActivityBand.mostlySitting:
        return 1;
      case ActivityBand.oftenStanding:
        return 3;
      case ActivityBand.regularlyWalking:
        return 5;
      case ActivityBand.physicallyIntense:
        return 8;
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