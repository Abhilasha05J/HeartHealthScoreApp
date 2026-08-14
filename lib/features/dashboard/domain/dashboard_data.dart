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

  /// Risk/Moderate/Normal classification for this domain — same one shown
  /// on the Domain Summary badge. Used to filter the Burden Breakdown list.
  final DomainStatus status;

  /// True for the "Inherited Risk" row, which renders in red instead of
  /// the standard yellow — per the mockup, it's visually called out as a
  /// non-modifiable risk factor distinct from the lifestyle-driven ones.
  final bool highlighted;

  @override
  List<Object?> get props => [label, value, status, highlighted];
}

/// A single card in the "Domain Summary" list — one per health domain
/// (Blood Pressure, Glucose, Lipids, etc.), showing its overall status,
/// HHS severity, weight, and a normal/borderline/at-risk parameter
/// breakdown.
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
  });

  final String title;
  final DomainStatus status;
  final int parameterCount;
  final double hhsSeverity;
  final int weight;
  final int normalCount;
  final int borderlineCount;
  final int atRiskCount;

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
  ];
}

/// Everything the Home dashboard needs to render. This is what
/// [DashboardRepository.fetchDashboard] returns — eventually backed by the
/// ML scoring endpoint's response, currently backed by
/// [MockDashboardRepository] with the exact sample values from the mockup.
class DashboardData extends Equatable {
  const DashboardData({
    required this.profileName,
    required this.age,
    required this.healthyHeartScore,
    required this.confidencePercent,
    required this.confidenceLabel,
    required this.restingHeartRateBpm,
    required this.sleepDurationLabel,
    required this.bloodPressureLabel,
    required this.stepCount,
    required this.burdenBreakdown,
    required this.domainSummary,
    this.maxScore = 100,
  });

  final String profileName;
  final int age;

  final double healthyHeartScore;
  final double maxScore;

  final int confidencePercent;
  final String confidenceLabel;

  final int restingHeartRateBpm;
  final String sleepDurationLabel;
  final String bloodPressureLabel;
  final int stepCount;

  final List<BurdenItem> burdenBreakdown;
  final List<DomainSummaryItem> domainSummary;

  double get scoreFraction => (healthyHeartScore / maxScore).clamp(0.0, 1.0);
  DashboardData copyWith({
    String? profileName,
    int? age,
    double? healthyHeartScore,
    double? maxScore,
    int? confidencePercent,
    String? confidenceLabel,
    int? restingHeartRateBpm,
    String? sleepDurationLabel,
    String? bloodPressureLabel,
    int? stepCount,
    List<BurdenItem>? burdenBreakdown,
    List<DomainSummaryItem>? domainSummary,
  }) {
    return DashboardData(
      profileName: profileName ?? this.profileName,
      age: age ?? this.age,
      healthyHeartScore: healthyHeartScore ?? this.healthyHeartScore,
      maxScore: maxScore ?? this.maxScore,
      confidencePercent: confidencePercent ?? this.confidencePercent,
      confidenceLabel: confidenceLabel ?? this.confidenceLabel,
      restingHeartRateBpm: restingHeartRateBpm ?? this.restingHeartRateBpm,
      sleepDurationLabel: sleepDurationLabel ?? this.sleepDurationLabel,
      bloodPressureLabel: bloodPressureLabel ?? this.bloodPressureLabel,
      stepCount: stepCount ?? this.stepCount,
      burdenBreakdown: burdenBreakdown ?? this.burdenBreakdown,
      domainSummary: domainSummary ?? this.domainSummary,
    );
  }
  @override
  List<Object?> get props => [
    profileName,
    age,
    healthyHeartScore,
    maxScore,
    confidencePercent,
    confidenceLabel,
    restingHeartRateBpm,
    sleepDurationLabel,
    bloodPressureLabel,
    stepCount,
    burdenBreakdown,
    domainSummary,
  ];
}