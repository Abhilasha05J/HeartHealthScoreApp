enum AssessmentTab { lipids, pressure, glucose, kidney, behavior }

extension AssessmentTabX on AssessmentTab {
  String get label => switch (this) {
    AssessmentTab.lipids => 'Lipids',
    AssessmentTab.pressure => 'Pressure',
    AssessmentTab.glucose => 'Glucose',
    AssessmentTab.kidney => 'Kidney',
    AssessmentTab.behavior => 'Behavior',
  };

  String get tabIcon => switch (this) {
    AssessmentTab.lipids => 'assets/icons/assessment/tab_lipids.png',
    AssessmentTab.pressure => 'assets/icons/assessment/tab_pressure.png',
    AssessmentTab.glucose => 'assets/icons/assessment/tab_glucose.png',
    AssessmentTab.kidney => 'assets/icons/assessment/tab_kidney.png',
    AssessmentTab.behavior => 'assets/icons/assessment/tab_behavior.png',
  };

  /// Pre-composed icon+circle-background for the page header row.
  /// Lipids and Behavior render null — Lipids has no header in the mockup,
  /// Behavior uses per-sub-section headers instead of one page header.
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
    AssessmentTab.behavior => 'Behavior Profile',
  };

  String get nextLabel => switch (this) {
    AssessmentTab.lipids => 'Next: Blood Pressure',
    AssessmentTab.pressure => 'Next: Glucose',
    AssessmentTab.glucose => 'Next: Kidney',
    AssessmentTab.kidney => 'Next: Behavior',
    AssessmentTab.behavior => 'Save Assessment',
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
  final double? pulsePressure;

  const PressureProfile({this.systolicBp, this.diastolicBp, this.pulsePressure});

  double get completion {
    final f = [systolicBp, diastolicBp, pulsePressure];
    return f.where((e) => e != null).length / f.length;
  }

  PressureProfile copyWith({double? systolicBp, double? diastolicBp, double? pulsePressure}) =>
      PressureProfile(
        systolicBp: systolicBp ?? this.systolicBp,
        diastolicBp: diastolicBp ?? this.diastolicBp,
        pulsePressure: pulsePressure ?? this.pulsePressure,
      );

  Map<String, dynamic> toJson() =>
      {'systolic_bp': systolicBp, 'diastolic_bp': diastolicBp, 'pulse_pressure': pulsePressure};
}

class GlucoseProfile {
  final DiabetesStatus? diabetesStatus;
  final double? hba1c;
  final double? fastingGlucose;
  final double? homaIr;

  const GlucoseProfile({this.diabetesStatus, this.hba1c, this.fastingGlucose, this.homaIr});

  double get completion {
    final f = [diabetesStatus, hba1c, fastingGlucose, homaIr];
    return f.where((e) => e != null).length / f.length;
  }

  GlucoseProfile copyWith({
    DiabetesStatus? diabetesStatus,
    double? hba1c,
    double? fastingGlucose,
    double? homaIr,
  }) =>
      GlucoseProfile(
        diabetesStatus: diabetesStatus ?? this.diabetesStatus,
        hba1c: hba1c ?? this.hba1c,
        fastingGlucose: fastingGlucose ?? this.fastingGlucose,
        homaIr: homaIr ?? this.homaIr,
      );

  Map<String, dynamic> toJson() => {
    'diabetes_status': diabetesStatus?.name,
    'hba1c': hba1c,
    'fasting_glucose': fastingGlucose,
    'homa_ir': homaIr,
  };
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

class BehaviorProfile {
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

  const BehaviorProfile({
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
  });

  double get completion {
    final f = [
      bmi, waistCircumference, waistHipRatio,
      weeklyActivityMinutes, structuredActivityScore,
      familyHistoryPrematureCvd, geneticRisk, geneticRiskScorePercent,
      smokingStatus, packYears, quitDurationYears,
      dietQualityScore, alcoholDrinksPerWeek, sleepHoursPerNight,
      stressLevel, stressIndexScore,
    ];
    return f.where((e) => e != null).length / f.length;
  }

  BehaviorProfile copyWith({
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
  }) =>
      BehaviorProfile(
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
  };
}

/// Aggregate root — one notifier holds this whole thing (see state-mgmt
/// rules in SKILL.md: users jump between tabs and must not lose data).
class AssessmentDraft {
  final LipidProfile lipids;
  final PressureProfile pressure;
  final GlucoseProfile glucose;
  final KidneyProfile kidney;
  final BehaviorProfile behavior;
  final List<UploadedReport> reports;

  const AssessmentDraft({
    this.lipids = const LipidProfile(),
    this.pressure = const PressureProfile(),
    this.glucose = const GlucoseProfile(),
    this.kidney = const KidneyProfile(),
    this.behavior = const BehaviorProfile(),
    this.reports = const [],
  });

  double completionFor(AssessmentTab tab) => switch (tab) {
    AssessmentTab.lipids => lipids.completion,
    AssessmentTab.pressure => pressure.completion,
    AssessmentTab.glucose => glucose.completion,
    AssessmentTab.kidney => kidney.completion,
    AssessmentTab.behavior => behavior.completion,
  };

  AssessmentDraft copyWith({
    LipidProfile? lipids,
    PressureProfile? pressure,
    GlucoseProfile? glucose,
    KidneyProfile? kidney,
    BehaviorProfile? behavior,
    List<UploadedReport>? reports,
  }) =>
      AssessmentDraft(
        lipids: lipids ?? this.lipids,
        pressure: pressure ?? this.pressure,
        glucose: glucose ?? this.glucose,
        kidney: kidney ?? this.kidney,
        behavior: behavior ?? this.behavior,
        reports: reports ?? this.reports,
      );

  Map<String, dynamic> toJson() => {
    'lipids': lipids.toJson(),
    'pressure': pressure.toJson(),
    'glucose': glucose.toJson(),
    'kidney': kidney.toJson(),
    'behavior': behavior.toJson(),
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