// import 'package:heart_health_score/features/dashboard/domain/dashboard_data.dart';
//
// /// Domain-classification helpers for mapping the `/me/dashboard` and
// /// `/me/monitoring` API payloads into [DashboardData].
// ///
// /// Lives alongside [ApiDashboardRepository] rather than inside it so the
// /// (currently assumption-heavy) domain/field mapping is easy to find and
// /// revise independently once the backend confirms it.
//
// /// Maps the backend's per-domain `Status` string ("High" / "Moderate" /
// /// "Mild" / "Low", from `assessment.domain_rows[i].Status`) onto the app's
// /// 3-value [DomainStatus]. "Mild" and "Low" both collapse to
// /// [DomainStatus.normal] — the UI's filter tabs and badges only have 3
// /// buckets (Risk / Moderate / Normal), not 4.
// DomainStatus mapDomainStatus(String? backendStatus) {
//   switch (backendStatus) {
//     case 'High':
//       return DomainStatus.risk;
//     case 'Moderate':
//       return DomainStatus.moderate;
//     case 'Mild':
//     case 'Low':
//     default:
//       return DomainStatus.normal;
//   }
// }
//
// /// ASSUMPTION: neither `/me/dashboard` nor `/me/monitoring` states which
// /// individual patient fields belong to which of the 10
// /// `domain_rows`/`domain_severities` domains (Lipids, Blood Pressure,
// /// Adiposity, Inherited Risk, Activity, Diet, Tobacco, Behavioral, Kidney,
// /// Glucose). This mapping is inferred from field-name semantics — it's
// /// consistent with how the Assessment feature's tabs group these same
// /// fields, but the Assessment tabs use coarser buckets (one "Lifestyle"
// /// tab covers Adiposity+Activity+Inherited Risk+Tobacco+Diet+Behavioral),
// /// so it's not a direct copy. Confirm with backend/ML before trusting
// /// `parameterCount`/`normalCount`/`borderlineCount`/`atRiskCount` for
// /// anything clinical, and switch to a backend-provided mapping the moment
// /// one exists (e.g. a `domain` key added to each `patient_data` entry).
// const Map<String, List<String>> domainFieldKeys = {
//   'Lipids': ['ldl', 'hdl', 'total_cholesterol', 'non_hdl', 'tc_hdl_ratio', 'triglycerides', 'apob', 'lpa'],
//   'Blood Pressure': ['sbp', 'dbp'],
//   'Adiposity': ['bmi', 'waist', 'whr'],
//   'Inherited Risk': ['family_history', 'genetic_mutation', 'prs_percentile'],
//   'Activity': ['physical_activity'],
//   'Diet': ['diet_score'],
//   'Tobacco': ['smoking_status', 'pack_years', 'years_since_quit', 'smokeless_tobacco'],
//   'Behavioral': ['sleep_hours', 'alcohol_audit', 'stress_score'],
//   'Kidney': ['egfr', 'uacr', 'ckd'],
//   'Glucose': ['hba1c', 'fasting_glucose', 'diabetes'],
// };
//
// /// Groups each domain's fields down to just the ones the backend actually
// /// scored for this patient — present in `patient_data` (the flat,
// /// severity-annotated sibling of `patient` in the `/me/dashboard`
// /// response) with a non-null `severity`. Fields with `severity: null`
// /// (categorical/context fields that are `"Unknown"`, e.g. `ckd` or
// /// `diabetes` in the sample payload) aren't part of the burden
// /// calculation, so they're excluded from parameter/normal/borderline/
// /// at-risk counts rather than silently counted as "normal".
// Map<String, List<double>> groupPatientFieldsByDomain(Map<String, dynamic> patientData) {
//   final result = <String, List<double>>{};
//
//   domainFieldKeys.forEach((domain, keys) {
//     final severities = <double>[];
//     for (final key in keys) {
//       final entry = patientData[key];
//       if (entry is Map<String, dynamic> && entry['severity'] != null) {
//         severities.add((entry['severity'] as num).toDouble());
//       }
//     }
//     result[domain] = severities;
//   });
//
//   return result;
// }
//
// class SeverityBucketCounts {
//   const SeverityBucketCounts({
//     required this.normal,
//     required this.borderline,
//     required this.atRisk,
//   });
//
//   final int normal;
//   final int borderline;
//   final int atRisk;
// }
//
// /// Buckets raw per-field severities (0 / 0.5 / 1 in the sample payload)
// /// into normal / borderline / at-risk counts.
// /// ASSUMPTION: severity <= 0 -> normal, >= 1 -> at risk, anything strictly
// /// between -> borderline. The API doesn't document discrete severity
// /// bands beyond the 0/0.5/1 values observed, so this is a best-effort
// /// threshold rather than a confirmed contract.
// SeverityBucketCounts countSeverityBuckets(List<double> severities) {
//   var normal = 0, borderline = 0, atRisk = 0;
//   for (final s in severities) {
//     if (s <= 0) {
//       normal++;
//     } else if (s >= 1) {
//       atRisk++;
//     } else {
//       borderline++;
//     }
//   }
//   return SeverityBucketCounts(normal: normal, borderline: borderline, atRisk: atRisk);
// }
import 'package:heart_health_score/features/dashboard/domain/dashboard_data.dart';

/// Domain-classification helpers for mapping the `/me/dashboard` and
/// `/me/monitoring` API payloads into [DashboardData].
///
/// Lives alongside [ApiDashboardRepository] rather than inside it so the
/// (currently assumption-heavy) domain/field mapping is easy to find and
/// revise independently once the backend confirms it.

/// Maps the backend's per-domain `Status` string ("High" / "Moderate" /
/// "Mild" / "Low", from `assessment.domain_rows[i].Status`) onto the app's
/// 3-value [DomainStatus]. "Mild" and "Low" both collapse to
/// [DomainStatus.normal] — the UI's filter tabs and badges only have 3
/// buckets (Risk / Moderate / Normal), not 4.
DomainStatus mapDomainStatus(String? backendStatus) {
  switch (backendStatus) {
    case 'High':
      return DomainStatus.risk;
    case 'Moderate':
      return DomainStatus.moderate;
    case 'Mild':
    case 'Low':
    default:
      return DomainStatus.normal;
  }
}

/// ASSUMPTION: neither `/me/dashboard` nor `/me/monitoring` states which
/// individual patient fields belong to which of the 10
/// `domain_rows`/`domain_severities` domains (Lipids, Blood Pressure,
/// Adiposity, Inherited Risk, Activity, Diet, Tobacco, Behavioral, Kidney,
/// Glucose). This mapping is inferred from field-name semantics — it's
/// consistent with how the Assessment feature's tabs group these same
/// fields, but the Assessment tabs use coarser buckets (one "Lifestyle"
/// tab covers Adiposity+Activity+Inherited Risk+Tobacco+Diet+Behavioral),
/// so it's not a direct copy. Confirm with backend/ML before trusting
/// `parameterCount`/`normalCount`/`borderlineCount`/`atRiskCount` for
/// anything clinical, and switch to a backend-provided mapping the moment
/// one exists (e.g. a `domain` key added to each `patient_data` entry).
const Map<String, List<String>> domainFieldKeys = {
  'Lipids': ['ldl', 'hdl', 'total_cholesterol', 'non_hdl', 'tc_hdl_ratio', 'triglycerides', 'apob', 'lpa'],
  // CORRECTED: confirmed against the reference web dashboard's "4
  // parameters" count for Blood Pressure — resting_hr and lvh belong here
  // too, not just sbp/dbp.
  'Blood Pressure': ['sbp', 'dbp', 'resting_hr', 'lvh'],
  'Adiposity': ['bmi', 'waist', 'whr'],
  // CORRECTED: the reference dashboard shows "1 parameter" for Inherited
  // Risk. genetic_mutation and prs_percentile always come back with
  // severity: null in every sample payload seen so far — they read as
  // not-yet-live v1 scoring inputs, not just missing data for this
  // patient — so they're excluded here rather than counted as N/A.
  'Inherited Risk': ['family_history'],
  'Activity': ['physical_activity'],
  'Diet': ['diet_score'],
  'Tobacco': ['smoking_status', 'pack_years', 'years_since_quit', 'smokeless_tobacco'],
  'Behavioral': ['sleep_hours', 'alcohol_audit', 'stress_score'],
  'Kidney': ['egfr', 'uacr', 'ckd'],
  'Glucose': ['hba1c', 'fasting_glucose', 'diabetes'],
};

/// Display title per domain for the Domain Summary section — matches the
/// naming used in the reference web dashboard, which is more specific
/// than the raw `domain_rows[i].Domain` string (e.g. "Glucose" ->
/// "Glucose / Diabetes"). Burden Breakdown intentionally keeps the raw
/// short names instead (see `BurdenItem.label` below) since that chart's
/// label column is only 88px wide.
const Map<String, String> domainDisplayTitles = {
  'Lipids': 'Lipid / Atherogenic Particle',
  'Blood Pressure': 'Blood Pressure / Hemodynamic',
  'Adiposity': 'Adiposity',
  'Inherited Risk': 'Inherited Risk',
  'Activity': 'Physical Activity',
  'Diet': 'Diet / Nutrition',
  'Tobacco': 'Tobacco',
  'Behavioral': 'Behavioral Risk',
  'Kidney': 'Kidney / Vascular Damage',
  'Glucose': 'Glucose / Diabetes',
};

/// Groups each domain's fields down to just the ones the backend actually
/// scored for this patient — present in `patient_data` (the flat,
/// severity-annotated sibling of `patient` in the `/me/dashboard`
/// response) with a non-null `severity`. Fields with `severity: null`
/// (categorical/context fields that are `"Unknown"`, e.g. `ckd` or
/// `diabetes` in the sample payload) aren't part of the burden
/// calculation, so they're excluded from normal/borderline/at-risk counts
/// rather than silently counted as "normal". NOTE: this is NOT the same
/// as `parameterCount` — see [countDomainParameters] below, which counts
/// every field the domain has, scored or not.
Map<String, List<double>> groupPatientFieldsByDomain(Map<String, dynamic> patientData) {
  final result = <String, List<double>>{};

  domainFieldKeys.forEach((domain, keys) {
    final severities = <double>[];
    for (final key in keys) {
      final entry = patientData[key];
      if (entry is Map<String, dynamic> && entry['severity'] != null) {
        severities.add((entry['severity'] as num).toDouble());
      }
    }
    result[domain] = severities;
  });

  return result;
}

/// Total parameter count for a domain — ALL fields mapped to it, whether
/// or not the backend returned a value/severity for this patient.
/// Confirmed against the reference web dashboard: e.g. Lipids shows
/// "8 parameters" even when only 1 of them has a scored severity for a
/// given patient — the other 7 render as Missing/N/A in the per-parameter
/// table, but still count toward the total.
int countDomainParameters(Map<String, dynamic> patientData, String domain) {
  final keys = domainFieldKeys[domain];
  if (keys == null) return 0;
  final present = keys.where((k) => patientData.containsKey(k)).length;
  // Falls back to the full key list if patientData is missing entries
  // entirely (e.g. a stubbed/partial response) rather than under-counting.
  return present > 0 ? present : keys.length;
}

/// Formats a raw `patient_data` value for display: null -> "--", numbers
/// drop a trailing ".0", everything else (strings like "type2", "never")
/// passes through as-is. Appends the field's unit when present.
String formatParameterValue(dynamic value, String? unit) {
  if (value == null) return '--';
  final base = value is num
      ? (value == value.roundToDouble() ? value.toInt().toString() : value.toString())
      : value.toString();
  return (unit != null && unit.isNotEmpty) ? '$base $unit' : base;
}

/// Builds the ordered Parameter/Value/Severity rows for a domain's detail
/// popup, in the same field order as [domainFieldKeys].
List<DomainParameterDetail> buildParameterDetails(
    Map<String, dynamic> patientData,
    String domain,
    ) {
  final keys = domainFieldKeys[domain] ?? const [];

  return [
    for (final key in keys)
      if (patientData[key] is Map<String, dynamic>) _parameterDetail(key, patientData[key] as Map<String, dynamic>),
  ];
}

DomainParameterDetail _parameterDetail(String key, Map<String, dynamic> entry) {
  final value = entry['value'];
  final severity = entry['severity'];

  final bucket = value == null
      ? ParameterSeverity.missing
      : severity == null
      ? ParameterSeverity.notApplicable
      : (severity as num) <= 0
      ? ParameterSeverity.normal
      : severity >= 1
      ? ParameterSeverity.atRisk
      : ParameterSeverity.borderline;

  return DomainParameterDetail(
    label: entry['excel_name'] as String? ?? key,
    valueLabel: formatParameterValue(value, entry['unit'] as String?),
    severity: bucket,
  );
}

class SeverityBucketCounts {
  const SeverityBucketCounts({
    required this.normal,
    required this.borderline,
    required this.atRisk,
  });

  final int normal;
  final int borderline;
  final int atRisk;
}

/// Buckets raw per-field severities (0 / 0.5 / 1 in the sample payload)
/// into normal / borderline / at-risk counts.
/// ASSUMPTION: severity <= 0 -> normal, >= 1 -> at risk, anything strictly
/// between -> borderline. The API doesn't document discrete severity
/// bands beyond the 0/0.5/1 values observed, so this is a best-effort
/// threshold rather than a confirmed contract.
SeverityBucketCounts countSeverityBuckets(List<double> severities) {
  var normal = 0, borderline = 0, atRisk = 0;
  for (final s in severities) {
    if (s <= 0) {
      normal++;
    } else if (s >= 1) {
      atRisk++;
    } else {
      borderline++;
    }
  }
  return SeverityBucketCounts(normal: normal, borderline: borderline, atRisk: atRisk);
}