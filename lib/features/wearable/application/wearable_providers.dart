import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heart_health_score/features/wearable/data/health_wearable_repository.dart';
import 'package:heart_health_score/features/wearable/domain/wearable_models.dart';
import 'package:heart_health_score/features/wearable/domain/wearable_repository.dart';

/// Single swap point — same pattern as authRepositoryProvider /
/// onboardingRepositoryProvider (skill section 7).
///
/// Now pointed at the real Health Connect / HealthKit implementation. If you
/// ever need to go back to seeded data for UI-only work (e.g. no test device
/// handy), swap back to:
///   import 'package:heart_health_score/features/wearable/data/mock_wearable_repository.dart';
///   (ref) => MockWearableRepository(),
///
/// No screen or controller code changes needed either direction.
final wearableRepositoryProvider = Provider<WearableRepository>(
      (ref) => HealthWearableRepository(),
);

final wearableControllerProvider =
StateNotifierProvider<WearableController, WearableConnectionState>(
      (ref) => WearableController(ref.watch(wearableRepositoryProvider)),
);

class WearableController extends StateNotifier<WearableConnectionState> {
  WearableController(this._repository) : super(const WearableConnectionState());

  final WearableRepository _repository;

  /// Single entry point for a one-tap button: connects if never connected
  /// (or if a previous attempt failed/was denied), re-syncs if already
  /// connected. Home only ever needs to call this one method.
  Future<void> connectOrRefresh() {
    if (state.status == WearableConnectionStatus.connected) {
      return refresh();
    }
    return connect();
  }

  Future<void> connect() async {
    state = state.copyWith(
      status: WearableConnectionStatus.connecting,
      errorMessage: null,
    );

    try {
      final available = await _repository.isPlatformStoreAvailable();
      if (!available) {
        state = state.copyWith(status: WearableConnectionStatus.storeUnavailable);
        return;
      }

      final granted = await _repository.requestPermissions();
      if (!granted) {
        state = state.copyWith(status: WearableConnectionStatus.permissionDenied);
        return;
      }

      final snapshot = await _repository.fetchLatestSnapshot();
      state = state.copyWith(
        status: WearableConnectionStatus.connected,
        snapshot: snapshot,
      );
    } catch (_) {
      state = state.copyWith(
        status: WearableConnectionStatus.error,
        errorMessage:
        "We couldn't connect right now. Please try again in a moment.",
      );
    }
  }

  /// Re-sync once already connected. Keeps the last good snapshot on screen
  /// if the refresh itself fails, rather than blanking the grid out — the
  /// failure is surfaced via [errorMessage] for a transient SnackBar, not by
  /// dropping back to a "disconnected" status.
  Future<void> refresh() async {
    if (state.status != WearableConnectionStatus.connected) return;
    state = state.copyWith(isRefreshing: true, errorMessage: null);
    try {
      final snapshot = await _repository.fetchLatestSnapshot();
      state = state.copyWith(snapshot: snapshot, isRefreshing: false);
    } catch (_) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: "Couldn't refresh your wearable data. Please try again.",
      );
    }
  }

  Future<bool> openStoreInstallPage() => _repository.openPlatformStoreInstallPage();
}