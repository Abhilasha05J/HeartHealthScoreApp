import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heart_health_score/features/wearable/application/wearable_providers.dart';
import 'package:heart_health_score/features/wearable/domain/wearable_formatters.dart';
import 'package:heart_health_score/features/wearable/domain/wearable_models.dart';

import '../data/mock_dashboard_repository.dart';
import '../domain/dashboard_data.dart';
import '../domain/dashboard_repository.dart';

/// Repository provider — the ONLY line to change when the backend is
/// ready (swap MockDashboardRepository() for ApiDashboardRepository(dio)).
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return MockDashboardRepository();
});

/// FutureProvider is enough here — the dashboard has no complex
/// multi-step mutable state like onboarding does, just an async fetch.
/// NOTE: screens should generally NOT watch this directly anymore — watch
/// [mergedDashboardDataProvider] instead, which layers connected-wearable
/// data on top of this. This provider stays as the base/fallback source.
final dashboardDataProvider = FutureProvider<DashboardData>((ref) {
  return ref.watch(dashboardRepositoryProvider).fetchDashboard();
});

/// Home's actual data source. Watches the base dashboard fetch AND the
/// wearable connection state; whenever the wearable has a synced value for
/// a metric, it overrides the base value for that metric only — anything
/// the wearable hasn't synced (e.g. no BP-capable device) still falls back
/// to [dashboardDataProvider]'s value. This is a client-side UI merge only;
/// it does not push wearable values back to any backend endpoint — see the
/// note on `HealthWearableRepository` for why that's a separate concern
/// (fetchDashboard() would need to start accepting wearable readings as an
/// input once the real scoring endpoint exists, if the ML model should
/// factor them in — that's a backend-integration decision, not a UI one).
final mergedDashboardDataProvider = Provider<AsyncValue<DashboardData>>((ref) {
  final baseAsync = ref.watch(dashboardDataProvider);
  final wearableState = ref.watch(wearableControllerProvider);

  return baseAsync.whenData((base) => _applyWearableOverrides(base, wearableState));
});

DashboardData _applyWearableOverrides(
  DashboardData base,
  WearableConnectionState wearable,
) {
  final snapshot = wearable.snapshot;
  if (wearable.status != WearableConnectionStatus.connected || snapshot == null) {
    return base;
  }

  return base.copyWith(
    restingHeartRateBpm: snapshot.restingHeartRate != null
        ? snapshot.restingHeartRate!.value
        : null,
    sleepDurationLabel: snapshot.sleepDuration != null
        ? formatSleepDuration(snapshot.sleepDuration!.value)
        : null,
    bloodPressureLabel: snapshot.bloodPressure != null
        ? formatBloodPressure(snapshot.bloodPressure!.value)
        : null,
    stepCount: snapshot.stepCount != null ? snapshot.stepCount!.value : null,
  );
}

/// Which bottom-nav tab is active is now owned by go_router's
/// StatefulShellRoute (see `HomeShell.navigationShell.currentIndex` in
/// app_router.dart / home_shell.dart) — HomeTab/homeTabProvider used to
/// track this via Riverpod before that refactor and are no longer used.

/// Whether the expandable "+" FAB (Log Workout / Log Water / Log Meal) is
/// currently open.
final fabExpandedProvider = StateProvider<bool>((ref) => false);
