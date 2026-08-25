import 'package:equatable/equatable.dart';

/// Risk classification for a domain — drives both the Domain Summary badge
/// color and the Burden Breakdown filter tabs (All / Risk / Moderate /
/// Normal).
enum DomainStatus { risk, moderate, normal }

/// A single row in the "Burden Breakdown" horizontal bar chart.
/// [value] is normalized 0.0–1.0 (chart x-axis is fixed 0 to 1).
class BurdenItem extends Equatable {
  const BurdenItem({
    required this.label,
    required this.value,
    required this.status,
    this.highlighted = false,
  });

  final String label;
  final double value;
  final DomainStatus status;
  final bool highlighted;

  @override
  List<Object?> get props => [label, value, status, highlighted];
}
enum ParameterSeverity { normal, borderline, atRisk, missing, notApplicable }
class DomainParameterDetail extends Equatable {
  const DomainParameterDetail({
    required this.label,
    required this.valueLabel,
    required this.severity,
  });

  /// Display name, e.g. "HbA1c" (from the backend's `excel_name`).
  final String label;

  /// Pre-formatted value + unit, e.g. "6.8 %", or "--" when missing.
  final String valueLabel;

  final ParameterSeverity severity;

  @override
  List<Object?> get props => [label, valueLabel, severity];
}
/// A single card in the "Domain Summary" list.
class DomainSummaryItem extends Equatable {
  const DomainSummaryItem({
    required this.title,
    required this.status,
    required this.parameterCount,
    required this.hhsSeverity,
    required this.weight,
    required this.normalCount,
    required this.borderlineCount,
    required this.atRiskCount,
    this.parameters = const [],
  });

  final String title;
  final DomainStatus status;
  final int parameterCount;
  final double hhsSeverity;
  final int weight;
  final int normalCount;
  final int borderlineCount;
  final int atRiskCount;
  final List<DomainParameterDetail> parameters;

  @override
  List<Object?> get props => [
    title,
    status,
    parameterCount,
    hhsSeverity,
    weight,
    normalCount,
    borderlineCount,
    atRiskCount,
    parameters,
  ];
}

/// The 4 "Weekly Achievements" mini-cards on Home.
class WeeklyAchievements extends Equatable {
  const WeeklyAchievements({
    required this.hydrationLast7DaysMl,
    required this.dailyActivityConsistencyPercent,
    required this.sleepQualityScore,
    required this.vitalsStable,
  });

  /// Exactly 7 values, oldest → newest (today last). Used to draw the
  /// Hydration Master bar chart; today's bar renders in the highlight
  /// color, the other 6 in the track color.
  final List<double> hydrationLast7DaysMl;

  /// 0–100. Drives the Daily Activity ring + "Consistency: High/Low" caption.
  final int dailyActivityConsistencyPercent;

  /// 0–100. Drives the Sleep Quality bar + big number.
  final int sleepQualityScore;

  /// Drives the Vitals Stability "STABLE" / not-stable caption.
  final bool vitalsStable;

  String get dailyActivityConsistencyLabel =>
      dailyActivityConsistencyPercent >= 80 ? 'High' : 'Low';

  @override
  List<Object?> get props => [
    hydrationLast7DaysMl,
    dailyActivityConsistencyPercent,
    sleepQualityScore,
    vitalsStable,
  ];
}

/// Which reward badges the user has unlocked — maps 1:1 to the icon +
/// glow + border-color set in the design assets.
enum RewardBadgeType { hydrationHero, deepSleeper, activeStreak }

/// The "Rewards & Milestones" progress card + "Unlocked Rewards" strip.
class RewardsProgress extends Equatable {
  const RewardsProgress({
    required this.nextTierName,
    required this.progressPercent,
    required this.segmentsCompleted,
    required this.segmentsTotal,
    required this.description,
    required this.unlockedBadges,
  });

  final String nextTierName;

  /// 0–100. Drives the green ring.
  final int progressPercent;

  /// Segmented pip bar under the description, e.g. 3 of 4 filled.
  final int segmentsCompleted;
  final int segmentsTotal;

  final String description;
  final List<RewardBadgeType> unlockedBadges;

  @override
  List<Object?> get props => [
    nextTierName,
    progressPercent,
    segmentsCompleted,
    segmentsTotal,
    description,
    unlockedBadges,
  ];
}

/// Everything the Home dashboard needs to render.
class DashboardData extends Equatable {
  const DashboardData({
    required this.profileName,
    required this.age,
    required this.healthyHeartScore,
    required this.previousScore,
    required this.confidencePercent,
    required this.confidenceLabel,
    required this.restingHeartRateBpm,
    required this.sleepDurationLabel,
    required this.bloodPressureLabel,
    required this.stepCount,
    required this.burdenBreakdown,
    required this.domainSummary,
    required this.weeklyAchievements,
    required this.rewardsProgress,
    this.maxScore = 100,
    this.hasAssessmentData = true,
  });

  final String profileName;
  final int age;

  final double healthyHeartScore;
  final double previousScore;
  final double maxScore;
  final bool hasAssessmentData;

  final int confidencePercent;
  final String confidenceLabel;

  final int restingHeartRateBpm;
  final String sleepDurationLabel;
  final String bloodPressureLabel;
  final int stepCount;

  final List<BurdenItem> burdenBreakdown;
  final List<DomainSummaryItem> domainSummary;

  final WeeklyAchievements weeklyAchievements;
  final RewardsProgress rewardsProgress;

  double get scoreFraction => (healthyHeartScore / maxScore).clamp(0.0, 1.0);
  double get scoreDelta => healthyHeartScore - previousScore;

  DashboardData copyWith({
    bool? hasAssessmentData,
    String? profileName,
    int? age,
    double? healthyHeartScore,
    double? previousScore,
    double? maxScore,
    int? confidencePercent,
    String? confidenceLabel,
    int? restingHeartRateBpm,
    String? sleepDurationLabel,
    String? bloodPressureLabel,
    int? stepCount,
    List<BurdenItem>? burdenBreakdown,
    List<DomainSummaryItem>? domainSummary,
    WeeklyAchievements? weeklyAchievements,
    RewardsProgress? rewardsProgress,
  }) {
    return DashboardData(
      hasAssessmentData: hasAssessmentData ?? this.hasAssessmentData,
      profileName: profileName ?? this.profileName,
      age: age ?? this.age,
      healthyHeartScore: healthyHeartScore ?? this.healthyHeartScore,
      previousScore: previousScore ?? this.previousScore,
      maxScore: maxScore ?? this.maxScore,
      confidencePercent: confidencePercent ?? this.confidencePercent,
      confidenceLabel: confidenceLabel ?? this.confidenceLabel,
      restingHeartRateBpm: restingHeartRateBpm ?? this.restingHeartRateBpm,
      sleepDurationLabel: sleepDurationLabel ?? this.sleepDurationLabel,
      bloodPressureLabel: bloodPressureLabel ?? this.bloodPressureLabel,
      stepCount: stepCount ?? this.stepCount,
      burdenBreakdown: burdenBreakdown ?? this.burdenBreakdown,
      domainSummary: domainSummary ?? this.domainSummary,
      weeklyAchievements: weeklyAchievements ?? this.weeklyAchievements,
      rewardsProgress: rewardsProgress ?? this.rewardsProgress,
    );
  }

  @override
  List<Object?> get props => [
    hasAssessmentData,
    profileName,
    age,
    healthyHeartScore,
    previousScore,
    maxScore,
    confidencePercent,
    confidenceLabel,
    restingHeartRateBpm,
    sleepDurationLabel,
    bloodPressureLabel,
    stepCount,
    burdenBreakdown,
    domainSummary,
    weeklyAchievements,
    rewardsProgress,
  ];
}

