import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heart_health_score/features/dashboard/data/mock_dashboard_repository.dart';
import 'package:heart_health_score/features/dashboard/domain/dashboard_data.dart';
import 'package:heart_health_score/features/dashboard/domain/dashboard_repository.dart';

/// Repository provider — the ONLY line to change when the backend is
/// ready (swap MockDashboardRepository() for ApiDashboardRepository(dio)).
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return MockDashboardRepository();
});

/// FutureProvider is enough here — the dashboard has no complex
/// multi-step mutable state like onboarding does, just an async fetch.
/// `ref.watch(dashboardDataProvider)` in the screen gives loading/error/
/// data states for free via AsyncValue.
final dashboardDataProvider = FutureProvider<DashboardData>((ref) {
  return ref.watch(dashboardRepositoryProvider).fetchDashboard();
});

/// Which bottom-nav tab is currently active on the Home shell.
enum HomeTab { home, reminder, profile, plans, settings }

final homeTabProvider = StateProvider<HomeTab>((ref) => HomeTab.home);

/// Whether the expandable "+" FAB (Log Workout / Log Water / Log Meal) is
/// currently open.
final fabExpandedProvider = StateProvider<bool>((ref) => false);







