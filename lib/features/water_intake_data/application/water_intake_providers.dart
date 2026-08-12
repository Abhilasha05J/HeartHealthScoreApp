import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_water_intake_repository.dart';
import '../domain/water_intake_data.dart';
import '../domain/water_intake_repository.dart';

final waterIntakeRepositoryProvider = Provider<WaterIntakeRepository>((ref) {
  return MockWaterIntakeRepository();
});

/// AsyncNotifier-style controller: loads on creation, exposes mutation
/// methods that optimistically update state via the repository (same
/// pattern as `OnboardingController`, adapted here for an async initial
/// load since — unlike onboarding's fresh-draft-every-time — this screen
/// loads existing data).
class WaterIntakeController extends StateNotifier<AsyncValue<WaterIntakeData>> {
  WaterIntakeController(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  final WaterIntakeRepository _repository;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.fetchWaterIntake();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() => _load();

  Future<void> logWater({required int amountMl, required String sourceLabel}) async {
    try {
      final updated = await _repository.logWater(amountMl: amountMl, sourceLabel: sourceLabel);
      state = AsyncValue.data(updated);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateReminderSettings(ReminderSettings settings) async {
    final current = state.value;
    if (current == null) return;
    // Optimistic update so toggles/chips feel instant.
    state = AsyncValue.data(current.copyWith(reminderSettings: settings));
    try {
      await _repository.updateReminderSettings(settings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final waterIntakeControllerProvider =
    StateNotifierProvider<WaterIntakeController, AsyncValue<WaterIntakeData>>((ref) {
  return WaterIntakeController(ref.watch(waterIntakeRepositoryProvider));
});
