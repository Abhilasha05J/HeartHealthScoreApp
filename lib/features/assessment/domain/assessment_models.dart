import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AssessmentTab { lipids, pressure, glucose, kidney, lifestyle, heartTests }

extension AssessmentTabX on AssessmentTab {
  String get label => switch (this) {
    AssessmentTab.lipids => 'Lipids',
    AssessmentTab.pressure => 'Pressure',
    AssessmentTab.glucose => 'Glucose',
    AssessmentTab.kidney => 'Kidney',
    AssessmentTab.lifestyle => 'Lifestyle',
    AssessmentTab.heartTests => 'ECG',
  };

  String? get tabIcon => switch (this) {
    AssessmentTab.lipids => 'assets/icons/assessment/tab_lipids.png',
    AssessmentTab.pressure => 'assets/icons/assessment/tab_pressure.png',
    AssessmentTab.glucose => 'assets/icons/assessment/tab_glucose.png',
    AssessmentTab.kidney => 'assets/icons/assessment/tab_kidney.png',
    AssessmentTab.lifestyle => 'assets/icons/assessment/tab_behavior.png',
    AssessmentTab.heartTests => 'assets/icons/assessment/tab_ecg.png',
  };

  IconData get tabIconFallback => Icons.monitor_heart_outlined;

  String? get headerIcon => switch (this) {
    AssessmentTab.pressure => 'assets/icons/assessment/header_pressure.png',
    AssessmentTab.glucose => 'assets/icons/assessment/header_glucose.png',
    AssessmentTab.kidney => 'assets/icons/assessment/header_kidney.png',
    AssessmentTab.heartTests => 'assets/icons/assessment/tab_hearttest.png',
    _ => null,
  };

  String get headerTitle => switch (this) {
    AssessmentTab.pressure => 'Blood Pressure / Hemodynamic',
    AssessmentTab.glucose => 'Glucose / Diabetes',
    AssessmentTab.kidney => 'Kidney / Vascular Damage',
    AssessmentTab.heartTests => 'Heart Tests',

    _ => '',
  };

  String get profileLabel => switch (this) {
    AssessmentTab.lipids => 'Lipid Profile',
    AssessmentTab.pressure => 'Blood Pressure Profile',
    AssessmentTab.glucose => 'Glucose Profile',
    AssessmentTab.kidney => 'Kidney Profile',
    AssessmentTab.lifestyle => 'Lifestyle & Fitness Profile',
    AssessmentTab.heartTests => 'Heart Tests Profile',
  };

  String get nextLabel => switch (this) {
    AssessmentTab.lipids => 'Next: Blood Pressure',
    AssessmentTab.pressure => 'Next: Glucose',
    AssessmentTab.glucose => 'Next: Kidney',
    AssessmentTab.kidney => 'Next: Lifestyle & Fitness',
    AssessmentTab.lifestyle => 'Next: Heart Tests',
    AssessmentTab.heartTests => 'Save Assessment',
  };

  AssessmentTab? get next {
    final values = AssessmentTab.values;
    final i = values.indexOf(this);
    return i == values.length - 1 ? null : values[i + 1];
  }
}

enum DiabetesStatus { none, prediabetes, type1, type2 }

extension DiabetesStatusX on DiabetesStatus {
  String get label => switch (this) {
    DiabetesStatus.none => 'No Diabetes',
    DiabetesStatus.prediabetes => 'Prediabetes',
    DiabetesStatus.type1 => 'Type 1 Diabetes',
    DiabetesStatus.type2 => 'Type 2 Diabetes',
  };
}

enum SmokingStatus { never, former, current }

extension SmokingStatusX on SmokingStatus {
  String get label => switch (this) {
    SmokingStatus.never => 'Never Smoked',
    SmokingStatus.former => 'Former Smoker',
    SmokingStatus.current => 'Current Smoker',
  };
}

enum RiskLevel { low, medium, high }

extension RiskLevelX on RiskLevel {
  String get label => switch (this) {
    RiskLevel.low => 'Low',
    RiskLevel.medium => 'Med',
    RiskLevel.high => 'High',
  };
}

enum StressLevel { low, moderate, high }

extension StressLevelX on StressLevel {
  String get label => switch (this) {
    StressLevel.low => 'Low Stress',
    StressLevel.moderate => 'Moderate Stress',
    StressLevel.high => 'High Stress',
  };
}

/// Tracks a field's value and freshness metadata from the backend.
// class FieldValue<T> {
//   final T? value;
//   final int? monthsOld; // null = just entered; 0 = current visit; 2 = 2 months old
//   final bool available; // backend returned a value
//
//   const FieldValue({
//     this.value,
//     this.monthsOld,
//     this.available = false,
//   });
//
//   /// Human-readable freshness label: "today", "2 months ago", etc.
//   String get freshnessLabel {
//     if (monthsOld == null || monthsOld == 0) return 'today';
//     if (monthsOld == 1) return '1 month ago';
//     return '$monthsOld months ago';
//   }
//
//   /// Whether to show freshness inline (true if not from current visit).
//   bool get shouldShowFreshness => monthsOld != null && monthsOld! > 0;
//
//   FieldValue<T> copyWith({T? value, int? monthsOld, bool? available}) => FieldValue(
//     value: value ?? this.value,
//     monthsOld: monthsOld ?? this.monthsOld,
//     available: available ?? this.available,
//   );
//
//   @override
//   String toString() => 'FieldValue($value, $freshnessLabel)';
// }
class _Unset {
  const _Unset();
}
const Object _unset = _Unset();

class FieldValue<T> {
  final T? value;
  final int? monthsOld;
  final bool available;

  const FieldValue({
    this.value,
    this.monthsOld,
    this.available = false,
  });

  String get freshnessLabel {
    if (monthsOld == null || monthsOld == 0) return 'today';
    if (monthsOld == 1) return '1 month ago';
    return '$monthsOld months ago';
  }

  bool get shouldShowFreshness => monthsOld != null && monthsOld! > 0;

  FieldValue<T> copyWith({
    Object? value = _unset,
    int? monthsOld,
    bool? available,
  }) =>
      FieldValue(
        value: identical(value, _unset) ? this.value : value as T?,
        monthsOld: monthsOld ?? this.monthsOld,
        available: available ?? this.available,
      );

  @override
  String toString() => 'FieldValue($value, $freshnessLabel)';
}
class LipidProfile {
  final FieldValue<double> ldlC;
  final FieldValue<double> hdlC;
  final FieldValue<double> totalCholesterol;
  final FieldValue<double> triglycerides;
  final FieldValue<double> apoB;
  final FieldValue<double> lpA;

  const LipidProfile({
    this.ldlC = const FieldValue(),
    this.hdlC = const FieldValue(),
    this.totalCholesterol = const FieldValue(),
    this.triglycerides = const FieldValue(),
    this.apoB = const FieldValue(),
    this.lpA = const FieldValue(),
  });

  double? get tcHdlRatio =>
      (totalCholesterol.value != null && hdlC.value != null && hdlC.value != 0)
          ? totalCholesterol.value! / hdlC.value!
          : null;

  double get completion {
    final f = [ldlC, hdlC, totalCholesterol, triglycerides, apoB, lpA];
    return f.where((e) => e.value != null).length / f.length;
  }

  LipidProfile copyWith({
    FieldValue<double>? ldlC,
    FieldValue<double>? hdlC,
    FieldValue<double>? totalCholesterol,
    FieldValue<double>? triglycerides,
    FieldValue<double>? apoB,
    FieldValue<double>? lpA,
  }) =>
      LipidProfile(
        ldlC: ldlC ?? this.ldlC,
        hdlC: hdlC ?? this.hdlC,
        totalCholesterol: totalCholesterol ?? this.totalCholesterol,
        triglycerides: triglycerides ?? this.triglycerides,
        apoB: apoB ?? this.apoB,
        lpA: lpA ?? this.lpA,
      );

  /// For backend submission — extracts just the value.
  Map<String, dynamic> toSubmissionJson() => {
    'ldl': ldlC.value,
    'hdl': hdlC.value,
    'total_cholesterol': totalCholesterol.value,
    'triglycerides': triglycerides.value,
    'apob': apoB.value,
    'lpa': lpA.value,
    'non_hdl': totalCholesterol.value != null && hdlC.value != null
        ? totalCholesterol.value! - hdlC.value!
        : null,
    'tc_hdl_ratio': tcHdlRatio,
  };
}

class PressureProfile {
  final FieldValue<double> systolicBp;
  final FieldValue<double> diastolicBp;
  final FieldValue<double> restingHeartRate;
  final FieldValue<bool> lvh; // Left Ventricular Hypertrophy

  const PressureProfile({
    this.systolicBp = const FieldValue(),
    this.diastolicBp = const FieldValue(),
    this.restingHeartRate = const FieldValue(),
    this.lvh = const FieldValue(),
  });

  double get completion {
    final f = [systolicBp, diastolicBp, restingHeartRate];
    return f.where((e) => e.value != null).length / f.length;
  }

  PressureProfile copyWith({
    FieldValue<double>? systolicBp,
    FieldValue<double>? diastolicBp,
    FieldValue<double>? restingHeartRate,
    FieldValue<bool>? lvh,
  }) =>
      PressureProfile(
        systolicBp: systolicBp ?? this.systolicBp,
        diastolicBp: diastolicBp ?? this.diastolicBp,
        restingHeartRate: restingHeartRate ?? this.restingHeartRate,
        lvh: lvh ?? this.lvh,
      );

  Map<String, dynamic> toSubmissionJson() => {
    'sbp': systolicBp.value,
    'dbp': diastolicBp.value,
    'resting_hr': restingHeartRate.value,
    'lvh': lvh.value,
  };
}

class GlucoseProfile {
  final FieldValue<DiabetesStatus> diabetesStatus;
  final FieldValue<double> hba1c;
  final FieldValue<double> fastingGlucose;

  const GlucoseProfile({
    this.diabetesStatus = const FieldValue(),
    this.hba1c = const FieldValue(),
    this.fastingGlucose = const FieldValue(),
  });

  double get completion {
    final f = [diabetesStatus, hba1c, fastingGlucose];
    return f.where((e) => e.value != null).length / f.length;
  }

  GlucoseProfile copyWith({
    FieldValue<DiabetesStatus>? diabetesStatus,
    FieldValue<double>? hba1c,
    FieldValue<double>? fastingGlucose,
  }) =>
      GlucoseProfile(
        diabetesStatus: diabetesStatus ?? this.diabetesStatus,
        hba1c: hba1c ?? this.hba1c,
        fastingGlucose: fastingGlucose ?? this.fastingGlucose,
      );

  Map<String, dynamic> toSubmissionJson() => {
    'diabetes': diabetesStatus.value?.name,
    'hba1c': hba1c.value,
    'fasting_glucose': fastingGlucose.value,
  };
}

class KidneyProfile {
  final FieldValue<double> eGfr;
  final FieldValue<double> creatinine;
  final FieldValue<double> uacr;
  final FieldValue<bool> ckd; // Chronic Kidney Disease diagnosis

  const KidneyProfile({
    this.eGfr = const FieldValue(),
    this.creatinine = const FieldValue(),
    this.uacr = const FieldValue(),
    this.ckd = const FieldValue(),
  });

  double get completion {
    final f = [eGfr, creatinine, uacr];
    return f.where((e) => e.value != null).length / f.length;
  }

  KidneyProfile copyWith({
    FieldValue<double>? eGfr,
    FieldValue<double>? creatinine,
    FieldValue<double>? uacr,
    FieldValue<bool>? ckd,
  }) =>
      KidneyProfile(
        eGfr: eGfr ?? this.eGfr,
        creatinine: creatinine ?? this.creatinine,
        uacr: uacr ?? this.uacr,
        ckd: ckd ?? this.ckd,
      );

  Map<String, dynamic> toSubmissionJson() => {
    'egfr': eGfr.value,
    'creatinine': creatinine.value,
    'uacr': uacr.value,
    'ckd': ckd.value,
  };
}

class LifestyleFitnessProfile {
  // Adiposity
  final FieldValue<double> bmi;
  final FieldValue<double> waistCircumference;
  final FieldValue<double> waistHipRatio;
  // Physical Activity
  final FieldValue<double> weeklyActivityMinutes;
  final FieldValue<double> structuredActivityScore;
  // Inherited Risk
  final FieldValue<String> familyHistory; // "No relatives", "One first-degree relative", etc.
  final FieldValue<String> geneticMutation;
  final FieldValue<double> geneticRiskScorePercent;
  // Tobacco Use
  final FieldValue<SmokingStatus> smokingStatus;
  final FieldValue<int> packYears;
  final FieldValue<int> quitDurationYears;
  final FieldValue<bool> smokelessTobacco;
  // Activity (target-tracked)
  final double moderateVigorousActivityMinutes;
  // Diet
  final FieldValue<double> dietQualityScore;
  // Behavioral
  final FieldValue<double> alcoholAudit; // AUDIT score
  final FieldValue<double> sleepHoursPerNight;
  final FieldValue<double> stressScore;

  const LifestyleFitnessProfile({
    this.bmi = const FieldValue(),
    this.waistCircumference = const FieldValue(),
    this.waistHipRatio = const FieldValue(),
    this.weeklyActivityMinutes = const FieldValue(),
    this.structuredActivityScore = const FieldValue(),
    this.familyHistory = const FieldValue(),
    this.geneticMutation = const FieldValue(),
    this.geneticRiskScorePercent = const FieldValue(),
    this.smokingStatus = const FieldValue(),
    this.packYears = const FieldValue(),
    this.quitDurationYears = const FieldValue(),
    this.smokelessTobacco = const FieldValue(),
    this.moderateVigorousActivityMinutes = 0,
    this.dietQualityScore = const FieldValue(),
    this.alcoholAudit = const FieldValue(),
    this.sleepHoursPerNight = const FieldValue(),
    this.stressScore = const FieldValue(),
  });

  double get completion {
    final f = [
      bmi,
      waistCircumference,
      smokingStatus,
      dietQualityScore,
      sleepHoursPerNight,
    ];
    return f.where((e) => e.value != null).length / f.length;
  }

  LifestyleFitnessProfile copyWith({
    FieldValue<double>? bmi,
    FieldValue<double>? waistCircumference,
    FieldValue<double>? waistHipRatio,
    FieldValue<double>? weeklyActivityMinutes,
    FieldValue<double>? structuredActivityScore,
    FieldValue<String>? familyHistory,
    FieldValue<String>? geneticMutation,
    FieldValue<double>? geneticRiskScorePercent,
    FieldValue<SmokingStatus>? smokingStatus,
    FieldValue<int>? packYears,
    FieldValue<int>? quitDurationYears,
    FieldValue<bool>? smokelessTobacco,
    double? moderateVigorousActivityMinutes,
    FieldValue<double>? dietQualityScore,
    FieldValue<double>? alcoholAudit,
    FieldValue<double>? sleepHoursPerNight,
    FieldValue<double>? stressScore,
  }) =>
      LifestyleFitnessProfile(
        bmi: bmi ?? this.bmi,
        waistCircumference: waistCircumference ?? this.waistCircumference,
        waistHipRatio: waistHipRatio ?? this.waistHipRatio,
        weeklyActivityMinutes: weeklyActivityMinutes ?? this.weeklyActivityMinutes,
        structuredActivityScore: structuredActivityScore ?? this.structuredActivityScore,
        familyHistory: familyHistory ?? this.familyHistory,
        geneticMutation: geneticMutation ?? this.geneticMutation,
        geneticRiskScorePercent: geneticRiskScorePercent ?? this.geneticRiskScorePercent,
        smokingStatus: smokingStatus ?? this.smokingStatus,
        packYears: packYears ?? this.packYears,
        quitDurationYears: quitDurationYears ?? this.quitDurationYears,
        smokelessTobacco: smokelessTobacco ?? this.smokelessTobacco,
        moderateVigorousActivityMinutes:
        moderateVigorousActivityMinutes ?? this.moderateVigorousActivityMinutes,
        dietQualityScore: dietQualityScore ?? this.dietQualityScore,
        alcoholAudit: alcoholAudit ?? this.alcoholAudit,
        sleepHoursPerNight: sleepHoursPerNight ?? this.sleepHoursPerNight,
        stressScore: stressScore ?? this.stressScore,
      );

  Map<String, dynamic> toSubmissionJson() => {
    'bmi': bmi.value,
    'waist': waistCircumference.value,
    'whr': waistHipRatio.value,
    'physical_activity': weeklyActivityMinutes.value,
    'diet_score': dietQualityScore.value,
    'smoking_status': smokingStatus.value?.name,
    'pack_years': packYears.value,
    'years_since_quit': quitDurationYears.value,
    'smokeless_tobacco': smokelessTobacco.value,
    'family_history': familyHistory.value,
    'genetic_mutation': geneticMutation.value,
    'prs_percentile': geneticRiskScorePercent.value,
    'sleep_hours': sleepHoursPerNight.value,
    'alcohol_audit': alcoholAudit.value,
    'stress_score': stressScore.value,
  };
}

class HeartTestsProfile {
  final FieldValue<bool> lvh;
  final FieldValue<double> hsCrp;
  final FieldValue<double> bnpNtProBnp;
  final FieldValue<double> hsTroponin;
  final FieldValue<double> cacScore;
  final FieldValue<bool> carotidPlaque;
  final FieldValue<double> carotidStenosisPercent;
  final FieldValue<double> abiLeft;
  final FieldValue<double> abiRight;
  final String? ecgFileName;
  final String? ecgLocalPath;
  final String? ecgAnalysisResult;

  const HeartTestsProfile({
    this.lvh = const FieldValue(),
    this.hsCrp = const FieldValue(),
    this.bnpNtProBnp = const FieldValue(),
    this.hsTroponin = const FieldValue(),
    this.cacScore = const FieldValue(),
    this.carotidPlaque = const FieldValue(),
    this.carotidStenosisPercent = const FieldValue(),
    this.abiLeft = const FieldValue(),
    this.abiRight = const FieldValue(),
    this.ecgFileName,
    this.ecgLocalPath,
    this.ecgAnalysisResult,
  });

  double get completion {
    final f = [lvh, hsCrp, bnpNtProBnp, hsTroponin, cacScore, carotidPlaque, abiLeft, abiRight];
    return f.where((e) => e.value != null).length / f.length;
  }

  HeartTestsProfile copyWith({
    FieldValue<bool>? lvh,
    FieldValue<double>? hsCrp,
    FieldValue<double>? bnpNtProBnp,
    FieldValue<double>? hsTroponin,
    FieldValue<double>? cacScore,
    FieldValue<bool>? carotidPlaque,
    FieldValue<double>? carotidStenosisPercent,
    FieldValue<double>? abiLeft,
    FieldValue<double>? abiRight,
    String? ecgFileName,
    String? ecgLocalPath,
    String? ecgAnalysisResult,
  }) =>
      HeartTestsProfile(
        lvh: lvh ?? this.lvh,
        hsCrp: hsCrp ?? this.hsCrp,
        bnpNtProBnp: bnpNtProBnp ?? this.bnpNtProBnp,
        hsTroponin: hsTroponin ?? this.hsTroponin,
        cacScore: cacScore ?? this.cacScore,
        carotidPlaque: carotidPlaque ?? this.carotidPlaque,
        carotidStenosisPercent: carotidStenosisPercent ?? this.carotidStenosisPercent,
        abiLeft: abiLeft ?? this.abiLeft,
        abiRight: abiRight ?? this.abiRight,
        ecgFileName: ecgFileName ?? this.ecgFileName,
        ecgLocalPath: ecgLocalPath ?? this.ecgLocalPath,
        ecgAnalysisResult: ecgAnalysisResult ?? this.ecgAnalysisResult,
      );

  Map<String, dynamic> toSubmissionJson() => {
    'lvh': lvh.value,
    'hscrp': hsCrp.value,
    'cac': cacScore.value,
    'ecg_analysis_result': ecgAnalysisResult,
  };
}

/// Visit and patient metadata for backend submission.
class VisitProfile {
  final String? patientId; // filled by backend or pre-set
  final String? visitId; // filled by backend on submit
  final DateTime? visitDate; // auto-set to now on submit
  final int? age;
  final String? biologicalSex; // "Male", "Female", etc.
  final String regionProfile; // region code or empty
  final String clinicalSetting; // "Self-reported (patient)", etc.
  final String reviewedBy; // clinician name, if any

  const VisitProfile({
    this.patientId,
    this.visitId,
    this.visitDate,
    this.age,
    this.biologicalSex,
    this.regionProfile = '',
    this.clinicalSetting = 'Self-reported (patient)',
    this.reviewedBy = '',
  });

  VisitProfile copyWith({
    String? patientId,
    String? visitId,
    DateTime? visitDate,
    int? age,
    String? biologicalSex,
    String? regionProfile,
    String? clinicalSetting,
    String? reviewedBy,
  }) =>
      VisitProfile(
        patientId: patientId ?? this.patientId,
        visitId: visitId ?? this.visitId,
        visitDate: visitDate ?? this.visitDate,
        age: age ?? this.age,
        biologicalSex: biologicalSex ?? this.biologicalSex,
        regionProfile: regionProfile ?? this.regionProfile,
        clinicalSetting: clinicalSetting ?? this.clinicalSetting,
        reviewedBy: reviewedBy ?? this.reviewedBy,
      );

  Map<String, dynamic> toJson() => {
    'patient_id': patientId,
    'visit_id': visitId,
    'visit_date': visitDate?.toIso8601String(),
    'age': age,
    'biological_sex': biologicalSex,
    'region_profile': regionProfile,
    'clinical_setting': clinicalSetting,
    'reviewed_by': reviewedBy,
  };
}

class PatientProfile {
  final String name;
  final String email;
  final String phone;
  final bool emailNotification;
  final bool pushNotification;
  final String emergencyContactName;
  final String emergencyContactRelation;
  final String emergencyContactEmail;
  final String emergencyContactPhone;

  const PatientProfile({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.emailNotification = true,
    this.pushNotification = true,
    this.emergencyContactName = '',
    this.emergencyContactRelation = '',
    this.emergencyContactEmail = '',
    this.emergencyContactPhone = '',
  });

  PatientProfile copyWith({
    String? name,
    String? email,
    String? phone,
    bool? emailNotification,
    bool? pushNotification,
    String? emergencyContactName,
    String? emergencyContactRelation,
    String? emergencyContactEmail,
    String? emergencyContactPhone,
  }) =>
      PatientProfile(
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        emailNotification: emailNotification ?? this.emailNotification,
        pushNotification: pushNotification ?? this.pushNotification,
        emergencyContactName: emergencyContactName ?? this.emergencyContactName,
        emergencyContactRelation: emergencyContactRelation ?? this.emergencyContactRelation,
        emergencyContactEmail: emergencyContactEmail ?? this.emergencyContactEmail,
        emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'contact': {
      'email': email,
      'phone': phone,
    },
    'notification_preferences': {
      'email': emailNotification,
      'push': pushNotification,
    },
    'emergency_contact': {
      'name': emergencyContactName,
      'relation': emergencyContactRelation,
      'contact': {
        'email': emergencyContactEmail,
        'phone': emergencyContactPhone,
      },
    },
  };
}

/// Aggregate root — one notifier holds this whole thing.
class AssessmentDraft {
  final VisitProfile visit;
  final PatientProfile patientProfile;
  final LipidProfile lipids;
  final PressureProfile pressure;
  final GlucoseProfile glucose;
  final KidneyProfile kidney;
  final LifestyleFitnessProfile lifestyle;
  final HeartTestsProfile heartTests;
  final List<UploadedReport> reports;
  final String? clinicianNote;
  final String lpaUnit; // "mg/dL" default

  const AssessmentDraft({
    this.visit = const VisitProfile(),
    this.patientProfile = const PatientProfile(),
    this.lipids = const LipidProfile(),
    this.pressure = const PressureProfile(),
    this.glucose = const GlucoseProfile(),
    this.kidney = const KidneyProfile(),
    this.lifestyle = const LifestyleFitnessProfile(),
    this.heartTests = const HeartTestsProfile(),
    this.reports = const [],
    this.clinicianNote = '',
    this.lpaUnit = 'mg/dL',
  });

  double completionFor(AssessmentTab tab) => switch (tab) {
    AssessmentTab.lipids => lipids.completion,
    AssessmentTab.pressure => pressure.completion,
    AssessmentTab.glucose => glucose.completion,
    AssessmentTab.kidney => kidney.completion,
    AssessmentTab.lifestyle => lifestyle.completion,
    AssessmentTab.heartTests => heartTests.completion,
  };

  AssessmentDraft copyWith({
    VisitProfile? visit,
    PatientProfile? patientProfile,
    LipidProfile? lipids,
    PressureProfile? pressure,
    GlucoseProfile? glucose,
    KidneyProfile? kidney,
    LifestyleFitnessProfile? lifestyle,
    HeartTestsProfile? heartTests,
    List<UploadedReport>? reports,
    String? clinicianNote,
    String? lpaUnit,
  }) =>
      AssessmentDraft(
        visit: visit ?? this.visit,
        patientProfile: patientProfile ?? this.patientProfile,
        lipids: lipids ?? this.lipids,
        pressure: pressure ?? this.pressure,
        glucose: glucose ?? this.glucose,
        kidney: kidney ?? this.kidney,
        lifestyle: lifestyle ?? this.lifestyle,
        heartTests: heartTests ?? this.heartTests,
        reports: reports ?? this.reports,
        clinicianNote: clinicianNote ?? this.clinicianNote,
        lpaUnit: lpaUnit ?? this.lpaUnit,
      );

  /// Full SubmissionIn payload for /me/encounters.
  Map<String, dynamic> toSubmissionJson() => {
    'visit': visit.toJson(),
    'patient_profile': patientProfile.toJson(),
    'fields': {
      // Lipids
      'ldl': _fieldToJson(lipids.ldlC),
      'hdl': _fieldToJson(lipids.hdlC),
      'total_cholesterol': _fieldToJson(lipids.totalCholesterol),
      'triglycerides': _fieldToJson(lipids.triglycerides),
      'apob': _fieldToJson(lipids.apoB),
      'lpa': _fieldToJson(lipids.lpA),
      'non_hdl': _fieldToJson(
        FieldValue(
          value: lipids.totalCholesterol.value != null && lipids.hdlC.value != null
              ? lipids.totalCholesterol.value! - lipids.hdlC.value!
              : null,
        ),
      ),
      'tc_hdl_ratio': _fieldToJson(
        FieldValue(value: lipids.tcHdlRatio),
      ),
      // Pressure
      'sbp': _fieldToJson(pressure.systolicBp),
      'dbp': _fieldToJson(pressure.diastolicBp),
      'resting_hr': _fieldToJson(pressure.restingHeartRate),
      'lvh': _fieldToJson(pressure.lvh),
      // Glucose
      'diabetes': _fieldToJson(
        FieldValue(value: glucose.diabetesStatus.value?.name),
      ),
      'hba1c': _fieldToJson(glucose.hba1c),
      'fasting_glucose': _fieldToJson(glucose.fastingGlucose),
      // Kidney
      'egfr': _fieldToJson(kidney.eGfr),
      'creatinine': _fieldToJson(kidney.creatinine),
      'uacr': _fieldToJson(kidney.uacr),
      'ckd': _fieldToJson(kidney.ckd),
      // Lifestyle
      'bmi': _fieldToJson(lifestyle.bmi),
      'waist': _fieldToJson(lifestyle.waistCircumference),
      'whr': _fieldToJson(lifestyle.waistHipRatio),
      'physical_activity': _fieldToJson(lifestyle.weeklyActivityMinutes),
      'diet_score': _fieldToJson(lifestyle.dietQualityScore),
      'smoking_status': _fieldToJson(
        FieldValue(value: lifestyle.smokingStatus.value?.name),
      ),
      'pack_years': _fieldToJson(lifestyle.packYears),
      'years_since_quit': _fieldToJson(lifestyle.quitDurationYears),
      'smokeless_tobacco': _fieldToJson(lifestyle.smokelessTobacco),
      'family_history': _fieldToJson(lifestyle.familyHistory),
      'genetic_mutation': _fieldToJson(lifestyle.geneticMutation),
      'prs_percentile': _fieldToJson(lifestyle.geneticRiskScorePercent),
      'sleep_hours': _fieldToJson(lifestyle.sleepHoursPerNight),
      'alcohol_audit': _fieldToJson(lifestyle.alcoholAudit),
      'stress_score': _fieldToJson(lifestyle.stressScore),
      // Heart Tests
      'hscrp': _fieldToJson(heartTests.hsCrp),
      'cac': _fieldToJson(heartTests.cacScore),
    },
    'clinician_note': clinicianNote ?? '',
    'lpa_unit': lpaUnit,
    'allow_duplicate_visit': false,
  };

  /// Converts a FieldValue to backend format: {status, value, months_old}.
  static Map<String, dynamic> _fieldToJson(FieldValue field) => {
    'status': field.value != null ? 'Available' : 'Unknown',
    'value': field.value,
    'months_old': field.monthsOld,
  };
}

abstract class AssessmentRepository {
  /// Fetch prefilled form data from backend.
  Future<AssessmentDraft> loadPrefill();

  /// Persist draft locally (no backend sync yet).
  Future<void> saveDraft(AssessmentDraft draft);

  /// Hit ML scoring endpoint, then POST to /me/encounters.
  Future<void> submitAssessment(AssessmentDraft draft);

  Future<UploadedReport> uploadReport({
    required String localPath,
    required String fileName,
    required ReportFileType type,
  });

  Future<String> analyzeEcg(String localPath);

  Future<void> deleteReport(String reportId);
}

enum ReportFileType { image, pdf }

class UploadedReport {
  final String id;
  final String fileName;
  final String localPath;
  final ReportFileType type;
  final int sizeBytes;
  final DateTime uploadedAt;

  const UploadedReport({
    required this.id,
    required this.fileName,
    required this.localPath,
    required this.type,
    required this.sizeBytes,
    required this.uploadedAt,
  });

  String get sizeLabel {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}