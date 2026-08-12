import 'dashboard_data.dart';

/// Contract the Home dashboard depends on. Same pattern as
/// AuthRepository/OnboardingRepository — presentation/state layers only
/// know about this interface, never about how the score is actually
/// computed or fetched.
abstract class DashboardRepository {
  /// Fetches the current user's computed Heart Health Score and
  /// supporting condition/burden data.
  ///
  /// TODO(backend-integration): once the ML scoring endpoint is live,
  /// this should call it (passing the onboarding profile + any connected
  /// wearable data) and map its response into [DashboardData]. Until
  /// then, [MockDashboardRepository] returns fixed sample data matching
  /// the mockup so the UI can be built and reviewed end-to-end.
  Future<DashboardData> fetchDashboard();
}