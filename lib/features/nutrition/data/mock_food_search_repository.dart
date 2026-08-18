import '../domain/food_item.dart';
import '../domain/food_search_repository.dart';

/// TEMPORARY mock — a small hand-picked sample so the search UI is fully
/// functional and demoable, NOT a real food database.
///
/// TODO(dataset-integration): replace this whole class once the real
/// dataset is shared. If it's a JSON/CSV asset, this becomes: load it
/// once (e.g. in a constructor or lazy getter), parse into
/// `List<FoodItem>`, and filter that list the same way `search()` does
/// below. If it's large enough to need a local database instead, swap
/// this class for one backed by `sqflite` — either way, nothing outside
/// `FoodSearchRepository` needs to change.
class MockFoodSearchRepository implements FoodSearchRepository {
  static final List<FoodItem> _dataset = [
    const FoodItem(
      id: 'apple',
      name: 'Apple',
      servingLabel: '1 medium (182g)',
      servingGrams: 182,
      calories: 95,
      proteinG: 0.5,
      carbsG: 25,
      fatG: 0.3,
    ),
    const FoodItem(
      id: 'banana',
      name: 'Banana',
      servingLabel: '1 medium (118g)',
      servingGrams: 118,
      calories: 105,
      proteinG: 1.3,
      carbsG: 27,
      fatG: 0.4,
    ),
    const FoodItem(
      id: 'chicken_breast',
      name: 'Chicken Breast, grilled',
      servingLabel: '100 g',
      servingGrams: 100,
      calories: 165,
      proteinG: 31,
      carbsG: 0,
      fatG: 3.6,
    ),
    const FoodItem(
      id: 'brown_rice',
      name: 'Brown Rice, cooked',
      servingLabel: '1 cup (195g)',
      servingGrams: 195,
      calories: 216,
      proteinG: 5,
      carbsG: 45,
      fatG: 1.8,
    ),
    const FoodItem(
      id: 'egg',
      name: 'Egg, boiled',
      servingLabel: '1 large (50g)',
      servingGrams: 50,
      calories: 78,
      proteinG: 6.3,
      carbsG: 0.6,
      fatG: 5.3,
    ),
    const FoodItem(
      id: 'greek_yogurt',
      name: 'Greek Yogurt, plain',
      servingLabel: '170 g',
      servingGrams: 170,
      calories: 100,
      proteinG: 17,
      carbsG: 6,
      fatG: 0.7,
    ),
    const FoodItem(
      id: 'almonds',
      name: 'Almonds',
      servingLabel: '28 g (~23 nuts)',
      servingGrams: 28,
      calories: 164,
      proteinG: 6,
      carbsG: 6.1,
      fatG: 14.2,
    ),
    const FoodItem(
      id: 'whole_wheat_bread',
      name: 'Whole Wheat Bread',
      servingLabel: '1 slice (28g)',
      servingGrams: 28,
      calories: 69,
      proteinG: 3.6,
      carbsG: 12,
      fatG: 0.9,
    ),
    const FoodItem(
      id: 'salmon',
      name: 'Salmon, baked',
      servingLabel: '100 g',
      servingGrams: 100,
      calories: 206,
      proteinG: 22,
      carbsG: 0,
      fatG: 13,
    ),
    const FoodItem(
      id: 'oatmeal',
      name: 'Oatmeal, cooked',
      servingLabel: '1 cup (234g)',
      servingGrams: 234,
      calories: 166,
      proteinG: 5.9,
      carbsG: 28,
      fatG: 3.6,
    ),
    const FoodItem(
      id: 'broccoli',
      name: 'Broccoli, steamed',
      servingLabel: '1 cup (156g)',
      servingGrams: 156,
      calories: 55,
      proteinG: 3.7,
      carbsG: 11,
      fatG: 0.6,
    ),
    const FoodItem(
      id: 'milk_whole',
      name: 'Milk, whole',
      servingLabel: '1 cup (244g)',
      servingGrams: 244,
      calories: 149,
      proteinG: 7.7,
      carbsG: 12,
      fatG: 8,
    ),
  ];

  @override
  Future<List<FoodItem>> search(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return const [];
    return _dataset.where((item) => item.name.toLowerCase().contains(trimmed)).toList();
  }
}
