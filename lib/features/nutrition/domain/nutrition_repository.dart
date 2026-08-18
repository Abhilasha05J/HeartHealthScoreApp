import 'nutrition_data.dart';

/// Contract the Log Meal screen depends on — same swap-one-file pattern
/// as every other feature in this app.
abstract class NutritionRepository {
  Future<NutritionData> fetchNutrition(DateTime date);

  Future<NutritionData> logFoodItem(FoodLogEntry entry);

  Future<NutritionData> addSupplement(String name);

  Future<NutritionData> updateMicroNutrient(String nutrient, double value);
}
