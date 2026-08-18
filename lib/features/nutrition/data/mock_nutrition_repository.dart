import '../domain/nutrition_data.dart';
import '../domain/nutrition_repository.dart';

/// TEMPORARY mock — in-memory only. Seeded exactly like the mockup: an
/// empty day (all totals 0, no food/supplements logged, all
/// micronutrients at 0).
class MockNutritionRepository implements NutritionRepository {
  NutritionData _state = NutritionData(
    date: DateTime.now(),
    foodLog: const [],
    supplements: const [],
    microNutrients: {for (final n in kMicroNutrientOrder) n: 0},
  );

  @override
  Future<NutritionData> fetchNutrition(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _state;
  }

  @override
  Future<NutritionData> logFoodItem(FoodLogEntry entry) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _state = _state.copyWith(foodLog: [..._state.foodLog, entry]);
    return _state;
  }

  @override
  Future<NutritionData> addSupplement(String name) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _state = _state.copyWith(supplements: [..._state.supplements, name]);
    return _state;
  }

  @override
  Future<NutritionData> updateMicroNutrient(String nutrient, double value) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final updated = Map<String, double>.from(_state.microNutrients);
    updated[nutrient] = value;
    _state = _state.copyWith(microNutrients: updated);
    return _state;
  }
}
