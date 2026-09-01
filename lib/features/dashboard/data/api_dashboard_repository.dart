import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:heart_health_score/features/auth/application/auth_providers.dart';
import 'package:heart_health_score/features/dashboard/domain/dashboard_data.dart';
import 'package:heart_health_score/features/dashboard/domain/dashboard_repository.dart';

import 'dashboard_domain_mapping.dart';
import 'mock_dashboard_repository.dart';

/// Live implementation of [DashboardRepository]. Calls two endpoints:
///
/// - `GET /me/dashboard` — current snapshot: `assessment.hhs` (score),
///   `data_confidence`/`confidence_label`, and `domain_rows` +
///   `domain_severities` (Burden Breakdown + Domain Summary).
/// - `GET /me/monitoring` — used ONLY for `monitoring.history.hhs_trend`,
///   to get the previous-visit score (`previousScore`). Its `current` and
///   `insights` blocks aren't consumed here; the trend/achievements
///   sections on Home are still separately mocked pending backend
///   confirmation (see project notes).
///
/// Scope note: per the current integration pass, ONLY profileName/age,
/// the score card, Domain Summary, and Burden Breakdown are sourced live.
/// The condition grid (resting HR / sleep / BP / steps), Weekly
/// Achievements, and Rewards & Milestones have no confirmed backend
/// contract yet, so they still fall back to [MockDashboardRepository]'s
/// sample values — `mergedDashboardDataProvider`'s wearable overlay
/// continues to apply on top of those fallbacks exactly as before this
/// change; nothing about that merge logic was touched.
///
/// ASSUMPTION: `_dio`'s base URL already includes the `/api/v1` prefix
/// (matching how `ApiAuthRepository` calls e.g. `/auth/login`), so the
/// paths below are relative (`/me/dashboard`, `/me/monitoring`). Adjust if
/// `ApiClient`'s base URL is configured differently.
class ApiDashboardRepository implements DashboardRepository {
  ApiDashboardRepository(this._dio, this._ref);

  final Dio _dio;
  final Ref _ref;

  static const _dashboardPath = '/me/dashboard';
  static const _monitoringPath = '/me/monitoring';

  @override
  Future<DashboardData> fetchDashboard() async {
    // Base values for everything this integration pass doesn't touch
    // (condition grid, Weekly Achievements, Rewards & Milestones) — same
    // sample data the UI has always shown for those sections. Fetched
    // first so it's available as a fallback in both the success and
    // no-assessment-yet paths below.
    final fallback = await MockDashboardRepository().fetchDashboard();

    try {
      final responses = await Future.wait([
        _dio.get(_dashboardPath),
        _dio.get(_monitoringPath),
      ]);

      final dashboardJson = responses[0].data as Map<String, dynamic>;
      final monitoringJson = responses[1].data as Map<String, dynamic>;

      return _mapToDashboardData(
        dashboardJson: dashboardJson,
        monitoringJson: monitoringJson,
        fallback: fallback,
      );
    } on DioException catch (e) {
      // CONFIRMED against a real fresh account: /me/dashboard returns 404
      // with body {"detail": "No assessment on file for your record
      // yet"}. Checking the detail message (not just the 404 status)
      // means an unrelated 404 — bad path, deleted account, etc. — still
      // surfaces as a real error instead of silently showing the
      // "complete your assessment" banner.
      if (e.response?.statusCode == 404 && _isNoAssessmentYet(e.response?.data)) {
        return _noAssessmentDashboardData(fallback);
      }
      rethrow;
    }
  }

  bool _isNoAssessmentYet(dynamic responseData) {
    if (responseData is! Map) return false;
    final detail = responseData['detail'];
    return detail is String && detail.toLowerCase().contains('no assessment');
  }

  /// Built when the account has no submitted assessment yet: keeps the
  /// same condition-grid/achievements/rewards fallback as a normal fetch
  /// (so the rest of Home renders exactly as it already does), but zeroes
  /// out the score-card and domain data — there's genuinely nothing to
  /// show there — and sets [DashboardData.hasAssessmentData] to false so
  /// the screen can show a banner instead of the full error state.
  DashboardData _noAssessmentDashboardData(DashboardData fallback) {
    final currentUser = _ref.read(currentUserProvider);

    return fallback.copyWith(
      profileName: currentUser?.name ?? fallback.profileName,
      healthyHeartScore: 0,
      previousScore: 0,
      confidencePercent: 0,
      confidenceLabel: '—',
      burdenBreakdown: const [],
      domainSummary: const [],
      hasAssessmentData: false,
    );
  }

  DashboardData _mapToDashboardData({
    required Map<String, dynamic> dashboardJson,
    required Map<String, dynamic> monitoringJson,
    required DashboardData fallback,
  }) {
    final patient = dashboardJson['patient'] as Map<String, dynamic>? ?? {};
    final patientData = dashboardJson['patient_data'] as Map<String, dynamic>? ?? {};
    final assessment = dashboardJson['assessment'] as Map<String, dynamic>? ?? {};

    final domainRows = (assessment['domain_rows'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final domainSeverities =
        assessment['domain_severities'] as Map<String, dynamic>? ?? {};
    final redFlags =
    (assessment['red_flags'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();

    final highlightedDomains = _highlightedDomains(domainRows, redFlags);
    final fieldsByDomain = groupPatientFieldsByDomain(patientData);

    final burdenBreakdown = <BurdenItem>[
      for (final row in domainRows)
        BurdenItem(
          label: row['Domain'] as String,
          value: ((domainSeverities[row['Domain']] as num?)?.toDouble() ??
              (row['Severity'] as num?)?.toDouble() ??
              0)
              .clamp(0.0, 1.0),
          status: mapDomainStatus(row['Status'] as String?),
          highlighted: highlightedDomains.contains(row['Domain']),
        ),
    ];

    final domainSummary = <DomainSummaryItem>[
      for (final row in domainRows)
        _domainSummaryItem(row, domainSeverities, fieldsByDomain, patientData),
    ];

    final previousScore = _previousScore(monitoringJson) ??
        (assessment['hhs'] as num?)?.toDouble() ??
        fallback.previousScore;

    final currentUser = _ref.read(currentUserProvider);

    return fallback.copyWith(
      profileName: currentUser?.name ?? fallback.profileName,
      age: (patient['age'] as num?)?.toInt() ?? fallback.age,
      healthyHeartScore: (assessment['hhs'] as num?)?.toDouble() ?? fallback.healthyHeartScore,
      previousScore: previousScore,
      confidencePercent:
      (assessment['data_confidence'] as num?)?.round() ?? fallback.confidencePercent,
      confidenceLabel: assessment['confidence_label'] as String? ?? fallback.confidenceLabel,
      burdenBreakdown: burdenBreakdown.isNotEmpty ? burdenBreakdown : fallback.burdenBreakdown,
      domainSummary: domainSummary.isNotEmpty ? domainSummary : fallback.domainSummary,
    );
  }

  DomainSummaryItem _domainSummaryItem(
      Map<String, dynamic> row,
      Map<String, dynamic> domainSeverities,
      Map<String, List<double>> fieldsByDomain,
      Map<String, dynamic> patientData,
      ) {
    final domain = row['Domain'] as String;
    final severities = fieldsByDomain[domain] ?? const <double>[];
    final counts = countSeverityBuckets(severities);

    return DomainSummaryItem(
      title: domainDisplayTitles[domain] ?? domain,
      status: mapDomainStatus(row['Status'] as String?),
      parameterCount: countDomainParameters(patientData, domain),
      hhsSeverity: (domainSeverities[domain] as num?)?.toDouble() ?? 0,
      weight: (row['Weight'] as num?)?.toInt() ?? 0,
      normalCount: counts.normal,
      borderlineCount: counts.borderline,
      atRiskCount: counts.atRisk,
      parameters: buildParameterDetails(patientData, domain),
    );
  }

  /// The second-to-last entry in `hhs_trend` — the last entry duplicates
  /// the current `/me/dashboard` score, so "previous" means one before
  /// that. Returns null (caller falls back) if there's no prior visit.
  double? _previousScore(Map<String, dynamic> monitoringJson) {
    final monitoring = monitoringJson['monitoring'] as Map<String, dynamic>?;
    final history = monitoring?['history'] as Map<String, dynamic>?;
    final trend = (history?['hhs_trend'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();

    if (trend.length < 2) return null;
    return (trend[trend.length - 2]['hhs'] as num?)?.toDouble();
  }

  /// ASSUMPTION (per your call): a domain is "highlighted" (renders the
  /// red bar instead of yellow in Burden Breakdown) when its Status is
  /// "High" OR it owns an active red flag. The mock only ever hardcoded
  /// one domain (Inherited Risk) true with no real backend to check
  /// against, so there was no existing precedent — revisit if design
  /// wants a stricter "red flags only" rule instead.
  Set<String> _highlightedDomains(
      List<Map<String, dynamic>> domainRows,
      List<Map<String, dynamic>> redFlags,
      ) {
    final highlighted = domainRows
        .where((r) => r['Status'] == 'High')
        .map((r) => r['Domain'] as String)
        .toSet();

    for (final flag in redFlags) {
      final domain = _redFlagDomain(flag['flag'] as String?);
      if (domain != null) highlighted.add(domain);
    }
    return highlighted;
  }

  /// ASSUMPTION: `red_flags` entries don't carry a `domain` field from the
  /// backend, so this hardcodes the two flag codes seen in the sample
  /// payload to the domain they clinically belong to. Extend this map (or
  /// ask backend to add a `domain` key to each red flag) as new flag codes
  /// appear — anything unmapped is simply not treated as highlighted.
  String? _redFlagDomain(String? flag) {
    switch (flag) {
      case 'hypertensive_crisis_range':
        return 'Blood Pressure';
      case 'severe_ldl_range':
        return 'Lipids';
      default:
        return null;
    }
  }
}