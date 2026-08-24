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

  /// Null for Heart Tests — no icon asset supplied yet; the tab bar falls
  /// back to `Icons.monitor_heart_outlined` for that case (see tabIconFallback).
  String? get tabIcon => switch (this) {
    AssessmentTab.lipids => 'assets/icons/assessment/tab_lipids.png',
    AssessmentTab.pressure => 'assets/icons/assessment/tab_pressure.png',
    AssessmentTab.glucose => 'assets/icons/assessment/tab_glucose.png',
    AssessmentTab.kidney => 'assets/icons/assessment/tab_kidney.png',
    AssessmentTab.lifestyle => 'assets/icons/assessment/tab_behavior.png', // was: tab_behavior.png
    AssessmentTab.heartTests => null,
  };

  IconData get tabIconFallback => Icons.monitor_heart_outlined; // only used when tabIcon is null

  String? get headerIcon => switch (this) {
    AssessmentTab.pressure => 'assets/icons/assessment/header_pressure.png',
    AssessmentTab.glucose => 'assets/icons/assessment/header_glucose.png',
    AssessmentTab.kidney => 'assets/icons/assessment/header_kidney.png',
    _ => null,
  };

  String get headerTitle => switch (this) {
    AssessmentTab.pressure => 'Blood Pressure / Hemodynamic',
    AssessmentTab.glucose => 'Glucose / Diabetes',
    AssessmentTab.kidney => 'Kidney / Vascular Damage',
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

class LipidProfile {
  final double? ldlC;
  final double? hdlC;
  final double? totalCholesterol;
  final double? triglycerides;
  final double? apoB;
  final double? lpA;

  const LipidProfile({
    this.ldlC,
    this.hdlC,
    this.totalCholesterol,
    this.triglycerides,
    this.apoB,
    this.lpA,
  });

  /// Auto-calculated — never user-entered, shown read-only.
  double? get tcHdlRatio => (totalCholesterol != null && hdlC != null && hdlC != 0)
      ? totalCholesterol! / hdlC!
      : null;

  double get completion {
    final f = [ldlC, hdlC, totalCholesterol, triglycerides, apoB, lpA];
    return f.where((e) => e != null).length / f.length;
  }

  LipidProfile copyWith({
    double? ldlC,
    double? hdlC,
    double? totalCholesterol,
    double? triglycerides,
    double? apoB,
    double? lpA,
  }) =>
      LipidProfile(
        ldlC: ldlC ?? this.ldlC,
        hdlC: hdlC ?? this.hdlC,
        totalCholesterol: totalCholesterol ?? this.totalCholesterol,
        triglycerides: triglycerides ?? this.triglycerides,
        apoB: apoB ?? this.apoB,
        lpA: lpA ?? this.lpA,
      );

  Map<String, dynamic> toJson() => {
    'ldl_c': ldlC,
    'hdl_c': hdlC,
    'total_cholesterol': totalCholesterol,
    'triglycerides': triglycerides,
    'apo_b': apoB,
    'lp_a': lpA,
    'tc_hdl_ratio': tcHdlRatio,
  };
}

class PressureProfile {
  final double? systolicBp;
  final double? diastolicBp;

  const PressureProfile({this.systolicBp, this.diastolicBp});

  double get completion {
    final f = [systolicBp, diastolicBp];
    return f.where((e) => e != null).length / f.length;
  }

  PressureProfile copyWith({double? systolicBp, double? diastolicBp}) => PressureProfile(
    systolicBp: systolicBp ?? this.systolicBp,
    diastolicBp: diastolicBp ?? this.diastolicBp,
  );

  Map<String, dynamic> toJson() => {'systolic_bp': systolicBp, 'diastolic_bp': diastolicBp};
}

class GlucoseProfile {
  final DiabetesStatus? diabetesStatus;
  final double? hba1c;
  final double? fastingGlucose;
  // homaIr removed per request

  const GlucoseProfile({this.diabetesStatus, this.hba1c, this.fastingGlucose});

  double get completion {
    final f = [diabetesStatus, hba1c, fastingGlucose];
    return f.where((e) => e != null).length / f.length;
  }

  GlucoseProfile copyWith({DiabetesStatus? diabetesStatus, double? hba1c, double? fastingGlucose}) =>
      GlucoseProfile(
        diabetesStatus: diabetesStatus ?? this.diabetesStatus,
        hba1c: hba1c ?? this.hba1c,
        fastingGlucose: fastingGlucose ?? this.fastingGlucose,
      );

  Map<String, dynamic> toJson() =>
      {'diabetes_status': diabetesStatus?.name, 'hba1c': hba1c, 'fasting_glucose': fastingGlucose};
}

class KidneyProfile {
  final double? eGfr;
  final double? creatinine;
  final double? uacr;

  const KidneyProfile({this.eGfr, this.creatinine, this.uacr});

  double get completion {
    final f = [eGfr, creatinine, uacr];
    return f.where((e) => e != null).length / f.length;
  }

  KidneyProfile copyWith({double? eGfr, double? creatinine, double? uacr}) => KidneyProfile(
    eGfr: eGfr ?? this.eGfr,
    creatinine: creatinine ?? this.creatinine,
    uacr: uacr ?? this.uacr,
  );

  Map<String, dynamic> toJson() => {'egfr': eGfr, 'creatinine': creatinine, 'uacr': uacr};
}

class LifestyleFitnessProfile {
  // Adiposity
  final double? bmi;
  final double? waistCircumference;
  final double? waistHipRatio;
  // Physical Activity (self-reported summary)
  final double? weeklyActivityMinutes;
  final double? structuredActivityScore;
  // Inherited Risk
  final bool? familyHistoryPrematureCvd;
  final RiskLevel? geneticRisk;
  final double? geneticRiskScorePercent;
  // Tobacco Use
  final SmokingStatus? smokingStatus;
  final int? packYears;
  final int? quitDurationYears;
  // Activity (target-tracked, mockup pre-fills 120)
  final double moderateVigorousActivityMinutes;
  // Diet / Nutrition
  final double? dietQualityScore;
  // Alcohol
  final double? alcoholDrinksPerWeek;
  // Sleep
  final double? sleepHoursPerNight;
  // Stress / Psychosocial
  final StressLevel? stressLevel;
  final double? stressIndexScore;
  //new
  final double? restingHeartRate;
  final double? vo2Max;
  final double? heartRateRecoveryBpm;

  const LifestyleFitnessProfile({
    this.bmi,
    this.waistCircumference,
    this.waistHipRatio,
    this.weeklyActivityMinutes,
    this.structuredActivityScore,
    this.familyHistoryPrematureCvd,
    this.geneticRisk,
    this.geneticRiskScorePercent,
    this.smokingStatus,
    this.packYears,
    this.quitDurationYears,
    this.moderateVigorousActivityMinutes = 120,
    this.dietQualityScore,
    this.alcoholDrinksPerWeek,
    this.sleepHoursPerNight,
    this.stressLevel,
    this.stressIndexScore,
    this.restingHeartRate,
    this.vo2Max,
    this.heartRateRecoveryBpm,
  });

  double get completion {
    final f = [
      bmi, waistCircumference, waistHipRatio,
      weeklyActivityMinutes, structuredActivityScore,
      familyHistoryPrematureCvd, geneticRisk, geneticRiskScorePercent,
      smokingStatus, packYears, quitDurationYears,
      dietQualityScore, alcoholDrinksPerWeek, sleepHoursPerNight,
      stressLevel, stressIndexScore, restingHeartRate, vo2Max, heartRateRecoveryBpm,
    ];
    return f.where((e) => e != null).length / f.length;
  }

  LifestyleFitnessProfile copyWith({
    double? bmi,
    double? waistCircumference,
    double? waistHipRatio,
    double? weeklyActivityMinutes,
    double? structuredActivityScore,
    bool? familyHistoryPrematureCvd,
    RiskLevel? geneticRisk,
    double? geneticRiskScorePercent,
    SmokingStatus? smokingStatus,
    int? packYears,
    int? quitDurationYears,
    double? moderateVigorousActivityMinutes,
    double? dietQualityScore,
    double? alcoholDrinksPerWeek,
    double? sleepHoursPerNight,
    StressLevel? stressLevel,
    double? stressIndexScore,
    double? restingHeartRate,
    double? vo2Max,
    double? heartRateRecoveryBpm,
  }) =>
      LifestyleFitnessProfile(
        bmi: bmi ?? this.bmi,
        waistCircumference: waistCircumference ?? this.waistCircumference,
        waistHipRatio: waistHipRatio ?? this.waistHipRatio,
        weeklyActivityMinutes: weeklyActivityMinutes ?? this.weeklyActivityMinutes,
        structuredActivityScore: structuredActivityScore ?? this.structuredActivityScore,
        familyHistoryPrematureCvd: familyHistoryPrematureCvd ?? this.familyHistoryPrematureCvd,
        geneticRisk: geneticRisk ?? this.geneticRisk,
        geneticRiskScorePercent: geneticRiskScorePercent ?? this.geneticRiskScorePercent,
        smokingStatus: smokingStatus ?? this.smokingStatus,
        packYears: packYears ?? this.packYears,
        quitDurationYears: quitDurationYears ?? this.quitDurationYears,
        moderateVigorousActivityMinutes:
        moderateVigorousActivityMinutes ?? this.moderateVigorousActivityMinutes,
        dietQualityScore: dietQualityScore ?? this.dietQualityScore,
        alcoholDrinksPerWeek: alcoholDrinksPerWeek ?? this.alcoholDrinksPerWeek,
        sleepHoursPerNight: sleepHoursPerNight ?? this.sleepHoursPerNight,
        stressLevel: stressLevel ?? this.stressLevel,
        stressIndexScore: stressIndexScore ?? this.stressIndexScore,
        restingHeartRate: restingHeartRate ?? this.restingHeartRate,
        vo2Max: vo2Max ?? this.vo2Max,
        heartRateRecoveryBpm: heartRateRecoveryBpm ?? this.heartRateRecoveryBpm,
      );

  Map<String, dynamic> toJson() => {
    'bmi': bmi,
    'waist_circumference': waistCircumference,
    'waist_hip_ratio': waistHipRatio,
    'weekly_activity_minutes': weeklyActivityMinutes,
    'structured_activity_score': structuredActivityScore,
    'family_history_premature_cvd': familyHistoryPrematureCvd,
    'genetic_risk': geneticRisk?.name,
    'genetic_risk_score_percent': geneticRiskScorePercent,
    'smoking_status': smokingStatus?.name,
    'pack_years': packYears,
    'quit_duration_years': quitDurationYears,
    'moderate_vigorous_activity_minutes': moderateVigorousActivityMinutes,
    'diet_quality_score': dietQualityScore,
    'alcohol_drinks_per_week': alcoholDrinksPerWeek,
    'sleep_hours_per_night': sleepHoursPerNight,
    'stress_level': stressLevel?.name,
    'stress_index_score': stressIndexScore,
    'resting_heart_rate': restingHeartRate,
    'vo2_max': vo2Max,
    'heart_rate_recovery_bpm': heartRateRecoveryBpm,
  };
}

class HeartTestsProfile {
  final bool? lvh;
  final double? hsCrp;
  final double? bnpNtProBnp;
  final double? hsTroponin;
  final double? cacScore;
  final bool? carotidPlaque;
  final double? carotidStenosisPercent; // optional per spec
  final double? abiLeft;
  final double? abiRight;
  final String? ecgFileName;
  final String? ecgLocalPath;
  final String? ecgAnalysisResult; // set once "Analyze" returns

  const HeartTestsProfile({
    this.lvh,
    this.hsCrp,
    this.bnpNtProBnp,
    this.hsTroponin,
    this.cacScore,
    this.carotidPlaque,
    this.carotidStenosisPercent,
    this.abiLeft,
    this.abiRight,
    this.ecgFileName,
    this.ecgLocalPath,
    this.ecgAnalysisResult,
  });

  /// Carotid Stenosis % is optional per spec, so it's excluded from the
  /// completion denominator rather than dragging the percentage down.
  double get completion {
    final f = [lvh, hsCrp, bnpNtProBnp, hsTroponin, cacScore, carotidPlaque, abiLeft, abiRight, ecgAnalysisResult];
    return f.where((e) => e != null).length / f.length;
  }

  HeartTestsProfile copyWith({
    bool? lvh,
    double? hsCrp,
    double? bnpNtProBnp,
    double? hsTroponin,
    double? cacScore,
    bool? carotidPlaque,
    double? carotidStenosisPercent,
    double? abiLeft,
    double? abiRight,
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

  Map<String, dynamic> toJson() => {
    'lvh': lvh,
    'hs_crp': hsCrp,
    'bnp_nt_probnp': bnpNtProBnp,
    'hs_troponin': hsTroponin,
    'cac_score': cacScore,
    'carotid_plaque': carotidPlaque,
    'carotid_stenosis_percent': carotidStenosisPercent,
    'abi_left': abiLeft,
    'abi_right': abiRight,
    'ecg_analysis_result': ecgAnalysisResult,
  };
}
/// Aggregate root — one notifier holds this whole thing (see state-mgmt
/// rules in SKILL.md: users jump between tabs and must not lose data).
class AssessmentDraft {
  final LipidProfile lipids;
  final PressureProfile pressure;
  final GlucoseProfile glucose;
  final KidneyProfile kidney;
  final LifestyleFitnessProfile lifestyle;
  final HeartTestsProfile heartTests;
  final List<UploadedReport> reports;

  const AssessmentDraft({
    this.lipids = const LipidProfile(),
    this.pressure = const PressureProfile(),
    this.glucose = const GlucoseProfile(),
    this.kidney = const KidneyProfile(),
    this.lifestyle = const LifestyleFitnessProfile(),
  this.heartTests = const HeartTestsProfile(),

  this.reports = const [],
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
    LipidProfile? lipids,
    PressureProfile? pressure,
    GlucoseProfile? glucose,
    KidneyProfile? kidney,
    LifestyleFitnessProfile? lifestyle,
    HeartTestsProfile? heartTests,
    List<UploadedReport>? reports,
  }) =>
      AssessmentDraft(
        lipids: lipids ?? this.lipids,
        pressure: pressure ?? this.pressure,
        glucose: glucose ?? this.glucose,
        kidney: kidney ?? this.kidney,
        lifestyle: lifestyle ?? this.lifestyle,
        heartTests: heartTests ?? this.heartTests,
        reports: reports ?? this.reports,
      );

  Map<String, dynamic> toJson() => {
    'lipids': lipids.toJson(),
    'pressure': pressure.toJson(),
    'glucose': glucose.toJson(),
    'kidney': kidney.toJson(),
    'lifestyle': lifestyle.toJson(),
  };
}

abstract class AssessmentRepository {
  Future<AssessmentDraft> loadDraft();
  Future<void> saveDraft(AssessmentDraft draft);
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