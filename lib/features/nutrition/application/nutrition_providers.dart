import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_nutrition_repository.dart';
import '../domain/nutrition_data.dart';
import '../domain/nutrition_repository.dart';

/// Transient UI state — which meal type is currently picked, feeding the
/// next food item logged. Not part of `NutritionData` since it's not
/// persisted, just a pending selection for the next "Add" action.
final pendingMealTypeProvider = StateProvider<MealType?>((ref) => null);

final nutritionRepositoryProvider = Provider<NutritionRepository>((ref) {
  return MockNutritionRepository();
});

class NutritionController extends StateNotifier<AsyncValue<NutritionData>> {
  NutritionController(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  final NutritionRepository _repository;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.fetchNutrition(DateTime.now());
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() => _load();

  Future<void> logFoodItem(FoodLogEntry entry) async {
    try {
      final updated = await _repository.logFoodItem(entry);
      state = AsyncValue.data(updated);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addSupplement(String name) async {
    try {
      final updated = await _repository.addSupplement(name);
      state = AsyncValue.data(updated);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateMicroNutrient(String nutrient, double value) async {
    final current = state.value;
    if (current == null) return;
    // Optimistic update so the dialog feels instant.
    final updatedMap = Map<String, double>.from(current.microNutrients)..[nutrient] = value;
    state = AsyncValue.data(current.copyWith(microNutrients: updatedMap));
    try {
      await _repository.updateMicroNutrient(nutrient, value);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void toggleMicroNutrientsExpanded() {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(microNutrientsExpanded: !current.microNutrientsExpanded),
    );
  }
}

final nutritionControllerProvider =
    StateNotifierProvider<NutritionController, AsyncValue<NutritionData>>((ref) {
  return NutritionController(ref.watch(nutritionRepositoryProvider));
});
