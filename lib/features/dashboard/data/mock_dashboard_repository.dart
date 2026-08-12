import 'package:heart_health_score/features/dashboard/domain/dashboard_data.dart';
import 'package:heart_health_score/features/dashboard/domain/dashboard_repository.dart';

/// TEMPORARY mock — returns the exact sample values shown in the
/// designer's mockup, after a simulated network delay.
///
/// TODO(backend-integration): replace with an implementation that calls
/// the real scoring endpoint, e.g.:
///
///   class ApiDashboardRepository implements DashboardRepository {
///     ApiDashboardRepository(this._dio);
///     final Dio _dio;
///
///     @override
///     Future<DashboardData> fetchDashboard() async {
///       final res = await _dio.get('/users/me/health-score');
///       return DashboardData(...); // map res.data into the model
///     }
///   }
class MockDashboardRepository implements DashboardRepository {
  @override
  Future<DashboardData> fetchDashboard() async {
    await Future.delayed(const Duration(milliseconds: 700));

    return const DashboardData(
      profileName: 'Profile Name',
      age: 34,
      healthyHeartScore: 62.2,
      confidencePercent: 87,
      confidenceLabel: 'High',
      restingHeartRateBpm: 95,
      sleepDurationLabel: '6-7 hrs',
      bloodPressureLabel: '110/68 mmhg',
      stepCount: 1200,
      burdenBreakdown: [
        // TODO(backend-integration): Sleep and Kidney/Vascular Damage
        // values below (0.11, 0.21) are estimated by scaling the Domain
        // Summary's HHS severity ratios (Sleep 0.05 / Diet 0.15 / Kidney
        // 0.10) onto this list's existing Diet value (0.32) — confirm
        // against the real severity source once it's wired up.
        BurdenItem(label: 'Sleep', value: 0.11, status: DomainStatus.normal),
        BurdenItem(label: 'Kidney', value: 0.21, status: DomainStatus.moderate),
        BurdenItem(label: 'Diet', value: 0.32, status: DomainStatus.normal),
        BurdenItem(label: 'Lipids', value: 0.34, status: DomainStatus.moderate),
        BurdenItem(label: 'Tobacco', value: 0.36, status: DomainStatus.moderate),
        BurdenItem(label: 'Glucose', value: 0.55, status: DomainStatus.risk),
        BurdenItem(label: 'Activity', value: 0.55, status: DomainStatus.moderate),
        BurdenItem(label: 'Adiposity', value: 0.53, status: DomainStatus.moderate),
        BurdenItem(label: 'Blood Pressure', value: 0.62, status: DomainStatus.risk),
        BurdenItem(
          label: 'Inherited Risk',
          value: 0.68,
          status: DomainStatus.moderate,
          highlighted: true,
        ),
      ],
      domainSummary: [
        DomainSummaryItem(
          title: 'Blood Pressure / Hemodynamic',
          status: DomainStatus.risk,
          parameterCount: 4,
          hhsSeverity: 0.66,
          weight: 10,
          normalCount: 0,
          borderlineCount: 1,
          atRiskCount: 2,
        ),
        DomainSummaryItem(
          title: 'Glucose / Diabetes',
          status: DomainStatus.risk,
          parameterCount: 3,
          hhsSeverity: 0.61,
          weight: 8,
          normalCount: 0,
          borderlineCount: 0,
          atRiskCount: 1,
        ),
        DomainSummaryItem(
          title: 'Lipid / Atherogenic Particle',
          status: DomainStatus.moderate,
          parameterCount: 8,
          hhsSeverity: 0.43,
          weight: 13,
          normalCount: 0,
          borderlineCount: 1,
          atRiskCount: 0,
        ),
        DomainSummaryItem(
          title: 'Tobacco',
          status: DomainStatus.moderate,
          parameterCount: 4,
          hhsSeverity: 0.44,
          weight: 9,
          normalCount: 0,
          borderlineCount: 3,
          atRiskCount: 0,
        ),
        DomainSummaryItem(
          title: 'Adiposity',
          status: DomainStatus.moderate,
          parameterCount: 3,
          hhsSeverity: 0.61,
          weight: 8,
          normalCount: 0,
          borderlineCount: 2,
          atRiskCount: 0,
        ),
        DomainSummaryItem(
          title: 'Kidney / Vascular Damage',
          status: DomainStatus.moderate,
          parameterCount: 3,
          hhsSeverity: 0.10,
          weight: 7,
          normalCount: 1,
          borderlineCount: 1,
          atRiskCount: 0,
        ),
        DomainSummaryItem(
          title: 'Inherited Risk',
          status: DomainStatus.moderate,
          parameterCount: 1,
          hhsSeverity: 0.70,
          weight: 6,
          normalCount: 0,
          borderlineCount: 1,
          atRiskCount: 0,
        ),
        DomainSummaryItem(
          title: 'Physical Activity',
          status: DomainStatus.moderate,
          parameterCount: 1,
          hhsSeverity: 0.61,
          weight: 5,
          normalCount: 0,
          borderlineCount: 1,
          atRiskCount: 0,
        ),
        DomainSummaryItem(
          title: 'Diet',
          status: DomainStatus.normal,
          parameterCount: 2,
          hhsSeverity: 0.15,
          weight: 4,
          normalCount: 2,
          borderlineCount: 0,
          atRiskCount: 0,
        ),
        DomainSummaryItem(
          title: 'Sleep',
          status: DomainStatus.normal,
          parameterCount: 1,
          hhsSeverity: 0.05,
          weight: 3,
          normalCount: 1,
          borderlineCount: 0,
          atRiskCount: 0,
        ),
      ],
    );
  }
}